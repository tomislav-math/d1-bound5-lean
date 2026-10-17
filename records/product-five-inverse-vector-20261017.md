# Product-five inverse last-column estimate

## Proved conditional analytic statement

For any complex 4x4 matrix F and vector v indexed by Fin 4, let H be the reference zero-diagonal matrix with all other entries 1/2. If its L2 operator norm satisfies `||F-H|| <= 11/96` and the Euclidean vector norm satisfies `||v-(1/2,1/2,1/2,1/2)||_2 < 1/200`, then `||F^-1 v||_2 < 11/12`. No symmetry or invertibility is an additional theorem hypothesis; invertibility is derived from the proximity.

Set z=(1/2,1/2,1/2,1/2), y=(1/3,1/3,1/3,1/3). Directly H y=z and `||y||_2=2/3`. The preexisting reference perturbation theorem gives `||F^-1|| < 8/3` since `11/96 < 1/8`, and its contraction proof yields det F nonzero. Then

`F^-1 v-y = F^-1 ((v-z)-(F-H)y)`.

Consequently

`||F^-1 v||_2 < 2/3 + (8/3)*(1/200 + (11/96)*(2/3)) = 1193/1350 < 11/12`.

Lean source: `D1Bound5/ProductFiveInverseVector.lean`, byte-identical to initial successful separate trial `exploration/FiveInverseVectorTrial.lean` at integration. The publicly exported theorem is `productFive_inverse_vector_bound`; private lemmas prove H y=z and the exact Euclidean norm of y. No arbitrary-ring or tuple statement is claimed for this conditional estimate. To apply it to the actual quintuple, use the one-witness `ProductFiveCompatibleSigns` prefix and last-column bounds to derive its two inputs.

## Verification status

Isolated proof trial05: `LEAN_NUM_THREADS=1 lake env lean exploration/FiveInverseVectorTrial.lean`, EXIT 0. Failed trials01/03/04 and repaired errors are preserved in local-logs. Root compile/axiom audit/targeted replay/source audit are recorded separately when completed; do not infer their success from the isolated trial.

The entire product-five lemma, arbitrary-order Bennett identity, finite checker coverage/descent and global bound-five statement remain OPEN. No independent mathematical reviewer or fresh clean-checkout verification was run for this unit.
