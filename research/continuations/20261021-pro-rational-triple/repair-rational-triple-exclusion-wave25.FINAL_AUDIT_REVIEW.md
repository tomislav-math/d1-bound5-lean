# Independent RationalTripleExclusion wave25 source review

Result: PASS for the exact source repair; no compilation or acceptance claim.
Read the full 46-line original, 15-line specification, 82-line actual error excerpt, author review, both actual receipts, the 31-line accepted analogue and narrow primary lemma sources. No canonical, queue, lock, Git, compiler or checker operations were performed.

- Specification SHA256: fb18117e18f28296bc5bb490ab0da892657555f0838f879b507d0b7f165c3649.
- Canonical preimage SHA256: 3b4eed051b98e0913edf7e32a5b70e88b0ca44cd93ed0d346cb059d3464f9839; exact proposed postimage SHA256: a371b62371998ecafcf62355545deafcb8b9d090deb6a8d1f808d6deebc0624b. Both contain 46 lines.
- The single count-two replacement adds NumberField.RingOfIntegers.coe_eq_algebraMap and map_ofNat to norm_num only at lines 36 and 37. Every other byte, the theorem header, hypotheses, constants, imports and local b definition remain unchanged.
- Actual error excerpt SHA256 bdfe078936c45687164f249e9b67bbaa777511d387723f61454a898b168163d1 matches the full build log. Exactly two source errors at 36:35 and 37:35 give four sign branches with residual norms of phi applied to the ring-of-integers numerals 3 and 8.
- Actual wave25 receipt SHA256 bf9b9230fa207a5f81bbc0fe1d4e7dd81fad3a83642a0375e0abce56f4ff92de records exit 1, not accepted, 234.69559604208916 seconds, no timeout/interruption and stable source/artifact guards. The recorded source closure contains the exact preimage.
- Primary NumberField/Basic.lean line 145 identifies the ring-of-integers coercion with algebraMap by rfl (file SHA256 68833cc080857da33ed2661fac14c281651f140904af0fb587a447e23b81bac6). Primary Data/Nat/Cast/Basic.lean lines 148–150 state map_ofNat for a ring homomorphism and a numeral at least two (file SHA256 b9f43fafa3d0626f0549fd9a84c86d6eb53b32e52a432750e72c00b017b2f400). These expose and reduce both algebraMap and phi on 3/8, after which the unchanged sign and norm simplification is numerical.
- The entire proposed cases-sgn/norm_num command is byte-identical to the one in RationalCutoffNorms (current source SHA256 7e14b14398c156606f9521e6ae9c9db75e66fe50dedbdbd1984734965b9c2d93). Its matching wave23 receipt SHA256 92357749a2508acabb0b50e723b15a02593809bd0e327228d9bf5c429a17ec8f records accepted exit 0 in 99.04068329185247 seconds with stable guards.
- Independent diagnostic verified all eight input pins, the sole count-two replacement, exact changed line numbers, exact pre/post hashes, complete error-excerpt correspondence, both receipts and unchanged remaining source bytes. PID 53321 completed with exit 0 (0.14 seconds), terminal collected.

The exact repair is suitable for root-owned guarded application and an actual rebuild after the active owner drains. This review adds no execution prerequisite and does not assert that the candidate compiles.
