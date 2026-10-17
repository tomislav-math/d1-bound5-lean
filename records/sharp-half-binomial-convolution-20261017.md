# Sharp half-binomial convolution — 17 October 2026

## Proven identity

Let `b(n) = Ring.choose (1/2 : ℝ) n`. For every `n >= 2`, the new `D1Bound5.halfBinomialCoeff_abs_convolution` states

`sum_(i+j=n) abs(b(i)*b(j)) = 4 * abs(b(n))`.

It is a sharp exact identity, not just an upper bound. Its proof uses the previously imported Chu–Vandermonde cancellation `sum_(i+j=n) b(i)*b(j)=0` and the signed positivity of the products with both indices positive. The two endpoint summands are `b(n)` each; the interior sum is therefore `-2*b(n)`. Interior terms have a common sign and their absolute-value sum equals `2*abs(b(n))`. Adding the endpoints yields `4*abs(b(n))`. The proof also provides the three intermediate signed absolute-value and interior-sum lemmas. The base recurrence, sign, coefficient monotonicity and convolution cancellation were proved earlier and are not counted as new here.

## Role in frozen v4

This yields the sharp coefficient envelope at every n>=2 by the triangle inequality for a complex convolution `f_n(x,y) = sum_(i+j=n) b(i)*b(j)*x^i*y^j`: if `norm(x),norm(y) <= t`, then `norm(f_n(x,y)) <= 4*abs(b(n))*t^n`. For n>=m+1 and m>=1, the existing absolute-value monotonicity further gives `4*abs(b(m+1))*t^n`. This COMPLEX weighted consequence has not been formalized in this module and is not asserted as proved in Lean. The analytic identification of the actual square-root interpolation coefficients, the explicit v4 remainder estimate, Bennett's arbitrary-order determinant, certified exhaustive finite descent and final sextuple exclusions are still open. MainStatement is UNPROVED.

## Verification

The isolated repaired Lean trial compiled with exit 0; the originally failed wrong-qualified-name attempt is retained separately. The root source imports only the previously accepted HalfBinomialCoefficients module, and the top-level root imports the new module. Integrated pinned Lake build exited 0 with 3065 jobs. Exact type, transitive-axiom, same-kernel replay, source/import and fingerprint evidence are recorded separately when finished. No independent review or clean checkout is claimed by this record.
