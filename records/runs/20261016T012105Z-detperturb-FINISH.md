# FINISH — quantitative reference-matrix perturbation

Outcome: COMPLETED_UNIT.

Start record: `20261016T012105Z-detperturb-START.md`. Verification and Git remote comparison observed on 2026-10-16 at 01:36:13 UTC.

## Proved Lean statements

`D1Bound5/ReferencePerturbation.lean` proves four new theorems without sorry or a mathematical axiom. Let H=(J₄-I₄)/2 and K=H⁻¹, with ‖K‖=2 already kernel-proved.

- `reference_perturbed_det_ne_zero`: ‖K(F-H)‖<1 implies det F≠0.
- `reference_perturbed_det_ne_zero_of_near`: ‖F-H‖<3*(128/8649) implies det F≠0.
- `reference_perturbed_inverse_norm_lt`: ‖F-H‖<1/8 implies ‖F⁻¹‖<8/3.
- `exists_signed_root_matrix_with_bounded_inverse`: transfers invertibility and the inverse bound to simultaneous symmetric choices of actual integral roots under the exact square identities and |a_i a_j|≥9, retaining zero squares and modulus ties.

Core proof: KF=I+K(F-H), then apply `isUnit_one_sub_of_norm_lt_one` to the negative perturbation. Derive the strict inverse norm inequality directly from K=F⁻¹+K(F-H)F⁻¹ and strict ‖K(F-H)‖<1/4.

## Actual checks

- Direct final source elaboration: exit 0.
- Integrated build from pinned project: exit 0, 3008 jobs.
- Source and root import coverage: `SOURCE_AUDIT_PASS`, 45 modules, 247 explicit theorems.
- Transitive axiom audit: exit 0, all four new theorem types printed, only propext, Classical.choice, Quot.sound.
- Installed Lean kernel replay: exit 0 for D1Bound5.ReferencePerturbation. This uses the same Lean kernel, not an independent checker.
- Source SHA-256 manifest: 48 entries, verification exit 0. Tool manifest: 12 entries, verification exit 0.

No whole-root replay, clean checkout, external independent review or final proof of MainStatement occurred. The frozen paper, other projects, settings and paid services were untouched.

## Git and preservation

Local commit `8b686a8889fa10ba834b32453d2ac3a95a9f9aac` succeeded, incorporating checked continuation modules left staged by earlier runs and this four-theorem module. The private repository's remote main was still `980cc19e008a0120098d32a50c11031ae8df1558` at 01:36:13 UTC. An ordinary `git push origin main` was blocked by the tool's safety guard before execution. No push succeeded and no bypass was attempted. Two older unstaged modifications to previously existing FINISH records were preserved and not incorporated into the proof commit.

## Exact next step

Formalize the upper singular-value determinant bound |det F|<hs³ and adjugate operator bound ‖adj F‖<hs² from the already proved four-by-four perturbation estimate. Then prove the rank-one determinant step of `lem:product-four` and the separate weighted A≥1,B≥3 case. Bennett's arbitrary-order identity, finite graph completeness and the final bound-five theorem remain open.
