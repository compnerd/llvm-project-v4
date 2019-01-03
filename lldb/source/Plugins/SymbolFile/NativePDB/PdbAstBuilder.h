//===-- PdbAstBuilder.h -----------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_PLUGINS_SYMBOLFILE_NATIVEPDB_PDBASTBUILDER_H
#define LLDB_PLUGINS_SYMBOLFILE_NATIVEPDB_PDBASTBUILDER_H

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/StringRef.h"

#include "lldb/Symbol/ClangASTImporter.h"

#include "PdbIndex.h"
#include "PdbSymUid.h"

namespace clang {
class TagDecl;
class DeclContext;
class Decl;
class QualType;
class FunctionDecl;
class NamespaceDecl;
} // namespace clang

namespace llvm {
namespace codeview {
class ProcSym;
}
} // namespace llvm

namespace lldb_private {
class ClangASTImporter;
class ObjectFile;

namespace npdb {
class PdbIndex;
struct VariableInfo;

struct DeclStatus {
  DeclStatus() = default;
  DeclStatus(lldb::user_id_t uid, bool resolved)
      : uid(uid), resolved(resolved) {}
  lldb::user_id_t uid = 0;
  bool resolved = false;
};

class PdbAstBuilder {
public:
  //------------------------------------------------------------------
  // Constructors and Destructors
  //------------------------------------------------------------------
  PdbAstBuilder(ObjectFile &obj, PdbIndex &index);

  clang::DeclContext &GetTranslationUnitDecl();

  clang::Decl *GetOrCreateDeclForUid(PdbSymUid uid);
  clang::DeclContext *GetOrCreateDeclContextForUid(PdbSymUid uid);
  clang::DeclContext *GetParentDeclContext(PdbSymUid uid);

  clang::NamespaceDecl *GetOrCreateNamespaceDecl(llvm::StringRef name,
                                                 clang::DeclContext &context);
  clang::FunctionDecl *GetOrCreateFunctionDecl(PdbCompilandSymId func_id);
  clang::BlockDecl *GetOrCreateBlockDecl(PdbCompilandSymId block_id);
  clang::VarDecl *GetOrCreateVariableDecl(PdbCompilandSymId scope_id,
                                          PdbCompilandSymId var_id);
  clang::VarDecl *GetOrCreateVariableDecl(PdbGlobalSymId var_id);
  void ParseDeclsForContext(clang::DeclContext &context);

  clang::QualType GetBasicType(lldb::BasicType type);
  clang::QualType GetOrCreateType(PdbTypeSymId type);

  bool CompleteTagDecl(clang::TagDecl &tag);
  bool CompleteType(clang::QualType qt);

  CompilerDecl ToCompilerDecl(clang::Decl &decl);
  CompilerType ToCompilerType(clang::QualType qt);
  CompilerDeclContext ToCompilerDeclContext(clang::DeclContext &context);
  clang::DeclContext *FromCompilerDeclContext(CompilerDeclContext context);

  ClangASTContext &clang() { return m_clang; }
  ClangASTImporter &importer() { return m_importer; }

  void Dump(Stream &stream);

private:
  clang::Decl *TryGetDecl(PdbSymUid uid) const;

  using TypeIndex = llvm::codeview::TypeIndex;

  clang::QualType
  CreatePointerType(const llvm::codeview::PointerRecord &pointer);
  clang::QualType
  CreateModifierType(const llvm::codeview::ModifierRecord &modifier);
  clang::QualType CreateArrayType(const llvm::codeview::ArrayRecord &array);
  clang::QualType CreateRecordType(PdbTypeSymId id,
                                   const llvm::codeview::TagRecord &record);
  clang::QualType CreateEnumType(PdbTypeSymId id,
                                 const llvm::codeview::EnumRecord &record);
  clang::QualType
  CreateProcedureType(const llvm::codeview::ProcedureRecord &proc);
  clang::QualType CreateType(PdbTypeSymId type);

  void CreateFunctionParameters(PdbCompilandSymId func_id,
                                clang::FunctionDecl &function_decl,
                                uint32_t param_count);
  clang::Decl *GetOrCreateSymbolForId(PdbCompilandSymId id);
  clang::VarDecl *CreateVariableDecl(PdbSymUid uid,
                                     llvm::codeview::CVSymbol sym,
                                     clang::DeclContext &scope);

  void ParseAllNamespacesPlusChildrenOf(llvm::Optional<llvm::StringRef> parent);
  void ParseDeclsForSimpleContext(clang::DeclContext &context);
  void ParseBlockChildren(PdbCompilandSymId block_id);

  void BuildParentMap();
  std::pair<clang::DeclContext *, std::string>
  CreateDeclInfoForType(const llvm::codeview::TagRecord &record, TypeIndex ti);
  clang::QualType CreateSimpleType(TypeIndex ti);

  PdbIndex &m_index;
  ClangASTContext &m_clang;

  ClangASTImporter m_importer;

  llvm::DenseMap<TypeIndex, TypeIndex> m_parent_types;
  llvm::DenseMap<clang::Decl *, DeclStatus> m_decl_to_status;
  llvm::DenseMap<lldb::user_id_t, clang::Decl *> m_uid_to_decl;
  llvm::DenseMap<lldb::user_id_t, clang::QualType> m_uid_to_type;
};

} // namespace npdb
} // namespace lldb_private

#endif // lldb_Plugins_SymbolFile_PDB_SymbolFilePDB_h_
