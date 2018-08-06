/*===---- clwbintrin.h - CLWB intrinsic ------------------------------------===
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *===-----------------------------------------------------------------------===
 */

#ifndef __IMMINTRIN_H
#error "Never use <clwbintrin.h> directly; include <immintrin.h> instead."
#endif

#ifndef __CLWBINTRIN_H
#define __CLWBINTRIN_H

/* Define the default attributes for the functions in this file. */
#define __DEFAULT_FN_ATTRS __attribute__((__always_inline__, __nodebug__,  __target__("clwb")))

/// Writes back to memory the cache line (if modified) that contains the
/// linear address specified in \a __p from any level of the cache hierarchy in
/// the cache coherence domain
///
/// \headerfile <immintrin.h>
///
/// This intrinsic corresponds to the <c> CLWB </c> instruction.
///
/// \param __p
///    A pointer to the memory location used to identify the cache line to be
///    written back.
static __inline__ void __DEFAULT_FN_ATTRS
_mm_clwb(void const *__p) {
  __builtin_ia32_clwb(__p);
}

#undef __DEFAULT_FN_ATTRS

#endif
