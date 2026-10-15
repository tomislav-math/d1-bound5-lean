# Formal irregular-triple growth lemma

The continuation proves the complete manuscript lemma `lem:irregular-growth`
in the full ring of integers of every imaginary quadratic field, not merely
an algebraic identity or a conditional implication from an unproved norm bound.
The original, more precise `eq:irregular-quadratic` is also proved because
the finite-complement argument uses it later.

For the chosen integral roots r^2=ab+1, s^2=ac+1, t^2=bc+1 let
u=a+b+c+2abc+2rst and v=a+b+c+2abc-2rst. The already proved product
identity and irregularity make u,v nonzero. The newly proved full-ring
norm result supplies |u|,|v|>=1. Therefore
|u|+|v| <= |uv|+1. Together with the sum identity and triangle inequalities
this gives exactly

0 <= C^2 - 2 (|1+2ab|-|a+b|) C + |(a-b)^2-4| + 2|a+b|+1.

The elementary bounds |a+b|<=A+B, |1+2ab|>=2AB-1 and
|(a-b)^2-4|<=(A+B)^2+4 give q(C)>=0 for
q(X)=(A+B+X+1)^2+4-4ABX.

For 3<=A<=B, the following integer-scaled inequalities prove negativity
of the two endpoints without division or analytic convexity imports:

3(A+2B+1)<=10B; 9(A+B+1)<=7AB; 9<=B^2; 81<=(AB)^2;
9(A+B+2AB+1)<=25AB.

They imply q(B)<0 and q(2AB)<0. The separately proved exact identity

(u-l)f(x)=(u-x)f(l)+(x-l)f(u)-(u-l)(x-l)(u-x)

for a monic quadratic f shows strict negativity on the whole closed
interval [l,u] if both endpoints are negative. Endpoint equality and
modulus ties are explicitly handled. Hence C cannot belong to [B,2AB].

The Lean declaration `irregular_growth` quantifies over K, its full
RingOfIntegers, any complex embedding, all six integral elements a,b,c,r,s,t,
the three exact square equations, irregularity, and 3<=A<=B<=C. Its
conclusion is the strict inequality 2AB<C. There are no additional
approximation, classification, computation, or coordinate assumptions.

The proof uses `one_le_norm_integer` through the now proved full-ring
bridge. Zero is permitted among the square-root values. No real ordering
of the tuple entries is assumed, only weak ordering of their moduli.

Source: D1Bound5/IrregularGrowth.lean. The initial standalone compile
returned exit 0; its stdout/stderr log was empty. The integrated build
and full axiom/kernel audit are recorded in the continuation check log.
This is a same-assistant reconstruction and back-translation, not an
independent external review. The main bound-five theorem remains unproved.
