import D1Bound5.FrontierFifteenCofactors
import D1Bound5.FrontierMixedDeterminant

open scoped Matrix.Norms.L2Operator BigOperators
open Matrix

namespace D1Bound5

theorem frontier_fifteen_numeric (A B C D : ℝ)
    (hA1 : 1 ≤ A) (hA3 : A < 3) (hB : 3 ≤ B) (hC : 15 ≤ C)
    (hD : 2*B*C < D)
    (hupper : A*B*C*D ≤
      (252/1000 : ℝ)*A^2+(256/1000)*B^2+(277/1000)*C^2+(282/1000)*D^2+
      (284/1000)*A*B+(284/1000)*A*C+(288/1000)*A*D+
      (286/1000)*B*C+(296/1000)*B*D+(362/1000)*C*D+1) :
    (59/20 : ℝ)*A*B*C < D := by
  have hA0 : 0 < A := by linarith only [hA1]
  have hB0 : 0 < B := by linarith only [hB]
  have hC0 : 0 < C := by linarith only [hC]
  have hBC : 45 ≤ B*C := by
    calc 45 = (3 : ℝ)*15 := by norm_num
         _ ≤ B*C := by gcongr
  have hD90 : 90 ≤ D := by linarith only [hD,hBC]
  have hD0 : 0 < D := by linarith only [hD90]
  let P := A*B*C*D
  have hP : 0 < P := by dsimp [P]; positivity
  have hbase : 4050 ≤ P := by
    calc 4050 = (1 : ℝ)*3*15*90 := by norm_num
         _ ≤ P := by dsimp [P]; gcongr
  have hcomp (X Y m : ℝ) (hX : 0 ≤ X) (hm : 0 < m) (hY : m ≤ Y)
      (hXY : P = X*Y) : X ≤ P/m := by
    apply (le_div_iff₀ hm).mpr
    rw [hXY]
    nlinarith only [mul_nonneg hX (sub_nonneg.mpr hY)]
  have hAB : A*B ≤ P/1350 := hcomp (A*B) (C*D) 1350 (by positivity) (by norm_num)
    (by
      calc
        1350 = (15 : ℝ)*90 := by norm_num
        _ ≤ C*D := by gcongr)
    (by dsimp [P]; ring)
  have hAC : A*C ≤ P/270 := hcomp (A*C) (B*D) 270 (by positivity) (by norm_num)
    (by
      calc
        270 = (3 : ℝ)*90 := by norm_num
        _ ≤ B*D := by gcongr)
    (by dsimp [P]; ring)
  have hAD : A*D ≤ P/45 := hcomp (A*D) (B*C) 45 (by positivity) (by norm_num) hBC
    (by dsimp [P]; ring)
  have hBC' : B*C ≤ P/90 := hcomp (B*C) (A*D) 90 (by positivity) (by norm_num)
    (by
      calc
        90 = (1 : ℝ)*90 := by norm_num
        _ ≤ A*D := by gcongr)
    (by dsimp [P]; ring)
  have hBD : B*D ≤ P/15 := hcomp (B*D) (A*C) 15 (by positivity) (by norm_num)
    (by
      calc
        15 = (1 : ℝ)*15 := by norm_num
        _ ≤ A*C := by gcongr)
    (by dsimp [P]; ring)
  have hCD : C*D ≤ P/3 := hcomp (C*D) (A*B) 3 (by positivity) (by norm_num)
    (by
      calc
        3 = (1 : ℝ)*3 := by norm_num
        _ ≤ A*B := by gcongr)
    (by dsimp [P]; ring)
  have hAsmall : A ≤ P/4050 := hcomp A (B*C*D) 4050 hA0.le (by norm_num)
    (by
      calc
        4050 = (3 : ℝ)*15*90 := by norm_num
        _ ≤ B*C*D := by gcongr)
    (by dsimp [P]; ring)
  have hA2 : A^2 ≤ P/1350 := by
    have hh := mul_nonneg hA0.le (sub_nonneg.mpr hA3.le)
    nlinarith only [hh,hAsmall]
  have hscaled := mul_le_mul_of_nonneg_left hD.le
    (show 0 ≤ A*B*C by positivity)
  have hAC2 : 225 ≤ A*C^2 := by
    calc 225 = (1 : ℝ)*15^2 := by norm_num
         _ ≤ A*C^2 := by gcongr
  have hAB2 : 9 ≤ A*B^2 := by
    calc 9 = (1 : ℝ)*3^2 := by norm_num
         _ ≤ A*B^2 := by gcongr
  have hB2 : B^2 ≤ P/450 := by
    have hh := mul_nonneg (sub_nonneg.mpr hAC2) (sq_nonneg B)
    dsimp [P]
    nlinarith only [hh,hscaled]
  have hC2 : C^2 ≤ P/18 := by
    have hh := mul_nonneg (sub_nonneg.mpr hAB2) (sq_nonneg C)
    dsimp [P]
    nlinarith only [hh,hscaled]
  by_contra hbad
  have hD2 : D^2 ≤ (59/20 : ℝ)*P := by
    have hh := mul_nonneg (sub_nonneg.mpr (le_of_not_gt hbad)) hD0.le
    dsimp [P]
    nlinarith only [hh]
  change P ≤ _ at hupper
  nlinarith only [hupper,hA2,hB2,hC2,hD2,hAB,hAC,hAD,hBC',hBD,hCD,hbase,hP]

theorem frontier_fifteen_matrix_bounds (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hd : ∀ i, F i i = 0) (hs : ∀ i j, F i j = F j i)
    (he : ∀ i j, i ≠ j → ‖F i j-(1/2 : ℂ)‖ ≤ frontierFifteenK i j-1/2) :
    ‖F.det‖ ≤ 1 ∧ ∀ i j, ‖F.adjugate i j‖ ≤ frontierFifteenG i j := by
  have hrepr : F =
      !![0,F 0 1,F 0 2,F 0 3; F 0 1,0,F 1 2,F 1 3;
         F 0 2,F 1 2,0,F 2 3; F 0 3,F 1 3,F 2 3,0] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      (simp (config := {decide := true}) [hd] <;>
        (first | exact hs _ _ | exact (hs _ _).symm))
  have hh := frontier_fifteen_six_bounds (F 0 1) (F 0 2) (F 0 3) (F 1 2) (F 1 3) (F 2 3)
    (by simpa [frontierFifteenK] using he 0 1 (by decide))
    (by simpa [frontierFifteenK] using he 0 2 (by decide))
    (by simpa [frontierFifteenK] using he 0 3 (by decide))
    (by simpa [frontierFifteenK] using he 1 2 (by decide))
    (by simpa [frontierFifteenK] using he 1 3 (by decide))
    (by simpa [frontierFifteenK] using he 2 3 (by decide))
  simpa only [← hrepr] using hh

theorem frontier_fifteen_rankOne_upper
    (F : Matrix (Fin 4) (Fin 4) ℂ) (w : Fin 4 → ℂ)
    (hF : F.det ≠ 0) (hdet : ‖F.det‖ ≤ 1)
    (hG : ∀ i j, ‖F.adjugate i j‖ ≤ frontierFifteenG i j) :
    ‖(F+Matrix.vecMulVec w w).det‖ ≤
      (252/1000 : ℝ)*‖w 0‖^2+(256/1000)*‖w 1‖^2+(277/1000)*‖w 2‖^2+(282/1000)*‖w 3‖^2+
      (284/1000)*‖w 0‖*‖w 1‖+(284/1000)*‖w 0‖*‖w 2‖+(288/1000)*‖w 0‖*‖w 3‖+
      (286/1000)*‖w 1‖*‖w 2‖+(296/1000)*‖w 1‖*‖w 3‖+(362/1000)*‖w 2‖*‖w 3‖+1 := by
  have hadj : w ⬝ᵥ (F.adjugate *ᵥ w) = F.det*(w ⬝ᵥ (F⁻¹ *ᵥ w)) := by
    simp only [adjugate_eq_det_smul_inverse F hF,Matrix.smul_mulVec,dotProduct_smul,smul_eq_mul]
  have hid : (F+Matrix.vecMulVec w w).det = F.det+w ⬝ᵥ (F.adjugate *ᵥ w) := by
    rw [rankOneDeterminant F w hF,hadj]
    ring
  have hform : w ⬝ᵥ (F.adjugate *ᵥ w) =
      ∑ i : Fin 4, ∑ j : Fin 4, w i*F.adjugate i j*w j := by
    simp only [dotProduct,mulVec,Finset.mul_sum,mul_assoc]
  have hbil : ‖w ⬝ᵥ (F.adjugate *ᵥ w)‖ ≤
      ∑ i : Fin 4, ∑ j : Fin 4, ‖w i‖*frontierFifteenG i j*‖w j‖ := by
    rw [hform]
    calc
      _ ≤ ∑ i : Fin 4, ‖∑ j : Fin 4, w i*F.adjugate i j*w j‖ := norm_sum_le _ _
      _ ≤ ∑ i : Fin 4, ∑ j : Fin 4, ‖w i*F.adjugate i j*w j‖ := by
        apply Finset.sum_le_sum
        intro i _
        exact norm_sum_le _ _
      _ = ∑ i : Fin 4, ∑ j : Fin 4, ‖w i‖*‖F.adjugate i j‖*‖w j‖ := by simp only [norm_mul]
      _ ≤ _ := by
        apply Finset.sum_le_sum
        intro i _
        apply Finset.sum_le_sum
        intro j _
        exact mul_le_mul_of_nonneg_right
          (mul_le_mul_of_nonneg_left (hG i j) (norm_nonneg _)) (norm_nonneg _)
  rw [hid]
  have hh := norm_add_le F.det (w ⬝ᵥ (F.adjugate *ᵥ w))
  simp [frontierFifteenG,Fin.sum_univ_four] at hbil
  nlinarith only [hh,hdet,hbil]

end D1Bound5
