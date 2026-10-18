# Actual finite P family

These are source-complete drafts pending the root agent's serial Lean compilation.
The main nonexistence theorem is not asserted as proved by this directory.

## Provenance

The frozen manuscript's finite P subsection gives the actual R and T pair rows.
`FinitePMatrix` uses those integer coefficients, expands their constant polynomial
parts, and forms R_ab, H=R_ab+R_bs-R_as, T_ab, V=T_as-T_bs. Its determinant is
proved by Lean ring normalization. The separate exact sparse expansion script
is a source audit, not an accepted proof or an imported certificate.

## Actual arithmetic chain

* `FinitePIntegralRows`: the determinant's last factor cannot vanish. A nonzero
  integral leading factor W has modulus at least one and is dominated by the
  c term under C>=200S. If W=0, the exact quadratic identity excludes the
  remaining factor. Polynomial entries then give an actual integral row with
  modulus at least one, for any fixed signed source-ring root products.
* `FinitePHeight`: after combining H and V, explicit integer monomials lie in
  the height boxes BS^3 and B^3S^2. Coefficient totals are at most
  (492,2424,2352). C>=200 already suffices for the constant2400 after the
  root-error factor101/100. No extra C>=1000 premise is needed.
* `FinitePResidualIdentity`: the actual principal square roots have convergent
  half-binomial expansions. The pair rows cancel through c^-4; the first
  surviving coefficient and the exact tails are displayed. The V leading
  terms15/(32s) cancel before taking absolute values.
* `FinitePLeadingBound`: the four leading absolute coefficient totals are
  at most560/256=35/16 after normalization by S^2/A^3.
* `FinitePMonomial`, `FinitePTailCoefficients`, `FinitePTailBound`: exact
  pair coefficient totals876 and2676, the actual half-binomial coefficient
  bound21/1024 from degree6, and AC>=1000 prove every combined row tail is
  strictly below (1/8)S^2/(A^3 C^5). No tail cancellation is assumed.
* `FinitePResidualBound`: the actual residual is <3S^2/(A^3 C^5).
* `FinitePRowBound`, `FinitePFullRing`: actual tuple square witnesses are
  given one fixed integral sign each, before the nonsingular row is selected.
  The resulting inequality is
  1 < 2400 max(BS^3,B^3S^2) C^3/Z +3S^2 Z/(A^3 C^5).
* `FinitePInterval`: the actual relative square-root error1/4000 excludes
  the closed interval with lower4*2400^2*max(BS^3,B^3S^2)^2*C^5/(1-eps)
  and upperA^6*C^9/(36S^4*(1+eps)).

The exact matrix and integral-row modules are owned by allorder_det, who also
wrote the uniform tail modules. Bennett owns the height, analytic identities,
leading bound, residual assembly and actual full-ring/window joins. Root alone
writes or compiles on the Mac and syncs Git.

## Adaptive refinement (source-complete, awaiting compilation)

`FinitePRatioMonomial` retains the exact A/B power in every leading and
combined-tail monomial. `FinitePAdaptiveLeading` and the two adaptive tail
modules compute the four actual manuscript L_i and W_i polynomials.
`FinitePAdaptiveResidual` proves their domination by the V row on 0<=A/B<=1,
then substitutes A/B<=1/q. Its rate is exactly the printed R(q).
`FiniteRowRootTransferHeight` obtains strictness from the already strict
height bound, so the weak residual estimate is sufficient; no strict tail
estimate is silently assumed. Adaptive row, full-ring and closed-window
modules preserve the actual same source-root signs. The upper endpoint is
A^6 C^9/(4 R(q)^2 S^4(1+eps)).
