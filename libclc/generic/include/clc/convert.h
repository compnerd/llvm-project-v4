#define _CLC_CONVERT_DECL(FROM_TYPE, TO_TYPE, SUFFIX) \
  _CLC_OVERLOAD _CLC_DECL TO_TYPE convert_##TO_TYPE##SUFFIX(FROM_TYPE x);

#define _CLC_VECTOR_CONVERT_DECL(FROM_TYPE, TO_TYPE, SUFFIX) \
  _CLC_CONVERT_DECL(FROM_TYPE, TO_TYPE, SUFFIX) \
  _CLC_CONVERT_DECL(FROM_TYPE##2, TO_TYPE##2, SUFFIX) \
  _CLC_CONVERT_DECL(FROM_TYPE##3, TO_TYPE##3, SUFFIX) \
  _CLC_CONVERT_DECL(FROM_TYPE##4, TO_TYPE##4, SUFFIX) \
  _CLC_CONVERT_DECL(FROM_TYPE##8, TO_TYPE##8, SUFFIX) \
  _CLC_CONVERT_DECL(FROM_TYPE##16, TO_TYPE##16, SUFFIX)

#define _CLC_VECTOR_CONVERT_FROM1(FROM_TYPE, SUFFIX) \
  _CLC_VECTOR_CONVERT_DECL(FROM_TYPE, char, SUFFIX) \
  _CLC_VECTOR_CONVERT_DECL(FROM_TYPE, uchar, SUFFIX) \
  _CLC_VECTOR_CONVERT_DECL(FROM_TYPE, int, SUFFIX) \
  _CLC_VECTOR_CONVERT_DECL(FROM_TYPE, uint, SUFFIX) \
  _CLC_VECTOR_CONVERT_DECL(FROM_TYPE, short, SUFFIX) \
  _CLC_VECTOR_CONVERT_DECL(FROM_TYPE, ushort, SUFFIX) \
  _CLC_VECTOR_CONVERT_DECL(FROM_TYPE, long, SUFFIX) \
  _CLC_VECTOR_CONVERT_DECL(FROM_TYPE, ulong, SUFFIX) \
  _CLC_VECTOR_CONVERT_DECL(FROM_TYPE, float, SUFFIX)

#ifdef cl_khr_fp64
#define _CLC_VECTOR_CONVERT_FROM(FROM_TYPE, SUFFIX) \
  _CLC_VECTOR_CONVERT_FROM1(FROM_TYPE, SUFFIX) \
  _CLC_VECTOR_CONVERT_DECL(FROM_TYPE, double, SUFFIX)
#else
#define _CLC_VECTOR_CONVERT_FROM(FROM_TYPE, SUFFIX) \
  _CLC_VECTOR_CONVERT_FROM1(FROM_TYPE, SUFFIX)
#endif

#define _CLC_VECTOR_CONVERT_TO1(SUFFIX) \
  _CLC_VECTOR_CONVERT_FROM(char, SUFFIX) \
  _CLC_VECTOR_CONVERT_FROM(uchar, SUFFIX) \
  _CLC_VECTOR_CONVERT_FROM(int, SUFFIX) \
  _CLC_VECTOR_CONVERT_FROM(uint, SUFFIX) \
  _CLC_VECTOR_CONVERT_FROM(short, SUFFIX) \
  _CLC_VECTOR_CONVERT_FROM(ushort, SUFFIX) \
  _CLC_VECTOR_CONVERT_FROM(long, SUFFIX) \
  _CLC_VECTOR_CONVERT_FROM(ulong, SUFFIX) \
  _CLC_VECTOR_CONVERT_FROM(float, SUFFIX)

#ifdef cl_khr_fp64
#define _CLC_VECTOR_CONVERT_TO(SUFFIX) \
  _CLC_VECTOR_CONVERT_TO1(SUFFIX) \
  _CLC_VECTOR_CONVERT_FROM(double, SUFFIX)
#else
#define _CLC_VECTOR_CONVERT_TO(SUFFIX) \
  _CLC_VECTOR_CONVERT_TO1(SUFFIX)
#endif

#define _CLC_VECTOR_CONVERT_TO_SUFFIX(ROUND) \
  _CLC_VECTOR_CONVERT_TO(_sat##ROUND) \
  _CLC_VECTOR_CONVERT_TO(ROUND)

_CLC_VECTOR_CONVERT_TO_SUFFIX(_rtn)
_CLC_VECTOR_CONVERT_TO_SUFFIX(_rte)
_CLC_VECTOR_CONVERT_TO_SUFFIX(_rtz)
_CLC_VECTOR_CONVERT_TO_SUFFIX(_rtp)
_CLC_VECTOR_CONVERT_TO_SUFFIX()
