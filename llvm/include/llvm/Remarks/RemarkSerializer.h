//===-- RemarkSerializer.h - Remark serialization interface -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file provides an interface for serializing remarks to different formats.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_REMARKS_REMARK_SERIALIZER_H
#define LLVM_REMARKS_REMARK_SERIALIZER_H

#include "llvm/Remarks/Remark.h"
#include "llvm/Remarks/RemarkStringTable.h"
#include "llvm/Support/raw_ostream.h"

namespace llvm {
namespace remarks {

struct MetaSerializer;

/// This is the base class for a remark serializer.
/// It includes support for using a string table while emitting.
struct RemarkSerializer {
  /// The open raw_ostream that the remark diagnostics are emitted to.
  raw_ostream &OS;
  /// The string table containing all the unique strings used in the output.
  /// The table can be serialized to be consumed after the compilation.
  Optional<StringTable> StrTab;

  RemarkSerializer(raw_ostream &OS) : OS(OS), StrTab() {}

  /// This is just an interface.
  virtual ~RemarkSerializer() = default;
  /// Emit a remark to the stream.
  virtual void emit(const Remark &Remark) = 0;
  /// Return the corresponding metadata serializer.
  virtual std::unique_ptr<MetaSerializer>
  metaSerializer(raw_ostream &OS,
                 Optional<StringRef> ExternalFilename = None) = 0;
};

/// This is the base class for a remark metadata serializer.
struct MetaSerializer {
  /// The open raw_ostream that the metadata is emitted to.
  raw_ostream &OS;

  MetaSerializer(raw_ostream &OS) : OS(OS) {}

  /// This is just an interface.
  virtual ~MetaSerializer() = default;
  virtual void emit() = 0;
};

/// Create a remark serializer.
Expected<std::unique_ptr<RemarkSerializer>>
createRemarkSerializer(Format RemarksFormat, raw_ostream &OS);

/// Create a remark serializer that uses a pre-filled string table.
Expected<std::unique_ptr<RemarkSerializer>>
createRemarkSerializer(Format RemarksFormat, raw_ostream &OS,
                       remarks::StringTable StrTab);

} // end namespace remarks
} // end namespace llvm

#endif /* LLVM_REMARKS_REMARK_SERIALIZER_H */
