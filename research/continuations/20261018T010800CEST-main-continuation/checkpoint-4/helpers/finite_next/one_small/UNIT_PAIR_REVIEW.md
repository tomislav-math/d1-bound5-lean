# Independent review of the unit-pair axis/Pell chain

Read in full on 2026-10-18: `UnitPairAxes.lean`,
`UnitPairPellClassification.lean`, and `FullRingUnitPairPell.lean` in
`unit_pair_next`. This is a mathematical/interface review, not a compilation.

The integral orthogonality reduction is sound. With x=gp, u=gq and a Bezout
identity pA+qB=1, orthogonality gives y=hq, v=-hp for h=By-Av.
The norm equation factors as (p^2+q^2)(g^2-dh^2)=8. Positivity bounds the
first integral factor by 8; the finite square cases force either pq=0 or
p^2=q^2. This correctly yields either a real extension or zero real part.
No unproved Pell classification or root-sign convention enters this step.

In the trace-zero basis, the real case has one real and one imaginary root,
giving u^2-dv^2=2 and z=+/-(dv^2+1). The both-real case forces z=0 and is
explicitly excluded. The imaginary case gives u^2-dv^2=1 and
z=2uv*sqrt(-d). In each alternative v is correctly proved nonzero.

The half-integral branch is included. The axes equations force each root's
second coordinate even: directly in the real case and by parity of the
trace equation in the imaginary case. Thus both roots lift through the
proved injective map sqrt(-d)=2omega-1, and their square equations lift as
well. The resulting imaginary coordinate (-2uv,4uv) is exactly
2uv*(2omega-1).

The full-ring endpoint chooses one fixed positive squarefree parameter and
one fixed integral square root of its negative for the whole field. It
correctly transports all nonzero extensions using that same choice. It does
not restrict the embedding, field, integral basis, root signs, or Pell
solution signs beyond the actual hypotheses. Zero roots are allowed.

Conclusion: mathematical review passes. Compiler/API verification remains
the coordinator's gate; no compiled status is asserted here.
