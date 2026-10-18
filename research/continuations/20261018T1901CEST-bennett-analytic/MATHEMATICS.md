# Bennett analytic majorants — bounded continuation

This unit resumes the reviewed wave119 sources. It does not count the source drafts as proofs. Actual results and failures are recorded separately in the build and check receipts.

## Explicit binomial/homogeneous tail

Let a_i be n+1 complex nodes, allowing repeated or zero nodes. Assume s<n, rho>=0, |a_i|<=rho, and rho|x|<1. With h_t the mathlib complete homogeneous symmetric polynomial, the source proves summability of

F = sum_{t>=0} choose(s,n+t) h_t(a) x^(n+t)

and the bound

|F| <= |choose(s,n)| |x|^n / (1-rho|x|)^(n-s).

The coefficient identity |choose(s,n+t)| choose(n+t,t) = |choose(s,n)| |choose(s-n,t)| cancels the monomial-counting factor in the complete homogeneous bound. The remaining nonnegative series has the exact sum (1-rho|x|)^(-(n-s)), derived from mathlib's analytic binomial theorem. The specialization n=3k, s=k+1/2 for k>=1 yields the exponent 2k-1/2 used in the two-anchor residual estimate.

The prepared source's last proof line failed because broad simplification changed the exponent before the explicit equality was applied. Restricting simplification resolved that exponent but exposed a real-to-complex cast mismatch in the binomial argument. The final repair rewrites the exponent in a separately named consequence first, then simplifies both sides. All theorem statements and assumptions remain unchanged. Failed source versions and compiler diagnostics are retained.

## Positive pole series

For d>0, integer p>=0 and 0<=r<d, the explicitly defined real majorant P(d,p) has coefficient

[P(d,p)]_n = |choose(-p,n)| d^(-(p+n)).

Its weighted sum is (d-r)^(-p); its coefficients are the norms of the corresponding complex pole-series coefficients when d is the pole-displacement norm. Positivity and summable Cauchy multiplication give

[P(d,p) P(e,q)]_n r^n <= (d-r)^(-p) (e-r)^(-q)

for positive d,e, nonnegative integer p,q,n and 0<=r<min(d,e). The p=0 and r=0 boundary cases are retained. These explicit positive envelopes support the local Taylor coefficient estimates in BennettCoefficientMajorant.

## Scope and remaining proof obligation

These are exact analytic building blocks, not an assumption that an arbitrary series is a Bennett residual. The algebraic moment/residue identification, integral row construction, determinant nonvanishing and final tuple exclusions must be discharged by their own accepted dependencies. The full-ring cardinality-five theorem remains UNPROVED. Targeted checks do not constitute an independent final review or a clean-checkout build. The current accepted root is not changed by this working-dependency verification unit.
