//===--- ExpectedTypes.h - Simplified C++ types -----------------*- C++-*--===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// A simplified model of C++ types that can be used to check whether they are
// convertible between each other for the purposes of code completion ranking
// without looking at the ASTs. Note that we don't aim to fully mimic the C++
// conversion rules, merely try to have a model that gives useful improvements
// to the code completion ranking.
//
// We define an encoding of AST types as opaque strings, which can be stored in
// the index. Similar types (such as `int` and `long`) are folded together,
// forming equivalence classes with the same encoding.
//===----------------------------------------------------------------------===//
#ifndef LLVM_CLANG_TOOLS_EXTRA_CLANGD_EXPECTED_TYPES_H
#define LLVM_CLANG_TOOLS_EXTRA_CLANGD_EXPECTED_TYPES_H

#include "clang/AST/Type.h"
#include "llvm/ADT/StringRef.h"

namespace clang {
class CodeCompletionResult;

namespace clangd {
/// A representation of a type that can be computed based on clang AST and
/// compared for equality. The encoding is stable between different ASTs, this
/// allows the representation to be stored in the index and compared with types
/// coming from a different AST later.
/// OpaqueType is a strongly-typedefed std::string, you can get the underlying
/// string with raw().
class OpaqueType {
public:
  /// Create a type from a code completion result.
  static llvm::Optional<OpaqueType>
  fromCompletionResult(ASTContext &Ctx, const CodeCompletionResult &R);
  /// Construct an instance from a clang::QualType. This is usually a
  /// PreferredType from a clang's completion context.
  static llvm::Optional<OpaqueType> fromType(ASTContext &Ctx, QualType Type);

  /// Get the raw byte representation of the type. You can only rely on the
  /// types being equal iff their raw representation is the same. The particular
  /// details of the used encoding might change over time and one should not
  /// rely on it.
  llvm::StringRef raw() const { return Data; }

  friend bool operator==(const OpaqueType &L, const OpaqueType &R) {
    return L.Data == R.Data;
  }
  friend bool operator!=(const OpaqueType &L, const OpaqueType &R) {
    return !(L == R);
  }

private:
  static llvm::Optional<OpaqueType> encode(ASTContext &Ctx, QualType Type);
  explicit OpaqueType(std::string Data);

  std::string Data;
};
} // namespace clangd
} // namespace clang
#endif
