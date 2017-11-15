//===----------------------------------------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is dual licensed under the MIT and the University of Illinois Open
// Source Licenses. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

// UNSUPPORTED: c++98, c++03, c++11, c++14

// <iterator>
// template <class C> constexpr auto data(C& c) -> decltype(c.data());               // C++17
// template <class C> constexpr auto data(const C& c) -> decltype(c.data());         // C++17
// template <class T, size_t N> constexpr T* data(T (&array)[N]) noexcept;           // C++17
// template <class E> constexpr const E* data(initializer_list<E> il) noexcept;      // C++17

#include <iterator>
#include <cassert>
#include <vector>
#include <array>
#include <initializer_list>

#include "test_macros.h"

template<typename C>
void test_const_container( const C& c )
{
//  Can't say noexcept here because the container might not be
    assert ( std::data(c)   == c.data());
}

template<typename T>
void test_const_container( const std::initializer_list<T>& c )
{
    ASSERT_NOEXCEPT(std::data(c));
    assert ( std::data(c)   == c.begin());
}

template<typename C>
void test_container( C& c )
{
//  Can't say noexcept here because the container might not be
    assert ( std::data(c)   == c.data());
}

template<typename T>
void test_container( std::initializer_list<T>& c)
{
    ASSERT_NOEXCEPT(std::data(c));
    assert ( std::data(c)   == c.begin());
}

template<typename T, size_t Sz>
void test_const_array( const T (&array)[Sz] )
{
    ASSERT_NOEXCEPT(std::data(array));
    assert ( std::data(array) == &array[0]);
}

int main()
{
    std::vector<int> v; v.push_back(1);
    std::array<int, 1> a; a[0] = 3;
    std::initializer_list<int> il = { 4 };

    test_container ( v );
    test_container ( a );
    test_container ( il );

    test_const_container ( v );
    test_const_container ( a );
    test_const_container ( il );

    static constexpr int arrA [] { 1, 2, 3 };
    test_const_array ( arrA );
}
