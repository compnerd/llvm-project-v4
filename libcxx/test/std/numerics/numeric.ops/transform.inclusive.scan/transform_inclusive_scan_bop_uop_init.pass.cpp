//===----------------------------------------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is dual licensed under the MIT and the University of Illinois Open
// Source Licenses. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

// <numeric>
// UNSUPPORTED: c++98, c++03, c++11, c++14

// template<class InputIterator, class OutputIterator, class T,
//          class BinaryOperation, class UnaryOperation>
//   OutputIterator transform_inclusive_scan(InputIterator first, InputIterator last,
//                                           OutputIterator result,
//                                           BinaryOperation binary_op,
//                                           UnaryOperation unary_op,
//                                           T init);


#include <numeric>
#include <algorithm>
#include <cassert>
#include <functional>
#include <iterator>
#include <vector>

#include "test_iterators.h"

struct add_ten {
    template <typename T>
    constexpr auto operator()(T x) const noexcept {
        return static_cast<T>(x + 10);
    }
};

template <class Iter1, class BOp, class UOp, class T, class Iter2>
void
test(Iter1 first, Iter1 last, BOp bop, UOp uop, T init, Iter2 rFirst, Iter2 rLast)
{
    std::vector<typename std::iterator_traits<Iter1>::value_type> v;
//  Test not in-place
    std::transform_inclusive_scan(first, last, std::back_inserter(v), bop, uop, init);
    assert(std::equal(v.begin(), v.end(), rFirst, rLast));

//  Test in-place
    v.clear();
    v.assign(first, last);
    std::transform_inclusive_scan(v.begin(), v.end(), v.begin(), bop, uop, init);
    assert(std::equal(v.begin(), v.end(), rFirst, rLast));
}


template <class Iter>
void
test()
{
          int ia[]     = {  1,  3,   5,    7,     9};
    const int pResI0[] = { 11, 24,  39,   56,    75};        // with add_ten
    const int mResI0[] = {  0,  0,   0,    0,     0};
    const int pResN0[] = { -1, -4,  -9,  -16,   -25};        // with negate
    const int mResN0[] = {  0,  0,   0,    0,     0};
    const int pResI2[] = { 13, 26,  41,   58,    77};        // with add_ten
    const int mResI2[] = { 22, 286, 4290, 72930, 1385670};
    const int pResN2[] = {  1, -2,  -7,  -14,   -23};        // with negate
    const int mResN2[] = { -2,  6, -30,  210, -1890};
    const unsigned sa = sizeof(ia) / sizeof(ia[0]);
    static_assert(sa == sizeof(pResI0) / sizeof(pResI0[0]));       // just to be sure
    static_assert(sa == sizeof(mResI0) / sizeof(mResI0[0]));       // just to be sure
    static_assert(sa == sizeof(pResN0) / sizeof(pResN0[0]));       // just to be sure
    static_assert(sa == sizeof(mResN0) / sizeof(mResN0[0]));       // just to be sure
    static_assert(sa == sizeof(pResI2) / sizeof(pResI2[0]));       // just to be sure
    static_assert(sa == sizeof(mResI2) / sizeof(mResI2[0]));       // just to be sure
    static_assert(sa == sizeof(pResN2) / sizeof(pResN2[0]));       // just to be sure
    static_assert(sa == sizeof(mResN2) / sizeof(mResN2[0]));       // just to be sure

    for (unsigned int i = 0; i < sa; ++i ) {
        test(Iter(ia), Iter(ia + i), std::plus<>(),       add_ten{},       0, pResI0, pResI0 + i);
        test(Iter(ia), Iter(ia + i), std::multiplies<>(), add_ten{},       0, mResI0, mResI0 + i);
        test(Iter(ia), Iter(ia + i), std::plus<>(),       std::negate<>(), 0, pResN0, pResN0 + i);
        test(Iter(ia), Iter(ia + i), std::multiplies<>(), std::negate<>(), 0, mResN0, mResN0 + i);
        test(Iter(ia), Iter(ia + i), std::plus<>(),       add_ten{},       2, pResI2, pResI2 + i);
        test(Iter(ia), Iter(ia + i), std::multiplies<>(), add_ten{},       2, mResI2, mResI2 + i);
        test(Iter(ia), Iter(ia + i), std::plus<>(),       std::negate<>(), 2, pResN2, pResN2 + i);
        test(Iter(ia), Iter(ia + i), std::multiplies<>(), std::negate<>(), 2, mResN2, mResN2 + i);
        }
}

int triangle(int n) { return n*(n+1)/2; }

//  Basic sanity
void basic_tests()
{
    {
    std::vector<int> v(10);
    std::fill(v.begin(), v.end(), 3);
    std::transform_inclusive_scan(v.begin(), v.end(), v.begin(), std::plus<>(), add_ten{}, 50);
    for (size_t i = 0; i < v.size(); ++i)
        assert(v[i] == 50 + (int) (i + 1) * 13);
    }

    {
    std::vector<int> v(10);
    std::iota(v.begin(), v.end(), 0);
    std::transform_inclusive_scan(v.begin(), v.end(), v.begin(), std::plus<>(), add_ten{}, 30);
    for (size_t i = 0; i < v.size(); ++i)
        assert(v[i] == 30 + triangle(i) + (i + 1) * 10);
    }

    {
    std::vector<int> v(10);
    std::iota(v.begin(), v.end(), 1);
    std::transform_inclusive_scan(v.begin(), v.end(), v.begin(), std::plus<>(), add_ten{}, 40);
    for (size_t i = 0; i < v.size(); ++i)
        assert(v[i] == 40 + triangle(i + 1) + (i + 1) * 10);
    }

    {
    std::vector<int> v, res;
    std::transform_inclusive_scan(v.begin(), v.end(), std::back_inserter(res), std::plus<>(), add_ten{}, 1);
    assert(res.empty());
    }

//  Make sure that the calculations are done using the init typedef
    {
    std::vector<unsigned char> v(10);
    std::iota(v.begin(), v.end(), static_cast<unsigned char>(1));
    std::vector<int> res;
    std::transform_inclusive_scan(v.begin(), v.end(), std::back_inserter(res), std::multiplies<>(), add_ten{}, 1);

    assert(res.size() == 10);
    int j = 11;
    assert(res[0] == 11);
    for (size_t i = 1; i < res.size(); ++i)
    {
        j *= i + 11;
        assert(res[i] == j);
    }
    }
}

int main()
{
    basic_tests();

//  All the iterator categories
    test<input_iterator        <const int*> >();
    test<forward_iterator      <const int*> >();
    test<bidirectional_iterator<const int*> >();
    test<random_access_iterator<const int*> >();
    test<const int*>();
    test<      int*>();
}
