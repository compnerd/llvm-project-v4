//===-- STLPostfixHeaderMap.h - hardcoded STL header map --------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "STLPostfixHeaderMap.h"

namespace clang {
namespace find_all_symbols {

const HeaderMapCollector::RegexHeaderMap *getSTLPostfixHeaderMap() {
  static const HeaderMapCollector::RegexHeaderMap STLPostfixHeaderMap = {
      {"include/__stddef_max_align_t.h$", "<cstddef>"},
      {"include/__wmmintrin_aes.h$", "<wmmintrin.h>"},
      {"include/__wmmintrin_pclmul.h$", "<wmmintrin.h>"},
      {"include/adxintrin.h$", "<immintrin.h>"},
      {"include/ammintrin.h$", "<ammintrin.h>"},
      {"include/avx2intrin.h$", "<immintrin.h>"},
      {"include/avx512bwintrin.h$", "<immintrin.h>"},
      {"include/avx512cdintrin.h$", "<immintrin.h>"},
      {"include/avx512dqintrin.h$", "<immintrin.h>"},
      {"include/avx512erintrin.h$", "<immintrin.h>"},
      {"include/avx512fintrin.h$", "<immintrin.h>"},
      {"include/avx512ifmaintrin.h$", "<immintrin.h>"},
      {"include/avx512ifmavlintrin.h$", "<immintrin.h>"},
      {"include/avx512pfintrin.h$", "<immintrin.h>"},
      {"include/avx512vbmiintrin.h$", "<immintrin.h>"},
      {"include/avx512vbmivlintrin.h$", "<immintrin.h>"},
      {"include/avx512vlbwintrin.h$", "<immintrin.h>"},
      {"include/avx512vlcdintrin.h$", "<immintrin.h>"},
      {"include/avx512vldqintrin.h$", "<immintrin.h>"},
      {"include/avx512vlintrin.h$", "<immintrin.h>"},
      {"include/avxintrin.h$", "<immintrin.h>"},
      {"include/bmi2intrin.h$", "<x86intrin.h>"},
      {"include/bmiintrin.h$", "<x86intrin.h>"},
      {"include/emmintrin.h$", "<emmintrin.h>"},
      {"include/f16cintrin.h$", "<emmintrin.h>"},
      {"include/float.h$", "<cfloat>"},
      {"include/fma4intrin.h$", "<x86intrin.h>"},
      {"include/fmaintrin.h$", "<immintrin.h>"},
      {"include/fxsrintrin.h$", "<immintrin.h>"},
      {"include/ia32intrin.h$", "<x86intrin.h>"},
      {"include/immintrin.h$", "<immintrin.h>"},
      {"include/inttypes.h$", "<cinttypes>"},
      {"include/limits.h$", "<climits>"},
      {"include/lzcntintrin.h$", "<x86intrin.h>"},
      {"include/mm3dnow.h$", "<mm3dnow.h>"},
      {"include/mm_malloc.h$", "<mm_malloc.h>"},
      {"include/mmintrin.h$", "<mmintrin>"},
      {"include/mwaitxintrin.h$", "<x86intrin.h>"},
      {"include/pkuintrin.h$", "<immintrin.h>"},
      {"include/pmmintrin.h$", "<pmmintrin.h>"},
      {"include/popcntintrin.h$", "<popcntintrin.h>"},
      {"include/prfchwintrin.h$", "<x86intrin.h>"},
      {"include/rdseedintrin.h$", "<x86intrin.h>"},
      {"include/rtmintrin.h$", "<immintrin.h>"},
      {"include/shaintrin.h$", "<immintrin.h>"},
      {"include/smmintrin.h$", "<smmintrin.h>"},
      {"include/stdalign.h$", "<cstdalign>"},
      {"include/stdarg.h$", "<cstdarg>"},
      {"include/stdbool.h$", "<cstdbool>"},
      {"include/stddef.h$", "<cstddef>"},
      {"include/stdint.h$", "<cstdint>"},
      {"include/tbmintrin.h$", "<x86intrin.h>"},
      {"include/tmmintrin.h$", "<tmmintrin.h>"},
      {"include/wmmintrin.h$", "<wmmintrin.h>"},
      {"include/x86intrin.h$", "<x86intrin.h>"},
      {"include/xmmintrin.h$", "<xmmintrin.h>"},
      {"include/xopintrin.h$", "<x86intrin.h>"},
      {"include/xsavecintrin.h$", "<immintrin.h>"},
      {"include/xsaveintrin.h$", "<immintrin.h>"},
      {"include/xsaveoptintrin.h$", "<immintrin.h>"},
      {"include/xsavesintrin.h$", "<immintrin.h>"},
      {"include/xtestintrin.h$", "<immintrin.h>"},
      {"include/_G_config.h$", "<cstdio>"},
      {"include/assert.h$", "<cassert>"},
      {"algorithm$", "<algorithm>"},
      {"array$", "<array>"},
      {"atomic$", "<atomic>"},
      {"backward/auto_ptr.h$", "<memory>"},
      {"backward/binders.h$", "<string>"},
      {"bits/algorithmfwd.h$", "<algorithm>"},
      {"bits/alloc_traits.h$", "<unordered_set>"},
      {"bits/allocator.h$", "<string>"},
      {"bits/atomic_base.h$", "<atomic>"},
      {"bits/atomic_lockfree_defines.h$", "<exception>"},
      {"bits/basic_ios.h$", "<ios>"},
      {"bits/basic_ios.tcc$", "<ios>"},
      {"bits/basic_string.h$", "<string>"},
      {"bits/basic_string.tcc$", "<string>"},
      {"bits/char_traits.h$", "<string>"},
      {"bits/codecvt.h$", "<locale>"},
      {"bits/concept_check.h$", "<numeric>"},
      {"bits/cpp_type_traits.h$", "<cmath>"},
      {"bits/cxxabi_forced.h$", "<cxxabi.h>"},
      {"bits/deque.tcc$", "<deque>"},
      {"bits/exception_defines.h$", "<exception>"},
      {"bits/exception_ptr.h$", "<exception>"},
      {"bits/forward_list.h$", "<forward_list>"},
      {"bits/forward_list.tcc$", "<forward_list>"},
      {"bits/fstream.tcc$", "<fstream>"},
      {"bits/functexcept.h$", "<list>"},
      {"bits/functional_hash.h$", "<string>"},
      {"bits/gslice.h$", "<valarray>"},
      {"bits/gslice_array.h$", "<valarray>"},
      {"bits/hash_bytes.h$", "<typeinfo>"},
      {"bits/hashtable.h$", "<unordered_set>"},
      {"bits/hashtable_policy.h$", "<unordered_set>"},
      {"bits/indirect_array.h$", "<valarray>"},
      {"bits/ios_base.h$", "<ios>"},
      {"bits/istream.tcc$", "<istream>"},
      {"bits/list.tcc$", "<list>"},
      {"bits/locale_classes.h$", "<locale>"},
      {"bits/locale_classes.tcc$", "<locale>"},
      {"bits/locale_facets.h$", "<locale>"},
      {"bits/locale_facets.tcc$", "<locale>"},
      {"bits/locale_facets_nonio.h$", "<locale>"},
      {"bits/locale_facets_nonio.tcc$", "<locale>"},
      {"bits/localefwd.h$", "<locale>"},
      {"bits/mask_array.h$", "<valarray>"},
      {"bits/memoryfwd.h$", "<memory>"},
      {"bits/move.h$", "<utility>"},
      {"bits/nested_exception.h$", "<exception>"},
      {"bits/ostream.tcc$", "<ostream>"},
      {"bits/ostream_insert.h$", "<ostream>"},
      {"bits/postypes.h$", "<iosfwd>"},
      {"bits/ptr_traits.h$", "<memory>"},
      {"bits/random.h$", "<random>"},
      {"bits/random.tcc$", "<random>"},
      {"bits/range_access.h$", "<iterator>"},
      {"bits/regex.h$", "<regex>"},
      {"bits/regex_compiler.h$", "<regex>"},
      {"bits/regex_constants.h$", "<regex>"},
      {"bits/regex_cursor.h$", "<regex>"},
      {"bits/regex_error.h$", "<regex>"},
      {"bits/regex_grep_matcher.h$", "<regex>"},
      {"bits/regex_grep_matcher.tcc$", "<regex>"},
      {"bits/regex_nfa.h$", "<regex>"},
      {"bits/shared_ptr.h$", "<memory>"},
      {"bits/shared_ptr_base.h$", "<memory>"},
      {"bits/slice_array.h$", "<valarray>"},
      {"bits/sstream.tcc$", "<sstream>"},
      {"bits/stl_algo.h$", "<algorithm>"},
      {"bits/stl_algobase.h$", "<list>"},
      {"bits/stl_bvector.h$", "<vector>"},
      {"bits/stl_construct.h$", "<deque>"},
      {"bits/stl_deque.h$", "<deque>"},
      {"bits/stl_function.h$", "<string>"},
      {"bits/stl_heap.h$", "<queue>"},
      {"bits/stl_iterator.h$", "<iterator>"},
      {"bits/stl_iterator_base_funcs.h$", "<iterator>"},
      {"bits/stl_iterator_base_types.h$", "<numeric>"},
      {"bits/stl_list.h$", "<list>"},
      {"bits/stl_map.h$", "<map>"},
      {"bits/stl_multimap.h$", "<map>"},
      {"bits/stl_multiset.h$", "<set>"},
      {"bits/stl_numeric.h$", "<numeric>"},
      {"bits/stl_pair.h$", "<utility>"},
      {"bits/stl_queue.h$", "<queue>"},
      {"bits/stl_raw_storage_iter.h$", "<memory>"},
      {"bits/stl_relops.h$", "<utility>"},
      {"bits/stl_set.h$", "<set>"},
      {"bits/stl_stack.h$", "<stack>"},
      {"bits/stl_tempbuf.h$", "<memory>"},
      {"bits/stl_tree.h$", "<map>"},
      {"bits/stl_uninitialized.h$", "<deque>"},
      {"bits/stl_vector.h$", "<vector>"},
      {"bits/stream_iterator.h$", "<iterator>"},
      {"bits/streambuf.tcc$", "<streambuf>"},
      {"bits/streambuf_iterator.h$", "<iterator>"},
      {"bits/stringfwd.h$", "<string>"},
      {"bits/unique_ptr.h$", "<memory>"},
      {"bits/unordered_map.h$", "<unordered_map>"},
      {"bits/unordered_set.h$", "<unordered_set>"},
      {"bits/uses_allocator.h$", "<tuple>"},
      {"bits/valarray_after.h$", "<valarray>"},
      {"bits/valarray_array.h$", "<valarray>"},
      {"bits/valarray_array.tcc$", "<valarray>"},
      {"bits/valarray_before.h$", "<valarray>"},
      {"bits/vector.tcc$", "<vector>"},
      {"bitset$", "<bitset>"},
      {"ccomplex$", "<ccomplex>"},
      {"cctype$", "<cctype>"},
      {"cerrno$", "<cerrno>"},
      {"cfenv$", "<cfenv>"},
      {"cfloat$", "<cfloat>"},
      {"chrono$", "<chrono>"},
      {"cinttypes$", "<cinttypes>"},
      {"climits$", "<climits>"},
      {"clocale$", "<clocale>"},
      {"cmath$", "<cmath>"},
      {"complex$", "<complex>"},
      {"complex.h$", "<complex.h>"},
      {"condition_variable$", "<condition_variable>"},
      {"csetjmp$", "<csetjmp>"},
      {"csignal$", "<csignal>"},
      {"cstdalign$", "<cstdalign>"},
      {"cstdarg$", "<cstdarg>"},
      {"cstdbool$", "<cstdbool>"},
      {"cstdint$", "<cstdint>"},
      {"cstdio$", "<cstdio>"},
      {"cstdlib$", "<cstdlib>"},
      {"cstring$", "<cstring>"},
      {"ctgmath$", "<ctgmath>"},
      {"ctime$", "<ctime>"},
      {"cwchar$", "<cwchar>"},
      {"cwctype$", "<cwctype>"},
      {"cxxabi.h$", "<cxxabi.h>"},
      {"debug/debug.h$", "<numeric>"},
      {"debug/map.h$", "<map>"},
      {"debug/multimap.h$", "<multimap>"},
      {"debug/multiset.h$", "<multiset>"},
      {"debug/set.h$", "<set>"},
      {"deque$", "<deque>"},
      {"exception$", "<exception>"},
      {"ext/alloc_traits.h$", "<deque>"},
      {"ext/atomicity.h$", "<memory>"},
      {"ext/concurrence.h$", "<memory>"},
      {"ext/new_allocator.h$", "<string>"},
      {"ext/numeric_traits.h$", "<list>"},
      {"ext/string_conversions.h$", "<string>"},
      {"ext/type_traits.h$", "<cmath>"},
      {"fenv.h$", "<fenv.h>"},
      {"forward_list$", "<forward_list>"},
      {"fstream$", "<fstream>"},
      {"functional$", "<functional>"},
      {"future$", "<future>"},
      {"initializer_list$", "<initializer_list>"},
      {"iomanip$", "<iomanip>"},
      {"ios$", "<ios>"},
      {"iosfwd$", "<iosfwd>"},
      {"iostream$", "<iostream>"},
      {"istream$", "<istream>"},
      {"iterator$", "<iterator>"},
      {"limits$", "<limits>"},
      {"list$", "<list>"},
      {"locale$", "<locale>"},
      {"map$", "<map>"},
      {"memory$", "<memory>"},
      {"mutex$", "<mutex>"},
      {"new$", "<new>"},
      {"numeric$", "<numeric>"},
      {"ostream$", "<ostream>"},
      {"queue$", "<queue>"},
      {"random$", "<random>"},
      {"ratio$", "<ratio>"},
      {"regex$", "<regex>"},
      {"scoped_allocator$", "<scoped_allocator>"},
      {"set$", "<set>"},
      {"sstream$", "<sstream>"},
      {"stack$", "<stack>"},
      {"stdexcept$", "<stdexcept>"},
      {"streambuf$", "<streambuf>"},
      {"string$", "<string>"},
      {"system_error$", "<system_error>"},
      {"tgmath.h$", "<tgmath.h>"},
      {"thread$", "<thread>"},
      {"tuple$", "<tuple>"},
      {"type_traits$", "<type_traits>"},
      {"typeindex$", "<typeindex>"},
      {"typeinfo$", "<typeinfo>"},
      {"unordered_map$", "<unordered_map>"},
      {"unordered_set$", "<unordered_set>"},
      {"utility$", "<utility>"},
      {"valarray$", "<valarray>"},
      {"vector$", "<vector>"},
      {"include/complex.h$", "<complex.h>"},
      {"include/ctype.h$", "<cctype>"},
      {"include/errno.h$", "<cerrno>"},
      {"include/fenv.h$", "<fenv.h>"},
      {"include/inttypes.h$", "<cinttypes>"},
      {"include/libio.h$", "<cstdio>"},
      {"include/limits.h$", "<climits>"},
      {"include/locale.h$", "<clocale>"},
      {"include/math.h$", "<cmath>"},
      {"include/setjmp.h$", "<csetjmp>"},
      {"include/signal.h$", "<csignal>"},
      {"include/stdint.h$", "<cstdint>"},
      {"include/stdio.h$", "<cstdio>"},
      {"include/stdlib.h$", "<cstdlib>"},
      {"include/string.h$", "<cstring>"},
      {"include/time.h$", "<ctime>"},
      {"include/wchar.h$", "<cwchar>"},
      {"include/wctype.h$", "<cwctype>"},
      {"bits/cmathcalls.h$", "<complex.h>"},
      {"bits/errno.h$", "<cerrno>"},
      {"bits/fenv.h$", "<fenv.h>"},
      {"bits/huge_val.h$", "<cmath>"},
      {"bits/huge_valf.h$", "<cmath>"},
      {"bits/huge_vall.h$", "<cmath>"},
      {"bits/inf.h$", "<cmath>"},
      {"bits/local_lim.h$", "<climits>"},
      {"bits/locale.h$", "<clocale>"},
      {"bits/mathcalls.h$", "<math.h>"},
      {"bits/mathdef.h$", "<cmath>"},
      {"bits/nan.h$", "<cmath>"},
      {"bits/posix1_lim.h$", "<climits>"},
      {"bits/posix2_lim.h$", "<climits>"},
      {"bits/setjmp.h$", "<csetjmp>"},
      {"bits/sigaction.h$", "<csignal>"},
      {"bits/sigcontext.h$", "<csignal>"},
      {"bits/siginfo.h$", "<csignal>"},
      {"bits/signum.h$", "<csignal>"},
      {"bits/sigset.h$", "<csignal>"},
      {"bits/sigstack.h$", "<csignal>"},
      {"bits/stdio_lim.h$", "<cstdio>"},
      {"bits/sys_errlist.h$", "<cstdio>"},
      {"bits/time.h$", "<ctime>"},
      {"bits/timex.h$", "<ctime>"},
      {"bits/typesizes.h$", "<cstdio>"},
      {"bits/wchar.h$", "<cwchar>"},
      {"bits/wordsize.h$", "<csetjmp>"},
      {"bits/xopen_lim.h$", "<climits>"},
      {"include/xlocale.h$", "<cstring>"},
      {"bits/atomic_word.h$", "<memory>"},
      {"bits/basic_file.h$", "<fstream>"},
      {"bits/c\\+\\+allocator.h$", "<string>"},
      {"bits/c\\+\\+config.h$", "<iosfwd>"},
      {"bits/c\\+\\+io.h$", "<ios>"},
      {"bits/c\\+\\+locale.h$", "<locale>"},
      {"bits/cpu_defines.h$", "<iosfwd>"},
      {"bits/ctype_base.h$", "<locale>"},
      {"bits/cxxabi_tweaks.h$", "<cxxabi.h>"},
      {"bits/error_constants.h$", "<system_error>"},
      {"bits/gthr-default.h$", "<memory>"},
      {"bits/gthr.h$", "<memory>"},
      {"bits/opt_random.h$", "<random>"},
      {"bits/os_defines.h$", "<iosfwd>"},
      // GNU C headers
      {"include/aio.h$", "<aio.h>"},
      {"include/aliases.h$", "<aliases.h>"},
      {"include/alloca.h$", "<alloca.h>"},
      {"include/ar.h$", "<ar.h>"},
      {"include/argp.h$", "<argp.h>"},
      {"include/argz.h$", "<argz.h>"},
      {"include/arpa/nameser.h$", "<resolv.h>"},
      {"include/arpa/nameser_compat.h$", "<resolv.h>"},
      {"include/byteswap.h$", "<byteswap.h>"},
      {"include/cpio.h$", "<cpio.h>"},
      {"include/crypt.h$", "<crypt.h>"},
      {"include/dirent.h$", "<dirent.h>"},
      {"include/dlfcn.h$", "<dlfcn.h>"},
      {"include/elf.h$", "<elf.h>"},
      {"include/endian.h$", "<endian.h>"},
      {"include/envz.h$", "<envz.h>"},
      {"include/err.h$", "<err.h>"},
      {"include/error.h$", "<error.h>"},
      {"include/execinfo.h$", "<execinfo.h>"},
      {"include/fcntl.h$", "<fcntl.h>"},
      {"include/features.h$", "<features.h>"},
      {"include/fenv.h$", "<fenv.h>"},
      {"include/fmtmsg.h$", "<fmtmsg.h>"},
      {"include/fnmatch.h$", "<fnmatch.h>"},
      {"include/fstab.h$", "<fstab.h>"},
      {"include/fts.h$", "<fts.h>"},
      {"include/ftw.h$", "<ftw.h>"},
      {"include/gconv.h$", "<gconv.h>"},
      {"include/getopt.h$", "<getopt.h>"},
      {"include/glob.h$", "<glob.h>"},
      {"include/grp.h$", "<grp.h>"},
      {"include/gshadow.h$", "<gshadow.h>"},
      {"include/iconv.h$", "<iconv.h>"},
      {"include/ifaddrs.h$", "<ifaddrs.h>"},
      {"include/kdb.h$", "<kdb.h>"},
      {"include/langinfo.h$", "<langinfo.h>"},
      {"include/libgen.h$", "<libgen.h>"},
      {"include/libintl.h$", "<libintl.h>"},
      {"include/link.h$", "<link.h>"},
      {"include/malloc.h$", "<malloc.h>"},
      {"include/mcheck.h$", "<mcheck.h>"},
      {"include/memory.h$", "<memory.h>"},
      {"include/mntent.h$", "<mntent.h>"},
      {"include/monetary.h$", "<monetary.h>"},
      {"include/mqueue.h$", "<mqueue.h>"},
      {"include/netdb.h$", "<netdb.h>"},
      {"include/netinet/in.h$", "<netinet/in.h>"},
      {"include/nl_types.h$", "<nl_types.h>"},
      {"include/nss.h$", "<nss.h>"},
      {"include/obstack.h$", "<obstack.h>"},
      {"include/panel.h$", "<panel.h>"},
      {"include/paths.h$", "<paths.h>"},
      {"include/printf.h$", "<printf.h>"},
      {"include/profile.h$", "<profile.h>"},
      {"include/pthread.h$", "<pthread.h>"},
      {"include/pty.h$", "<pty.h>"},
      {"include/pwd.h$", "<pwd.h>"},
      {"include/re_comp.h$", "<re_comp.h>"},
      {"include/regex.h$", "<regex.h>"},
      {"include/regexp.h$", "<regexp.h>"},
      {"include/resolv.h$", "<resolv.h>"},
      {"include/rpc/netdb.h$", "<netdb.h>"},
      {"include/sched.h$", "<sched.h>"},
      {"include/search.h$", "<search.h>"},
      {"include/semaphore.h$", "<semaphore.h>"},
      {"include/sgtty.h$", "<sgtty.h>"},
      {"include/shadow.h$", "<shadow.h>"},
      {"include/spawn.h$", "<spawn.h>"},
      {"include/stab.h$", "<stab.h>"},
      {"include/stdc-predef.h$", "<stdc-predef.h>"},
      {"include/stdio_ext.h$", "<stdio_ext.h>"},
      {"include/strings.h$", "<strings.h>"},
      {"include/stropts.h$", "<stropts.h>"},
      {"include/sudo_plugin.h$", "<sudo_plugin.h>"},
      {"include/sysexits.h$", "<sysexits.h>"},
      {"include/tar.h$", "<tar.h>"},
      {"include/tcpd.h$", "<tcpd.h>"},
      {"include/term.h$", "<term.h>"},
      {"include/term_entry.h$", "<term_entry.h>"},
      {"include/termcap.h$", "<termcap.h>"},
      {"include/termios.h$", "<termios.h>"},
      {"include/thread_db.h$", "<thread_db.h>"},
      {"include/tic.h$", "<tic.h>"},
      {"include/ttyent.h$", "<ttyent.h>"},
      {"include/uchar.h$", "<uchar.h>"},
      {"include/ucontext.h$", "<ucontext.h>"},
      {"include/ulimit.h$", "<ulimit.h>"},
      {"include/unctrl.h$", "<unctrl.h>"},
      {"include/unistd.h$", "<unistd.h>"},
      {"include/utime.h$", "<utime.h>"},
      {"include/utmp.h$", "<utmp.h>"},
      {"include/utmpx.h$", "<utmpx.h>"},
      {"include/values.h$", "<values.h>"},
      {"include/wordexp.h$", "<wordexp.h>"},
      {"fpu_control.h$", "<fpu_control.h>"},
      {"ieee754.h$", "<ieee754.h>"},
      {"include/xlocale.h$", "<xlocale.h>"},
      {"gnu/lib-names.h$", "<gnu/lib-names.h>"},
      {"gnu/libc-version.h$", "<gnu/libc-version.h>"},
      {"gnu/option-groups.h$", "<gnu/option-groups.h>"},
      {"gnu/stubs-32.h$", "<gnu/stubs-32.h>"},
      {"gnu/stubs-64.h$", "<gnu/stubs-64.h>"},
      {"gnu/stubs-x32.h$", "<gnu/stubs-x32.h>"},
      {"include/rpc/auth_des.h$", "<rpc/auth_des.h>"},
      {"include/rpc/rpc_msg.h$", "<rpc/rpc_msg.h>"},
      {"include/rpc/pmap_clnt.h$", "<rpc/pmap_clnt.h>"},
      {"include/rpc/rpc.h$", "<rpc/rpc.h>"},
      {"include/rpc/types.h$", "<rpc/types.h>"},
      {"include/rpc/auth_unix.h$", "<rpc/auth_unix.h>"},
      {"include/rpc/key_prot.h$", "<rpc/key_prot.h>"},
      {"include/rpc/pmap_prot.h$", "<rpc/pmap_prot.h>"},
      {"include/rpc/auth.h$", "<rpc/auth.h>"},
      {"include/rpc/svc_auth.h$", "<rpc/svc_auth.h>"},
      {"include/rpc/xdr.h$", "<rpc/xdr.h>"},
      {"include/rpc/pmap_rmt.h$", "<rpc/pmap_rmt.h>"},
      {"include/rpc/des_crypt.h$", "<rpc/des_crypt.h>"},
      {"include/rpc/svc.h$", "<rpc/svc.h>"},
      {"include/rpc/rpc_des.h$", "<rpc/rpc_des.h>"},
      {"include/rpc/clnt.h$", "<rpc/clnt.h>"},
      {"include/scsi/scsi.h$", "<scsi/scsi.h>"},
      {"include/scsi/sg.h$", "<scsi/sg.h>"},
      {"include/scsi/scsi_ioctl.h$", "<scsi/scsi_ioctl>"},
      {"include/netrose/rose.h$", "<netrose/rose.h>"},
      {"include/nfs/nfs.h$", "<nfs/nfs.h>"},
      {"include/netatalk/at.h$", "<netatalk/at.h>"},
      {"include/netinet/ether.h$", "<netinet/ether.h>"},
      {"include/netinet/icmp6.h$", "<netinet/icmp6.h>"},
      {"include/netinet/if_ether.h$", "<netinet/if_ether.h>"},
      {"include/netinet/if_fddi.h$", "<netinet/if_fddi.h>"},
      {"include/netinet/if_tr.h$", "<netinet/if_tr.h>"},
      {"include/netinet/igmp.h$", "<netinet/igmp.h>"},
      {"include/netinet/in.h$", "<netinet/in.h>"},
      {"include/netinet/in_systm.h$", "<netinet/in_systm.h>"},
      {"include/netinet/ip.h$", "<netinet/ip.h>"},
      {"include/netinet/ip6.h$", "<netinet/ip6.h>"},
      {"include/netinet/ip_icmp.h$", "<netinet/ip_icmp.h>"},
      {"include/netinet/tcp.h$", "<netinet/tcp.h>"},
      {"include/netinet/udp.h$", "<netinet/udp.h>"},
      {"include/netrom/netrom.h$", "<netrom/netrom.h>"},
      {"include/protocols/routed.h$", "<protocols/routed.h>"},
      {"include/protocols/rwhod.h$", "<protocols/rwhod.h>"},
      {"include/protocols/talkd.h$", "<protocols/talkd.h>"},
      {"include/protocols/timed.h$", "<protocols/timed.h>"},
      {"include/rpcsvc/klm_prot.x$", "<rpcsvc/klm_prot.x>"},
      {"include/rpcsvc/rstat.h$", "<rpcsvc/rstat.h>"},
      {"include/rpcsvc/spray.x$", "<rpcsvc/spray.x>"},
      {"include/rpcsvc/nlm_prot.x$", "<rpcsvc/nlm_prot.x>"},
      {"include/rpcsvc/nis_callback.x$", "<rpcsvc/nis_callback.x>"},
      {"include/rpcsvc/yp.h$", "<rpcsvc/yp.h>"},
      {"include/rpcsvc/yp.x$", "<rpcsvc/yp.x>"},
      {"include/rpcsvc/nfs_prot.h$", "<rpcsvc/nfs_prot.h>"},
      {"include/rpcsvc/rex.h$", "<rpcsvc/rex.h>"},
      {"include/rpcsvc/yppasswd.h$", "<rpcsvc/yppasswd.h>"},
      {"include/rpcsvc/rex.x$", "<rpcsvc/rex.x>"},
      {"include/rpcsvc/nis_tags.h$", "<rpcsvc/nis_tags.h>"},
      {"include/rpcsvc/nis_callback.h$", "<rpcsvc/nis_callback.h>"},
      {"include/rpcsvc/nfs_prot.x$", "<rpcsvc/nfs_prot.x>"},
      {"include/rpcsvc/bootparam_prot.x$", "<rpcsvc/bootparam_prot.x>"},
      {"include/rpcsvc/rusers.x$", "<rpcsvc/rusers.x>"},
      {"include/rpcsvc/rquota.x$", "<rpcsvc/rquota.x>"},
      {"include/rpcsvc/nis.h$", "<rpcsvc/nis.h>"},
      {"include/rpcsvc/nislib.h$", "<rpcsvc/nislib.h>"},
      {"include/rpcsvc/ypupd.h$", "<rpcsvc/ypupd.h>"},
      {"include/rpcsvc/bootparam.h$", "<rpcsvc/bootparam.h>"},
      {"include/rpcsvc/spray.h$", "<rpcsvc/spray.h>"},
      {"include/rpcsvc/key_prot.h$", "<rpcsvc/key_prot.h>"},
      {"include/rpcsvc/klm_prot.h$", "<rpcsvc/klm_prot.h>"},
      {"include/rpcsvc/sm_inter.h$", "<rpcsvc/sm_inter.h>"},
      {"include/rpcsvc/nlm_prot.h$", "<rpcsvc/nlm_prot.h>"},
      {"include/rpcsvc/yp_prot.h$", "<rpcsvc/yp_prot.h>"},
      {"include/rpcsvc/ypclnt.h$", "<rpcsvc/ypclnt.h>"},
      {"include/rpcsvc/rstat.x$", "<rpcsvc/rstat.x>"},
      {"include/rpcsvc/rusers.h$", "<rpcsvc/rusers.h>"},
      {"include/rpcsvc/key_prot.x$", "<rpcsvc/key_prot.x>"},
      {"include/rpcsvc/sm_inter.x$", "<rpcsvc/sm_inter.x>"},
      {"include/rpcsvc/rquota.h$", "<rpcsvc/rquota.h>"},
      {"include/rpcsvc/nis.x$", "<rpcsvc/nis.x>"},
      {"include/rpcsvc/bootparam_prot.h$", "<rpcsvc/bootparam_prot.h>"},
      {"include/rpcsvc/mount.h$", "<rpcsvc/mount.h>"},
      {"include/rpcsvc/mount.x$", "<rpcsvc/mount.x>"},
      {"include/rpcsvc/nis_object.x$", "<rpcsvc/nis_object.x>"},
      {"include/rpcsvc/yppasswd.x$", "<rpcsvc/yppasswd.x>"},
      {"sys/acct.h$", "<sys/acct.h>"},
      {"sys/auxv.h$", "<sys/auxv.h>"},
      {"sys/cdefs.h$", "<sys/cdefs.h>"},
      {"sys/debugreg.h$", "<sys/debugreg.h>"},
      {"sys/dir.h$", "<sys/dir.h>"},
      {"sys/elf.h$", "<sys/elf.h>"},
      {"sys/epoll.h$", "<sys/epoll.h>"},
      {"sys/eventfd.h$", "<sys/eventfd.h>"},
      {"sys/fanotify.h$", "<sys/fanotify.h>"},
      {"sys/file.h$", "<sys/file.h>"},
      {"sys/fsuid.h$", "<sys/fsuid.h>"},
      {"sys/gmon.h$", "<sys/gmon.h>"},
      {"sys/gmon_out.h$", "<sys/gmon_out.h>"},
      {"sys/inotify.h$", "<sys/inotify.h>"},
      {"sys/io.h$", "<sys/io.h>"},
      {"sys/ioctl.h$", "<sys/ioctl.h>"},
      {"sys/ipc.h$", "<sys/ipc.h>"},
      {"sys/kd.h$", "<sys/kd.h>"},
      {"sys/kdaemon.h$", "<sys/kdaemon.h>"},
      {"sys/klog.h$", "<sys/klog.h>"},
      {"sys/mman.h$", "<sys/mman.h>"},
      {"sys/mount.h$", "<sys/mount.h>"},
      {"sys/msg.h$", "<sys/msg.h>"},
      {"sys/mtio.h$", "<sys/mtio.h>"},
      {"sys/param.h$", "<sys/param.h>"},
      {"sys/pci.h$", "<sys/pci.h>"},
      {"sys/perm.h$", "<sys/perm.h>"},
      {"sys/personality.h$", "<sys/personality.h>"},
      {"sys/poll.h$", "<sys/poll.h>"},
      {"sys/prctl.h$", "<sys/prctl.h>"},
      {"sys/procfs.h$", "<sys/procfs.h>"},
      {"sys/profil.h$", "<sys/profil.h>"},
      {"sys/ptrace.h$", "<sys/ptrace.h>"},
      {"sys/queue.h$", "<sys/queue.h>"},
      {"sys/quota.h$", "<sys/quota.h>"},
      {"sys/raw.h$", "<sys/raw.h>"},
      {"sys/reboot.h$", "<sys/reboot.h>"},
      {"sys/reg.h$", "<sys/reg.h>"},
      {"sys/resource.h$", "<sys/resource.h>"},
      {"sys/select.h$", "<sys/select.h>"},
      {"sys/sem.h$", "<sys/sem.h>"},
      {"sys/sendfile.h$", "<sys/sendfile.h>"},
      {"sys/shm.h$", "<sys/shm.h>"},
      {"sys/signalfd.h$", "<sys/signalfd.h>"},
      {"sys/socket.h$", "<sys/socket.h>"},
      {"sys/stat.h$", "<sys/stat.h>"},
      {"sys/statfs.h$", "<sys/statfs.h>"},
      {"sys/statvfs.h$", "<sys/statvfs.h>"},
      {"sys/swap.h$", "<sys/swap.h>"},
      {"sys/syscall.h$", "<sys/syscall.h>"},
      {"sys/sysctl.h$", "<sys/sysctl.h>"},
      {"sys/sysinfo.h$", "<sys/sysinfo.h>"},
      {"sys/syslog.h$", "<sys/syslog.h>"},
      {"sys/sysmacros.h$", "<sys/sysmacros.h>"},
      {"sys/termios.h$", "<sys/termios.h>"},
      {"sys/time.h$", "<sys/select.h>"},
      {"sys/timeb.h$", "<sys/timeb.h>"},
      {"sys/timerfd.h$", "<sys/timerfd.h>"},
      {"sys/times.h$", "<sys/times.h>"},
      {"sys/timex.h$", "<sys/timex.h>"},
      {"sys/ttychars.h$", "<sys/ttychars.h>"},
      {"sys/ttydefaults.h$", "<sys/ttydefaults.h>"},
      {"sys/types.h$", "<sys/types.h>"},
      {"sys/ucontext.h$", "<sys/ucontext.h>"},
      {"sys/uio.h$", "<sys/uio.h>"},
      {"sys/un.h$", "<sys/un.h>"},
      {"sys/user.h$", "<sys/user.h>"},
      {"sys/ustat.h$", "<sys/ustat.h>"},
      {"sys/utsname.h$", "<sys/utsname.h>"},
      {"sys/vlimit.h$", "<sys/vlimit.h>"},
      {"sys/vm86.h$", "<sys/vm86.h>"},
      {"sys/vtimes.h$", "<sys/vtimes.h>"},
      {"sys/wait.h$", "<sys/wait.h>"},
      {"sys/xattr.h$", "<sys/xattr.h>"},
      {"bits/epoll.h$", "<sys/epoll.h>"},
      {"bits/eventfd.h$", "<sys/eventfd.h>"},
      {"bits/inotify.h$", "<sys/inotify.h>"},
      {"bits/ipc.h$", "<sys/ipc.h>"},
      {"bits/ipctypes.h$", "<sys/ipc.h>"},
      {"bits/mman-linux.h$", "<sys/mman.h>"},
      {"bits/mman.h$", "<sys/mman.h>"},
      {"bits/msq.h$", "<sys/msg.h>"},
      {"bits/resource.h$", "<sys/resource.h>"},
      {"bits/sem.h$", "<sys/sem.h>"},
      {"bits/shm.h$", "<sys/shm.h>"},
      {"bits/signalfd.h$", "<sys/signalfd.h>"},
      {"bits/statfs.h$", "<sys/statfs.h>"},
      {"bits/statvfs.h$", "<sys/statvfs.h>"},
      {"bits/timerfd.h$", "<sys/timerfd.h>"},
      {"bits/utsname.h$", "<sys/utsname.h>"},
      {"bits/auxv.h$", "<sys/auxv.h>"},
      {"bits/byteswap-16.h$", "<byteswap.h>"},
      {"bits/byteswap.h$", "<byteswap.h>"},
      {"bits/confname.h$", "<unistd.h>"},
      {"bits/dirent.h$", "<dirent.h>"},
      {"bits/dlfcn.h$", "<dlfcn.h>"},
      {"bits/elfclass.h$", "<link.h>"},
      {"bits/endian.h$", "<endian.h>"},
      {"bits/environments.h$", "<unistd.h>"},
      {"bits/fcntl-linux.h$", "<fcntl.h>"},
      {"bits/fcntl.h$", "<fcntl.h>"},
      {"bits/in.h$", "<netinet/in.h>"},
      {"bits/ioctl-types.h$", "<sys/ioctl.h>"},
      {"bits/ioctls.h$", "<sys/ioctl.h>"},
      {"bits/link.h$", "<link.h>"},
      {"bits/mqueue.h$", "<mqueue.h>"},
      {"bits/netdb.h$", "<netdb.h>"},
      {"bits/param.h$", "<sys/param.h>"},
      {"bits/poll.h$", "<sys/poll.h>"},
      {"bits/posix_opt.h$", "<bits/posix_opt.h>"},
      {"bits/pthreadtypes.h$", "<pthread.h>"},
      {"bits/sched.h$", "<sched.h>"},
      {"bits/select.h$", "<sys/select.h>"},
      {"bits/semaphore.h$", "<semaphore.h>"},
      {"bits/sigthread.h$", "<pthread.h>"},
      {"bits/sockaddr.h$", "<sys/socket.h>"},
      {"bits/socket.h$", "<sys/socket.h>"},
      {"bits/socket_type.h$", "<sys/socket.h>"},
      {"bits/stab.def$", "<stab.h>"},
      {"bits/stat.h$", "<sys/stat.h>"},
      {"bits/stropts.h$", "<stropts.h>"},
      {"bits/syscall.h$", "<sys/syscall.h>"},
      {"bits/syslog-path.h$", "<sys/syslog.h>"},
      {"bits/termios.h$", "<termios.h>"},
      {"bits/types.h$", "<sys/types.h>"},
      {"bits/typesizes.h$", "<sys/types.h>"},
      {"bits/uio.h$", "<sys/uio.h>"},
      {"bits/ustat.h$", "<sys/ustat.h>"},
      {"bits/utmp.h$", "<utmp.h>"},
      {"bits/utmpx.h$", "<utmpx.h>"},
      {"bits/waitflags.h$", "<sys/wait.h>"},
      {"bits/waitstatus.h$", "<sys/wait.h>"},
      {"bits/xtitypes.h$", "<stropts.h>"},
  };
  return &STLPostfixHeaderMap;
}

} // namespace find_all_symbols
} // namespace clang
