#include <clc/clc.h>

#define __CLC_FUNC cos
#define __CLC_BODY <half_unary.inc>
#define __FLOAT_ONLY
#include <clc/math/gentype.inc>
