//===-- SBMemoryRegionInfo.cpp ----------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "lldb/API/SBMemoryRegionInfo.h"
#include "Utils.h"
#include "lldb/API/SBDefines.h"
#include "lldb/API/SBError.h"
#include "lldb/API/SBStream.h"
#include "lldb/Target/MemoryRegionInfo.h"
#include "lldb/Utility/StreamString.h"

using namespace lldb;
using namespace lldb_private;

SBMemoryRegionInfo::SBMemoryRegionInfo()
    : m_opaque_up(new MemoryRegionInfo()) {}

SBMemoryRegionInfo::SBMemoryRegionInfo(const MemoryRegionInfo *lldb_object_ptr)
    : m_opaque_up(new MemoryRegionInfo()) {
  if (lldb_object_ptr)
    ref() = *lldb_object_ptr;
}

SBMemoryRegionInfo::SBMemoryRegionInfo(const SBMemoryRegionInfo &rhs)
    : m_opaque_up() {
  m_opaque_up = clone(rhs.m_opaque_up);
}

const SBMemoryRegionInfo &SBMemoryRegionInfo::
operator=(const SBMemoryRegionInfo &rhs) {
  if (this != &rhs)
    m_opaque_up = clone(rhs.m_opaque_up);
  return *this;
}

SBMemoryRegionInfo::~SBMemoryRegionInfo() {}

void SBMemoryRegionInfo::Clear() { m_opaque_up->Clear(); }

bool SBMemoryRegionInfo::operator==(const SBMemoryRegionInfo &rhs) const {
  return ref() == rhs.ref();
}

bool SBMemoryRegionInfo::operator!=(const SBMemoryRegionInfo &rhs) const {
  return ref() != rhs.ref();
}

MemoryRegionInfo &SBMemoryRegionInfo::ref() { return *m_opaque_up; }

const MemoryRegionInfo &SBMemoryRegionInfo::ref() const { return *m_opaque_up; }

lldb::addr_t SBMemoryRegionInfo::GetRegionBase() {
  return m_opaque_up->GetRange().GetRangeBase();
}

lldb::addr_t SBMemoryRegionInfo::GetRegionEnd() {
  return m_opaque_up->GetRange().GetRangeEnd();
}

bool SBMemoryRegionInfo::IsReadable() {
  return m_opaque_up->GetReadable() == MemoryRegionInfo::eYes;
}

bool SBMemoryRegionInfo::IsWritable() {
  return m_opaque_up->GetWritable() == MemoryRegionInfo::eYes;
}

bool SBMemoryRegionInfo::IsExecutable() {
  return m_opaque_up->GetExecutable() == MemoryRegionInfo::eYes;
}

bool SBMemoryRegionInfo::IsMapped() {
  return m_opaque_up->GetMapped() == MemoryRegionInfo::eYes;
}

const char *SBMemoryRegionInfo::GetName() {
  return m_opaque_up->GetName().AsCString();
}

bool SBMemoryRegionInfo::GetDescription(SBStream &description) {
  Stream &strm = description.ref();
  const addr_t load_addr = m_opaque_up->GetRange().base;

  strm.Printf("[0x%16.16" PRIx64 "-0x%16.16" PRIx64 " ", load_addr,
              load_addr + m_opaque_up->GetRange().size);
  strm.Printf(m_opaque_up->GetReadable() ? "R" : "-");
  strm.Printf(m_opaque_up->GetWritable() ? "W" : "-");
  strm.Printf(m_opaque_up->GetExecutable() ? "X" : "-");
  strm.Printf("]");

  return true;
}
