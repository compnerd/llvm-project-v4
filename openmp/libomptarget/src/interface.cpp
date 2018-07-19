//===-------- interface.cpp - Target independent OpenMP target RTL --------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is dual licensed under the MIT and the University of Illinois Open
// Source Licenses. See LICENSE.txt for details.
//
//===----------------------------------------------------------------------===//
//
// Implementation of the interface to be used by Clang during the codegen of a
// target region.
//
//===----------------------------------------------------------------------===//

#include <omptarget.h>

#include "device.h"
#include "private.h"
#include "rtl.h"

#include <cassert>
#include <cstdlib>

////////////////////////////////////////////////////////////////////////////////
/// adds a target shared library to the target execution image
EXTERN void __tgt_register_lib(__tgt_bin_desc *desc) {
  RTLs.RegisterLib(desc);
}

////////////////////////////////////////////////////////////////////////////////
/// unloads a target shared library
EXTERN void __tgt_unregister_lib(__tgt_bin_desc *desc) {
  RTLs.UnregisterLib(desc);
}

/// creates host-to-target data mapping, stores it in the
/// libomptarget.so internal structure (an entry in a stack of data maps)
/// and passes the data to the device.
EXTERN void __tgt_target_data_begin(int64_t device_id, int32_t arg_num,
    void **args_base, void **args, int64_t *arg_sizes, int64_t *arg_types) {
  DP("Entering data begin region for device %" PRId64 " with %d mappings\n",
      device_id, arg_num);

  // No devices available?
  if (device_id == OFFLOAD_DEVICE_DEFAULT) {
    device_id = omp_get_default_device();
    DP("Use default device id %" PRId64 "\n", device_id);
  }

  if (CheckDeviceAndCtors(device_id) != OFFLOAD_SUCCESS) {
    DP("Failed to get device %" PRId64 " ready\n", device_id);
    return;
  }

  DeviceTy& Device = Devices[device_id];

#ifdef OMPTARGET_DEBUG
  for (int i=0; i<arg_num; ++i) {
    DP("Entry %2d: Base=" DPxMOD ", Begin=" DPxMOD ", Size=%" PRId64
        ", Type=0x%" PRIx64 "\n", i, DPxPTR(args_base[i]), DPxPTR(args[i]),
        arg_sizes[i], arg_types[i]);
  }
#endif

  target_data_begin(Device, arg_num, args_base, args, arg_sizes, arg_types);
}

EXTERN void __tgt_target_data_begin_nowait(int64_t device_id, int32_t arg_num,
    void **args_base, void **args, int64_t *arg_sizes, int64_t *arg_types,
    int32_t depNum, void *depList, int32_t noAliasDepNum,
    void *noAliasDepList) {
  if (depNum + noAliasDepNum > 0)
    __kmpc_omp_taskwait(NULL, 0);

  __tgt_target_data_begin(device_id, arg_num, args_base, args, arg_sizes,
                          arg_types);
}

/// passes data from the target, releases target memory and destroys
/// the host-target mapping (top entry from the stack of data maps)
/// created by the last __tgt_target_data_begin.
EXTERN void __tgt_target_data_end(int64_t device_id, int32_t arg_num,
    void **args_base, void **args, int64_t *arg_sizes, int64_t *arg_types) {
  DP("Entering data end region with %d mappings\n", arg_num);

  // No devices available?
  if (device_id == OFFLOAD_DEVICE_DEFAULT) {
    device_id = omp_get_default_device();
  }

  RTLsMtx.lock();
  size_t Devices_size = Devices.size();
  RTLsMtx.unlock();
  if (Devices_size <= (size_t)device_id) {
    DP("Device ID  %" PRId64 " does not have a matching RTL.\n", device_id);
    return;
  }

  DeviceTy &Device = Devices[device_id];
  if (!Device.IsInit) {
    DP("Uninit device: ignore");
    return;
  }

#ifdef OMPTARGET_DEBUG
  for (int i=0; i<arg_num; ++i) {
    DP("Entry %2d: Base=" DPxMOD ", Begin=" DPxMOD ", Size=%" PRId64
        ", Type=0x%" PRIx64 "\n", i, DPxPTR(args_base[i]), DPxPTR(args[i]),
        arg_sizes[i], arg_types[i]);
  }
#endif

  target_data_end(Device, arg_num, args_base, args, arg_sizes, arg_types);
}

EXTERN void __tgt_target_data_end_nowait(int64_t device_id, int32_t arg_num,
    void **args_base, void **args, int64_t *arg_sizes, int64_t *arg_types,
    int32_t depNum, void *depList, int32_t noAliasDepNum,
    void *noAliasDepList) {
  if (depNum + noAliasDepNum > 0)
    __kmpc_omp_taskwait(NULL, 0);

  __tgt_target_data_end(device_id, arg_num, args_base, args, arg_sizes,
                        arg_types);
}

EXTERN void __tgt_target_data_update(int64_t device_id, int32_t arg_num,
    void **args_base, void **args, int64_t *arg_sizes, int64_t *arg_types) {
  DP("Entering data update with %d mappings\n", arg_num);

  // No devices available?
  if (device_id == OFFLOAD_DEVICE_DEFAULT) {
    device_id = omp_get_default_device();
  }

  if (CheckDeviceAndCtors(device_id) != OFFLOAD_SUCCESS) {
    DP("Failed to get device %" PRId64 " ready\n", device_id);
    return;
  }

  DeviceTy& Device = Devices[device_id];
  target_data_update(Device, arg_num, args_base, args, arg_sizes, arg_types);
}

EXTERN void __tgt_target_data_update_nowait(
    int64_t device_id, int32_t arg_num, void **args_base, void **args,
    int64_t *arg_sizes, int64_t *arg_types, int32_t depNum, void *depList,
    int32_t noAliasDepNum, void *noAliasDepList) {
  if (depNum + noAliasDepNum > 0)
    __kmpc_omp_taskwait(NULL, 0);

  __tgt_target_data_update(device_id, arg_num, args_base, args, arg_sizes,
                           arg_types);
}

EXTERN int __tgt_target(int64_t device_id, void *host_ptr, int32_t arg_num,
    void **args_base, void **args, int64_t *arg_sizes, int64_t *arg_types) {
  DP("Entering target region with entry point " DPxMOD " and device Id %"
      PRId64 "\n", DPxPTR(host_ptr), device_id);

  if (device_id == OFFLOAD_DEVICE_DEFAULT) {
    device_id = omp_get_default_device();
  }

  if (CheckDeviceAndCtors(device_id) != OFFLOAD_SUCCESS) {
    DP("Failed to get device %" PRId64 " ready\n", device_id);
    return OFFLOAD_FAIL;
  }

#ifdef OMPTARGET_DEBUG
  for (int i=0; i<arg_num; ++i) {
    DP("Entry %2d: Base=" DPxMOD ", Begin=" DPxMOD ", Size=%" PRId64
        ", Type=0x%" PRIx64 "\n", i, DPxPTR(args_base[i]), DPxPTR(args[i]),
        arg_sizes[i], arg_types[i]);
  }
#endif

  int rc = target(device_id, host_ptr, arg_num, args_base, args, arg_sizes,
      arg_types, 0, 0, false /*team*/);

  return rc;
}

EXTERN int __tgt_target_nowait(int64_t device_id, void *host_ptr,
    int32_t arg_num, void **args_base, void **args, int64_t *arg_sizes,
    int64_t *arg_types, int32_t depNum, void *depList, int32_t noAliasDepNum,
    void *noAliasDepList) {
  if (depNum + noAliasDepNum > 0)
    __kmpc_omp_taskwait(NULL, 0);

  return __tgt_target(device_id, host_ptr, arg_num, args_base, args, arg_sizes,
                      arg_types);
}

EXTERN int __tgt_target_teams(int64_t device_id, void *host_ptr,
    int32_t arg_num, void **args_base, void **args, int64_t *arg_sizes,
    int64_t *arg_types, int32_t team_num, int32_t thread_limit) {
  DP("Entering target region with entry point " DPxMOD " and device Id %"
      PRId64 "\n", DPxPTR(host_ptr), device_id);

  if (device_id == OFFLOAD_DEVICE_DEFAULT) {
    device_id = omp_get_default_device();
  }

  if (CheckDeviceAndCtors(device_id) != OFFLOAD_SUCCESS) {
    DP("Failed to get device %" PRId64 " ready\n", device_id);
    return OFFLOAD_FAIL;
  }

#ifdef OMPTARGET_DEBUG
  for (int i=0; i<arg_num; ++i) {
    DP("Entry %2d: Base=" DPxMOD ", Begin=" DPxMOD ", Size=%" PRId64
        ", Type=0x%" PRIx64 "\n", i, DPxPTR(args_base[i]), DPxPTR(args[i]),
        arg_sizes[i], arg_types[i]);
  }
#endif

  int rc = target(device_id, host_ptr, arg_num, args_base, args, arg_sizes,
      arg_types, team_num, thread_limit, true /*team*/);

  return rc;
}

EXTERN int __tgt_target_teams_nowait(int64_t device_id, void *host_ptr,
    int32_t arg_num, void **args_base, void **args, int64_t *arg_sizes,
    int64_t *arg_types, int32_t team_num, int32_t thread_limit, int32_t depNum,
    void *depList, int32_t noAliasDepNum, void *noAliasDepList) {
  if (depNum + noAliasDepNum > 0)
    __kmpc_omp_taskwait(NULL, 0);

  return __tgt_target_teams(device_id, host_ptr, arg_num, args_base, args,
                            arg_sizes, arg_types, team_num, thread_limit);
}


// The trip count mechanism will be revised - this scheme is not thread-safe.
EXTERN void __kmpc_push_target_tripcount(int64_t device_id,
    uint64_t loop_tripcount) {
  if (device_id == OFFLOAD_DEVICE_DEFAULT) {
    device_id = omp_get_default_device();
  }

  if (CheckDeviceAndCtors(device_id) != OFFLOAD_SUCCESS) {
    DP("Failed to get device %" PRId64 " ready\n", device_id);
    return;
  }

  DP("__kmpc_push_target_tripcount(%" PRId64 ", %" PRIu64 ")\n", device_id,
      loop_tripcount);
  Devices[device_id].loopTripCnt = loop_tripcount;
}
