#define PERL_NO_GET_CONTEXT

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "pcg.h"

typedef pcg32_random_t *Math__Random__PCG32;

MODULE = Math::Random::PCG32		PACKAGE = Math::Random::PCG32

PROTOTYPES: ENABLE

Math::Random::PCG32
new(package, initstate, initseq)
    char *package
    UV initstate
    UV initseq
    CODE:
        RETVAL = new(initstate, initseq);
    OUTPUT:
        RETVAL

UV
rand(obj)
    Math::Random::PCG32 obj
    CODE:
        RETVAL = pcg32_random_r(obj);
    OUTPUT:
        RETVAL

void
DESTROY(obj)
    Math::Random::PCG32 obj
