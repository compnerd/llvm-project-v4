#include <clc/clc.h>
 
#define __CLC_FUNC exp10
#define __FLOAT_ONLY
#define __CLC_BODY <half_native_unary.inc>
#include <clc/math/gentype.inc>
