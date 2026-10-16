import D1Bound5.ProductFourLargeBranch
import D1Bound5.TailIrregular

open scoped NumberField
open Module

namespace D1Bound5

private theorem min_ne_max_fin {n : ℕ} (i j : Fin n) (hij : i ≠ j) :
    min i j ≠ max i j := by
  intro h
  rcases lt_or_gt_of_ne hij with hlt | hgt
  · have he : i = j := by
      simpa [min_eq_left hlt.le, max_eq_right hlt.le] using h
    exact hij he
  · have he : j = i := by
      simpa [min_eq_right hgt.le, max_eq_left hgt.le] using h
    exact hij he.symm

/-- Choose a square root indexed by the unordered pair {i,j}; swapping
indices does not change the chosen root. -/
private noncomputable def tuplePairRoot {R : Type*} [CommRing R] {n : ℕ}
    (t : Fin n → R) (ht : IsD1Tuple t) (i j : Fin n) (hij : i ≠ j) : R :=
  Classical.choose (ht.2.2 (min i j) (max i j) (min_ne_max_fin i j hij))

private theorem tuplePairRoot_sq {R : Type*} [CommRing R] {n : ℕ}
    (t : Fin n → R) (ht : IsD1Tuple t) (i j : Fin n) (hij : i ≠ j) :
    (tuplePairRoot t ht i j hij)^2 = t i * t j + 1 := by
  have hr : (tuplePairRoot t ht i j hij)^2 =
      t (min i j) * t (max i j) + 1 := by
    unfold tuplePairRoot
    simpa only [pow_two] using
      (Classical.choose_spec
        (ht.2.2 (min i j) (max i j) (min_ne_max_fin i j hij)))
  rcases lt_or_gt_of_ne hij with hlt | hgt
  · simpa [min_eq_left hlt.le, max_eq_right hlt.le] using hr
  · simpa [min_eq_right hgt.le, max_eq_left hgt.le, mul_comm] using hr

private theorem tuplePairRoot_symm {R : Type*} [CommRing R] {n : ℕ}
    (t : Fin n → R) (ht : IsD1Tuple t) (i j : Fin n) (hij : i ≠ j) :
    tuplePairRoot t ht i j hij = tuplePairRoot t ht j i (Ne.symm hij) := by
  simp [tuplePairRoot, min_comm, max_comm]

/-- Every indexed D(1)-tuple admits a symmetric root matrix over the same
original commutative ring. The diagonal is the tuple itself. -/
theorem IsD1Tuple.exists_symmetric_root_matrix {R : Type*} [CommRing R]
    {n : ℕ} (t : Fin n → R) (ht : IsD1Tuple t) :
    ∃ M : Matrix (Fin n) (Fin n) R,
      (∀ i, M i i = t i) ∧
      (∀ i j, M i j = M j i) ∧
      (∀ i j, i ≠ j → (M i j)^2 = t i * t j + 1) := by
  classical
  let M : Matrix (Fin n) (Fin n) R :=
    fun i j => if hij : i = j then t i else tuplePairRoot t ht i j hij
  refine ⟨M, ?_, ?_, ?_⟩
  · intro i
    simp [M]
  · intro i j
    by_cases hij : i = j
    · subst j
      rfl
    · have hji : j ≠ i := Ne.symm hij
      simp only [M, dif_neg hij, dif_neg hji]
      exact tuplePairRoot_symm t ht i j hij
  · intro i j hij
    simpa only [M, dif_neg hij] using tuplePairRoot_sq t ht i j hij

/-- The A >= 3 branch of product-four stated for an actual ordered D(1)
quadruple: no auxiliary root-matrix or tail-growth hypothesis remains. -/
theorem IsD1Tuple.productFour_large_growth
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖))
    (hA : 3 ≤ ‖phi (t 0 : K)‖) :
    2 * ‖phi (t 0 : K)‖ * ‖phi (t 1 : K)‖ *
      ‖phi (t 2 : K)‖ < ‖phi (t 3 : K)‖ := by
  obtain ⟨M, hdiag, hsymm, hroot⟩ := ht.exists_symmetric_root_matrix t
  have hB : 3 ≤ ‖phi (t 1 : K)‖ :=
    hA.trans (hmon (by decide : (0 : Fin 4) ≤ 1))
  have htail :=
    (ht.tail_irregular_and_growth hK phi t hmon hB).2
  exact full_ring_productFour_large_growth hK phi t M hdiag hsymm
    hroot hmon hA htail

end D1Bound5
