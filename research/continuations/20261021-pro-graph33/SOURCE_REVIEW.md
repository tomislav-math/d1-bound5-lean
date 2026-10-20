# Graph 33 source and statement review

This continuation resumes the existing exact 720-row partition. Chunk04 covers
rows 512 through 639 and Chunk05 covers rows 640 through 719. Both keep the
entire original vertex list, the bound 10^1100 and both mutation signs.
Chunks00 through03 are reused only with matching accepted closures and artifacts.

The original Coverage decision exceeded the 240-second limit. Its failed source,
log and receipt remain in this directory and must not be counted as accepted.
The changed proof is archived separately under coverage-projection/.

The witness list is defined by zipWith, pairing every original vertex with its
supplied root pair. The new local lemma proves, by induction on arbitrary lists,
that projecting the first component of such a zipWith recovers the first list
whenever its length is at most the second list's length. map_zipWith reduces the
actual witness projection to this lemma. Only the two list lengths and the small
anchor-root equation require decide +kernel. No large coordinate equality is
assumed or delegated to an external computation.

The public Coverage statement is byte-for-byte unchanged before its proof body.
The original parent indexed_checked and smallPairClosure_33_checked statements
are checked against the independently preserved unsplit source. Their existing
six-prefix join and terminal empty-tail proof remain unchanged. The aggregate
Data33 contains only its three original component imports.

Compilation, exact public-type/transitive-axiom checks and targeted installed
SAME-kernel replays have distinct receipts. No accepted-root integration, fresh
whole-root replay, independent semantic review or main-theorem proof is claimed
by this source review. See the eventual verification summary for actual outcomes.
