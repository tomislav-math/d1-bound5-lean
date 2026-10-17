import D1Bound5.BennettFirstOrder

open Finset Polynomial Matrix

namespace D1Bound5

section Field

variable {F : Type*} [Field F] {n : ℕ}

theorem eval_derivative_basisDivisor (x y z : F) :
    (Lagrange.basisDivisor x y).derivative.eval z = (x - y)⁻¹ := by
  simp [Lagrange.basisDivisor, Polynomial.derivative_C_mul]

/-- The diagonal entry is the logarithmic derivative of the nodal product
with its vanishing factor omitted. -/
theorem lagrangeDifferentiation_diagonal (a : Fin n → F)
    (ha : Function.Injective a) (i : Fin n) :
    lagrangeDifferentiation a i i =
      ∑ j ∈ Finset.univ.erase i, (a i - a j)⁻¹ := by
  classical
  unfold lagrangeDifferentiation Lagrange.basis
  rw [Polynomial.derivative_prod_finset, Polynomial.eval_finsetSum]
  apply Finset.sum_congr rfl
  intro j hj
  rw [Polynomial.eval_mul, Polynomial.eval_prod, eval_derivative_basisDivisor]
  have hp : (∏ l ∈ (Finset.univ.erase i).erase j,
      (Lagrange.basisDivisor (a i) (a l)).eval (a i)) = 1 := by
    apply Finset.prod_eq_one
    intro l hl
    apply Lagrange.eval_basisDivisor_left_of_ne
    exact fun h => (Finset.mem_erase.mp (Finset.mem_erase.mp hl).2).1 (ha h).symm
  rw [hp, one_mul]

theorem lagrange_basis_eq_weight_mul_nodal_erase (a : Fin n → F) (j : Fin n) :
    Lagrange.basis Finset.univ a j =
      C (Lagrange.nodalWeight Finset.univ a j) *
        Lagrange.nodal (Finset.univ.erase j) a := by
  classical
  simp only [Lagrange.basis, Lagrange.basisDivisor, Lagrange.nodalWeight,
    Lagrange.nodal, Finset.prod_mul_distrib, map_prod]

/-- The off-diagonal derivative identity in the normalization appearing
in Bennett's residue matrix. -/
theorem nodalWeight_mul_lagrangeDifferentiation_offDiagonal
    (a : Fin n → F) (ha : Function.Injective a) (i j : Fin n) (hij : i ≠ j) :
    Lagrange.nodalWeight Finset.univ a i * lagrangeDifferentiation a i j =
      Lagrange.nodalWeight Finset.univ a j / (a i - a j) := by
  classical
  have hi : i ∈ Finset.univ.erase j := by simp [hij]
  have hj : j ∈ Finset.univ.erase i := by simp [Ne.symm hij]
  have hdiff : a i - a j ≠ 0 := sub_ne_zero.mpr (fun h => hij (ha h))
  have hprod : (∏ l ∈ Finset.univ.erase i, (a i - a l)) ≠ 0 := by
    apply Finset.prod_ne_zero_iff.mpr
    intro l hl
    apply sub_ne_zero.mpr
    exact fun h => (Finset.mem_erase.mp hl).1 (ha h).symm
  have hweight : Lagrange.nodalWeight Finset.univ a i *
      ((a i - a j) * ∏ l ∈ (Finset.univ.erase i).erase j, (a i - a l)) = 1 := by
    rw [Finset.mul_prod_erase (Finset.univ.erase i) (fun l => a i - a l) hj,
      Lagrange.nodalWeight,
      Finset.prod_inv_distrib]
    exact inv_mul_cancel₀ hprod
  have hcancel : Lagrange.nodalWeight Finset.univ a i *
      (∏ l ∈ (Finset.univ.erase i).erase j, (a i - a l)) = (a i - a j)⁻¹ := by
    apply mul_right_cancel₀ hdiff
    calc
      (Lagrange.nodalWeight Finset.univ a i *
          (∏ l ∈ (Finset.univ.erase i).erase j, (a i - a l))) * (a i - a j) =
        Lagrange.nodalWeight Finset.univ a i *
          ((a i - a j) * ∏ l ∈ (Finset.univ.erase i).erase j, (a i - a l)) := by ring
      _ = 1 := hweight
      _ = (a i - a j)⁻¹ * (a i - a j) := (inv_mul_cancel₀ hdiff).symm
  unfold lagrangeDifferentiation
  rw [lagrange_basis_eq_weight_mul_nodal_erase,
    Polynomial.derivative_C_mul, Polynomial.eval_mul, Polynomial.eval_C,
    Lagrange.eval_nodal_derivative_eval_node_eq hi, Lagrange.eval_nodal]
  rw [Finset.erase_right_comm]
  calc
    _ = Lagrange.nodalWeight Finset.univ a j *
        (Lagrange.nodalWeight Finset.univ a i *
          ∏ l ∈ (Finset.univ.erase i).erase j, (a i - a l)) := by ring
    _ = _ := by rw [hcancel, div_eq_mul_inv]

/-- The explicit k=1 residue matrix, including both diagonal derivatives
and the simple off-diagonal reciprocal-difference expression. -/
noncomputable def bennettFirstOrderExplicit (a : Fin n → F) (N t : F) :
    Matrix (Fin n) (Fin n) F := fun i j =>
  if i = j then
    N⁻¹ * Lagrange.nodalWeight Finset.univ a i *
      (t - (N + a i) * ∑ l ∈ Finset.univ.erase i, (a i - a l)⁻¹)
  else
    N⁻¹ * (N + a j) * Lagrange.nodalWeight Finset.univ a j / (a j - a i)

theorem bennettFirstOrderResidue_eq_explicit (a : Fin n → F)
    (ha : Function.Injective a) (N t : F) :
    bennettFirstOrderResidue a N t = bennettFirstOrderExplicit a N t := by
  classical
  ext i j
  simp only [bennettFirstOrderResidue, Matrix.diagonal_mul, Matrix.mul_diagonal,
    Matrix.sub_apply, Matrix.scalar_apply, Matrix.diagonal_apply,
    bennettFirstOrderExplicit]
  split_ifs with hij
  · subst j
    rw [lagrangeDifferentiation_diagonal a ha]
    ring
  · have h := nodalWeight_mul_lagrangeDifferentiation_offDiagonal a ha i j hij
    have hs : a j - a i = -(a i - a j) := by ring
    rw [hs, div_neg]
    calc
      _ = -(N⁻¹ * (N + a j) *
        (Lagrange.nodalWeight Finset.univ a i * lagrangeDifferentiation a i j)) := by ring
      _ = _ := by rw [h]; ring

/-- Arbitrary-size k=1 Bennett determinant for the explicit residue entries. -/
theorem bennettFirstOrderExplicit_det (a : Fin n → F)
    (ha : Function.Injective a) (N t : F) :
    (bennettFirstOrderExplicit a N t).det =
      (N⁻¹) ^ n * (∏ i : Fin n, Lagrange.nodalWeight Finset.univ a i) *
        ∏ j : Fin n, (t - (j.val : F)) := by
  rw [← bennettFirstOrderResidue_eq_explicit a ha]
  exact bennettFirstOrderResidue_det a ha N t

/-- At the manuscript parameter `t=3/2`, no diagonal spectral factor can
vanish in characteristic zero. -/
theorem three_halves_sub_natCast_ne_zero [CharZero F] (j : ℕ) :
    (3 / 2 : F) - (j : F) ≠ 0 := by
  intro h
  have htwo : (2 : F) ≠ 0 := by norm_num
  have heq : (3 : F) = (j : F) * 2 :=
    (div_eq_iff htwo).mp (sub_eq_zero.mp h)
  have hi : (3 : ℤ) = (j : ℤ) * 2 := by exact_mod_cast heq
  omega

/-- Genuine nonvanishing of the explicit arbitrary-size k=1 residue matrix
at the square-root parameter. -/
theorem bennettFirstOrderExplicit_det_ne_zero [CharZero F]
    (a : Fin n → F) (ha : Function.Injective a) (N : F) (hN : N ≠ 0) :
    (bennettFirstOrderExplicit a N (3 / 2)).det ≠ 0 := by
  rw [bennettFirstOrderExplicit_det a ha]
  apply mul_ne_zero
  · apply mul_ne_zero
    · exact pow_ne_zero n (inv_ne_zero hN)
    · apply Finset.prod_ne_zero_iff.mpr
      intro i _
      exact Lagrange.nodalWeight_ne_zero ha.injOn (Finset.mem_univ i)
  · apply Finset.prod_ne_zero_iff.mpr
    intro j _
    exact three_halves_sub_natCast_ne_zero j.val

end Field

end D1Bound5
