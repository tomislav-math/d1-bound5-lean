# Unit-pair cubic growth and bounded first extension

## Mathematical scope

Frozen v4 targets are Lemma `sm:five-unit-cubic` and the first-extension cutoff in the proof of `sm:bs7-unit-pair` (frozen TeX lines 2567-2629). The manuscript is unchanged. A compiling source is not final acceptance; see actual build/audit/replay receipts separately.

For actual common extensions c,d of {-1,1} in the FULL integer ring of any imaginary quadratic number field, C=|c|>=9, C<=D=|d|, and d!=-c, the target is D>C^3/2. All five square witnesses are supplied by the tuple. The working proof replaces the manuscript's even-binomial estimate with sign selection inside the same ring and exact quadratic cancellation, keeping the original conclusion.

Write w=c+d and z^2=cd+1. Products of the original roots yield square roots of (c+1)(d+1) and (1-c)(1-d). Choose their signs U,V to be close to z. The exact identity is 2z(U+V-2z)=-((U-z)^2+(V-z)^2). If U+V=2z, the two square equations imply UV=z^2 and w^2=0, contrary to d!=-c. Thus L=U+V-2z is a nonzero element of the same integer ring and |L|>=1. The numerical lemma uses Z^2>=CD-1, |w|<=C+D, and the strict first-order margins (15/8)Z|U-z|<|w| and (15/8)Z|V-z|<|w|. It concludes D>C^3/2 without assuming the desired gap.

In an ordered sextuple (-1,1,s,t,c,d), the already proved symmetric-five obstruction excludes opposite pairs among the four large extensions. Consequently three cubic gaps give |d|>|s|^27/8192 when |s|>=9. No strict-modulus ordering or separate sign exclusion is added to the final sextuple hypotheses.

The final target `IsD1Tuple.unit_pair_first_extension_lt` combines that growth with the verified all-positive-order full-ring Bennett inequality and the exact logarithmic cutoff. For a monotone-in-modulus sextuple with first two entries -1,1, it concludes |s|<10000. It contains no analytic-certificate, axis classification, large-entry, or nonzero-root hypotheses. The small |s|<9 branch is handled separately.

## Remaining gap

The cutoff alone does not exclude a sextuple with |s|<10000, does not prove the field-parameter/axis reduction, and does not verify any finite Pell-production certificate or global sextuple exclusion. MainStatement remains UNPROVED. Accepted-root integration and final clean-checkout/independent-statement/kernel gates remain separate.
