# Actual P determinant and integral-row certificate

`FinitePIntegralRows.lean` is a research continuation draft awaiting the parent's serial Lean compiler gate.

The displayed divided matrix has determinant

-78750 a b s (a-b)^5 (a-s)(b-s) [7t+6cW],

where t=2s-a-b and W=3s²-(a+b)s-ab. `verify_determinant.py` independently expands the full4x4 matrix over exact integer polynomials and verifies the identity (52 surviving monomials). This check is not a substitute for the queued Lean determinant proof.

Actual full-ring nonvanishing uses two cases:

* W=0: a vanishing bracket gives t=0, and the exact identity (a-b)²=4W-(6s+a+b)t contradicts a≠b.
* W≠0: W is an algebraic integer in the given imaginary quadratic field, so its complex modulus is at least1. The bracket equation gives6C|W|=7|t|≤28S, contradicting C≥200S and s≠0.

The endpoint `full_ring_finitePRowForm_exists_one_le_norm` accepts actual ring integers a,b,s,c,z,rA,rB,rS, anchor nonzero/distinctness, terminal-root nonzero, ordered moduli A≤B≤S, and C≥200S. It proves existence of a concrete row with norm≥1. No separate nonsingularity, integrality, or approximation certificate is assumed.

`FinitePMonomial.lean` is the common elementary scalar estimate for the residual terms:

U^d V^e/U^n ≤ S²/A^q,

provided1≤A≤U,V≤S, e≤2, and d+e+q≤n+2. The leading and tail bounds use q=3 andq=4 respectively.

Bennett owns the remaining P height/residual/root-transfer/closed-window construction. Allorder_det owns this integral-row module and the existing determinant proof's compiler repairs.
