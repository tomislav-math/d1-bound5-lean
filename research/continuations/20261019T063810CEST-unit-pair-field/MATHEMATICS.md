# Unit-pair finite-parameter reduction

## Exact mathematical statement
For any imaginary quadratic number field K, any embedding phi into C, and an actual modulus-ordered D(1) sextuple t in the FULL ring of integers with t(0)=-1 and t(1)=1, there is one UnitPairArithmeticModel M for that same ring such that 7 <= M.d < 10000 and M.d is congruent to 7 modulo 8. The model itself proves positivity, squarefreeness, the integral element w with w*w=-d, conjugation, the negative-integer-square criterion, and the Pell description. None of those data are additional hypotheses of the sextuple theorem.

For each of the four remaining entries z there are integers u,v with v nonzero, u^2-d*v^2=2 and z equal to either d*v^2+1 or its negative. The same d is retained for all four entries and for later negative-square tests.

## Proof and source meaning
The already verified real/imaginary-axis reduction supplies one model and its congruence. The preceding first-extension theorem gives |phi(t(2))|<10000. The proved Pell norm lower bound gives d+1 <= |phi(t(2))|. Their combination yields d<10000; positivity and d mod 8=7 yield d>=7. The source needed only a definitional change to put both norm bounds in the same ring-homomorphism notation before linarith. Original imports and theorem header are unchanged.

This is a finite set of possible FIELD PARAMETERS, not a claim that the number fields are finite fields. The reduction neither verifies all Pell certificates nor excludes all sextuples in the remaining parameter range. The complete main theorem and whole-root verification gates remain open.

## Verification status
Accept the repaired module only after its actual guarded pinned build, exact type/transitive-axiom audit and targeted installed same-kernel replay have passed. Recorded hashes are source integrity evidence, not mathematical proofs. No independent review or clean-checkout build is claimed in this unit.

## Bounded finite-prefix batch

The unchanged PellLightPrefixPilot and original prefix blocks 2 and 3 provide 33 exact checker theorems. Parameters: 151, 159, 167, 183, 191, 199, 215, 223, 231, 239, 247, 255, 263, 271, 287, 295, 303, 311, 319, 327, 335, 359, 367, 383, 391, 399, 407, 415, 431, 439, 447, 455, 4519. Each theorem proves the actual recurrence invariants, the terminal numerator strictly greater than 10^275, and exact equality between its explicit magnitude list and the complete filtered finite recurrence trace. PellLightCFBridge and the existing prefix-completeness theorem give the intended exhaustive meaning; graph matching certificates are a different obligation and were not supplied or assumed here. The existing baseline block 1 was not repeated. No claim of complete finite exclusion or MainStatement follows from this batch alone.
