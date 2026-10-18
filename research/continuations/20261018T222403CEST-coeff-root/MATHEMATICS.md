# Verified coefficient and root-error endpoints

For the actual cleared two-anchor Bennett entries and every integer k>=1, every row i, nonzero complex a,b,c with a!=b, |a|<=|b| and |a||c|>=1000, the checked theorem proves

    |Q[i,1]| < (42 |a|^2 |b| |c|)^k,
    |Q[i,2]| < (42 |b|^3 |c|)^k.

The proof bounds the exact finite cleared Taylor residue through convergent positive polynomial/pole generating functions. At radius 2 min(X,delta)/5, the triangle inequalities, positive denominator bounds and exact rational rounding give a strict base42. No bound on Q itself is an input. Equal moduli for distinct anchors remain allowed.

For a commutative source ring R, a ring map f:R->C and roots r^2=ac+1, v^2=ad+1, z^2=cd+1, assume f(a),f(c),f(z) nonzero, |f(a)||f(c)|>=1000 and 4|f(a)|<=|f(c)|. A checked theorem constructs s=rv or s=-rv in R such that

    |(1+1/(f(a)f(c)))^(1/2) - f(s)/(f(a)f(z))|
      < (3/2)|f(c)|/(|f(a)| |f(z)|^2).

The complex half-power is the same branch used in the constructed interpolation matrix. The sign is chosen once from the actual integral root product, independently of the matrix row and k. The generic statement does not require r or v nonzero. The nonzero z hypothesis must still be derived in the actual tuple application. The full integer ring is an allowed source ring, without unique factorization or a restricted integral basis.

The six modules contain seventeen original public theorems and one original private norm helper. Constants compiled unchanged. Five modules needed proof-body repairs, with all public/private headers unchanged. Failed trials and exact patches are preserved.

These endpoints close neither the weighted combined coefficient bound nor the full analytic residue bound/identification and all-order tuple inequality. The final full-ring height application, exhaustive finite checks/descent, accepted-root integration, fresh full-root verification and MainStatement remain open. The reviews here were performed by the same assistant. Targeted installed-kernel replay is not independent verification.
