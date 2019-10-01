//===-- MDGenerator.cpp - Markdown Generator --------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Generators.h"
#include "Representation.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"
#include <string>

using namespace llvm;

namespace clang {
namespace doc {

// Enum conversion

std::string getAccess(AccessSpecifier AS) {
  switch (AS) {
  case AccessSpecifier::AS_public:
    return "public";
  case AccessSpecifier::AS_protected:
    return "protected";
  case AccessSpecifier::AS_private:
    return "private";
  case AccessSpecifier::AS_none:
    return {};
  }
  llvm_unreachable("Unknown AccessSpecifier");
}

std::string getTagType(TagTypeKind AS) {
  switch (AS) {
  case TagTypeKind::TTK_Class:
    return "class";
  case TagTypeKind::TTK_Union:
    return "union";
  case TagTypeKind::TTK_Interface:
    return "interface";
  case TagTypeKind::TTK_Struct:
    return "struct";
  case TagTypeKind::TTK_Enum:
    return "enum";
  }
  llvm_unreachable("Unknown TagTypeKind");
}

// Markdown generation

std::string genItalic(const Twine &Text) { return "*" + Text.str() + "*"; }

std::string genEmphasis(const Twine &Text) { return "**" + Text.str() + "**"; }

std::string genLink(const Twine &Text, const Twine &Link) {
  return "[" + Text.str() + "](" + Link.str() + ")";
}

std::string genReferenceList(const llvm::SmallVectorImpl<Reference> &Refs) {
  std::string Buffer;
  llvm::raw_string_ostream Stream(Buffer);
  bool First = true;
  for (const auto &R : Refs) {
    if (!First)
      Stream << ", ";
    Stream << R.Name;
    First = false;
  }
  return Stream.str();
}

void writeLine(const Twine &Text, raw_ostream &OS) { OS << Text << "\n\n"; }

void writeNewLine(raw_ostream &OS) { OS << "\n\n"; }

void writeHeader(const Twine &Text, unsigned int Num, raw_ostream &OS) {
  OS << std::string(Num, '#') + " " + Text << "\n\n";
}

void writeFileDefinition(const Location &L, raw_ostream &OS) {
  OS << genItalic("Defined at line " + std::to_string(L.LineNumber) + " of " +
                  L.Filename)
     << "\n\n";
}

void writeDescription(const CommentInfo &I, raw_ostream &OS) {
  if (I.Kind == "FullComment") {
    for (const auto &Child : I.Children)
      writeDescription(*Child, OS);
  } else if (I.Kind == "ParagraphComment") {
    for (const auto &Child : I.Children)
      writeDescription(*Child, OS);
    writeNewLine(OS);
  } else if (I.Kind == "BlockCommandComment") {
    OS << genEmphasis(I.Name);
    for (const auto &Child : I.Children)
      writeDescription(*Child, OS);
  } else if (I.Kind == "InlineCommandComment") {
    OS << genEmphasis(I.Name) << " " << I.Text;
  } else if (I.Kind == "ParamCommandComment") {
    std::string Direction = I.Explicit ? (" " + I.Direction).str() : "";
    OS << genEmphasis(I.ParamName) << I.Text << Direction << "\n\n";
  } else if (I.Kind == "TParamCommandComment") {
    std::string Direction = I.Explicit ? (" " + I.Direction).str() : "";
    OS << genEmphasis(I.ParamName) << I.Text << Direction << "\n\n";
  } else if (I.Kind == "VerbatimBlockComment") {
    for (const auto &Child : I.Children)
      writeDescription(*Child, OS);
  } else if (I.Kind == "VerbatimBlockLineComment") {
    OS << I.Text;
    writeNewLine(OS);
  } else if (I.Kind == "VerbatimLineComment") {
    OS << I.Text;
    writeNewLine(OS);
  } else if (I.Kind == "HTMLStartTagComment") {
    if (I.AttrKeys.size() != I.AttrValues.size())
      return;
    std::string Buffer;
    llvm::raw_string_ostream Attrs(Buffer);
    for (unsigned Idx = 0; Idx < I.AttrKeys.size(); ++Idx)
      Attrs << " \"" << I.AttrKeys[Idx] << "=" << I.AttrValues[Idx] << "\"";

    std::string CloseTag = I.SelfClosing ? "/>" : ">";
    writeLine("<" + I.Name + Attrs.str() + CloseTag, OS);
  } else if (I.Kind == "HTMLEndTagComment") {
    writeLine("</" + I.Name + ">", OS);
  } else if (I.Kind == "TextComment") {
    OS << I.Text;
  } else {
    OS << "Unknown comment kind: " << I.Kind << ".\n\n";
  }
}

void genMarkdown(const EnumInfo &I, llvm::raw_ostream &OS) {
  if (I.Scoped)
    writeLine("| enum class " + I.Name + " |", OS);
  else
    writeLine("| enum " + I.Name + " |", OS);
  writeLine("--", OS);

  std::string Buffer;
  llvm::raw_string_ostream Members(Buffer);
  if (!I.Members.empty())
    for (const auto &N : I.Members)
      Members << "| " << N << " |\n";
  writeLine(Members.str(), OS);
  if (I.DefLoc)
    writeFileDefinition(I.DefLoc.getValue(), OS);

  for (const auto &C : I.Description)
    writeDescription(C, OS);
}

void genMarkdown(const FunctionInfo &I, llvm::raw_ostream &OS) {
  std::string Buffer;
  llvm::raw_string_ostream Stream(Buffer);
  bool First = true;
  for (const auto &N : I.Params) {
    if (!First)
      Stream << ", ";
    Stream << N.Type.Name + " " + N.Name;
    First = false;
  }
  writeHeader(I.Name, 3, OS);
  std::string Access = getAccess(I.Access);
  if (Access != "")
    writeLine(genItalic(Access + " " + I.ReturnType.Type.Name + " " + I.Name +
                        "(" + Stream.str() + ")"),
              OS);
  else
    writeLine(genItalic(I.ReturnType.Type.Name + " " + I.Name + "(" +
                        Stream.str() + ")"),
              OS);
  if (I.DefLoc)
    writeFileDefinition(I.DefLoc.getValue(), OS);

  for (const auto &C : I.Description)
    writeDescription(C, OS);
}

void genMarkdown(const NamespaceInfo &I, llvm::raw_ostream &OS) {
  if (I.Name == "")
    writeHeader("Global Namespace", 1, OS);
  else
    writeHeader("namespace " + I.Name, 1, OS);
  writeNewLine(OS);

  if (!I.Description.empty()) {
    for (const auto &C : I.Description)
      writeDescription(C, OS);
    writeNewLine(OS);
  }

  if (!I.ChildNamespaces.empty()) {
    writeHeader("Namespaces", 2, OS);
    for (const auto &R : I.ChildNamespaces)
      writeLine(R.Name, OS);
    writeNewLine(OS);
  }
  if (!I.ChildRecords.empty()) {
    writeHeader("Records", 2, OS);
    for (const auto &R : I.ChildRecords)
      writeLine(R.Name, OS);
    writeNewLine(OS);
  }
  if (!I.ChildFunctions.empty()) {
    writeHeader("Functions", 2, OS);
    for (const auto &F : I.ChildFunctions)
      genMarkdown(F, OS);
    writeNewLine(OS);
  }
  if (!I.ChildEnums.empty()) {
    writeHeader("Enums", 2, OS);
    for (const auto &E : I.ChildEnums)
      genMarkdown(E, OS);
    writeNewLine(OS);
  }
}

void genMarkdown(const RecordInfo &I, llvm::raw_ostream &OS) {
  writeHeader(getTagType(I.TagType) + " " + I.Name, 1, OS);
  if (I.DefLoc)
    writeFileDefinition(I.DefLoc.getValue(), OS);

  if (!I.Description.empty()) {
    for (const auto &C : I.Description)
      writeDescription(C, OS);
    writeNewLine(OS);
  }

  std::string Parents = genReferenceList(I.Parents);
  std::string VParents = genReferenceList(I.VirtualParents);
  if (!Parents.empty() || !VParents.empty()) {
    if (Parents.empty())
      writeLine("Inherits from " + VParents, OS);
    else if (VParents.empty())
      writeLine("Inherits from " + Parents, OS);
    else
      writeLine("Inherits from " + Parents + ", " + VParents, OS);
    writeNewLine(OS);
  }

  if (!I.Members.empty()) {
    writeHeader("Members", 2, OS);
    for (const auto Member : I.Members) {
      std::string Access = getAccess(Member.Access);
      if (Access != "")
        writeLine(Access + " " + Member.Type.Name + " " + Member.Name, OS);
      else
        writeLine(Member.Type.Name + " " + Member.Name, OS);
    }
    writeNewLine(OS);
  }

  if (!I.ChildRecords.empty()) {
    writeHeader("Records", 2, OS);
    for (const auto &R : I.ChildRecords)
      writeLine(R.Name, OS);
    writeNewLine(OS);
  }
  if (!I.ChildFunctions.empty()) {
    writeHeader("Functions", 2, OS);
    for (const auto &F : I.ChildFunctions)
      genMarkdown(F, OS);
    writeNewLine(OS);
  }
  if (!I.ChildEnums.empty()) {
    writeHeader("Enums", 2, OS);
    for (const auto &E : I.ChildEnums)
      genMarkdown(E, OS);
    writeNewLine(OS);
  }
}

/// Generator for Markdown documentation.
class MDGenerator : public Generator {
public:
  static const char *Format;

  llvm::Error generateDocForInfo(Info *I, llvm::raw_ostream &OS) override;
};

const char *MDGenerator::Format = "md";

llvm::Error MDGenerator::generateDocForInfo(Info *I, llvm::raw_ostream &OS) {
  switch (I->IT) {
  case InfoType::IT_namespace:
    genMarkdown(*static_cast<clang::doc::NamespaceInfo *>(I), OS);
    break;
  case InfoType::IT_record:
    genMarkdown(*static_cast<clang::doc::RecordInfo *>(I), OS);
    break;
  case InfoType::IT_enum:
    genMarkdown(*static_cast<clang::doc::EnumInfo *>(I), OS);
    break;
  case InfoType::IT_function:
    genMarkdown(*static_cast<clang::doc::FunctionInfo *>(I), OS);
    break;
  case InfoType::IT_default:
    return llvm::make_error<llvm::StringError>("Unexpected info type.\n",
                                               llvm::inconvertibleErrorCode());
  }
  return llvm::Error::success();
}

static GeneratorRegistry::Add<MDGenerator> MD(MDGenerator::Format,
                                              "Generator for MD output.");

// This anchor is used to force the linker to link in the generated object file
// and thus register the generator.
volatile int MDGeneratorAnchorSource = 0;

} // namespace doc
} // namespace clang
