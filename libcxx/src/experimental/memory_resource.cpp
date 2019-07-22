//===------------------------ memory_resource.cpp -------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "experimental/memory_resource"

#ifndef _LIBCPP_HAS_NO_ATOMIC_HEADER
#include "atomic"
#elif !defined(_LIBCPP_HAS_NO_THREADS)
#include "mutex"
#if defined(__unix__) && !defined(__ANDROID__) && defined(__ELF__) && defined(_LIBCPP_HAS_COMMENT_LIB_PRAGMA)
#pragma comment(lib, "pthread")
#endif
#endif

_LIBCPP_BEGIN_NAMESPACE_LFTS_PMR

// memory_resource

//memory_resource::~memory_resource() {}

// new_delete_resource()

class _LIBCPP_TYPE_VIS __new_delete_memory_resource_imp
    : public memory_resource
{
    void *do_allocate(size_t size, size_t align) override {
#ifdef _LIBCPP_HAS_NO_ALIGNED_ALLOCATION
        if (__is_overaligned_for_new(align))
            __throw_bad_alloc();
#endif
        return _VSTD::__libcpp_allocate(size, align);
    }

    void do_deallocate(void *p, size_t n, size_t align) override {
      _VSTD::__libcpp_deallocate(p, n, align);
    }

    bool do_is_equal(memory_resource const & other) const _NOEXCEPT override
        { return &other == this; }

public:
    ~__new_delete_memory_resource_imp() override = default;
};

// null_memory_resource()

class _LIBCPP_TYPE_VIS __null_memory_resource_imp
    : public memory_resource
{
public:
    ~__null_memory_resource_imp() = default;

protected:
    virtual void* do_allocate(size_t, size_t) {
        __throw_bad_alloc();
    }
    virtual void do_deallocate(void *, size_t, size_t) {}
    virtual bool do_is_equal(memory_resource const & __other) const _NOEXCEPT
    { return &__other == this; }
};

namespace {

union ResourceInitHelper {
  struct {
    __new_delete_memory_resource_imp new_delete_res;
    __null_memory_resource_imp       null_res;
  } resources;
  char dummy;
  _LIBCPP_CONSTEXPR_AFTER_CXX11 ResourceInitHelper() : resources() {}
  ~ResourceInitHelper() {}
};

// Detect if the init_priority attribute is supported.
#if (defined(_LIBCPP_COMPILER_GCC) && defined(__APPLE__)) \
  || defined(_LIBCPP_COMPILER_MSVC)
// GCC on Apple doesn't support the init priority attribute,
// and MSVC doesn't support any GCC attributes.
# define _LIBCPP_INIT_PRIORITY_MAX
#else
# define _LIBCPP_INIT_PRIORITY_MAX __attribute__((init_priority(101)))
#endif

// When compiled in C++14 this initialization should be a constant expression.
// Only in C++11 is "init_priority" needed to ensure initialization order.
#if _LIBCPP_STD_VER > 11
_LIBCPP_SAFE_STATIC
#endif
ResourceInitHelper res_init _LIBCPP_INIT_PRIORITY_MAX;

} // end namespace


memory_resource * new_delete_resource() _NOEXCEPT {
    return &res_init.resources.new_delete_res;
}

memory_resource * null_memory_resource() _NOEXCEPT {
    return &res_init.resources.null_res;
}

// default_memory_resource()

static memory_resource *
__default_memory_resource(bool set = false, memory_resource * new_res = nullptr) _NOEXCEPT
{
#ifndef _LIBCPP_HAS_NO_ATOMIC_HEADER
    _LIBCPP_SAFE_STATIC static atomic<memory_resource*> __res =
        ATOMIC_VAR_INIT(&res_init.resources.new_delete_res);
    if (set) {
        new_res = new_res ? new_res : new_delete_resource();
        // TODO: Can a weaker ordering be used?
        return _VSTD::atomic_exchange_explicit(
            &__res, new_res, memory_order::memory_order_acq_rel);
    }
    else {
        return _VSTD::atomic_load_explicit(
            &__res, memory_order::memory_order_acquire);
    }
#elif !defined(_LIBCPP_HAS_NO_THREADS)
    _LIBCPP_SAFE_STATIC static memory_resource * res = &res_init.resources.new_delete_res;
    static mutex res_lock;
    if (set) {
        new_res = new_res ? new_res : new_delete_resource();
        lock_guard<mutex> guard(res_lock);
        memory_resource * old_res = res;
        res = new_res;
        return old_res;
    } else {
        lock_guard<mutex> guard(res_lock);
        return res;
    }
#else
    _LIBCPP_SAFE_STATIC static memory_resource* res = &res_init.resources.new_delete_res;
    if (set) {
        new_res = new_res ? new_res : new_delete_resource();
        memory_resource * old_res = res;
        res = new_res;
        return old_res;
    } else {
        return res;
    }
#endif
}

memory_resource * get_default_resource() _NOEXCEPT
{
    return __default_memory_resource();
}

memory_resource * set_default_resource(memory_resource * __new_res) _NOEXCEPT
{
    return __default_memory_resource(true, __new_res);
}

_LIBCPP_END_NAMESPACE_LFTS_PMR
