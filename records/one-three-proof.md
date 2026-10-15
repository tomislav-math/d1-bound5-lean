# Coordinate-model rationality of common extensions of 1 and 3

Source: rationality part of `lem:pr-one-three` in the frozen v4 manuscript.
Formal source: `D1Bound5/OneThree.lean`. This does not assert the missing
coordinate-to-full-ring equivalence or the lemma's separate cardinality claim.

Let omega^2=tau*omega-nu and Delta=4nu-tau^2>0, with tau,nu integral.
Positive Delta is at least three, since a square modulo four is zero or one.
For any z in this coordinate ring, if r^2=z+1 and s^2=3z+1, then z is an
integer. No nonzero-root or distinct-entry hypothesis is needed for this lemma.

Assume z has nonzero imaginary coordinate. Set

```
e = 2*r.re + tau*r.im,   f = r.im,
g = 2*s.re + tau*s.im,   h = s.im,
k = r.re*s.im - r.im*s.re,
X = 3*e^2-g^2,          V = h^2-3*f^2.
```

The root equations give e*f=z.im, g*h=3*z.im, and thus f and g are nonzero.
Their real and imaginary parts yield the exact integral identities

```
g*h = 3*e*f,
X + Delta*V = 8,
e*h-f*g = 2*k,
g^2*V = 3*f^2*X,
X*V = 12*k^2.
```

Since g^2 and 3*f^2 are positive, X and V have the same sign. Their positive
weighted sum is eight, so both are positive. Their product is therefore
positive, which already implies k^2>=1. A separate argument that a rational
number cannot square to three is unnecessary.

Finally,

```
64 = (X+Delta*V)^2
   >= 4*Delta*X*V
    = 48*Delta*k^2
   >= 144,
```

which is impossible. The Lean proof implements all polynomial identities,
positivity and integer inequalities directly. The only finite computation
in the discriminant lower bound checks the four residues modulo four.
The manuscript itself has not been edited.
