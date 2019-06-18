//===-- SBReproducerPrivate.h -----------------------------------*- C++ -*-===//
//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLDB_API_SBREPRODUCER_PRIVATE_H
#define LLDB_API_SBREPRODUCER_PRIVATE_H

#include "lldb/API/SBReproducer.h"

#include "lldb/Utility/FileSpec.h"
#include "lldb/Utility/Log.h"
#include "lldb/Utility/Reproducer.h"
#include "lldb/Utility/ReproducerInstrumentation.h"

#include "llvm/ADT/DenseMap.h"

#define LLDB_GET_INSTRUMENTATION_DATA()                                        \
  lldb_private::repro::GetInstrumentationData()

namespace lldb_private {
namespace repro {

class SBRegistry : public Registry {
public:
  SBRegistry();
};

class SBProvider : public Provider<SBProvider> {
public:
  struct Info {
    static const char *name;
    static const char *file;
  };

  SBProvider(const FileSpec &directory)
      : Provider(directory),
        m_stream(directory.CopyByAppendingPathComponent("sbapi.bin").GetPath(),
                 m_ec, llvm::sys::fs::OpenFlags::F_None),
        m_serializer(m_stream) {}

  Serializer &GetSerializer() { return m_serializer; }
  Registry &GetRegistry() { return m_registry; }

  static char ID;

private:
  std::error_code m_ec;
  llvm::raw_fd_ostream m_stream;
  Serializer m_serializer;
  SBRegistry m_registry;
};

inline InstrumentationData GetInstrumentationData() {
  if (!lldb_private::repro::Reproducer::Initialized())
    return {};

  if (auto *g = lldb_private::repro::Reproducer::Instance().GetGenerator()) {
    auto &p = g->GetOrCreate<SBProvider>();
    return {p.GetSerializer(), p.GetRegistry()};
  }

  return {};
}

template <typename T> void RegisterMethods(Registry &R);

} // namespace repro
} // namespace lldb_private

#endif
