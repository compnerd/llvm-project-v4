//===--- OwningMemoryCheck.cpp - clang-tidy--------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "OwningMemoryCheck.h"
#include "../utils/Matchers.h"
#include "../utils/OptionsUtils.h"
#include "clang/AST/ASTContext.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include <string>
#include <vector>

using namespace clang::ast_matchers;
using namespace clang::ast_matchers::internal;

namespace clang {
namespace tidy {
namespace cppcoreguidelines {

/// Match common cases, where the owner semantic is relevant, like function
/// calls, delete expressions and others.
void OwningMemoryCheck::registerMatchers(MatchFinder *Finder) {
  if (!getLangOpts().CPlusPlus11)
    return;

  const auto OwnerDecl = typeAliasTemplateDecl(hasName("::gsl::owner"));
  const auto IsOwnerType = hasType(OwnerDecl);
  const auto CreatesOwner =
      anyOf(cxxNewExpr(), callExpr(callee(functionDecl(
                              returns(qualType(hasDeclaration(OwnerDecl)))))));
  const auto ConsideredOwner = anyOf(IsOwnerType, CreatesOwner);

  // Find delete expressions that delete non-owners.
  Finder->addMatcher(
      cxxDeleteExpr(
          hasDescendant(
              declRefExpr(unless(ConsideredOwner)).bind("deleted_variable")))
          .bind("delete_expr"),
      this);

  // Matching assignment to owners, with the rhs not being an owner nor creating
  // one.
  Finder->addMatcher(binaryOperator(allOf(matchers::isAssignmentOperator(),
                                          hasLHS(IsOwnerType),
                                          hasRHS(unless(ConsideredOwner))))
                         .bind("owner_assignment"),
                     this);

  // Matching initialization of owners with non-owners, nor creating owners.
  Finder->addMatcher(
      namedDecl(
          varDecl(allOf(hasInitializer(unless(ConsideredOwner)), IsOwnerType))
              .bind("owner_initialization")),
      this);

  // Match class member initialization that expects owners, but does not get
  // them.
  Finder->addMatcher(
      cxxRecordDecl(has(cxxConstructorDecl(forEachConstructorInitializer(
          cxxCtorInitializer(
              allOf(
                  isMemberInitializer(), forField(IsOwnerType),
                  withInitializer(
                      // Avoid templatesdeclaration with excluding parenListExpr.
                      allOf(unless(ConsideredOwner), unless(parenListExpr())))))
              .bind("owner_member_initializer"))))),
      this);

  // Matching on assignment operations where the RHS is a newly created owner,
  // but the LHS is not an owner.
  Finder->addMatcher(
      binaryOperator(allOf(matchers::isAssignmentOperator(),
                           hasLHS(unless(IsOwnerType)), hasRHS(CreatesOwner)))
          .bind("bad_owner_creation_assignment"),
      this);

  // Matching on initialization operations where the initial value is a newly
  // created owner, but the LHS is not an owner.
  Finder->addMatcher(
      namedDecl(varDecl(eachOf(allOf(hasInitializer(CreatesOwner),
                                     unless(IsOwnerType)),
                               allOf(hasInitializer(ConsideredOwner),
                                     hasType(autoType().bind("deduced_type")))))
                    .bind("bad_owner_creation_variable")),
      this);

  // Match on all function calls that expect owners as arguments, but didn't
  // get them.
  Finder->addMatcher(
      callExpr(forEachArgumentWithParam(
          expr(unless(ConsideredOwner)).bind("expected_owner_argument"),
          parmVarDecl(IsOwnerType))),
      this);

  // Matching for function calls where one argument is a created owner, but the
  // parameter type is not an owner.
  Finder->addMatcher(callExpr(forEachArgumentWithParam(
                         expr(CreatesOwner).bind("bad_owner_creation_argument"),
                         parmVarDecl(unless(IsOwnerType))
                             .bind("bad_owner_creation_parameter"))),
                     this);

  // Matching on functions, that return an owner/resource, but don't declare
  // their return type as owner.
  Finder->addMatcher(
      functionDecl(
          allOf(hasDescendant(returnStmt(hasReturnValue(ConsideredOwner))
                                  .bind("bad_owner_return")),
                unless(returns(qualType(hasDeclaration(OwnerDecl))))))
          .bind("function_decl"),
      this);

  // Match on classes that have an owner as member, but don't declare a
  // destructor to properly release the owner.
  Finder->addMatcher(
      cxxRecordDecl(
          allOf(
              has(fieldDecl(IsOwnerType).bind("undestructed_owner_member")),
              anyOf(unless(has(cxxDestructorDecl())),
                    has(cxxDestructorDecl(anyOf(isDefaulted(), isDeleted()))))))
          .bind("non_destructor_class"),
      this);
}

void OwningMemoryCheck::check(const MatchFinder::MatchResult &Result) {
  const auto &Nodes = Result.Nodes;

  bool CheckExecuted = false;
  CheckExecuted |= handleDeletion(Nodes);
  CheckExecuted |= handleExpectedOwner(Nodes);
  CheckExecuted |= handleAssignmentAndInit(Nodes);
  CheckExecuted |= handleAssignmentFromNewOwner(Nodes);
  CheckExecuted |= handleReturnValues(Nodes);
  CheckExecuted |= handleOwnerMembers(Nodes);

  assert(CheckExecuted &&
         "None of the subroutines executed, logic error in matcher!");
}

bool OwningMemoryCheck::handleDeletion(const BoundNodes &Nodes) {
  // Result of delete matchers.
  const auto *DeleteStmt = Nodes.getNodeAs<CXXDeleteExpr>("delete_expr");
  const auto *DeletedVariable =
      Nodes.getNodeAs<DeclRefExpr>("deleted_variable");

  // Deletion of non-owners, with `delete variable;`
  if (DeleteStmt) {
    diag(DeleteStmt->getLocStart(),
         "deleting a pointer through a type that is "
         "not marked 'gsl::owner<>'; consider using a "
         "smart pointer instead")
        << DeletedVariable->getSourceRange();
    return true;
  }
  return false;
}

bool OwningMemoryCheck::handleExpectedOwner(const BoundNodes &Nodes) {
  // Result of function call matchers.
  const auto *ExpectedOwner = Nodes.getNodeAs<Expr>("expected_owner_argument");

  // Expected function argument to be owner.
  if (ExpectedOwner) {
    diag(ExpectedOwner->getLocStart(),
         "expected argument of type 'gsl::owner<>'; got %0")
        << ExpectedOwner->getType() << ExpectedOwner->getSourceRange();
    return true;
  }
  return false;
}

/// Assignment and initialization of owner variables.
bool OwningMemoryCheck::handleAssignmentAndInit(const BoundNodes &Nodes) {
  const auto *OwnerAssignment =
      Nodes.getNodeAs<BinaryOperator>("owner_assignment");
  const auto *OwnerInitialization =
      Nodes.getNodeAs<VarDecl>("owner_initialization");
  const auto *OwnerInitializer =
      Nodes.getNodeAs<CXXCtorInitializer>("owner_member_initializer");

  // Assignments to owners.
  if (OwnerAssignment) {
    diag(OwnerAssignment->getLocStart(),
         "expected assignment source to be of type 'gsl::owner<>'; got %0")
        << OwnerAssignment->getRHS()->getType()
        << OwnerAssignment->getSourceRange();
    return true;
  }

  // Initialization of owners.
  if (OwnerInitialization) {
    diag(OwnerInitialization->getLocStart(),
         "expected initialization with value of type 'gsl::owner<>'; got %0")
        << OwnerInitialization->getAnyInitializer()->getType()
        << OwnerInitialization->getSourceRange();
    return true;
  }

  // Initializer of class constructors that initialize owners.
  if (OwnerInitializer) {
    diag(OwnerInitializer->getSourceLocation(),
         "expected initialization of owner member variable with value of type "
         "'gsl::owner<>'; got %0")
        // FIXME: the expression from getInit has type 'void', but the type
        // of the supplied argument would be of interest.
        << OwnerInitializer->getInit()->getType()
        << OwnerInitializer->getSourceRange();
    return true;
  }
  return false;
}

/// Problematic assignment and initializations, since the assigned value is a
/// newly created owner.
bool OwningMemoryCheck::handleAssignmentFromNewOwner(const BoundNodes &Nodes) {
  const auto *BadOwnerAssignment =
      Nodes.getNodeAs<BinaryOperator>("bad_owner_creation_assignment");
  const auto *BadOwnerInitialization =
      Nodes.getNodeAs<VarDecl>("bad_owner_creation_variable");

  const auto *BadOwnerArgument =
      Nodes.getNodeAs<Expr>("bad_owner_creation_argument");
  const auto *BadOwnerParameter =
      Nodes.getNodeAs<ParmVarDecl>("bad_owner_creation_parameter");

  // Bad assignments to non-owners, where the RHS is a newly created owner.
  if (BadOwnerAssignment) {
    diag(BadOwnerAssignment->getLocStart(),
         "assigning newly created 'gsl::owner<>' to non-owner %0")
        << BadOwnerAssignment->getLHS()->getType()
        << BadOwnerAssignment->getSourceRange();
    return true;
  }

  // Bad initialization of non-owners, where the RHS is a newly created owner.
  if (BadOwnerInitialization) {
    diag(BadOwnerInitialization->getLocStart(),
         "initializing non-owner %0 with a newly created 'gsl::owner<>'")
        << BadOwnerInitialization->getType()
        << BadOwnerInitialization->getSourceRange();
    // FIXME: FixitHint to rewrite the type if possible.

    // If the type of the variable was deduced, the wrapping owner typedef is
    // eliminated, therefore the check emits a special note for that case.
    if (Nodes.getNodeAs<AutoType>("deduced_type")) {
      diag(BadOwnerInitialization->getLocStart(),
           "type deduction did not result in an owner", DiagnosticIDs::Note);
    }
    return true;
  }

  // Function call, where one arguments is a newly created owner, but the
  // parameter type is not.
  if (BadOwnerArgument) {
    assert(BadOwnerParameter &&
           "parameter for the problematic argument not found");
    diag(BadOwnerArgument->getLocStart(), "initializing non-owner argument of "
                                          "type %0 with a newly created "
                                          "'gsl::owner<>'")
        << BadOwnerParameter->getType() << BadOwnerArgument->getSourceRange();
    return true;
  }
  return false;
}

bool OwningMemoryCheck::handleReturnValues(const BoundNodes &Nodes) {
  // Function return statements, that are owners/resources, but the function
  // declaration does not declare its return value as owner.
  const auto *BadReturnType = Nodes.getNodeAs<ReturnStmt>("bad_owner_return");
  const auto *Function = Nodes.getNodeAs<FunctionDecl>("function_decl");

  // Function return values, that should be owners but aren't.
  if (BadReturnType) {
    // The returned value is of type owner, but not the declared return type.
    diag(BadReturnType->getLocStart(),
         "returning a newly created resource of "
         "type %0 or 'gsl::owner<>' from a "
         "function whose return type is not 'gsl::owner<>'")
        << Function->getReturnType() << BadReturnType->getSourceRange();
    // The returned value is a resource that was not annotated with owner<> and
    // the function return type is not owner<>.
    return true;
  }
  return false;
}

bool OwningMemoryCheck::handleOwnerMembers(const BoundNodes &Nodes) {
  // Classes, that have owners as member, but do not declare destructors
  // accordingly.
  const auto *BadClass = Nodes.getNodeAs<CXXRecordDecl>("non_destructor_class");

  // Classes, that contains owners, but do not declare destructors.
  if (BadClass) {
    const auto *DeclaredOwnerMember =
        Nodes.getNodeAs<FieldDecl>("undestructed_owner_member");
    assert(DeclaredOwnerMember &&
           "match on class with bad destructor but without a declared owner");

    diag(DeclaredOwnerMember->getLocStart(),
         "member variable of type 'gsl::owner<>' requires the class %0 to "
         "implement a destructor to release the owned resource")
        << BadClass;
    return true;
  }
  return false;
}

} // namespace cppcoreguidelines
} // namespace tidy
} // namespace clang
