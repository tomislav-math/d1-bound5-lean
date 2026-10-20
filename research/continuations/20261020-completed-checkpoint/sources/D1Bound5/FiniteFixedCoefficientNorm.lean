import D1Bound5.FinitePolynomialHeight
import D1Bound5.SmallExtensionSymmetry

namespace D1Bound5
open QuadInt

/-- Homogeneous coefficient evaluation commutes with ring maps. -/
theorem finiteFixedHomogeneous_map {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (n : ℕ) (v : Fin (n+1) → ℤ) (x y : R) :
    f (finiteHomogeneousTwo n v x y) = finiteHomogeneousTwo n v (f x) (f y) := by
  simp [finiteHomogeneousTwo]

/-- Simultaneous negation changes a homogeneous polynomial only by its
degree sign, so the evaluated coefficient norm is preserved. -/
theorem finiteFixedHomogeneous_neg {R : Type*} [CommRing R]
    (n : ℕ) (v : Fin (n+1) → ℤ) (x y : R) :
    finiteHomogeneousTwo n v (-x) (-y) = (-1)^n*finiteHomogeneousTwo n v x y := by
  unfold finiteHomogeneousTwo
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  have hj : (j : ℕ) ≤ n := by omega
  have hsum : (j : ℕ)+(n-(j : ℕ)) = n := by omega
  rw [neg_pow x (j : ℕ), neg_pow y (n-(j : ℕ))]
  calc
    _ = ((-1 : R)^(j : ℕ)*(-1)^(n-(j : ℕ)))*
        ((v j : R)*x^(j : ℕ)*y^(n-(j : ℕ))) := by ring
    _ = _ := by rw [←pow_add,hsum]

theorem finiteFixedHomogeneous_star {tau nu : ℤ}
    (n : ℕ) (v : Fin (n+1) → ℤ) (x y : QuadInt tau nu) :
    finiteHomogeneousTwo n v (star x) (star y) =
      star (finiteHomogeneousTwo n v x y) := by
  simp [finiteHomogeneousTwo,mul_comm,mul_left_comm,mul_assoc]


end D1Bound5
