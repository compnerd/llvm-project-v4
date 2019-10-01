//===- unittests/AST/DeclTest.cpp --- Declaration tests -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Unit tests for Decl nodes in the AST.
//
//===----------------------------------------------------------------------===//

#include "MatchVerifier.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/Mangle.h"
#include "clang/ASTMatchers/ASTMatchFinder.h"
#include "clang/Basic/LLVM.h"
#include "clang/Tooling/Tooling.h"
#include "gtest/gtest.h"

using namespace clang::ast_matchers;
using namespace clang::tooling;
using namespace clang;

TEST(Decl, CleansUpAPValues) {
  MatchFinder Finder;
  std::unique_ptr<FrontendActionFactory> Factory(
      newFrontendActionFactory(&Finder));

  // This is a regression test for a memory leak in APValues for structs that
  // allocate memory. This test only fails if run under valgrind with full leak
  // checking enabled.
  std::vector<std::string> Args(1, "-std=c++11");
  Args.push_back("-fno-ms-extensions");
  ASSERT_TRUE(runToolOnCodeWithArgs(
      Factory->create(),
      "struct X { int a; }; constexpr X x = { 42 };"
      "union Y { constexpr Y(int a) : a(a) {} int a; }; constexpr Y y = { 42 };"
      "constexpr int z[2] = { 42, 43 };"
      "constexpr int __attribute__((vector_size(16))) v1 = {};"
      "\n#ifdef __SIZEOF_INT128__\n"
      "constexpr __uint128_t large_int = 0xffffffffffffffff;"
      "constexpr __uint128_t small_int = 1;"
      "\n#endif\n"
      "constexpr double d1 = 42.42;"
      "constexpr long double d2 = 42.42;"
      "constexpr _Complex long double c1 = 42.0i;"
      "constexpr _Complex long double c2 = 42.0;"
      "template<int N> struct A : A<N-1> {};"
      "template<> struct A<0> { int n; }; A<50> a;"
      "constexpr int &r = a.n;"
      "constexpr int A<50>::*p = &A<50>::n;"
      "void f() { foo: bar: constexpr int k = __builtin_constant_p(0) ?"
      "                         (char*)&&foo - (char*)&&bar : 0; }",
      Args));

  // FIXME: Once this test starts breaking we can test APValue::needsCleanup
  // for ComplexInt.
  ASSERT_FALSE(runToolOnCodeWithArgs(
      Factory->create(),
      "constexpr _Complex __uint128_t c = 0xffffffffffffffff;",
      Args));
}

TEST(Decl, AsmLabelAttr) {
  // Create two method decls: `f` and `g`.
  StringRef Code = R"(
    struct S {
      void f() {}
      void g() {}
    };
  )";
  auto AST =
      tooling::buildASTFromCodeWithArgs(Code, {"-target", "i386-apple-darwin"});
  ASTContext &Ctx = AST->getASTContext();
  assert(Ctx.getTargetInfo().getDataLayout().getGlobalPrefix() &&
         "Expected target to have a global prefix");
  DiagnosticsEngine &Diags = AST->getDiagnostics();
  SourceManager &SM = AST->getSourceManager();
  FileID MainFileID = SM.getMainFileID();

  // Find the method decls within the AST.
  SmallVector<Decl *, 1> Decls;
  AST->findFileRegionDecls(MainFileID, Code.find('{'), 0, Decls);
  ASSERT_TRUE(Decls.size() == 1);
  CXXRecordDecl *DeclS = cast<CXXRecordDecl>(Decls[0]);
  NamedDecl *DeclF = *DeclS->method_begin();
  NamedDecl *DeclG = *(++DeclS->method_begin());

  // Attach asm labels to the decls: one literal, and one not.
  DeclF->addAttr(::new (Ctx) AsmLabelAttr(SourceRange(), Ctx, "foo",
                                          /*LiteralLabel=*/true, 0));
  DeclG->addAttr(::new (Ctx) AsmLabelAttr(SourceRange(), Ctx, "goo",
                                          /*LiteralLabel=*/false, 0));

  // Mangle the decl names.
  std::string MangleF, MangleG;
  MangleContext *MC = ItaniumMangleContext::create(Ctx, Diags);
  {
    llvm::raw_string_ostream OS_F(MangleF);
    llvm::raw_string_ostream OS_G(MangleG);
    MC->mangleName(DeclF, OS_F);
    MC->mangleName(DeclG, OS_G);
  }

  ASSERT_TRUE(0 == MangleF.compare("\x01" "foo"));
  ASSERT_TRUE(0 == MangleG.compare("goo"));
}

TEST(Decl, Availability) {
  const char *CodeStr = "int x __attribute__((availability(macosx, "
        "introduced=10.2, deprecated=10.8, obsoleted=10.10)));";
  auto Matcher = varDecl(hasName("x"));
  std::vector<std::string> Args = {"-target", "x86_64-apple-macosx10.9"};

  class AvailabilityVerifier : public MatchVerifier<clang::VarDecl> {
  public:
    void verify(const MatchFinder::MatchResult &Result,
                const clang::VarDecl &Node) override {
      if (Node.getAvailability(nullptr, clang::VersionTuple(10, 1)) !=
          clang::AR_NotYetIntroduced) {
        setFailure("failed introduced");
      }
      if (Node.getAvailability(nullptr, clang::VersionTuple(10, 2)) !=
          clang::AR_Available) {
        setFailure("failed available (exact)");
      }
      if (Node.getAvailability(nullptr, clang::VersionTuple(10, 3)) !=
          clang::AR_Available) {
        setFailure("failed available");
      }
      if (Node.getAvailability(nullptr, clang::VersionTuple(10, 8)) !=
          clang::AR_Deprecated) {
        setFailure("failed deprecated (exact)");
      }
      if (Node.getAvailability(nullptr, clang::VersionTuple(10, 9)) !=
          clang::AR_Deprecated) {
        setFailure("failed deprecated");
      }
      if (Node.getAvailability(nullptr, clang::VersionTuple(10, 10)) !=
          clang::AR_Unavailable) {
        setFailure("failed obsoleted (exact)");
      }
      if (Node.getAvailability(nullptr, clang::VersionTuple(10, 11)) !=
          clang::AR_Unavailable) {
        setFailure("failed obsoleted");
      }

      if (Node.getAvailability() != clang::AR_Deprecated)
        setFailure("did not default to target OS version");

      setSuccess();
    }
  };

  AvailabilityVerifier Verifier;
  EXPECT_TRUE(Verifier.match(CodeStr, Matcher, Args, Lang_C));
}
