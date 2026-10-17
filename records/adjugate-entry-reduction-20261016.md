# Four-by-four adjugate entry reduction (isolated Lean proof)

Date: 2026-10-16, Europe/Zagreb. All code and mathematics in this record are independent of the still-unproved global bound-five theorem.

## Exact proved declarations

The isolated file `exploration/AdjugateFourTrial.lean` contains SIX kernel-elaborated proofs, with exact transitive axiom checks:

- `four_operator_norm_lt_of_entry_bounds`: for a general complex 4x4 matrix E with diagonal norms <a and other entry norms <b, where a,b>0, the L2 operator norm is <a+3b. The proof splits a diagonal matrix and a zero-diagonal matrix, then invokes the previously verified three-matching estimate.
- `symmetricZeroFour_adjugate_00`: for the symmetric zero-diagonal matrix with six variables x,y,z,u,v,w, cofactor (0,0) is 2uvw.
- `symmetricZeroFour_adjugate_01`: cofactor (0,1) is w²x-wzu-wyv. Both formulae are proved by Lean's determinant and adjugate definitions followed by polynomial normalization.
- `four_adjugate_numeric_margin`: exact rational arithmetic establishes 3/8 + 23/1000 + 3*(197/10000) < (8905/5766)*(3139/5766)^2.
- `four_adjugate_bound_of_entry_bounds`: for an arbitrary complex F, diagonal error <23/1000 and off-diagonal error <197/10000 in adj(F)-adj(H) imply norm(adj(F)) < productFourH*productFourS², where H=(J-I)/2. The proof uses ||adj(H)||=3/8, already proven as a consequence of det H and ||H^{-1}||.
- `nearHalf_triple_cofactor_bound`: if each of x,y,z is within epsilon=128/8649 of 1/2, then |2xyz-1/4|<23/1000. This is a complete complex-norm proof, using the telescoping identity 2xyz-1/4=2(x-1/2)yz+(y-1/2)z+(z-1/2)/2.

## Remaining scalar estimate

For the off-diagonal cofactor w²x-wzu-wyv it remains to formalize

    |w²x-wzu-wyv+1/8| < 197/10000

when each of x,y,z,u,v,w is within epsilon=128/8649 of 1/2. A direct expansion in deviations a,b,c,d,e,f gives

    (a-b-c-d-e)/4
      + f*(a-(b+c+d+e)/2)
      + (f²-b*e-c*d)/2
      + f*(a*f-b*e-c*d).

The four norms are bounded respectively by (5/4)eps, 3eps², (3/2)eps² and 3eps³. The sum is (5/4)eps+(9/2)eps²+3eps³ < 197/10000. These inequalities were checked exactly in the local exploratory arithmetic and are NOT yet a formal Lean proof. Complete them in Lean, prove all 16 adjugate entries via finite index cases or appropriate symmetry, then invoke `four_adjugate_bound_of_entry_bounds`.

## Verification and trust boundary

Actual command, from /Users/tp/Lean/D1Bound5:

    LEAN_NUM_THREADS=1 /Users/tp/.elan/bin/lake env lean exploration/AdjugateFourTrial.lean

Final exit 0. Raw receipt: `local-logs/adjugate-four-trial-final-20261016.log`. Embedded `Lean.collectAxioms` audited the six theorem declarations and reported `ADJUGATE_TRIAL_AXIOM_PASS: 6 theorems`; only propext, Classical.choice, Quot.sound. There are three unused-simp-argument warnings, no proof errors.

Previous attempts 01,02,03,05 exited 1 and were repaired. The first attempt used nonexistent `Matrix.cofactor`, corrected to `Matrix.adjugate_apply` and `Matrix.det_succ_row_zero`. The split proof needed explicit pointwise `change`. One bound required an explicitly typed intermediate multiplication estimate. Attempts 04 and 06 compiled without embedded audit; final pass includes the audit.

The source is under ignored exploration/, NOT root-integrated or installed-leanchecker-replayed. Prior safety guard blocked moving the separate determinant trial, so no claim of accepted root dependency or private remote push is made. Preserve all existing staged and unstaged changes. The frozen manuscript and main theorem are unchanged.

Next: prove the off-diagonal cubic error inequality, all four-by-four index cases, and integrate only through a permitted operation; then run source/root import audit, pinned lake build, transitive axiom audit and installed leanchecker. The separate mixed A>=1,B>=3 branch remains open, as do Bennett's all-orders determinant and finite graph completeness.
