"""Exact rational checks of the proposed higher-order recurrence.

This finite computation is not a proof of the general identity.
Only Python standard-library exact rational arithmetic is used.
"""
from fractions import Fraction as Q
from math import factorial


def prod(xs):
    out = Q(1)
    for x in xs:
        out *= x
    return out


def choose(x, n):
    return prod(x - j for j in range(n)) / factorial(n)


def compositions(total, n):
    if n == 1:
        yield (total,)
    else:
        for j in range(total + 1):
            for rest in compositions(total - j, n - 1):
                yield (j,) + rest


def matrix(a, k, nu, N):
    n = len(a)
    out = []
    for i in range(n):
        row = []
        for j in range(n):
            value = Q(0)
            for h in compositions(k + (i == j) - 1, n):
                term = choose(k + nu, h[j]) * (N + a[j]) ** (k - h[j])
                term *= prod(
                    choose(Q(-k - (i == l)), h[l])
                    * (a[j] - a[l]) ** (-k - (i == l) - h[l])
                    for l in range(n) if l != j
                )
                value += term
            row.append(value)
        out.append(row)
    return out


def determinant(A):
    A = [row[:] for row in A]
    result = Q(1)
    for i in range(len(A)):
        pivot = next((j for j in range(i, len(A)) if A[j][i]), None)
        if pivot is None:
            return Q(0)
        if pivot != i:
            A[i], A[pivot] = A[pivot], A[i]
            result = -result
        result *= A[i][i]
        for j in range(i + 1, len(A)):
            ratio = A[j][i] / A[i][i]
            A[j] = [x - ratio * y for x, y in zip(A[j], A[i])]
    return result


if __name__ == "__main__":
    for n in range(1, 5):
        a = list(map(Q, [0, 2, -3, 7][:n]))
        for k in range(1, 4):
            nu = Q(1, 2)
            expected = prod(choose(nu - v*k, k) for v in range(-1, n-1))
            expected *= prod((ar-al)**(-k) for i, al in enumerate(a)
                             for j, ar in enumerate(a) if i != j)
            for N in map(Q, [0, 1, -1, 5, 13]):
                assert determinant(matrix(a, k, nu, N)) == expected
            if n > 1:
                for q in range(n):
                    kept = [j for j in range(n) if j != q]
                    A = matrix(a, k, nu, -a[q])
                    B = matrix([a[j] for j in kept], k, nu-k, -a[q])
                    for r, i in enumerate(kept):
                        for s, j in enumerate(kept):
                            assert A[i][j] == B[r][s] * (a[j]-a[q])**(-k)
            print(f"n={n}, k={k}: 5 determinant values and every node-removal matrix PASS")
