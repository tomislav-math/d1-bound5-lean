# Sharp inverse norm and perturbation contraction

Status: source proof compiled in the isolated Lean trial. Integrated-project
compilation, axiom audit and targeted kernel replay have separate receipts.

Let H=(J_4-I_4)/2 and let K be the explicitly verified two-sided inverse,
with K_ii=-4/3 and K_ij=2/3 for i!=j.

Define the real symmetric reflection R by R_ii=1/2 and R_ij=-1/2
for i!=j. Direct four-by-four calculations prove R^H=R and R^2=I.
Consequently ||R||_2^2=||R^H R||_2=||I||_2=1 and ||R||_2=1.

The exact decomposition

    K = -(2/3) I -(4/3) R

gives ||K||_2 <= 2 by the triangle inequality. For the nonzero
matrix Q=I+R, direct multiplication yields K Q=-2 Q. Thus

    2 ||Q||_2=||K Q||_2<=||K||_2 ||Q||_2,

and ||Q||_2>0 proves ||K||_2>=2. Hence ||K||_2=2 exactly.

For any complex four-by-four F with ||F-H||_2<3*(128/8649),

    ||K(F-H)||_2<=2||F-H||_2<768/8649<1.

The latter is the norm-smallness input for a future resolvent/inverse
argument. It does not by itself formalize the inverse of F, any bound
on det F or adj F, nor lem:product-four.

No hypotheses concerning quadratic fields are inserted: these are
complex-matrix statements. The bound on F-H from actual D(1) entries
is a previously compiled theorem under its explicit large pair-product
hypotheses. The remaining weighted A>=1,B>=3 case is separate.

Source: D1Bound5/ReferenceInverseNorm.lean.
Audit source: scripts/ReferenceInverseNormAudit.lean.
Verification receipts are recorded in records/runs and build-record.md.
