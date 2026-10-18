# Statement and source review

Scope: direct review in this interactive invocation, using the current Lean sources and actual elaborated types in the two `*-type-axioms.log` files. This is not an independent reviewer or a complete audit of MainStatement.

## Residual majorant

The generic theorem has exactly n+1 nodes in an arbitrary finite nonempty index type. Nodes may repeat or vanish. The real parameter s satisfies s<n; rho is nonnegative and bounds every node norm. The radius condition rho*|x|<1 makes the real-power denominator strictly positive. The public conclusion is summability of the explicitly specified complex series and its norm bound, not an unspecified coefficient-envelope premise.

The displayed complex generalized-binomial coefficient takes the real parameter through its complex embedding. Compatibility with the real binomial coefficient used in the numerical bound is proved through the pinned mathlib cast identity inside the norm calculation. The final source repair preserves every theorem header and performs exponent rewriting before normalizing these casts.

The two-anchor specialization retains k>=1 and exactly 3k+1 nodes. Its exponent is 2k-1/2. These assumptions are explicit; the specialization is not asserted for k=0. No node distinctness or nonzero-node hypothesis was introduced.

## Positive pole majorants

The definition specifies every coefficient by the absolute real negative-binomial coefficient times an inverse power of the pole distance. The norm identity relates these coefficients to the actual imported `bennettPoleSeries`; its internal cast repair forces the entire real coefficient through `Complex.ofReal`.

The analytic sum theorem assumes d>0 and 0<=r<d and includes every natural pole order, including zero. The Cauchy multiplication theorem retains its actual HasSum and nonnegative-coefficient premises. The new finite helper is a polynomial identity valid for every real radius; it merely separates a previous local proof and does not count as a separate original target.

The final coefficient bound retains positive d,e, natural p,q,n and 0<=r<min(d,e). There is no division by r, so r=0 is preserved. All eight original positive-series theorem headers and the definition header are unchanged.

## Verification boundary

All six residual theorems, eight original positive-series theorems, one new finite helper and one definition passed exact-type and enforced transitive-axiom audits. Only propext, Classical.choice and Quot.sound occur. Seven transitive project source modules were hash checked and scanned for prohibited proof shortcuts or research imports. The compiled-source/dependency guards are preserved during the separate kernel checks.

The dedicated kernel receipts, not this review, determine which replay commands completed. The accepted root remains unchanged. Identification of the actual Bennett residues/row coefficients, downstream integral and determinant arguments, complete finite graph/Pell certificates and final sextuple exclusions remain separate obligations. No full cardinality-five theorem, whole-root clean-checkout validation or independent final review is claimed.
