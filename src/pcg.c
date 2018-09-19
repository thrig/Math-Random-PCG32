/* *Really* minimal PCG32 code / (c) 2014 M.E. O'Neill / pcg-random.org
 * Licensed under Apache License 2.0 (NO WARRANTY, etc. see website) */

#include <EXTERN.h>
#include <perl.h>

#include "pcg.h"

pcg32_random_t *new(uint64_t initstate, uint64_t initseq)
{
    pcg32_random_t *rng = malloc(sizeof(pcg32_random_t));
    if (rng == NULL)
        croak("out of memory");
    rng->state = 0U;
    rng->inc = (initseq << 1u) | 1u;
    pcg32_random_r(rng);
    rng->state += initstate;
    pcg32_random_r(rng);
    return rng;
}

uint32_t pcg32_random_r(pcg32_random_t * rng)
{
    uint64_t oldstate = rng->state;
    // Advance internal state
    rng->state = oldstate * 6364136223846793005ULL + (rng->inc | 1);
    // Calculate output function (XSH RR), uses old state for max ILP
    uint32_t xorshifted = ((oldstate >> 18u) ^ oldstate) >> 27u;
    uint32_t rot = oldstate >> 59u;
    return (xorshifted >> rot) | (xorshifted << ((-rot) & 31));
}

void DESTROY(pcg32_random_t * rng)
{
    free(rng);
}
