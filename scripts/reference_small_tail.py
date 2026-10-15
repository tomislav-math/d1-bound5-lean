#!/usr/bin/env python3
"""Independent integer-arithmetic reference for the small-tail case.

This generates finite counts only. Mathematical completeness and negative
results still require the separate Lean disk/square-test soundness proofs and
kernel-checked finite certificate evaluation. It never edits frozen evidence.
"""
from math import isqrt

FIELDS = (1, 2, 3, 5, 6, 7, 10, 11, 13, 14, 15, 19, 23,
          31, 35, 39, 43, 47, 51, 55, 59)

def parameters(d):
    return (1, (d + 1) // 4) if d % 4 == 3 else (0, d)

def norm(z, tau, nu):
    a, b = z
    return a * a + tau * a * b + nu * b * b

def multiply(z, w, tau, nu):
    a, b = z
    c, d = w
    return (a * c - nu * b * d, a * d + b * c + tau * b * d)

def add(z, w):
    return (z[0] + w[0], z[1] + w[1])

def disk(d, bound):
    tau, nu = parameters(d)
    delta = 4 * nu - tau * tau
    out = []
    for y in range(-isqrt(4 * bound // delta), isqrt(4 * bound // delta) + 1):
        r = isqrt(4 * bound - delta * y * y)
        for e in range(-r, r + 1):
            if (e - tau * y) % 2 == 0:
                z = ((e - tau * y) // 2, y)
                assert norm(z, tau, nu) <= bound
                out.append(z)
    return out

def check_field(d):
    tau, nu = parameters(d)
    # For all tested entries, a root has norm <= 70; zero is included.
    squares = {multiply(r, r, tau, nu) for r in disk(d, 70)}
    candidates = disk(d, 15)
    large = sorted((x for x in candidates if 9 <= norm(x, tau, nu)),
                   key=lambda x: (norm(x, tau, nu), x))
    pairs = triples = preliminary = failures = 0
    for i, b in enumerate(large):
        for c in large[i + 1:]:
            bc = add(multiply(b, c, tau, nu), (1, 0))
            if bc not in squares:
                continue
            pairs += 1
            roots = {r for r in disk(d, 16) if multiply(r, r, tau, nu) == bc}
            assert roots
            r = min(roots)
            for sign in (-1, 1):
                dentry = add(add(b, c), (2 * sign * r[0], 2 * sign * r[1]))
                if dentry in ((0, 0), b, c) or norm(dentry, tau, nu) < norm(c, tau, nu):
                    continue
                triples += 1
                for a in candidates:
                    if a in ((0, 0), b, c, dentry) or norm(a, tau, nu) > norm(b, tau, nu):
                        continue
                    if add(multiply(a, b, tau, nu), (1, 0)) not in squares:
                        continue
                    if add(multiply(a, c, tau, nu), (1, 0)) not in squares:
                        continue
                    preliminary += 1
                    if add(multiply(a, dentry, tau, nu), (1, 0)) in squares:
                        failures += 1
    return (d, pairs, triples, preliminary, failures)

if __name__ == "__main__":
    rows = [check_field(d) for d in FIELDS]
    totals = tuple(sum(row[j] for row in rows) for j in range(1, 5))
    assert totals == (90, 118, 16, 0), totals
    for row in rows:
        print(*row)
    print("COUNTS_PASS", totals)
