# Coefficient majorants for the Bennett local expansion

This recovery verifies the existing wave119 coefficient-majorant unit. The new change is a one-line Lean proof repair, not a new mathematical theorem or a weakened statement.

The principal coefficient comparison is abs(choose(k+1/2,h)) <= choose(k+1,h) for h<=k. Positivity and monotonicity of the falling factorial prove it after multiplying by h!. The failed elaboration left explicit lambda applications around the evaluation map; `dsimp only at hmono` beta-reduces them before the existing rewriting step.

The remaining public lemmas transfer coefficient norm bounds through the Cauchy product, identify the coefficients and nonnegativity of the explicit numerator majorant U^(-1)*(U+X)^(k+1), evaluate its finite generating series, and bound the evaluated complex cleared Taylor expression by that positive majorant. The final coefficient bound retains its explicit hypothesis on the other pole series and the nonzero norm U=norm(N+a). Those hypotheses still have to be supplied in the actual later Bennett row construction.

There are six public theorems, one public definition and one private helper. Separate verification is not root integration, independent review or the main cardinality theorem. MainStatement remains UNPROVED.
