# Rational triple exclusion verified working checkpoint

The original theorem excludes a modulus-ordered full-ring D(1)-sextuple
whose first three entries are simultaneously signed 1, 3 and 8, in any
totally complex number field of degree two. Its original hypotheses and
statement are unchanged. The proof uses the existing analytic cutoff and
the strict fourth-entry growth bound greater than 48.

The repair changes exactly two proof commands, exposing the ring-of-integers
coercion and ring-homomorphism images of the numerals 3 and 8.
The previous exit-1 attempt is preserved separately and is not accepted.

One guarded pinned build, the exact original public-type/transitive-axiom
audit, and one targeted installed SAME-kernel replay passed. The supplied
source patch also received a separate independent review; that review did
not independently inspect imported proofs or recompute file hashes.

SOURCE_MAP.json reconstructs the full 329-module accepted source closure
from one new payload and 328 exact prior Git references. Compiled proof
objects are not uploaded. Audit records are in
../20261020T100000CEST-work-resume/pro-rational-triple-audit/.

This is a verified working dependency. Canonical root integration,
MainTheorem, OneSmallImpossible and final whole-project gates remain open.
Publication is established separately by the post-push receipt and handoff.
