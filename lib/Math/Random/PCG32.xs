#define PERL_NO_GET_CONTEXT

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "pcg.h"

MODULE = Math::Random::PCG32		PACKAGE = Math::Random::PCG32

PROTOTYPES: ENABLE

pcg32_random_t *
new(CLASS, initstate, initseq)
    char *CLASS
    UV initstate
    UV initseq
    CODE:
        Newxz(RETVAL, 1, pcg32_random_t);
        if (RETVAL == NULL) croak("Could not allocate state memory");
        pcg32_srandom_r(RETVAL, initstate, initseq);
    OUTPUT:
        RETVAL

UV
decay(pcg32_random_t *rng, uint32_t odds, uint32_t min, uint32_t max)
    PREINIT:
        uint32_t count;
    CODE:
        count = min;
        while (count < max) {
            if (pcg32_random_r(rng) < odds) break;
            count++;
        }
        RETVAL = count;
    OUTPUT:
        RETVAL

UV
dice(pcg32_random_t *rng, uint32_t count, uint32_t sides)
    PREINIT:
        uint32_t i, sum;
    CODE:
        sum = 0;
        for (i = 0; i < count; i++) sum += 1 + pcg32_random_r(rng) % sides;
        RETVAL = sum;
    OUTPUT:
        RETVAL

UV
irand(pcg32_random_t *rng)
    CODE:
        RETVAL = pcg32_random_r(rng);
    OUTPUT:
        RETVAL

UV
irand64(pcg32_random_t *rng)
    CODE:
        RETVAL = ((uint64_t) pcg32_random_r(rng) << 32) | pcg32_random_r(rng);
    OUTPUT:
        RETVAL

UV
irand_in(pcg32_random_t *rng, uint32_t min, uint32_t max)
    CODE:
        if (max == min)     RETVAL = min;
        else if (min > max) croak("max must be greater than min");
        else RETVAL = min + pcg32_random_r(rng) % (max - min + 1);
    OUTPUT:
        RETVAL

void
irand_way(pcg32_random_t *rng, int32_t x1, int32_t y1, int32_t x2, int32_t y2)
    PREINIT:
        int32_t dx, dy, magx;
    PPCODE:
        if (x1 == x2 && y1 == y2) XSRETURN_UNDEF;
        EXTEND(SP, 2);
        dx = x2 - x1;
        dy = y2 - y1;
        if (dx == 0)      goto MOVE_Y;
        else if (dy == 0) goto MOVE_X;
        magx = abs(dx);
        if (pcg32_random_r(rng) % (magx + abs(dy)) < magx) {
            MOVE_X:
            PUSHs(sv_2mortal(newSViv(x1 + (dx > 0 ? 1 : -1))));
            PUSHs(sv_2mortal(newSViv(y1)));
        } else {
            MOVE_Y:
            PUSHs(sv_2mortal(newSViv(x1)));
            PUSHs(sv_2mortal(newSViv(y1 + (dy > 0 ? 1 : -1))));
        }

double
rand(pcg32_random_t *rng, ...)
    PROTOTYPE: $;$
    PREINIT:
        double factor;
    CODE:
        if (items > 1) {
            if (!SvIOK(ST(1)) && !SvNOK(ST(1)))
              croak("factor must be a number");
            factor = SvNV(ST(1));
        } else factor = 1.0;
        RETVAL = pcg32_random_r(rng) / 4294967296.0 * factor;
    OUTPUT:
        RETVAL

SV *
rand_elm(pcg32_random_t *rng, avref)
    AV *avref;
    PREINIT:
        int len;
        SV **svp;
    CODE:
        len = av_len(avref) + 1;
        if (len == 0) XSRETURN_UNDEF;
        svp = av_fetch(avref, pcg32_random_r(rng) % len, FALSE);
        SvREFCNT_inc(*svp);
        RETVAL = *svp;
    OUTPUT:
        RETVAL

UV
rand_idx(pcg32_random_t *rng, avref)
    AV *avref;
    PREINIT:
        int len;
    CODE:
        len = av_len(avref) + 1;
        if (len == 0) XSRETURN_UNDEF;
        else          RETVAL = pcg32_random_r(rng) % len;
    OUTPUT:
        RETVAL

void
DESTROY(pcg32_random_t *rng)
    PPCODE:
        Safefree(rng);
