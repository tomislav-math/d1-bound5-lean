# Exact partition of the first row26 blocks

2026-10-19T17:57:05.489442+02:00

Each original first block checks 54 heads against every later vertex. Replace that computation by 18 contiguous groups of three heads at offsets 0,3,...,51, for each of the left and right lists. Both cached and witness lists are dropped by the same offset, never truncated. The verified prefix-concatenation identity proves the original 54-head statement from the parts, also for unequal or malformed witness lists. The already verified left part00 is reused. Parent sources are still unchanged until all their parts compile. The full row has further blocks and is NOT closed by this first-block repair. No certificate data, masking rule, norm test, field model or root convention is changed.
