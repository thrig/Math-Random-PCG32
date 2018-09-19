/* *Really* minimal PCG32 code / (c) 2014 M.E. O'Neill / pcg-random.org
 * Licensed under Apache License 2.0 (NO WARRANTY, etc. see website) */

#include <stdint.h>

typedef struct {
    uint64_t state;
    uint64_t inc;
} pcg32_random_t;

pcg32_random_t *new(uint64_t initstate, uint64_t initseq);
uint32_t pcg32_random_r(pcg32_random_t * rng);
void DESTROY(pcg32_random_t * rng);
