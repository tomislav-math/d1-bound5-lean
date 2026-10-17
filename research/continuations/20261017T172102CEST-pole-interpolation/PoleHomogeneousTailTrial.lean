import D1Bound5.InterpolationWeights
import D1Bound5.WeightedPoleFiniteTail

open Finset

namespace D1Bound5

/-- A finite generating-function identity for reciprocal Lagrange weights.
The Taylor polynomial is expressed by complete homogeneous symmetric
polynomials, with an exact rational remainder at every finite order. -/
theorem reciprocal_pole_hsymm_finite_tail
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (hs : s.Nonempty) (hinj : Set.InjOn a s)
    (ha : ∀ i ∈ s, a i ≠ 0) (z : F)
    (haz : ∀ i ∈ s, a i ≠ z) (n : ℕ) :
    (∑ i ∈ s, (∏ j ∈ s.erase i, (a i - a j))⁻¹ / (a i - z)) =
      (∑ k ∈ Finset.range n,
        z ^ k * (((-1 : F) ^ (s.card - 1) * (∏ i ∈ s, a i)⁻¹) *
          MvPolynomial.aeval (fun i : s => (a i)⁻¹)
            (MvPolynomial.hsymm s F k))) +
      z ^ n * (∑ i ∈ s,
        (∏ j ∈ s.erase i, (a i - a j))⁻¹ /
          ((a i) ^ n * (a i - z))) := by
  let w : ι → F := fun i => (∏ j ∈ s.erase i, (a i - a j))⁻¹
  have hcoeff (k : ℕ) :
      (∑ i ∈ s, w i / (a i) ^ (k + 1)) =
        ((-1 : F) ^ (s.card - 1) * (∏ i ∈ s, a i)⁻¹) *
          MvPolynomial.aeval (fun i : s => (a i)⁻¹)
            (MvPolynomial.hsymm s F k) := by
    have hterms :
        (∑ i ∈ s, w i / (a i) ^ (k + 1)) =
        (∑ i ∈ s,
          ((a i)⁻¹) ^ (k + 1) /
            (∏ j ∈ s.erase i, (a i - a j))) := by
      apply Finset.sum_congr rfl
      intro i hi
      simp only [w, div_eq_mul_inv, inv_pow]
      ring
    rw [hterms]
    exact reciprocal_anchor_sum_eq_hsymm s a hs ha hinj k
  calc
    (∑ i ∈ s, (∏ j ∈ s.erase i, (a i - a j))⁻¹ / (a i - z)) =
      (∑ k ∈ Finset.range n,
        z ^ k * (∑ i ∈ s, w i / (a i) ^ (k + 1))) +
      z ^ n * (∑ i ∈ s, w i / ((a i) ^ n * (a i - z))) := by
        exact weighted_poles_finite_tail s a w z ha haz n
    _ = _ := by
      simp_rw [hcoeff]
      rfl

end D1Bound5

#check @D1Bound5.reciprocal_pole_hsymm_finite_tail
#print axioms D1Bound5.reciprocal_pole_hsymm_finite_tail
