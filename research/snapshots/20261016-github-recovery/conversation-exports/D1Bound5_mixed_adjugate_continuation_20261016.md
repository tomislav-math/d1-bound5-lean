# D1 bound-five: mixed adjugate envelope continuation

**Execution:** 16 October 2026, begun 16:13:45 CEST (14:13:45 UTC).  
**Project:** `/Users/tp/Lean/D1Bound5` on authorized Mac device `788d1b22-4569-4161-bfbe-d886d48c6a75`.  
**Branch / starting HEAD:** `main`, `feb2b68`.  
**Outcome:** PARTIAL — a new, genuinely proved **conditional four-by-four adjugate norm closure** with four Lean declarations. The scalar cofactor hypotheses are mathematically established below using explicit complex triangle inequalities, but their Lean implementation and original-ring transfer have NOT yet been completed. Main bound-five statement UNPROVED.

## Verified Lean proof unit

Source: `MixedAdjugateEnvelope.lean`, SHA-256 `ff1dc2f3d01196f264755007df08d100ac1f1bf66874598e7ca2beea27d1e35b` (including its own transitive-axiom audit). The source uses existing verified project modules `D1Bound5.WeightedSchur` and `D1Bound5.AdjugateCoverage` without altering those modules.

Define the real symmetric entrywise envelope

\[
B=\begin{pmatrix}
1/40&53/1000&53/1000&53/1000\\
53/1000&7/100&47/1000&47/1000\\
53/1000&47/1000&7/100&47/1000\\
53/1000&47/1000&47/1000&7/100
\end{pmatrix}.
\]

Its row sums are `184/1000`, `217/1000`, `217/1000`, `217/1000`. It is entrywise nonnegative and symmetric. The already formalized weighted Schur theorem (with constant weight 1) implies that any complex 4-by-4 matrix E with `||E_ij|| <= B_ij` satisfies `||E||_2 <= 217/1000`.

The new theorem `mixedFour_adjugate_norm_of_entries` states, for an arbitrary complex 4-by-4 F, that the entrywise bounds `||(adj F - adj H)00|| < 1/40`, `||(adj F - adj H)ii|| < 7/100` for `i>0`, `||(adj F - adj H)0j||, ||(adj F - adj H)j0|| < 53/1000`, and `||(adj F - adj H)ij|| < 47/1000` for distinct positive indices, imply

\[
\|\operatorname{adj}F\|_2
 \le 3/8+217/1000=74/125
 < (155/96)(59/96)^2 =539555/884736.
\]

The strict rational margin is `1973911/110592000 > 0`. This is the precise adjugate bound used by the **mixed** `A>=1, B>=3` numerical argument. It is not the `productFourH*productFourS^2` bound of the other (`A>=3`) branch. In the first in-memory trial, the wrong branch constants were used, and the compiler correctly rejected the false inequality. That error was diagnosed and fixed.

### Verification receipts

- At first inspection (16:13:45 CEST), no project-owned Lean/lake/leanchecker process was running. The main worktree had previously checked staged changes in `MixedFourDetBound.lean`, `WeightedSchur.lean`, and associated records, plus unrelated historical untracked notes. The separate `tail-analytic-20261015` worktree was untouched.
- The first in-memory Lean trial (`PID 44340`) failed on an **incorrect numerical target** using the large-branch rather than mixed-branch coefficient.
- The second trial (`PID 44380`) repaired that target but omitted a final `simp` step in the concrete row-sum proof. EXIT 1, with exactly four unresolved finite arithmetic goals.
- Corrected in-memory source (`PID 44425`) invoked `/Users/tp/.elan/bin/lake env lean --stdin` from the pinned project. It returned **EXIT 0**. All four new theorem declarations passed explicit **transitive** axiom audit. Every transitive axiom was one of `propext`, `Classical.choice`, `Quot.sound`. Two harmless linter warnings concern the row-sum tactic combinator.
- This is a completed Lean elaboration/kernel check of the in-memory source and an actual transitive axiom audit, but **not** a saved project module, `.olean` compilation, integrated root Lake build, separate leanchecker replay, fresh checkout, or independent mathematical referee review.
- Both attempted writes of the START record to the authorized Mac were rejected by a higher-level tool safety check *before execution*. The second was the one permitted bounded recovery. No later write to that Mac, integration or Git operation was attempted. The exact cause is UNKNOWN. A START-equivalent and FINISH-equivalent record and the complete proof source are preserved as separate sandbox artifacts and, after one recovery of a container-session upload error, have been successfully uploaded to ChatGPT Library under `/D1Bound5-Lean-continuations/20261016T141345Z-mixed-adjugate/`. No Mac file write or Git operation succeeded during this invocation.

## New exact mathematical reduction for completing the scalar hypotheses

The same coefficientwise argument covers **all sixteen** adjugate entries; by the exact `symmetricFour_adjugate_formula` already formalized in the project it suffices to treat four scalar prototypes. Let `alpha=1/18` and `beta=1/64`. Write the six independent entries of a symmetric zero-diagonal matrix as

`x=1/2+a`, `y=1/2+b`, `z=1/2+c`, `u=1/2+d`, `v=1/2+e`, `w=1/2+f`,

where `|a|,|b|,|c|<alpha` and `|d|,|e|,|f|<beta`. Here `|.|` means the complex modulus.

The diagonal cofactor in position (0,0) is `2uvw`, and direct expansion and the triangle inequality yield

`|2uvw-1/4| <= 3*beta/2 + 3*beta^2 + 2*beta^3 = 3169/131072 < 1/40`.

A positive diagonal cofactor, such as `2yzw`, has two alpha factors and one beta factor. Expansion yields

`|2yzw-1/4| <= alpha + beta/2 + alpha^2 + 2*alpha*beta + 2*alpha^2*beta = 59/864 < 7/100`.

For the (0,1) cofactor, which equals `w^2*x - w*z*u - w*y*v`, use the following **exact algebraic identity**. Let

```
A = a - c - d - b - e
C = a - (c + d + b + e)/2
D = f^2 - c*d - b*e
T = a*f - c*d - b*e
```

Then

`w^2*x-w*z*u-w*y*v+1/8 = A/4 + f*C + D/2 + f*T`.

The coefficient bounds here are `|A| <= 3*alpha+2*beta`, `|C| <= 2*alpha+beta`, `|D| <= beta^2+2*alpha*beta`, and `|T| <= 3*alpha*beta`. Therefore

`|w^2*x-w*z*u-w*y*v+1/8|`

`<= (3*alpha+2*beta)/4 + beta*(2*alpha+beta) + (beta^2+2*alpha*beta)/2 + 3*alpha*beta^2`

`= 215/4096 < 53/1000`.

A positive off-diagonal cofactor, such as `z^2*u-z*y*v-z*x*w`, has the same algebraic expression with the *two different radius assignments*: the squared variable and two of the linear input variables have radius `alpha`, while the remaining three variables have radius `beta`. The generic four-group identity now gives

`|z^2*u-z*y*v-z*x*w+1/8|`

`<= (2*alpha+3*beta)/4 + alpha*(alpha+2*beta) + (alpha^2+2*alpha*beta)/2 + 3*alpha^2*beta`

`= 3/64 < 47/1000`.

Every other cofactor has one of these four forms after permuting the indices 1,2,3 and, for off-diagonals, transposing. The exact cofactor table and its sixteen-entry completeness are already proven by `symmetricFour_adjugate_formula` in `AdjugateCoverage.lean`. Thus the **unconditional mixed adjugate bound follows mathematically**, with no invertibility assumption on F. The four scalar inequalities have been checked independently by exact symbolic polynomial expansion and rational arithmetic during this run. They have **not** been promoted to accepted Lean proofs merely on that basis.

## Precise next action

1. Once the authorized Mac allows ordinary file writes, restore the archived source into an appropriately named `D1Bound5` module, separate its audit into `scripts/`, and recompile/audit/replay under the pinned project. Check that no newer user source is overwritten.
2. Formalize the four **unconditional scalar prototype inequalities** above (preferably in one generic six-radius cofactor inequality plus two diagonal lemmas) and discharge the hypotheses of `mixedFour_adjugate_norm_of_entries` using the existing sixteen-entry cofactor table. Establish the unconditional mixed adjugate bound for one symmetric normalized root-error matrix and transfer it to the **same** ring-valued signed-root choice as the mixed determinant bound.
3. Connect this with the already saved isolated mixed numerical closure and the arithmetic determinant lower bound to finish the second branch `D>(3/2)ABC` for actual D(1)-quadruples. The main bound-five theorem remains open, as do product-five, Bennett's arbitrary-order determinant identity, complete finite certificates and the final sextuple exclusions.
