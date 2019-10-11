//===- llvm/unittest/DebugInfo/GSYMTest.cpp -------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/DebugInfo/GSYM/Header.h"
#include "llvm/DebugInfo/GSYM/FileEntry.h"
#include "llvm/DebugInfo/GSYM/FileWriter.h"
#include "llvm/DebugInfo/GSYM/FunctionInfo.h"
#include "llvm/DebugInfo/GSYM/GsymCreator.h"
#include "llvm/DebugInfo/GSYM/GsymReader.h"
#include "llvm/DebugInfo/GSYM/InlineInfo.h"
#include "llvm/DebugInfo/GSYM/Range.h"
#include "llvm/DebugInfo/GSYM/StringTable.h"
#include "llvm/Support/DataExtractor.h"
#include "llvm/Support/Endian.h"

#include "gtest/gtest.h"
#include <string>

using namespace llvm;
using namespace gsym;

void checkError(ArrayRef<std::string> ExpectedMsgs, Error Err) {
  ASSERT_TRUE(bool(Err));
  size_t WhichMsg = 0;
  Error Remaining =
      handleErrors(std::move(Err), [&](const ErrorInfoBase &Actual) {
        ASSERT_LT(WhichMsg, ExpectedMsgs.size());
        // Use .str(), because googletest doesn't visualise a StringRef
        // properly.
        EXPECT_EQ(Actual.message(), ExpectedMsgs[WhichMsg++]);
      });
  EXPECT_EQ(WhichMsg, ExpectedMsgs.size());
  EXPECT_FALSE(Remaining);
}

void checkError(std::string ExpectedMsg, Error Err) {
  checkError(ArrayRef<std::string>{ExpectedMsg}, std::move(Err));
}
TEST(GSYMTest, TestFileEntry) {
  // Make sure default constructed GSYM FileEntry has zeroes in the
  // directory and basename string table indexes.
  FileEntry empty1;
  FileEntry empty2;
  EXPECT_EQ(empty1.Dir, 0u);
  EXPECT_EQ(empty1.Base, 0u);
  // Verify equality operator works
  FileEntry a1(10, 30);
  FileEntry a2(10, 30);
  FileEntry b(10, 40);
  EXPECT_EQ(empty1, empty2);
  EXPECT_EQ(a1, a2);
  EXPECT_NE(a1, b);
  EXPECT_NE(a1, empty1);
  // Test we can use llvm::gsym::FileEntry in llvm::DenseMap.
  DenseMap<FileEntry, uint32_t> EntryToIndex;
  constexpr uint32_t Index1 = 1;
  constexpr uint32_t Index2 = 1;
  auto R = EntryToIndex.insert(std::make_pair(a1, Index1));
  EXPECT_TRUE(R.second);
  EXPECT_EQ(R.first->second, Index1);
  R = EntryToIndex.insert(std::make_pair(a1, Index1));
  EXPECT_FALSE(R.second);
  EXPECT_EQ(R.first->second, Index1);
  R = EntryToIndex.insert(std::make_pair(b, Index2));
  EXPECT_TRUE(R.second);
  EXPECT_EQ(R.first->second, Index2);
  R = EntryToIndex.insert(std::make_pair(a1, Index2));
  EXPECT_FALSE(R.second);
  EXPECT_EQ(R.first->second, Index2);
}

TEST(GSYMTest, TestFunctionInfo) {
  // Test GSYM FunctionInfo structs and functionality.
  FunctionInfo invalid;
  EXPECT_FALSE(invalid.isValid());
  EXPECT_FALSE(invalid.hasRichInfo());
  const uint64_t StartAddr = 0x1000;
  const uint64_t EndAddr = 0x1100;
  const uint64_t Size = EndAddr - StartAddr;
  const uint32_t NameOffset = 30;
  FunctionInfo FI(StartAddr, Size, NameOffset);
  EXPECT_TRUE(FI.isValid());
  EXPECT_FALSE(FI.hasRichInfo());
  EXPECT_EQ(FI.startAddress(), StartAddr);
  EXPECT_EQ(FI.endAddress(), EndAddr);
  EXPECT_EQ(FI.size(), Size);
  const uint32_t FileIdx = 1;
  const uint32_t Line = 12;
  FI.OptLineTable = LineTable();
  FI.OptLineTable->push(LineEntry(StartAddr,FileIdx,Line));
  EXPECT_TRUE(FI.hasRichInfo());
  FI.clear();
  EXPECT_FALSE(FI.isValid());
  EXPECT_FALSE(FI.hasRichInfo());

  FunctionInfo A1(0x1000, 0x100, NameOffset);
  FunctionInfo A2(0x1000, 0x100, NameOffset);
  FunctionInfo B;
  // Check == operator
  EXPECT_EQ(A1, A2);
  // Make sure things are not equal if they only differ by start address.
  B = A2;
  B.setStartAddress(0x2000);
  EXPECT_NE(B, A2);
  // Make sure things are not equal if they only differ by size.
  B = A2;
  B.setSize(0x101);
  EXPECT_NE(B, A2);
  // Make sure things are not equal if they only differ by name.
  B = A2;
  B.Name = 60;
  EXPECT_NE(B, A2);
  // Check < operator.
  // Check less than where address differs.
  B = A2;
  B.setStartAddress(A2.startAddress() + 0x1000);
  EXPECT_LT(A1, B);

  // We use the < operator to take a variety of different FunctionInfo
  // structs from a variety of sources: symtab, debug info, runtime info
  // and we sort them and want the sorting to allow us to quickly get the
  // best version of a function info.
  FunctionInfo FISymtab(StartAddr, Size, NameOffset);
  FunctionInfo FIWithLines(StartAddr, Size, NameOffset);
  FIWithLines.OptLineTable = LineTable();
  FIWithLines.OptLineTable->push(LineEntry(StartAddr,FileIdx,Line));
  // Test that a FunctionInfo with just a name and size is less than one
  // that has name, size and any number of line table entries
  EXPECT_LT(FISymtab, FIWithLines);

  FunctionInfo FIWithLinesAndInline = FIWithLines;
  FIWithLinesAndInline.Inline = InlineInfo();
  FIWithLinesAndInline.Inline->Ranges.insert(
      AddressRange(StartAddr, StartAddr + 0x10));
  // Test that a FunctionInfo with name, size, and line entries is less than
  // the same one with valid inline info
  EXPECT_LT(FIWithLines, FIWithLinesAndInline);

  // Test if we have an entry with lines and one with more lines for the same
  // range, the ones with more lines is greater than the one with less.
  FunctionInfo FIWithMoreLines = FIWithLines;
  FIWithMoreLines.OptLineTable->push(LineEntry(StartAddr,FileIdx,Line+5));
  EXPECT_LT(FIWithLines, FIWithMoreLines);

  // Test that if we have the same number of lines we compare the line entries
  // in the FunctionInfo.OptLineTable.Lines vector.
  FunctionInfo FIWithLinesWithHigherAddress = FIWithLines;
  FIWithLinesWithHigherAddress.OptLineTable->get(0).Addr += 0x10;
  EXPECT_LT(FIWithLines, FIWithLinesWithHigherAddress);
}

static void TestFunctionInfoDecodeError(llvm::support::endianness ByteOrder,
                                        std::string Bytes,
                                        const uint64_t BaseAddr,
                                        std::string ExpectedErrorMsg) {
  uint8_t AddressSize = 4;
  DataExtractor Data(Bytes, ByteOrder == llvm::support::little, AddressSize);
  llvm::Expected<FunctionInfo> Decoded = FunctionInfo::decode(Data, BaseAddr);
  // Make sure decoding fails.
  ASSERT_FALSE((bool)Decoded);
  // Make sure decoded object is the same as the one we encoded.
  checkError(ExpectedErrorMsg, Decoded.takeError());
}

TEST(GSYMTest, TestFunctionInfoDecodeErrors) {
  // Test decoding FunctionInfo objects that ensure we report an appropriate
  // error message.
  const llvm::support::endianness ByteOrder = llvm::support::little;
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  const uint64_t BaseAddr = 0x100;
  TestFunctionInfoDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000000: missing FunctionInfo Size");
  FW.writeU32(0x100); // Function size.
  TestFunctionInfoDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000004: missing FunctionInfo Name");
  // Write out an invalid Name string table offset of zero.
  FW.writeU32(0);
  TestFunctionInfoDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000004: invalid FunctionInfo Name value 0x00000000");
  // Modify the Name to be 0x00000001, which is a valid value.
  FW.fixup32(0x00000001, 4);
  TestFunctionInfoDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000008: missing FunctionInfo InfoType value");
  auto FixupOffset = FW.tell();
  FW.writeU32(1); // InfoType::LineTableInfo.
  TestFunctionInfoDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x0000000c: missing FunctionInfo InfoType length");
  FW.fixup32(4, FixupOffset); // Write an invalid InfoType enumeration value
  FW.writeU32(0); // LineTableInfo InfoType data length.
  TestFunctionInfoDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000008: unsupported InfoType 4");
}

static void TestFunctionInfoEncodeError(llvm::support::endianness ByteOrder,
                                      const FunctionInfo &FI,
                                      std::string ExpectedErrorMsg) {
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  Expected<uint64_t> ExpectedOffset = FI.encode(FW);
  ASSERT_FALSE(ExpectedOffset);
  checkError(ExpectedErrorMsg, ExpectedOffset.takeError());
}

TEST(GSYMTest, TestFunctionInfoEncodeErrors) {
  const uint64_t FuncAddr = 0x1000;
  const uint64_t FuncSize = 0x100;
  const uint32_t InvalidName = 0;
  const uint32_t ValidName = 1;
  FunctionInfo InvalidNameFI(FuncAddr, FuncSize, InvalidName);
  TestFunctionInfoEncodeError(llvm::support::little, InvalidNameFI,
      "attempted to encode invalid FunctionInfo object");

  FunctionInfo InvalidLineTableFI(FuncAddr, FuncSize, ValidName);
  // Empty line tables are not valid. Verify if the encoding of anything
  // in our line table fails, that we see get the error propagated.
  InvalidLineTableFI.OptLineTable = LineTable();
  TestFunctionInfoEncodeError(llvm::support::little, InvalidLineTableFI,
      "attempted to encode invalid LineTable object");

  FunctionInfo InvalidInlineInfoFI(FuncAddr, FuncSize, ValidName);
  // Empty line tables are not valid. Verify if the encoding of anything
  // in our line table fails, that we see get the error propagated.
  InvalidInlineInfoFI.Inline = InlineInfo();
  TestFunctionInfoEncodeError(llvm::support::little, InvalidInlineInfoFI,
      "attempted to encode invalid InlineInfo object");
}

static void TestFunctionInfoEncodeDecode(llvm::support::endianness ByteOrder,
                                         const FunctionInfo &FI) {
  // Test encoding and decoding FunctionInfo objects.
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  llvm::Expected<uint64_t> ExpectedOffset = FI.encode(FW);
  ASSERT_TRUE(bool(ExpectedOffset));
  // Verify we got the encoded offset back from the encode function.
  ASSERT_EQ(ExpectedOffset.get(), 0ULL);
  std::string Bytes(OutStrm.str());
  uint8_t AddressSize = 4;
  DataExtractor Data(Bytes, ByteOrder == llvm::support::little, AddressSize);
  llvm::Expected<FunctionInfo> Decoded = FunctionInfo::decode(Data,
                                                              FI.Range.Start);
  // Make sure decoding succeeded.
  ASSERT_TRUE((bool)Decoded);
  // Make sure decoded object is the same as the one we encoded.
  EXPECT_EQ(FI, Decoded.get());
}

static void AddLines(uint64_t FuncAddr, uint32_t FileIdx, FunctionInfo &FI) {
    FI.OptLineTable = LineTable();
    LineEntry Line0(FuncAddr + 0x000, FileIdx, 10);
    LineEntry Line1(FuncAddr + 0x010, FileIdx, 11);
    LineEntry Line2(FuncAddr + 0x100, FileIdx, 1000);
    FI.OptLineTable->push(Line0);
    FI.OptLineTable->push(Line1);
    FI.OptLineTable->push(Line2);
}


static void AddInline(uint64_t FuncAddr, uint64_t FuncSize, FunctionInfo &FI) {
    FI.Inline = InlineInfo();
    FI.Inline->Ranges.insert(AddressRange(FuncAddr, FuncAddr + FuncSize));
    InlineInfo Inline1;
    Inline1.Ranges.insert(AddressRange(FuncAddr + 0x10, FuncAddr + 0x30));
    Inline1.Name = 1;
    Inline1.CallFile = 1;
    Inline1.CallLine = 11;
    FI.Inline->Children.push_back(Inline1);
}

TEST(GSYMTest, TestFunctionInfoEncoding) {
  constexpr uint64_t FuncAddr = 0x1000;
  constexpr uint64_t FuncSize = 0x100;
  constexpr uint32_t FuncName = 1;
  constexpr uint32_t FileIdx = 1;
  // Make sure that we can encode and decode a FunctionInfo with no line table
  // or inline info.
  FunctionInfo FI(FuncAddr, FuncSize, FuncName);
  TestFunctionInfoEncodeDecode(llvm::support::little, FI);
  TestFunctionInfoEncodeDecode(llvm::support::big, FI);

  // Make sure that we can encode and decode a FunctionInfo with a line table
  // and no inline info.
  FunctionInfo FILines(FuncAddr, FuncSize, FuncName);
  AddLines(FuncAddr, FileIdx, FILines);
  TestFunctionInfoEncodeDecode(llvm::support::little, FILines);
  TestFunctionInfoEncodeDecode(llvm::support::big, FILines);

  // Make sure that we can encode and decode a FunctionInfo with no line table
  // and with inline info.
  FunctionInfo FIInline(FuncAddr, FuncSize, FuncName);
  AddInline(FuncAddr, FuncSize, FIInline);
  TestFunctionInfoEncodeDecode(llvm::support::little, FIInline);
  TestFunctionInfoEncodeDecode(llvm::support::big, FIInline);

  // Make sure that we can encode and decode a FunctionInfo with no line table
  // and with inline info.
  FunctionInfo FIBoth(FuncAddr, FuncSize, FuncName);
  AddLines(FuncAddr, FileIdx, FIBoth);
  AddInline(FuncAddr, FuncSize, FIBoth);
  TestFunctionInfoEncodeDecode(llvm::support::little, FIBoth);
  TestFunctionInfoEncodeDecode(llvm::support::big, FIBoth);
}

static void TestInlineInfoEncodeDecode(llvm::support::endianness ByteOrder,
                                       const InlineInfo &Inline) {
  // Test encoding and decoding InlineInfo objects
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  const uint64_t BaseAddr = Inline.Ranges[0].Start;
  llvm::Error Err = Inline.encode(FW, BaseAddr);
  ASSERT_FALSE(Err);
  std::string Bytes(OutStrm.str());
  uint8_t AddressSize = 4;
  DataExtractor Data(Bytes, ByteOrder == llvm::support::little, AddressSize);
  llvm::Expected<InlineInfo> Decoded = InlineInfo::decode(Data, BaseAddr);
  // Make sure decoding succeeded.
  ASSERT_TRUE((bool)Decoded);
  // Make sure decoded object is the same as the one we encoded.
  EXPECT_EQ(Inline, Decoded.get());
}

static void TestInlineInfoDecodeError(llvm::support::endianness ByteOrder,
                                      std::string Bytes,
                                      const uint64_t BaseAddr,
                                      std::string ExpectedErrorMsg) {
  uint8_t AddressSize = 4;
  DataExtractor Data(Bytes, ByteOrder == llvm::support::little, AddressSize);
  llvm::Expected<InlineInfo> Decoded = InlineInfo::decode(Data, BaseAddr);
  // Make sure decoding fails.
  ASSERT_FALSE((bool)Decoded);
  // Make sure decoded object is the same as the one we encoded.
  checkError(ExpectedErrorMsg, Decoded.takeError());
}

static void TestInlineInfoEncodeError(llvm::support::endianness ByteOrder,
                                      const InlineInfo &Inline,
                                      std::string ExpectedErrorMsg) {
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  const uint64_t BaseAddr = Inline.Ranges.empty() ? 0 : Inline.Ranges[0].Start;
  llvm::Error Err = Inline.encode(FW, BaseAddr);
  checkError(ExpectedErrorMsg, std::move(Err));
}

TEST(GSYMTest, TestInlineInfo) {
  // Test InlineInfo structs.
  InlineInfo II;
  EXPECT_FALSE(II.isValid());
  II.Ranges.insert(AddressRange(0x1000, 0x2000));
  // Make sure InlineInfo in valid with just an address range since
  // top level InlineInfo objects have ranges with no name, call file
  // or call line
  EXPECT_TRUE(II.isValid());
  // Make sure InlineInfo isn't after being cleared.
  II.clear();
  EXPECT_FALSE(II.isValid());

  // Create an InlineInfo that contains the following data. The
  // indentation of the address range indicates the parent child
  // relationships of the InlineInfo objects:
  //
  // Variable    Range and values
  // =========== ====================================================
  // Root        [0x100-0x200) (no name, file, or line)
  // Inline1       [0x150-0x160) Name = 1, File = 1, Line = 11
  // Inline1Sub1     [0x152-0x155) Name = 2, File = 2, Line = 22
  // Inline1Sub2     [0x157-0x158) Name = 3, File = 3, Line = 33
  InlineInfo Root;
  Root.Ranges.insert(AddressRange(0x100, 0x200));
  InlineInfo Inline1;
  Inline1.Ranges.insert(AddressRange(0x150, 0x160));
  Inline1.Name = 1;
  Inline1.CallFile = 1;
  Inline1.CallLine = 11;
  InlineInfo Inline1Sub1;
  Inline1Sub1.Ranges.insert(AddressRange(0x152, 0x155));
  Inline1Sub1.Name = 2;
  Inline1Sub1.CallFile = 2;
  Inline1Sub1.CallLine = 22;
  InlineInfo Inline1Sub2;
  Inline1Sub2.Ranges.insert(AddressRange(0x157, 0x158));
  Inline1Sub2.Name = 3;
  Inline1Sub2.CallFile = 3;
  Inline1Sub2.CallLine = 33;
  Inline1.Children.push_back(Inline1Sub1);
  Inline1.Children.push_back(Inline1Sub2);
  Root.Children.push_back(Inline1);

  // Make sure an address that is out of range won't match
  EXPECT_FALSE(Root.getInlineStack(0x50));

  // Verify that we get no inline stacks for addresses out of [0x100-0x200)
  EXPECT_FALSE(Root.getInlineStack(Root.Ranges[0].Start - 1));
  EXPECT_FALSE(Root.getInlineStack(Root.Ranges[0].End));

  // Verify we get no inline stack entries for addresses that are in
  // [0x100-0x200) but not in [0x150-0x160)
  EXPECT_FALSE(Root.getInlineStack(Inline1.Ranges[0].Start - 1));
  EXPECT_FALSE(Root.getInlineStack(Inline1.Ranges[0].End));

  // Verify we get one inline stack entry for addresses that are in
  // [[0x150-0x160)) but not in [0x152-0x155) or [0x157-0x158)
  auto InlineInfos = Root.getInlineStack(Inline1.Ranges[0].Start);
  ASSERT_TRUE(InlineInfos);
  ASSERT_EQ(InlineInfos->size(), 1u);
  ASSERT_EQ(*InlineInfos->at(0), Inline1);
  InlineInfos = Root.getInlineStack(Inline1.Ranges[0].End - 1);
  EXPECT_TRUE(InlineInfos);
  ASSERT_EQ(InlineInfos->size(), 1u);
  ASSERT_EQ(*InlineInfos->at(0), Inline1);

  // Verify we get two inline stack entries for addresses that are in
  // [0x152-0x155)
  InlineInfos = Root.getInlineStack(Inline1Sub1.Ranges[0].Start);
  EXPECT_TRUE(InlineInfos);
  ASSERT_EQ(InlineInfos->size(), 2u);
  ASSERT_EQ(*InlineInfos->at(0), Inline1Sub1);
  ASSERT_EQ(*InlineInfos->at(1), Inline1);
  InlineInfos = Root.getInlineStack(Inline1Sub1.Ranges[0].End - 1);
  EXPECT_TRUE(InlineInfos);
  ASSERT_EQ(InlineInfos->size(), 2u);
  ASSERT_EQ(*InlineInfos->at(0), Inline1Sub1);
  ASSERT_EQ(*InlineInfos->at(1), Inline1);

  // Verify we get two inline stack entries for addresses that are in
  // [0x157-0x158)
  InlineInfos = Root.getInlineStack(Inline1Sub2.Ranges[0].Start);
  EXPECT_TRUE(InlineInfos);
  ASSERT_EQ(InlineInfos->size(), 2u);
  ASSERT_EQ(*InlineInfos->at(0), Inline1Sub2);
  ASSERT_EQ(*InlineInfos->at(1), Inline1);
  InlineInfos = Root.getInlineStack(Inline1Sub2.Ranges[0].End - 1);
  EXPECT_TRUE(InlineInfos);
  ASSERT_EQ(InlineInfos->size(), 2u);
  ASSERT_EQ(*InlineInfos->at(0), Inline1Sub2);
  ASSERT_EQ(*InlineInfos->at(1), Inline1);

  // Test encoding and decoding InlineInfo objects
  TestInlineInfoEncodeDecode(llvm::support::little, Root);
  TestInlineInfoEncodeDecode(llvm::support::big, Root);
}

TEST(GSYMTest, TestInlineInfoEncodeErrors) {
  // Test InlineInfo encoding errors.

  // Test that we get an error when trying to encode an InlineInfo object
  // that has no ranges.
  InlineInfo Empty;
  std::string EmptyErr("attempted to encode invalid InlineInfo object");
  TestInlineInfoEncodeError(llvm::support::little, Empty, EmptyErr);
  TestInlineInfoEncodeError(llvm::support::big, Empty, EmptyErr);

  // Verify that we get an error trying to encode an InlineInfo object that has
  // a child InlineInfo that has no ranges.
  InlineInfo ContainsEmpty;
  ContainsEmpty.Ranges.insert({0x100,200});
  ContainsEmpty.Children.push_back(Empty);
  TestInlineInfoEncodeError(llvm::support::little, ContainsEmpty, EmptyErr);
  TestInlineInfoEncodeError(llvm::support::big, ContainsEmpty, EmptyErr);

  // Verify that we get an error trying to encode an InlineInfo object that has
  // a child whose address range is not contained in the parent address range.
  InlineInfo ChildNotContained;
  std::string ChildNotContainedErr("child range not contained in parent");
  ChildNotContained.Ranges.insert({0x100,200});
  InlineInfo ChildNotContainedChild;
  ChildNotContainedChild.Ranges.insert({0x200,300});
  ChildNotContained.Children.push_back(ChildNotContainedChild);
  TestInlineInfoEncodeError(llvm::support::little, ChildNotContained,
                            ChildNotContainedErr);
  TestInlineInfoEncodeError(llvm::support::big, ChildNotContained,
                            ChildNotContainedErr);

}

TEST(GSYMTest, TestInlineInfoDecodeErrors) {
  // Test decoding InlineInfo objects that ensure we report an appropriate
  // error message.
  const llvm::support::endianness ByteOrder = llvm::support::little;
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  const uint64_t BaseAddr = 0x100;
  TestInlineInfoDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000000: missing InlineInfo address ranges data");
  AddressRanges Ranges;
  Ranges.insert({BaseAddr, BaseAddr+0x100});
  Ranges.encode(FW, BaseAddr);
  TestInlineInfoDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000004: missing InlineInfo uint8_t indicating children");
  FW.writeU8(0);
  TestInlineInfoDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000005: missing InlineInfo uint32_t for name");
  FW.writeU32(0);
  TestInlineInfoDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000009: missing ULEB128 for InlineInfo call file");
  FW.writeU8(0);
  TestInlineInfoDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x0000000a: missing ULEB128 for InlineInfo call line");
}

TEST(GSYMTest, TestLineEntry) {
  // test llvm::gsym::LineEntry structs.
  const uint64_t ValidAddr = 0x1000;
  const uint64_t InvalidFileIdx = 0;
  const uint32_t ValidFileIdx = 1;
  const uint32_t ValidLine = 5;

  LineEntry Invalid;
  EXPECT_FALSE(Invalid.isValid());
  // Make sure that an entry is invalid if it has a bad file index.
  LineEntry BadFile(ValidAddr, InvalidFileIdx, ValidLine);
  EXPECT_FALSE(BadFile.isValid());
  // Test operators
  LineEntry E1(ValidAddr, ValidFileIdx, ValidLine);
  LineEntry E2(ValidAddr, ValidFileIdx, ValidLine);
  LineEntry DifferentAddr(ValidAddr + 1, ValidFileIdx, ValidLine);
  LineEntry DifferentFile(ValidAddr, ValidFileIdx + 1, ValidLine);
  LineEntry DifferentLine(ValidAddr, ValidFileIdx, ValidLine + 1);
  EXPECT_TRUE(E1.isValid());
  EXPECT_EQ(E1, E2);
  EXPECT_NE(E1, DifferentAddr);
  EXPECT_NE(E1, DifferentFile);
  EXPECT_NE(E1, DifferentLine);
  EXPECT_LT(E1, DifferentAddr);
}

TEST(GSYMTest, TestRanges) {
  // test llvm::gsym::AddressRange.
  const uint64_t StartAddr = 0x1000;
  const uint64_t EndAddr = 0x2000;
  // Verify constructor and API to ensure it takes start and end address.
  const AddressRange Range(StartAddr, EndAddr);
  EXPECT_EQ(Range.size(), EndAddr - StartAddr);

  // Verify llvm::gsym::AddressRange::contains().
  EXPECT_FALSE(Range.contains(0));
  EXPECT_FALSE(Range.contains(StartAddr - 1));
  EXPECT_TRUE(Range.contains(StartAddr));
  EXPECT_TRUE(Range.contains(EndAddr - 1));
  EXPECT_FALSE(Range.contains(EndAddr));
  EXPECT_FALSE(Range.contains(UINT64_MAX));

  const AddressRange RangeSame(StartAddr, EndAddr);
  const AddressRange RangeDifferentStart(StartAddr + 1, EndAddr);
  const AddressRange RangeDifferentEnd(StartAddr, EndAddr + 1);
  const AddressRange RangeDifferentStartEnd(StartAddr + 1, EndAddr + 1);
  // Test == and != with values that are the same
  EXPECT_EQ(Range, RangeSame);
  EXPECT_FALSE(Range != RangeSame);
  // Test == and != with values that are the different
  EXPECT_NE(Range, RangeDifferentStart);
  EXPECT_NE(Range, RangeDifferentEnd);
  EXPECT_NE(Range, RangeDifferentStartEnd);
  EXPECT_FALSE(Range == RangeDifferentStart);
  EXPECT_FALSE(Range == RangeDifferentEnd);
  EXPECT_FALSE(Range == RangeDifferentStartEnd);

  // Test "bool operator<(const AddressRange &, const AddressRange &)".
  EXPECT_FALSE(Range < RangeSame);
  EXPECT_FALSE(RangeSame < Range);
  EXPECT_LT(Range, RangeDifferentStart);
  EXPECT_LT(Range, RangeDifferentEnd);
  EXPECT_LT(Range, RangeDifferentStartEnd);
  // Test "bool operator<(const AddressRange &, uint64_t)"
  EXPECT_LT(Range.Start, StartAddr + 1);
  // Test "bool operator<(uint64_t, const AddressRange &)"
  EXPECT_LT(StartAddr - 1, Range.Start);

  // Verify llvm::gsym::AddressRange::isContiguousWith() and
  // llvm::gsym::AddressRange::intersects().
  const AddressRange EndsBeforeRangeStart(0, StartAddr - 1);
  const AddressRange EndsAtRangeStart(0, StartAddr);
  const AddressRange OverlapsRangeStart(StartAddr - 1, StartAddr + 1);
  const AddressRange InsideRange(StartAddr + 1, EndAddr - 1);
  const AddressRange OverlapsRangeEnd(EndAddr - 1, EndAddr + 1);
  const AddressRange StartsAtRangeEnd(EndAddr, EndAddr + 0x100);
  const AddressRange StartsAfterRangeEnd(EndAddr + 1, EndAddr + 0x100);

  EXPECT_FALSE(Range.intersects(EndsBeforeRangeStart));
  EXPECT_FALSE(Range.intersects(EndsAtRangeStart));
  EXPECT_TRUE(Range.intersects(OverlapsRangeStart));
  EXPECT_TRUE(Range.intersects(InsideRange));
  EXPECT_TRUE(Range.intersects(OverlapsRangeEnd));
  EXPECT_FALSE(Range.intersects(StartsAtRangeEnd));
  EXPECT_FALSE(Range.intersects(StartsAfterRangeEnd));

  // Test the functions that maintain GSYM address ranges:
  //  "bool AddressRange::contains(uint64_t Addr) const;"
  //  "void AddressRanges::insert(const AddressRange &R);"
  AddressRanges Ranges;
  Ranges.insert(AddressRange(0x1000, 0x2000));
  Ranges.insert(AddressRange(0x2000, 0x3000));
  Ranges.insert(AddressRange(0x4000, 0x5000));

  EXPECT_FALSE(Ranges.contains(0));
  EXPECT_FALSE(Ranges.contains(0x1000 - 1));
  EXPECT_TRUE(Ranges.contains(0x1000));
  EXPECT_TRUE(Ranges.contains(0x2000));
  EXPECT_TRUE(Ranges.contains(0x4000));
  EXPECT_TRUE(Ranges.contains(0x2000 - 1));
  EXPECT_TRUE(Ranges.contains(0x3000 - 1));
  EXPECT_FALSE(Ranges.contains(0x3000 + 1));
  EXPECT_TRUE(Ranges.contains(0x5000 - 1));
  EXPECT_FALSE(Ranges.contains(0x5000 + 1));
  EXPECT_FALSE(Ranges.contains(UINT64_MAX));

  EXPECT_FALSE(Ranges.contains(AddressRange()));
  EXPECT_FALSE(Ranges.contains(AddressRange(0x1000-1, 0x1000)));
  EXPECT_FALSE(Ranges.contains(AddressRange(0x1000, 0x1000)));
  EXPECT_TRUE(Ranges.contains(AddressRange(0x1000, 0x1000+1)));
  EXPECT_TRUE(Ranges.contains(AddressRange(0x1000, 0x2000)));
  EXPECT_FALSE(Ranges.contains(AddressRange(0x1000, 0x2001)));
  EXPECT_TRUE(Ranges.contains(AddressRange(0x2000, 0x3000)));
  EXPECT_FALSE(Ranges.contains(AddressRange(0x2000, 0x3001)));
  EXPECT_FALSE(Ranges.contains(AddressRange(0x3000, 0x3001)));
  EXPECT_FALSE(Ranges.contains(AddressRange(0x1500, 0x4500)));
  EXPECT_FALSE(Ranges.contains(AddressRange(0x5000, 0x5001)));

  // Verify that intersecting ranges get combined
  Ranges.clear();
  Ranges.insert(AddressRange(0x1100, 0x1F00));
  // Verify a wholy contained range that is added doesn't do anything.
  Ranges.insert(AddressRange(0x1500, 0x1F00));
  EXPECT_EQ(Ranges.size(), 1u);
  EXPECT_EQ(Ranges[0], AddressRange(0x1100, 0x1F00));

  // Verify a range that starts before and intersects gets combined.
  Ranges.insert(AddressRange(0x1000, Ranges[0].Start + 1));
  EXPECT_EQ(Ranges.size(), 1u);
  EXPECT_EQ(Ranges[0], AddressRange(0x1000, 0x1F00));

  // Verify a range that starts inside and extends ranges gets combined.
  Ranges.insert(AddressRange(Ranges[0].End - 1, 0x2000));
  EXPECT_EQ(Ranges.size(), 1u);
  EXPECT_EQ(Ranges[0], AddressRange(0x1000, 0x2000));

  // Verify that adjacent ranges don't get combined
  Ranges.insert(AddressRange(0x2000, 0x3000));
  EXPECT_EQ(Ranges.size(), 2u);
  EXPECT_EQ(Ranges[0], AddressRange(0x1000, 0x2000));
  EXPECT_EQ(Ranges[1], AddressRange(0x2000, 0x3000));
  // Verify if we add an address range that intersects two ranges
  // that they get combined
  Ranges.insert(AddressRange(Ranges[0].End - 1, Ranges[1].Start + 1));
  EXPECT_EQ(Ranges.size(), 1u);
  EXPECT_EQ(Ranges[0], AddressRange(0x1000, 0x3000));

  Ranges.insert(AddressRange(0x3000, 0x4000));
  Ranges.insert(AddressRange(0x4000, 0x5000));
  Ranges.insert(AddressRange(0x2000, 0x4500));
  EXPECT_EQ(Ranges.size(), 1u);
  EXPECT_EQ(Ranges[0], AddressRange(0x1000, 0x5000));
}

TEST(GSYMTest, TestStringTable) {
  StringTable StrTab(StringRef("\0Hello\0World\0", 13));
  // Test extracting strings from a string table.
  EXPECT_EQ(StrTab.getString(0), "");
  EXPECT_EQ(StrTab.getString(1), "Hello");
  EXPECT_EQ(StrTab.getString(7), "World");
  EXPECT_EQ(StrTab.getString(8), "orld");
  // Test pointing to last NULL terminator gets empty string.
  EXPECT_EQ(StrTab.getString(12), "");
  // Test pointing to past end gets empty string.
  EXPECT_EQ(StrTab.getString(13), "");
}

static void TestFileWriterHelper(llvm::support::endianness ByteOrder) {
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  const int64_t MinSLEB = INT64_MIN;
  const int64_t MaxSLEB = INT64_MAX;
  const uint64_t MinULEB = 0;
  const uint64_t MaxULEB = UINT64_MAX;
  const uint8_t U8 = 0x10;
  const uint16_t U16 = 0x1122;
  const uint32_t U32 = 0x12345678;
  const uint64_t U64 = 0x33445566778899aa;
  const char *Hello = "hello";
  FW.writeU8(U8);
  FW.writeU16(U16);
  FW.writeU32(U32);
  FW.writeU64(U64);
  FW.alignTo(16);
  const off_t FixupOffset = FW.tell();
  FW.writeU32(0);
  FW.writeSLEB(MinSLEB);
  FW.writeSLEB(MaxSLEB);
  FW.writeULEB(MinULEB);
  FW.writeULEB(MaxULEB);
  FW.writeNullTerminated(Hello);
  // Test Seek, Tell using Fixup32.
  FW.fixup32(U32, FixupOffset);

  std::string Bytes(OutStrm.str());
  uint8_t AddressSize = 4;
  DataExtractor Data(Bytes, ByteOrder == llvm::support::little, AddressSize);
  uint64_t Offset = 0;
  EXPECT_EQ(Data.getU8(&Offset), U8);
  EXPECT_EQ(Data.getU16(&Offset), U16);
  EXPECT_EQ(Data.getU32(&Offset), U32);
  EXPECT_EQ(Data.getU64(&Offset), U64);
  Offset = alignTo(Offset, 16);
  EXPECT_EQ(Data.getU32(&Offset), U32);
  EXPECT_EQ(Data.getSLEB128(&Offset), MinSLEB);
  EXPECT_EQ(Data.getSLEB128(&Offset), MaxSLEB);
  EXPECT_EQ(Data.getULEB128(&Offset), MinULEB);
  EXPECT_EQ(Data.getULEB128(&Offset), MaxULEB);
  EXPECT_EQ(Data.getCStrRef(&Offset), StringRef(Hello));
}

TEST(GSYMTest, TestFileWriter) {
  TestFileWriterHelper(llvm::support::little);
  TestFileWriterHelper(llvm::support::big);
}

TEST(GSYMTest, TestAddressRangeEncodeDecode) {
  // Test encoding and decoding AddressRange objects. AddressRange objects
  // are always stored as offsets from the a base address. The base address
  // is the FunctionInfo's base address for function level ranges, and is
  // the base address of the parent range for subranges.
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  const auto ByteOrder = llvm::support::endian::system_endianness();
  FileWriter FW(OutStrm, ByteOrder);
  const uint64_t BaseAddr = 0x1000;
  const AddressRange Range1(0x1000, 0x1010);
  const AddressRange Range2(0x1020, 0x1030);
  Range1.encode(FW, BaseAddr);
  Range2.encode(FW, BaseAddr);
  std::string Bytes(OutStrm.str());
  uint8_t AddressSize = 4;
  DataExtractor Data(Bytes, ByteOrder == llvm::support::little, AddressSize);

  AddressRange DecodedRange1, DecodedRange2;
  uint64_t Offset = 0;
  DecodedRange1.decode(Data, BaseAddr, Offset);
  DecodedRange2.decode(Data, BaseAddr, Offset);
  EXPECT_EQ(Range1, DecodedRange1);
  EXPECT_EQ(Range2, DecodedRange2);
}

static void TestAddressRangeEncodeDecodeHelper(const AddressRanges &Ranges,
                                               const uint64_t BaseAddr) {
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  const auto ByteOrder = llvm::support::endian::system_endianness();
  FileWriter FW(OutStrm, ByteOrder);
  Ranges.encode(FW, BaseAddr);

  std::string Bytes(OutStrm.str());
  uint8_t AddressSize = 4;
  DataExtractor Data(Bytes, ByteOrder == llvm::support::little, AddressSize);

  AddressRanges DecodedRanges;
  uint64_t Offset = 0;
  DecodedRanges.decode(Data, BaseAddr, Offset);
  EXPECT_EQ(Ranges, DecodedRanges);
}

TEST(GSYMTest, TestAddressRangesEncodeDecode) {
  // Test encoding and decoding AddressRanges. AddressRanges objects contain
  // ranges that are stored as offsets from the a base address. The base address
  // is the FunctionInfo's base address for function level ranges, and is the
  // base address of the parent range for subranges.
  const uint64_t BaseAddr = 0x1000;

  // Test encoding and decoding with no ranges.
  AddressRanges Ranges;
  TestAddressRangeEncodeDecodeHelper(Ranges, BaseAddr);

  // Test encoding and decoding with 1 range.
  Ranges.insert(AddressRange(0x1000, 0x1010));
  TestAddressRangeEncodeDecodeHelper(Ranges, BaseAddr);

  // Test encoding and decoding with multiple ranges.
  Ranges.insert(AddressRange(0x1020, 0x1030));
  Ranges.insert(AddressRange(0x1050, 0x1070));
  TestAddressRangeEncodeDecodeHelper(Ranges, BaseAddr);
}

static void TestLineTableHelper(llvm::support::endianness ByteOrder,
                                const LineTable &LT) {
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  const uint64_t BaseAddr = LT[0].Addr;
  llvm::Error Err = LT.encode(FW, BaseAddr);
  ASSERT_FALSE(Err);
  std::string Bytes(OutStrm.str());
  uint8_t AddressSize = 4;
  DataExtractor Data(Bytes, ByteOrder == llvm::support::little, AddressSize);
  llvm::Expected<LineTable> Decoded = LineTable::decode(Data, BaseAddr);
  // Make sure decoding succeeded.
  ASSERT_TRUE((bool)Decoded);
  // Make sure decoded object is the same as the one we encoded.
  EXPECT_EQ(LT, Decoded.get());
}

TEST(GSYMTest, TestLineTable) {
  const uint64_t StartAddr = 0x1000;
  const uint32_t FileIdx = 1;
  LineTable LT;
  LineEntry Line0(StartAddr+0x000, FileIdx, 10);
  LineEntry Line1(StartAddr+0x010, FileIdx, 11);
  LineEntry Line2(StartAddr+0x100, FileIdx, 1000);
  ASSERT_TRUE(LT.empty());
  ASSERT_EQ(LT.size(), (size_t)0);
  LT.push(Line0);
  ASSERT_EQ(LT.size(), (size_t)1);
  LT.push(Line1);
  LT.push(Line2);
  LT.push(LineEntry(StartAddr+0x120, FileIdx, 900));
  LT.push(LineEntry(StartAddr+0x120, FileIdx, 2000));
  LT.push(LineEntry(StartAddr+0x121, FileIdx, 2001));
  LT.push(LineEntry(StartAddr+0x122, FileIdx, 2002));
  LT.push(LineEntry(StartAddr+0x123, FileIdx, 2003));
  ASSERT_FALSE(LT.empty());
  ASSERT_EQ(LT.size(), (size_t)8);
  // Test operator[].
  ASSERT_EQ(LT[0], Line0);
  ASSERT_EQ(LT[1], Line1);
  ASSERT_EQ(LT[2], Line2);

  // Test encoding and decoding line tables.
  TestLineTableHelper(llvm::support::little, LT);
  TestLineTableHelper(llvm::support::big, LT);

  // Verify the clear method works as expected.
  LT.clear();
  ASSERT_TRUE(LT.empty());
  ASSERT_EQ(LT.size(), (size_t)0);

  LineTable LT1;
  LineTable LT2;

  // Test that two empty line tables are equal and neither are less than
  // each other.
  ASSERT_EQ(LT1, LT2);
  ASSERT_FALSE(LT1 < LT2);
  ASSERT_FALSE(LT2 < LT2);

  // Test that a line table with less number of line entries is less than a
  // line table with more line entries and that they are not equal.
  LT2.push(Line0);
  ASSERT_LT(LT1, LT2);
  ASSERT_NE(LT1, LT2);

  // Test that two line tables with the same entries are equal.
  LT1.push(Line0);
  ASSERT_EQ(LT1, LT2);
  ASSERT_FALSE(LT1 < LT2);
  ASSERT_FALSE(LT2 < LT2);
}

static void TestLineTableDecodeError(llvm::support::endianness ByteOrder,
                                     std::string Bytes,
                                     const uint64_t BaseAddr,
                                     std::string ExpectedErrorMsg) {
  uint8_t AddressSize = 4;
  DataExtractor Data(Bytes, ByteOrder == llvm::support::little, AddressSize);
  llvm::Expected<LineTable> Decoded = LineTable::decode(Data, BaseAddr);
  // Make sure decoding fails.
  ASSERT_FALSE((bool)Decoded);
  // Make sure decoded object is the same as the one we encoded.
  checkError(ExpectedErrorMsg, Decoded.takeError());
}

TEST(GSYMTest, TestLineTableDecodeErrors) {
  // Test decoding InlineInfo objects that ensure we report an appropriate
  // error message.
  const llvm::support::endianness ByteOrder = llvm::support::little;
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  const uint64_t BaseAddr = 0x100;
  TestLineTableDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000000: missing LineTable MinDelta");
  FW.writeU8(1); // MinDelta (ULEB)
  TestLineTableDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000001: missing LineTable MaxDelta");
  FW.writeU8(10); // MaxDelta (ULEB)
  TestLineTableDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000002: missing LineTable FirstLine");
  FW.writeU8(20); // FirstLine (ULEB)
  TestLineTableDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000003: EOF found before EndSequence");
  // Test a SetFile with the argument missing from the stream
  FW.writeU8(1); // SetFile opcode (uint8_t)
  TestLineTableDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000004: EOF found before SetFile value");
  FW.writeU8(5); // SetFile value as index (ULEB)
  // Test a AdvancePC with the argument missing from the stream
  FW.writeU8(2); // AdvancePC opcode (uint8_t)
  TestLineTableDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000006: EOF found before AdvancePC value");
  FW.writeU8(20); // AdvancePC value as offset (ULEB)
  // Test a AdvancePC with the argument missing from the stream
  FW.writeU8(3); // AdvanceLine opcode (uint8_t)
  TestLineTableDecodeError(ByteOrder, OutStrm.str(), BaseAddr,
      "0x00000008: EOF found before AdvanceLine value");
  FW.writeU8(20); // AdvanceLine value as offset (LLEB)
}

TEST(GSYMTest, TestLineTableEncodeErrors) {
  const uint64_t BaseAddr = 0x1000;
  const uint32_t FileIdx = 1;
  const llvm::support::endianness ByteOrder = llvm::support::little;
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  LineTable LT;
  checkError("attempted to encode invalid LineTable object",
             LT.encode(FW, BaseAddr));

  // Try to encode a line table where a line entry has an address that is less
  // than BaseAddr and verify we get an appropriate error.
  LineEntry Line0(BaseAddr+0x000, FileIdx, 10);
  LineEntry Line1(BaseAddr+0x010, FileIdx, 11);
  LT.push(Line0);
  LT.push(Line1);
  checkError("LineEntry has address 0x1000 which is less than the function "
             "start address 0x1010", LT.encode(FW, BaseAddr+0x10));
  LT.clear();

  // Try to encode a line table where a line entries  has an address that is less
  // than BaseAddr and verify we get an appropriate error.
  LT.push(Line1);
  LT.push(Line0);
  checkError("LineEntry in LineTable not in ascending order",
             LT.encode(FW, BaseAddr));
  LT.clear();
}

static void TestHeaderEncodeError(const Header &H,
                                  std::string ExpectedErrorMsg) {
  const support::endianness ByteOrder = llvm::support::little;
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  llvm::Error Err = H.encode(FW);
  checkError(ExpectedErrorMsg, std::move(Err));
}

static void TestHeaderDecodeError(std::string Bytes,
                                  std::string ExpectedErrorMsg) {
  const support::endianness ByteOrder = llvm::support::little;
  uint8_t AddressSize = 4;
  DataExtractor Data(Bytes, ByteOrder == llvm::support::little, AddressSize);
  llvm::Expected<Header> Decoded = Header::decode(Data);
  // Make sure decoding fails.
  ASSERT_FALSE((bool)Decoded);
  // Make sure decoded object is the same as the one we encoded.
  checkError(ExpectedErrorMsg, Decoded.takeError());
}

// Populate a GSYM header with valid values.
static void InitHeader(Header &H) {
  H.Magic = GSYM_MAGIC;
  H.Version = GSYM_VERSION;
  H.AddrOffSize = 4;
  H.UUIDSize = 16;
  H.BaseAddress = 0x1000;
  H.NumAddresses = 1;
  H.StrtabOffset= 0x2000;
  H.StrtabSize = 0x1000;
  for (size_t i=0; i<GSYM_MAX_UUID_SIZE; ++i) {
    if (i < H.UUIDSize)
      H.UUID[i] = i;
    else
      H.UUID[i] = 0;
  }
}

TEST(GSYMTest, TestHeaderEncodeErrors) {
  Header H;
  InitHeader(H);
  H.Magic = 12;
  TestHeaderEncodeError(H, "invalid GSYM magic 0x0000000c");
  InitHeader(H);
  H.Version = 12;
  TestHeaderEncodeError(H, "unsupported GSYM version 12");
  InitHeader(H);
  H.AddrOffSize = 12;
  TestHeaderEncodeError(H, "invalid address offset size 12");
  InitHeader(H);
  H.UUIDSize = 128;
  TestHeaderEncodeError(H, "invalid UUID size 128");
}

TEST(GSYMTest, TestHeaderDecodeErrors) {
  const llvm::support::endianness ByteOrder = llvm::support::little;
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  Header H;
  InitHeader(H);
  llvm::Error Err = H.encode(FW);
  ASSERT_FALSE(Err);
  FW.fixup32(12, offsetof(Header, Magic));
  TestHeaderDecodeError(OutStrm.str(), "invalid GSYM magic 0x0000000c");
  FW.fixup32(GSYM_MAGIC, offsetof(Header, Magic));
  FW.fixup32(12, offsetof(Header, Version));
  TestHeaderDecodeError(OutStrm.str(), "unsupported GSYM version 12");
  FW.fixup32(GSYM_VERSION, offsetof(Header, Version));
  FW.fixup32(12, offsetof(Header, AddrOffSize));
  TestHeaderDecodeError(OutStrm.str(), "invalid address offset size 12");
  FW.fixup32(4, offsetof(Header, AddrOffSize));
  FW.fixup32(128, offsetof(Header, UUIDSize));
  TestHeaderDecodeError(OutStrm.str(), "invalid UUID size 128");
}

static void TestHeaderEncodeDecode(const Header &H,
                                   support::endianness ByteOrder) {
  uint8_t AddressSize = 4;
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  llvm::Error Err = H.encode(FW);
  ASSERT_FALSE(Err);
  std::string Bytes(OutStrm.str());
  DataExtractor Data(Bytes, ByteOrder == llvm::support::little, AddressSize);
  llvm::Expected<Header> Decoded = Header::decode(Data);
  // Make sure decoding succeeded.
  ASSERT_TRUE((bool)Decoded);
  EXPECT_EQ(H, Decoded.get());

}
TEST(GSYMTest, TestHeaderEncodeDecode) {
  Header H;
  InitHeader(H);
  TestHeaderEncodeDecode(H, llvm::support::little);
  TestHeaderEncodeDecode(H, llvm::support::big);
}

static void TestGsymCreatorEncodeError(llvm::support::endianness ByteOrder,
                                       const GsymCreator &GC,
                                       std::string ExpectedErrorMsg) {
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  llvm::Error Err = GC.encode(FW);
  ASSERT_TRUE(bool(Err));
  checkError(ExpectedErrorMsg, std::move(Err));
}

TEST(GSYMTest, TestGsymCreatorEncodeErrors) {
  const uint8_t ValidUUID[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
                               14, 15, 16};
  const uint8_t InvalidUUID[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
                                 14, 15, 16, 17, 18, 19, 20, 21};
  // Verify we get an error when trying to encode an GsymCreator with no
  // function infos. We shouldn't be saving a GSYM file in this case since
  // there is nothing inside of it.
  GsymCreator GC;
  TestGsymCreatorEncodeError(llvm::support::little, GC,
                             "no functions to encode");
  const uint64_t FuncAddr = 0x1000;
  const uint64_t FuncSize = 0x100;
  const uint32_t FuncName = GC.insertString("foo");
  // Verify we get an error trying to encode a GsymCreator that isn't
  // finalized.
  GC.addFunctionInfo(FunctionInfo(FuncAddr, FuncSize, FuncName));
  TestGsymCreatorEncodeError(llvm::support::little, GC,
                             "GsymCreator wasn't finalized prior to encoding");
  std::string finalizeIssues;
  raw_string_ostream OS(finalizeIssues);
  llvm::Error finalizeErr = GC.finalize(OS);
  ASSERT_FALSE(bool(finalizeErr));
  finalizeErr = GC.finalize(OS);
  ASSERT_TRUE(bool(finalizeErr));
  checkError("already finalized", std::move(finalizeErr));
  // Verify we get an error trying to encode a GsymCreator with a UUID that is
  // too long.
  GC.setUUID(InvalidUUID);
  TestGsymCreatorEncodeError(llvm::support::little, GC,
                             "invalid UUID size 21");
  GC.setUUID(ValidUUID);
  // Verify errors are propagated when we try to encoding an invalid line
  // table.
  GC.forEachFunctionInfo([](FunctionInfo &FI) -> bool {
    FI.OptLineTable = LineTable(); // Invalid line table.
    return false; // Stop iterating
  });
  TestGsymCreatorEncodeError(llvm::support::little, GC,
                             "attempted to encode invalid LineTable object");
  // Verify errors are propagated when we try to encoding an invalid inline
  // info.
  GC.forEachFunctionInfo([](FunctionInfo &FI) -> bool {
    FI.OptLineTable = llvm::None;
    FI.Inline = InlineInfo(); // Invalid InlineInfo.
    return false; // Stop iterating
  });
  TestGsymCreatorEncodeError(llvm::support::little, GC,
                             "attempted to encode invalid InlineInfo object");
}

static void Compare(const GsymCreator &GC, const GsymReader &GR) {
  // Verify that all of the data in a GsymCreator is correctly decoded from
  // a GsymReader. To do this, we iterator over
  GC.forEachFunctionInfo([&](const FunctionInfo &FI) -> bool {
    auto DecodedFI = GR.getFunctionInfo(FI.Range.Start);
    EXPECT_TRUE(bool(DecodedFI));
    EXPECT_EQ(FI, *DecodedFI);
    return true; // Keep iterating over all FunctionInfo objects.
  });
}

static void TestEncodeDecode(const GsymCreator &GC,
                             support::endianness ByteOrder, uint16_t Version,
                             uint8_t AddrOffSize, uint64_t BaseAddress,
                             uint32_t NumAddresses, ArrayRef<uint8_t> UUID) {
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  llvm::Error Err = GC.encode(FW);
  ASSERT_FALSE((bool)Err);
  Expected<GsymReader> GR = GsymReader::copyBuffer(OutStrm.str());
  ASSERT_TRUE(bool(GR));
  const Header &Hdr = GR->getHeader();
  EXPECT_EQ(Hdr.Version, Version);
  EXPECT_EQ(Hdr.AddrOffSize, AddrOffSize);
  EXPECT_EQ(Hdr.UUIDSize, UUID.size());
  EXPECT_EQ(Hdr.BaseAddress, BaseAddress);
  EXPECT_EQ(Hdr.NumAddresses, NumAddresses);
  EXPECT_EQ(ArrayRef<uint8_t>(Hdr.UUID, Hdr.UUIDSize), UUID);
  Compare(GC, GR.get());
}

TEST(GSYMTest, TestGsymCreator1ByteAddrOffsets) {
  uint8_t UUID[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
  GsymCreator GC;
  GC.setUUID(UUID);
  constexpr uint64_t BaseAddr = 0x1000;
  constexpr uint8_t AddrOffSize = 1;
  const uint32_t Func1Name = GC.insertString("foo");
  const uint32_t Func2Name = GC.insertString("bar");
  GC.addFunctionInfo(FunctionInfo(BaseAddr+0x00, 0x10, Func1Name));
  GC.addFunctionInfo(FunctionInfo(BaseAddr+0x20, 0x10, Func2Name));
  Error Err = GC.finalize(llvm::nulls());
  ASSERT_FALSE(Err);
  TestEncodeDecode(GC, llvm::support::little,
                   GSYM_VERSION,
                   AddrOffSize,
                   BaseAddr,
                   2, // NumAddresses
                   ArrayRef<uint8_t>(UUID));
  TestEncodeDecode(GC, llvm::support::big,
                   GSYM_VERSION,
                   AddrOffSize,
                   BaseAddr,
                   2, // NumAddresses
                   ArrayRef<uint8_t>(UUID));
}

TEST(GSYMTest, TestGsymCreator2ByteAddrOffsets) {
  uint8_t UUID[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
  GsymCreator GC;
  GC.setUUID(UUID);
  constexpr uint64_t BaseAddr = 0x1000;
  constexpr uint8_t AddrOffSize = 2;
  const uint32_t Func1Name = GC.insertString("foo");
  const uint32_t Func2Name = GC.insertString("bar");
  GC.addFunctionInfo(FunctionInfo(BaseAddr+0x000, 0x100, Func1Name));
  GC.addFunctionInfo(FunctionInfo(BaseAddr+0x200, 0x100, Func2Name));
  Error Err = GC.finalize(llvm::nulls());
  ASSERT_FALSE(Err);
  TestEncodeDecode(GC, llvm::support::little,
                   GSYM_VERSION,
                   AddrOffSize,
                   BaseAddr,
                   2, // NumAddresses
                   ArrayRef<uint8_t>(UUID));
  TestEncodeDecode(GC, llvm::support::big,
                   GSYM_VERSION,
                   AddrOffSize,
                   BaseAddr,
                   2, // NumAddresses
                   ArrayRef<uint8_t>(UUID));
}

TEST(GSYMTest, TestGsymCreator4ByteAddrOffsets) {
  uint8_t UUID[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
  GsymCreator GC;
  GC.setUUID(UUID);
  constexpr uint64_t BaseAddr = 0x1000;
  constexpr uint8_t AddrOffSize = 4;
  const uint32_t Func1Name = GC.insertString("foo");
  const uint32_t Func2Name = GC.insertString("bar");
  GC.addFunctionInfo(FunctionInfo(BaseAddr+0x000, 0x100, Func1Name));
  GC.addFunctionInfo(FunctionInfo(BaseAddr+0x20000, 0x100, Func2Name));
  Error Err = GC.finalize(llvm::nulls());
  ASSERT_FALSE(Err);
  TestEncodeDecode(GC, llvm::support::little,
                   GSYM_VERSION,
                   AddrOffSize,
                   BaseAddr,
                   2, // NumAddresses
                   ArrayRef<uint8_t>(UUID));
  TestEncodeDecode(GC, llvm::support::big,
                   GSYM_VERSION,
                   AddrOffSize,
                   BaseAddr,
                   2, // NumAddresses
                   ArrayRef<uint8_t>(UUID));
}

TEST(GSYMTest, TestGsymCreator8ByteAddrOffsets) {
  uint8_t UUID[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
  GsymCreator GC;
  GC.setUUID(UUID);
  constexpr uint64_t BaseAddr = 0x1000;
  constexpr uint8_t AddrOffSize = 8;
  const uint32_t Func1Name = GC.insertString("foo");
  const uint32_t Func2Name = GC.insertString("bar");
  GC.addFunctionInfo(FunctionInfo(BaseAddr+0x000, 0x100, Func1Name));
  GC.addFunctionInfo(FunctionInfo(BaseAddr+0x100000000, 0x100, Func2Name));
  Error Err = GC.finalize(llvm::nulls());
  ASSERT_FALSE(Err);
  TestEncodeDecode(GC, llvm::support::little,
                   GSYM_VERSION,
                   AddrOffSize,
                   BaseAddr,
                   2, // NumAddresses
                   ArrayRef<uint8_t>(UUID));
  TestEncodeDecode(GC, llvm::support::big,
                   GSYM_VERSION,
                   AddrOffSize,
                   BaseAddr,
                   2, // NumAddresses
                   ArrayRef<uint8_t>(UUID));
}

static void VerifyFunctionInfo(const GsymReader &GR, uint64_t Addr,
                               const FunctionInfo &FI) {
  auto ExpFI = GR.getFunctionInfo(Addr);
  ASSERT_TRUE(bool(ExpFI));
  ASSERT_EQ(FI, ExpFI.get());
}

static void VerifyFunctionInfoError(const GsymReader &GR, uint64_t Addr,
                                    std::string ErrMessage) {
  auto ExpFI = GR.getFunctionInfo(Addr);
  ASSERT_FALSE(bool(ExpFI));
  checkError(ErrMessage, ExpFI.takeError());
}

TEST(GSYMTest, TestGsymReader) {
  uint8_t UUID[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};
  GsymCreator GC;
  GC.setUUID(UUID);
  constexpr uint64_t BaseAddr = 0x1000;
  constexpr uint64_t Func1Addr = BaseAddr;
  constexpr uint64_t Func2Addr = BaseAddr+0x20;
  constexpr uint64_t FuncSize = 0x10;
  const uint32_t Func1Name = GC.insertString("foo");
  const uint32_t Func2Name = GC.insertString("bar");
  const auto ByteOrder = support::endian::system_endianness();
  GC.addFunctionInfo(FunctionInfo(Func1Addr, FuncSize, Func1Name));
  GC.addFunctionInfo(FunctionInfo(Func2Addr, FuncSize, Func2Name));
  Error FinalizeErr = GC.finalize(llvm::nulls());
  ASSERT_FALSE(FinalizeErr);
  SmallString<512> Str;
  raw_svector_ostream OutStrm(Str);
  FileWriter FW(OutStrm, ByteOrder);
  llvm::Error Err = GC.encode(FW);
  ASSERT_FALSE((bool)Err);
  if (auto ExpectedGR = GsymReader::copyBuffer(OutStrm.str())) {
    const GsymReader &GR = ExpectedGR.get();
    VerifyFunctionInfoError(GR, Func1Addr-1, "address 0xfff not in GSYM");

    FunctionInfo Func1(Func1Addr, FuncSize, Func1Name);
    VerifyFunctionInfo(GR, Func1Addr, Func1);
    VerifyFunctionInfo(GR, Func1Addr+1, Func1);
    VerifyFunctionInfo(GR, Func1Addr+FuncSize-1, Func1);
    VerifyFunctionInfoError(GR, Func1Addr+FuncSize,
                            "address 0x1010 not in GSYM");
    VerifyFunctionInfoError(GR, Func2Addr-1, "address 0x101f not in GSYM");
    FunctionInfo Func2(Func2Addr, FuncSize, Func2Name);
    VerifyFunctionInfo(GR, Func2Addr, Func2);
    VerifyFunctionInfo(GR, Func2Addr+1, Func2);
    VerifyFunctionInfo(GR, Func2Addr+FuncSize-1, Func2);
    VerifyFunctionInfoError(GR, Func2Addr+FuncSize,
                            "address 0x1030 not in GSYM");
  }
}
