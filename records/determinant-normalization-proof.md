# Normalization of integral root matrices

Source: `D1Bound5/DeterminantNormalization.lean`.
Reference: D1_bound5-v4.tex, equations (integrated-1) and
(integrated-2), the beginning of the determinant estimates.

## Polynomial normalization, without localization

Work over any commutative ring R. Let a_i and u_i satisfy u_i^2=a_i,
and let M be a finite square matrix with M_ii=a_i and
M_ij^2=a_i*a_j+1 for distinct i,j.

Define N_ij=u_i*M_ij*u_j and F_ij=N_ij-a_i*a_j. Then

  N = a*a^T + F,       F_ii = 0,
  det(N) = (prod_i a_i)*det(M).

The determinant identity holds without nonzero hypotheses, in all finite
dimensions including dimension zero, by determinant multiplicativity
and the equality N=diag(u) M diag(u).

At each distinct pair i,j, write x=a_i*a_j, t=u_i*M_ij*u_j and
e=t-x. Since t^2=x(x+1),

  e^2+2*x*e = t^2-x^2 = x.

This is the denominator-free version of equation (integrated-2) and
holds even over rings with zero divisors. In the complex case, x!=0
allows division and gives e-1/2=-e^2/(2*x). The proof of the latter
does not select any analytic square-root branch.

## Trust and scope

All seven theorem statements are included in the project root import.
The module uses no sorry, admit, custom axioms or native evaluation.
Source and integrated build receipts and the exact targeted axiom and
kernel verification status are stored in local-logs/det-normalization-20261015T2217-*.
The initial experimental compilation failed on redundant tactics, an
incorrect rewrite orientation and the sign of a linear combination.
These errors were repaired; subsequent direct Lean and target module
builds both returned exit code 0.

This is a genuine prerequisite, not a proof of the spectral-norm
estimates in lem:product-four. The next structural task is to prove the
complex magnitude bounds on the branch-selected F, followed by an upper
bound for det(a*a^T+F), and combine it with the already proved
nonvanishing/lower bound on det(M). Bennett's all-orders identity and the
main bound-five theorem remain open.
