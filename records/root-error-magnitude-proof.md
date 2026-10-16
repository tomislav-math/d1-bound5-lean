# Uniform root-error bounds for determinant estimates

Source: D1Bound5/RootErrorMagnitude.lean.
Target: the entrywise estimates in the proof of lem:product-four,
immediately after the normalization identities (integrated-1), (integrated-2).

Let x,t be complex numbers with t^2=x(x+1). Write e=v-x,
where v is either t or -t. The pre-existing proved elementary
sign-selection lemma gives, for c>=0 and
1<(1-c^2)|x|,

    (1+c)|e|<1.

No analytic complex square-root branch is used. The polynomial identity

    e^2+2xe=x

gives

    e-1/2=-e^2/(2x),

so, with x nonzero,

    (2|x|(1+c)^2)|e-1/2|<1.

All these steps are proved in the generic theorem
exists_root_error_control. They apply even when t is zero,
although the lower modulus bound in fact excludes the troublesome
pair product x=0. Signs are chosen freely and independently for
off-diagonal entries. No nonsingularity of a root matrix is assumed
in these entrywise bounds.

Three numerical consequences are separately proved by the Lean kernel:

  |x|>=3:  |e|<5/9,   |e-1/2|<25/486.
  |x|>=9:  |e|<16/31, |e-1/2|<128/8649.
  |x|>=12: |e|<7/13, |e-1/2|<1/64.

The constants match the entrywise assumptions in the two
lem:product-four determinant arguments. The first bound at 9
is also transported to an arbitrary product u*r*v with
u^2=a, v^2=b and r^2=ab+1.

This unit closes branch selection and the scalar error bounds,
not the spectral-norm estimates, rank-one determinant upper bounds,
lem:product-four, Bennett's arbitrary-order identity, or the main
bound-five theorem. Next prove simultaneous sign selection for the
finite root matrix (preserving every squared entry) and matrix
operator-norm bounds, then combine with the already proved integral
even-dimensional determinant lower bound.

Validation: see records/build-record.md and
records/runs/20261015T2045Z-root-error-FINISH.md for actual statuses.
