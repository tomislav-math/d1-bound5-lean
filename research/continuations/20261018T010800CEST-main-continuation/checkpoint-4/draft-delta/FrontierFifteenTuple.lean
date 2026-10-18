import D1Bound5.FrontierFifteenNumeric

open scoped NumberField Matrix.Norms.L2Operator BigOperators
open Matrix Module

namespace D1Bound5

/-- The sharpened fourth-entry gap used for the S>=15 one-small
branch. It holds for every actual ordered quadruple with A<3, B>=3
and S>=15, without a first-pair table or a determinant certificate. -/
theorem IsD1Tuple.frontier_fifteen_growth
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 4 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hA3 : ‖phi (a 0 : K)‖ < 3) (hB : 3 ≤ ‖phi (a 1 : K)‖)
    (hC : 15 ≤ ‖phi (a 2 : K)‖) :
    (59/20 : ℝ)*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖ <
      ‖phi (a 3 : K)‖ := by
  classical
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let w : Fin 4 → ℂ := fun i => f (a i)
  have hA1 : 1 ≤ ‖w 0‖ := one_le_norm_integer hK phi (ha.2.1 0)
  have htail : 2*‖w 1‖*‖w 2‖ < ‖w 3‖ :=
    (ha.tail_irregular_and_growth hK phi a hmon hB).2
  have hBC : 45 ≤ ‖w 1‖*‖w 2‖ := by
    calc
      45 = (3 : ℝ)*15 := by norm_num
      _ ≤ ‖w 1‖*‖w 2‖ := by gcongr
  have hD90 : 90 ≤ ‖w 3‖ := by linarith only [htail,hBC]
  let m : Fin 4 → ℝ := ![1,3,15,90]
  have hm (i : Fin 4) : m i ≤ ‖w i‖ := by
    fin_cases i
    · exact hA1
    · exact hB
    · exact hC
    · exact hD90
  have hm0 (i : Fin 4) : 0 ≤ m i := by fin_cases i <;> norm_num [m]
  have hlarge (i j : Fin 4) (_ : i ≠ j) :
      frontierFifteenMin i j ≤ ‖f (a i)*f (a j)‖ := by
    have hmin : frontierFifteenMin i j ≤ m i*m j := by
      fin_cases i <;> fin_cases j <;> norm_num [frontierFifteenMin,m]
    rw [norm_mul]
    exact hmin.trans (mul_le_mul (hm i) (hm j) (hm0 j) (norm_nonneg _))
  have hex (i : Fin 4) : ∃ z : ℂ, z^2 = f (a i) :=
    IsAlgClosed.exists_pow_nat_eq (f (a i)) (by decide : 0 < 2)
  choose u hu using hex
  have hr (i j : Fin 4) (hij : i ≠ j) : ∃ r : 𝓞 K, r^2 = a i*a j+1 := by
    obtain ⟨r,hh⟩ := ha.2.2 i j hij
    exact ⟨r,by simpa only [pow_two] using hh⟩
  obtain ⟨S,hd,hs,hsq,he⟩ := exists_frontier_fifteen_root_matrix f a u hu hr hlarge
  let F := normalizedRootError w u (S.map f)
  have hzero (i : Fin 4) : F i i = 0 :=
    normalizedRootError_diag w u (S.map f) hu (fun j => congrArg f (hd j)) i
  have hsym (i j : Fin 4) : F i j = F j i := by
    change u i*f (S i j)*u j-f (a i)*f (a j) =
      u j*f (S j i)*u i-f (a j)*f (a i)
    rw [hs i j]
    ring
  have herr (i j : Fin 4) (hij : i ≠ j) :
      ‖F i j-(1/2 : ℂ)‖ ≤ frontierFifteenK i j-1/2 := he i j hij
  obtain ⟨hdet,hG⟩ := frontier_fifteen_matrix_bounds F hzero hsym herr
  have hEzero (i : Fin 4) : (F-halfOffDiagonal) i i = 0 := by
    simp [Matrix.sub_apply,halfOffDiagonal,hzero]
  have hEoff (i j : Fin 4) (hij : i ≠ j) :
      ‖(F-halfOffDiagonal) i j‖ < (1/18 : ℝ) := by
    have hbound : frontierFifteenK i j-1/2 < (1/18 : ℝ) := by
      fin_cases i <;> fin_cases j <;> norm_num [frontierFifteenK]
    simp only [Matrix.sub_apply,halfOffDiagonal,if_neg hij]
    exact (herr i j hij).trans_lt hbound
  have hE := four_zero_diagonal_operator_norm_lt (F-halfOffDiagonal) (1/18)
    (by norm_num) hEzero hEoff
  have hF : F.det ≠ 0 := by
    apply reference_perturbed_det_ne_zero F
    have hh := Matrix.l2_opNorm_mul halfOffDiagonalInverse (F-halfOffDiagonal)
    rw [halfOffDiagonalInverse_norm] at hh
    linarith only [hh,hE]
  have hupper := frontier_fifteen_rankOne_upper F w hF hdet hG
  have hmatrix : F+Matrix.vecMulVec w w = scaledRootMatrix u (S.map f) := by
    ext i j
    simp only [Matrix.add_apply,Matrix.vecMulVec_apply,
      F,w,normalizedRootError,scaledRootMatrix,Matrix.map_apply]
    ring
  have hlower := full_ring_scaledRootMatrix_det_norm_lower hK phi
    (by decide : Even (Fintype.card (Fin 4))) a S hd hsq u hu
  have hlower' : ‖w 0‖*‖w 1‖*‖w 2‖*‖w 3‖ ≤ ‖(F+Matrix.vecMulVec w w).det‖ := by
    rw [hmatrix]
    convert hlower using 1
    simp [w,f,Fin.prod_univ_four]
  exact frontier_fifteen_numeric ‖w 0‖ ‖w 1‖ ‖w 2‖ ‖w 3‖
    hA1 hA3 hB hC htail (hlower'.trans hupper)

end D1Bound5
