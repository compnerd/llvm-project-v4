//===-- DynamicLoaderMacOS.h -------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// This is the DynamicLoader plugin for Darwin (macOS / iPhoneOS / tvOS /
// watchOS / BridgeOS)
// platforms late 2016 and newer, where lldb will call dyld SPI functions to get
// information about shared libraries, information about the shared cache, and
// the _dyld_debugger_notification function we put a breakpoint on give us an
// array of load addresses for solibs loaded and unloaded.  The SPI will tell us
// about both dyld and the executable, in addition to all of the usual solibs.

#ifndef liblldb_DynamicLoaderMacOS_h_
#define liblldb_DynamicLoaderMacOS_h_

#include <mutex>
#include <vector>

#include "lldb/Target/DynamicLoader.h"
#include "lldb/Target/Process.h"
#include "lldb/Utility/FileSpec.h"
#include "lldb/Utility/StructuredData.h"
#include "lldb/Utility/UUID.h"

#include "DynamicLoaderDarwin.h"

class DynamicLoaderMacOS : public lldb_private::DynamicLoaderDarwin {
public:
  DynamicLoaderMacOS(lldb_private::Process *process);

  virtual ~DynamicLoaderMacOS() override;

  //------------------------------------------------------------------
  // Static Functions
  //------------------------------------------------------------------
  static void Initialize();

  static void Terminate();

  static lldb_private::ConstString GetPluginNameStatic();

  static const char *GetPluginDescriptionStatic();

  static lldb_private::DynamicLoader *
  CreateInstance(lldb_private::Process *process, bool force);

  //------------------------------------------------------------------
  /// Called after attaching a process.
  ///
  /// Allow DynamicLoader plug-ins to execute some code after
  /// attaching to a process.
  //------------------------------------------------------------------
  bool ProcessDidExec() override;

  lldb_private::Status CanLoadImage() override;

  bool GetSharedCacheInformation(
      lldb::addr_t &base_address, lldb_private::UUID &uuid,
      lldb_private::LazyBool &using_shared_cache,
      lldb_private::LazyBool &private_shared_cache) override;

  //------------------------------------------------------------------
  // PluginInterface protocol
  //------------------------------------------------------------------
  lldb_private::ConstString GetPluginName() override;

  uint32_t GetPluginVersion() override;

protected:
  void PutToLog(lldb_private::Log *log) const;

  void DoInitialImageFetch() override;

  bool NeedToDoInitialImageFetch() override;

  bool DidSetNotificationBreakpoint() override;

  void AddBinaries(const std::vector<lldb::addr_t> &load_addresses);

  void DoClear() override;

  static bool
  NotifyBreakpointHit(void *baton,
                      lldb_private::StoppointCallbackContext *context,
                      lldb::user_id_t break_id, lldb::user_id_t break_loc_id);

  bool SetNotificationBreakpoint() override;

  void ClearNotificationBreakpoint() override;

  void UpdateImageInfosHeaderAndLoadCommands(ImageInfo::collection &image_infos,
                                             uint32_t infos_count,
                                             bool update_executable);

  lldb::addr_t
  GetDyldLockVariableAddressFromModule(lldb_private::Module *module);

  uint32_t m_image_infos_stop_id; // The Stop ID the last time we
                                  // loaded/unloaded images
  lldb::user_id_t m_break_id;
  mutable std::recursive_mutex m_mutex;
  lldb::addr_t m_maybe_image_infos_address; // If dyld is still maintaining the
                                            // all_image_infos address, store it
                                            // here so we can use it to detect
                                            // exec's when talking to
                                            // debugservers that don't support
                                            // the "reason:exec" annotation.

private:
  DISALLOW_COPY_AND_ASSIGN(DynamicLoaderMacOS);
};

#endif // liblldb_DynamicLoaderMacOS_h_
