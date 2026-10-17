# Compatible five-entry original-ring root signs

Continuation begun 2026-10-16 at 21:41:44 UTC. Pinned Lean 4.33.1,
mathlib 0df444a360eaa60ab8c11dca51a86af692955474.

## Mathematical scope

For every ordered D(1) quintuple in the FULL ring of integers of an
imaginary quadratic field, with smallest modulus >=1 and second >=3,
construct a single symmetric original-ring root matrix S and five complex
square roots u_i of its diagonal values. Every one of the ten pair-square
relations is preserved. Its normalized correction has mixed-quality first
four entries, determinant of that four-prefix <33/128, and each of its
four last-column entries differs from 1/2 by <1/400.

No unproved existence or large-last-entry assumption is used in the final
quintuple specialization. Apply the existing A>=3 product-four theorem to
the last four entries, deriving D>2BSC>=54. Thus every last-column pair
product has modulus >=54. For the prefix, products meeting index zero
have modulus >=3 and remaining products have modulus >=9.

The scalar sign estimate uses the already proved root perturbation lemma
with c=49/50, obtaining |e|<50/99 and |e-1/2|<625/264627<1/400.
Define sign quality with priority on pairs meeting index four. Choose one
sign on each unordered pair (min i j,max i j), then impose symmetry.
Signs on the first four indices are exactly compatible with the existing
MixedSignedEntryGood predicate; no independent existential witness is
substituted in the prefix determinant bound.

The final vector estimate under development is |f-f0|_2<1/200 and
|f|_2<201/200. It follows by summing four squared entry bounds and the
triangle inequality; f0 is the constant 1/2 vector with L2 norm one.

## Actual checks so far

The complete scalar/sign/actual-tuple source (nine public theorems and
one predicate) compiled in trial04 with EXIT 0, no warnings.
Trials01--03 failed only at documented Lean logical/Fin-coercion steps.
Trial05 adds the vector estimate and is not presumed successful yet.
Source remains exploration/FiveSignsContinuation.lean until integration.

## Remaining proof obligations

No claim of full product-five or main bound-five completion. Still derive
the F^-1 f estimate, all three bilinear bounds, and ||G-H||_2<1/2 for the
same chosen matrix, then finish the tuple-level product-five assembly.
Bennett's arbitrary-order identity, exhaustive finite descent/graph checks,
final exclusions and independent final statement audit remain open.

## Verified follow-up

Trial05 completed with EXIT 0, including the Euclidean vector estimates.
Byte-identical root module: D1Bound5/ProductFiveCompatibleSigns.lean,
SHA256 7ef326eadce635a2fc8001d19ab9a7846a67febccdcf6d3cfe50963ad72c4cef.
Integrated target/root build EXIT 0 (3038 jobs). Source/import audit EXIT 0,
75 modules and 367 explicit theorem declarations. All 78 source and 38
verification-tool fingerprints passed; the external frozen TeX digest is
unchanged. The dedicated eleven-declaration audit completed EXIT 0 with
only propext, Classical.choice and Quot.sound. All ten elaborated theorem
types plus the predicate were printed and checked. The actual tuple theorem
quantifies over an arbitrary NumberField K, finrank Q K=2 and total
complexity, with entries in NumberField.RingOfIntegers K. It assumes only
IsD1Tuple, monotone moduli, A>=1 and B>=3. Zero-square exclusions, strict
ordering and unproved sign-existence assumptions are absent.

The targeted same-kernel replay is running and its exit is not assumed.
No independent reviewer, clean-checkout build or whole-project replay.
