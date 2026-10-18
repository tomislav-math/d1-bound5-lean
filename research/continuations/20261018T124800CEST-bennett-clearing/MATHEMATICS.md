# Exact two-anchor Bennett denominator clearing

**Scope:** repaired wave119 source, subsequently compiled as a dedicated module. Its contents are six algebraic theorems over an arbitrary characteristic-zero field. These are proof dependencies for the integral two-anchor Bennett row construction, not the complete arbitrary-order Bennett determinant or the main cardinality bound.

The first theorem is the exact identity `x^u * (x⁻¹)^v = x^t`, for nonzero `x` and a certified exponent relation `u=v+t`. The three following theorems clear the common denominator `(a*b*(a-b)^2)^k` from the three columns of the two-anchor construction, retaining precisely the nonnegative powers in `a`, `b`, `c`, `a*c+1`, `b*c+1`, and `a-b`. The final two theorems restore orientation signs for the zero and first columns. This leaves the integer/polynomial row factors in forms suitable for later ring-integrality arguments.

The integer relations `d0+d1+d2=1` and `h0+h1+h2+1=k+dj` are hypotheses of these monomial identities. They must be proved when instantiating the actual Bennett row, and are not permissible as unproved new hypotheses in the final theorem. The pole variables needed for inverses are explicitly required nonzero. The module contains no global D(1)-tuple assertion or finite case exhaustion.

The accepted proof status depends on the actual pinned build, elaborated type/axiom audit, and installed same-kernel replay receipts, not on this note. The module is not included in the accepted root import closure in this unit. The corrected source is preserved separately from the failed older fingerprint and may be integrated only after its downstream dependencies and complete import graph are checked.
