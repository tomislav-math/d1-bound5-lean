import D1Bound5.FiniteN2RationalHeight
import D1Bound5.FiniteN3RationalHeight
import D1Bound5.FiniteA3RationalHeight
import D1Bound5.FiniteA4RationalHeight
import D1Bound5.FiniteA5RationalHeight
import D1Bound5.OneSmallN3AbFixedArithmetic
import D1Bound5.OneSmallN3BsFixedArithmetic
import D1Bound5.OneSmallA3FixedArithmetic
import D1Bound5.OneSmallA4FixedArithmetic
import D1Bound5.OneSmallA5FixedArithmetic

open scoped NumberField

namespace D1Bound5
open QuadInt

/-- These are integer equalities in the table's coefficient model only;
no equivalence of that model with the ambient number field is used. -/
theorem rationalCutoff_anchorA :
    oneSmallCutoffRow_56.triple.anchorA = (1 : QuadInt 0 1) := by rfl
theorem rationalCutoff_anchorB :
    oneSmallCutoffRow_56.triple.anchorB = (3 : QuadInt 0 1) := by rfl
theorem rationalCutoff_anchorS :
    oneSmallCutoffRow_56.triple.anchorS = (8 : QuadInt 0 1) := by rfl
theorem rationalCutoff_b0 : oneSmallCutoffRow_56.b0 = 9 := by decide +kernel
theorem rationalCutoff_s0 : oneSmallCutoffRow_56.s0 = 64 := by decide +kernel
theorem rationalCutoff_mem : oneSmallCutoffRow_56 ∈ oneSmallCutoffRows := by decide +kernel

/-- Exact embedding geometry of the simultaneous signed rational pair. -/
theorem rationalCutoff_pair_geometry
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (sgn : Bool) (x y : 𝓞 K)
    (hx : x = if sgn then -1 else 1)
    (hy : y = if sgn then -3 else 3) :
    ‖phi (x : K)‖ = 1 ∧ ‖phi (y : K)‖ = 3 ∧
      ‖phi (x : K)-phi (y : K)‖ = 2 := by
  rw [hx,hy]
  cases sgn <;> norm_num [NumberField.RingOfIntegers.coe_eq_algebraMap,map_ofNat]

theorem rationalCutoff_bs_geometry
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (sgn : Bool) (b s : 𝓞 K)
    (hb : b = if sgn then -3 else 3)
    (hs : s = if sgn then -8 else 8) :
    ‖phi (b : K)‖ = 3 ∧ ‖phi (s : K)‖ = 8 ∧
      ‖phi (b : K)-phi (s : K)‖ = 5 := by
  rw [hb,hs]
  cases sgn <;> norm_num [NumberField.RingOfIntegers.coe_eq_algebraMap,map_ofNat]

/-- Actual N2 height at the signed rational pair, valid in every
number field. The coefficient certificate is checked before transfer. -/
theorem finiteN2_rational_height
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (sgn : Bool) (x y c : 𝓞 K)
    (hx : x = if sgn then -1 else 1)
    (hy : y = if sgn then -3 else 3)
    (hC : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN2Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
      ‖finiteN2Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
      (oneSmallCutoffRow_56.M2 : ℝ)*‖phi (y : K)‖^4*‖phi (c : K)‖^2 := by
  have hY : ‖phi (y : K)‖ = 3 := by
    rw [hy]
    cases sgn <;> norm_num [NumberField.RingOfIntegers.coe_eq_algebraMap,map_ofNat]
  have hy0 : phi (y : K) ≠ 0 := norm_pos_iff.mp (by rw [hY]; norm_num)
  have hnorm (i : Fin 3) (j : Fin 2) (ell : Fin 3) :
      ‖finiteN2FixedPolynomial (phi (x : K)) (phi (y : K)) i j ell‖^2 =
        ((finiteN2FixedPolynomial oneSmallCutoffRow_56.triple.anchorA
          oneSmallCutoffRow_56.triple.anchorB i j ell).norm : ℝ) := by
    change _ =
      ((finiteN2FixedPolynomial (1 : QuadInt 0 1) (3 : QuadInt 0 1) i j ell).norm : ℝ)
    simpa only [Int.cast_one,Int.cast_ofNat] using
      finiteN2FixedPolynomial_rational_norm_sq phi 0 1 1 3 sgn x y
        (by simpa only [Int.cast_one,Int.cast_ofNat] using hx)
        (by simpa only [Int.cast_one,Int.cast_ofNat] using hy) i j ell
  have hYsq : ‖phi (y : K)‖^2 = (oneSmallCutoffRow_56.b0 : ℝ) := by
    rw [hY,rationalCutoff_b0]
    norm_num
  exact finiteN2_fixed_height_of_norm_sq oneSmallCutoffRow_56 rationalCutoff_mem
    (phi (x : K)) (phi (y : K)) (phi (c : K)) hYsq hnorm hy0 hC hCY i

/-- Actual N3Ab height at the signed rational pair, valid in every
number field. The coefficient certificate is checked before transfer. -/
theorem finiteN3Ab_rational_height
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (sgn : Bool) (x y c : 𝓞 K)
    (hx : x = if sgn then -1 else 1)
    (hy : y = if sgn then -3 else 3)
    (hC : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN3Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
      ‖finiteN3Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
      (oneSmallCutoffRow_56.Mn : ℝ)*‖phi (y : K)‖^7*‖phi (c : K)‖^3 := by
  have hY : ‖phi (y : K)‖ = 3 := by
    rw [hy]
    cases sgn <;> norm_num [NumberField.RingOfIntegers.coe_eq_algebraMap,map_ofNat]
  have hy0 : phi (y : K) ≠ 0 := norm_pos_iff.mp (by rw [hY]; norm_num)
  have hnorm (i : Fin 3) (j : Fin 2) (ell : Fin 4) :
      ‖finiteN3FixedPolynomial (phi (x : K)) (phi (y : K)) i j ell‖^2 =
        ((finiteN3FixedPolynomial oneSmallCutoffRow_56.triple.anchorA
          oneSmallCutoffRow_56.triple.anchorB i j ell).norm : ℝ) := by
    change _ =
      ((finiteN3FixedPolynomial (1 : QuadInt 0 1) (3 : QuadInt 0 1) i j ell).norm : ℝ)
    simpa only [Int.cast_one,Int.cast_ofNat] using
      finiteN3FixedPolynomial_rational_norm_sq phi 0 1 1 3 sgn x y
        (by simpa only [Int.cast_one,Int.cast_ofNat] using hx)
        (by simpa only [Int.cast_one,Int.cast_ofNat] using hy) i j ell
  have hYsq : ‖phi (y : K)‖^2 =
      (oneSmallCutoffRow_56.triple.anchorB.norm : ℝ) := by
    have hh : ‖phi (y : K)‖^2 = (oneSmallCutoffRow_56.b0 : ℝ) := by
      rw [hY,rationalCutoff_b0]
      norm_num
    simpa only [OneSmallCutoffRow.b0,Rat.cast_intCast] using hh
  exact finiteN3_fixed_height_of_norm_sq oneSmallCutoffRow_56.triple.anchorA
    oneSmallCutoffRow_56.triple.anchorB oneSmallCutoffRow_56.Mn
    finiteN3AbCutoffWeights_56 finiteN3AbCutoffWeights_56_valid
    (phi (x : K)) (phi (y : K)) (phi (c : K)) hYsq hnorm hy0 hC hCY i

/-- Actual N3Bs height at the signed rational pair, valid in every
number field. The coefficient certificate is checked before transfer. -/
theorem finiteN3Bs_rational_height
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (sgn : Bool) (x y c : 𝓞 K)
    (hx : x = if sgn then -3 else 3)
    (hy : y = if sgn then -8 else 8)
    (hC : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN3Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
      ‖finiteN3Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
      (oneSmallCutoffRow_56.Mbs : ℝ)*‖phi (y : K)‖^7*‖phi (c : K)‖^3 := by
  have hY : ‖phi (y : K)‖ = 8 := by
    rw [hy]
    cases sgn <;> norm_num [NumberField.RingOfIntegers.coe_eq_algebraMap,map_ofNat]
  have hy0 : phi (y : K) ≠ 0 := norm_pos_iff.mp (by rw [hY]; norm_num)
  have hnorm (i : Fin 3) (j : Fin 2) (ell : Fin 4) :
      ‖finiteN3FixedPolynomial (phi (x : K)) (phi (y : K)) i j ell‖^2 =
        ((finiteN3FixedPolynomial oneSmallCutoffRow_56.triple.anchorB
          oneSmallCutoffRow_56.triple.anchorS i j ell).norm : ℝ) := by
    change _ =
      ((finiteN3FixedPolynomial (3 : QuadInt 0 1) (8 : QuadInt 0 1) i j ell).norm : ℝ)
    simpa only [Int.cast_one,Int.cast_ofNat] using
      finiteN3FixedPolynomial_rational_norm_sq phi 0 1 3 8 sgn x y
        (by simpa only [Int.cast_one,Int.cast_ofNat] using hx)
        (by simpa only [Int.cast_one,Int.cast_ofNat] using hy) i j ell
  have hYsq : ‖phi (y : K)‖^2 =
      (oneSmallCutoffRow_56.triple.anchorS.norm : ℝ) := by
    have hh : ‖phi (y : K)‖^2 = (oneSmallCutoffRow_56.s0 : ℝ) := by
      rw [hY,rationalCutoff_s0]
      norm_num
    simpa only [OneSmallCutoffRow.s0,Rat.cast_intCast] using hh
  exact finiteN3_fixed_height_of_norm_sq oneSmallCutoffRow_56.triple.anchorB
    oneSmallCutoffRow_56.triple.anchorS oneSmallCutoffRow_56.Mbs
    finiteN3BsCutoffWeights_56 finiteN3BsCutoffWeights_56_valid
    (phi (x : K)) (phi (y : K)) (phi (c : K)) hYsq hnorm hy0 hC hCY i

/-- Actual A3 height at the signed rational pair, valid in every
number field. The coefficient certificate is checked before transfer. -/
theorem finiteA3_rational_height
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (sgn : Bool) (x y c : 𝓞 K)
    (hx : x = if sgn then -1 else 1)
    (hy : y = if sgn then -3 else 3)
    (hC : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteA3Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
      ‖finiteA3Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
      (oneSmallCutoffRow_56.M3 : ℝ)*‖phi (y : K)‖^6*‖phi (c : K)‖^3 := by
  have hY : ‖phi (y : K)‖ = 3 := by
    rw [hy]
    cases sgn <;> norm_num [NumberField.RingOfIntegers.coe_eq_algebraMap,map_ofNat]
  have hy0 : phi (y : K) ≠ 0 := norm_pos_iff.mp (by rw [hY]; norm_num)
  have hnorm (i : Fin 3) (j : Fin 2) (ell : Fin 4) :
      ‖finiteA3RootCoeff (phi (x : K)) (phi (y : K)) i j ell‖^2 =
        ((finiteA3RootCoeff oneSmallCutoffRow_56.triple.anchorA
          oneSmallCutoffRow_56.triple.anchorB i j ell).norm : ℝ) := by
    change _ =
      ((finiteA3RootCoeff (1 : QuadInt 0 1) (3 : QuadInt 0 1) i j ell).norm : ℝ)
    simpa only [Int.cast_one,Int.cast_ofNat] using
      finiteA3RootCoeff_rational_norm_sq phi 0 1 1 3 sgn x y
        (by simpa only [Int.cast_one,Int.cast_ofNat] using hx)
        (by simpa only [Int.cast_one,Int.cast_ofNat] using hy) i j ell
  have hYsq : ‖phi (y : K)‖^2 =
      (oneSmallCutoffRow_56.triple.anchorB.norm : ℝ) := by
    have hh : ‖phi (y : K)‖^2 = (oneSmallCutoffRow_56.b0 : ℝ) := by
      rw [hY,rationalCutoff_b0]
      norm_num
    simpa only [OneSmallCutoffRow.b0,Rat.cast_intCast] using hh
  exact finiteA3_fixed_height_of_norm_sq oneSmallCutoffRow_56.triple.anchorA
    oneSmallCutoffRow_56.triple.anchorB oneSmallCutoffRow_56.M3
    finiteA3CutoffWeights_56 finiteA3CutoffWeights_56_valid
    (phi (x : K)) (phi (y : K)) (phi (c : K)) hYsq hnorm hy0 hC hCY i

/-- Actual A4 height at the signed rational pair, valid in every
number field. The coefficient certificate is checked before transfer. -/
theorem finiteA4_rational_height
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (sgn : Bool) (x y c : 𝓞 K)
    (hx : x = if sgn then -1 else 1)
    (hy : y = if sgn then -3 else 3)
    (hC : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteA4Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
      ‖finiteA4Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
      (oneSmallCutoffRow_56.M4 : ℝ)*‖phi (y : K)‖^9*‖phi (c : K)‖^4 := by
  have hY : ‖phi (y : K)‖ = 3 := by
    rw [hy]
    cases sgn <;> norm_num [NumberField.RingOfIntegers.coe_eq_algebraMap,map_ofNat]
  have hy0 : phi (y : K) ≠ 0 := norm_pos_iff.mp (by rw [hY]; norm_num)
  have hnorm (i : Fin 3) (j : Fin 2) (ell : Fin 5) :
      ‖finiteA4RootCoeff (phi (x : K)) (phi (y : K)) i j ell‖^2 =
        ((finiteA4RootCoeff oneSmallCutoffRow_56.triple.anchorA
          oneSmallCutoffRow_56.triple.anchorB i j ell).norm : ℝ) := by
    change _ =
      ((finiteA4RootCoeff (1 : QuadInt 0 1) (3 : QuadInt 0 1) i j ell).norm : ℝ)
    simpa only [Int.cast_one,Int.cast_ofNat] using
      finiteA4RootCoeff_rational_norm_sq phi 0 1 1 3 sgn x y
        (by simpa only [Int.cast_one,Int.cast_ofNat] using hx)
        (by simpa only [Int.cast_one,Int.cast_ofNat] using hy) i j ell
  have hYsq : ‖phi (y : K)‖^2 =
      (oneSmallCutoffRow_56.triple.anchorB.norm : ℝ) := by
    have hh : ‖phi (y : K)‖^2 = (oneSmallCutoffRow_56.b0 : ℝ) := by
      rw [hY,rationalCutoff_b0]
      norm_num
    simpa only [OneSmallCutoffRow.b0,Rat.cast_intCast] using hh
  exact finiteA4_fixed_height_of_norm_sq oneSmallCutoffRow_56.triple.anchorA
    oneSmallCutoffRow_56.triple.anchorB oneSmallCutoffRow_56.M4
    finiteA4CutoffWeights_56 finiteA4CutoffWeights_56_valid
    (phi (x : K)) (phi (y : K)) (phi (c : K)) hYsq hnorm hy0 hC hCY i

/-- Actual A5 height at the signed rational pair, valid in every
number field. The coefficient certificate is checked before transfer. -/
theorem finiteA5_rational_height
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (sgn : Bool) (x y c : 𝓞 K)
    (hx : x = if sgn then -1 else 1)
    (hy : y = if sgn then -3 else 3)
    (hC : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteA5Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
      ‖finiteA5Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
      (oneSmallCutoffRow_56.M5 : ℝ)*‖phi (y : K)‖^12*‖phi (c : K)‖^5 := by
  have hY : ‖phi (y : K)‖ = 3 := by
    rw [hy]
    cases sgn <;> norm_num [NumberField.RingOfIntegers.coe_eq_algebraMap,map_ofNat]
  have hy0 : phi (y : K) ≠ 0 := norm_pos_iff.mp (by rw [hY]; norm_num)
  have hnorm (i : Fin 3) (j : Fin 2) (ell : Fin 6) :
      ‖finiteA5RootCoeff (phi (x : K)) (phi (y : K)) i j ell‖^2 =
        ((finiteA5RootCoeff oneSmallCutoffRow_56.triple.anchorA
          oneSmallCutoffRow_56.triple.anchorB i j ell).norm : ℝ) := by
    change _ =
      ((finiteA5RootCoeff (1 : QuadInt 0 1) (3 : QuadInt 0 1) i j ell).norm : ℝ)
    simpa only [Int.cast_one,Int.cast_ofNat] using
      finiteA5RootCoeff_rational_norm_sq phi 0 1 1 3 sgn x y
        (by simpa only [Int.cast_one,Int.cast_ofNat] using hx)
        (by simpa only [Int.cast_one,Int.cast_ofNat] using hy) i j ell
  have hYsq : ‖phi (y : K)‖^2 =
      (oneSmallCutoffRow_56.triple.anchorB.norm : ℝ) := by
    have hh : ‖phi (y : K)‖^2 = (oneSmallCutoffRow_56.b0 : ℝ) := by
      rw [hY,rationalCutoff_b0]
      norm_num
    simpa only [OneSmallCutoffRow.b0,Rat.cast_intCast] using hh
  exact finiteA5_fixed_height_of_norm_sq oneSmallCutoffRow_56.triple.anchorA
    oneSmallCutoffRow_56.triple.anchorB oneSmallCutoffRow_56.M5
    finiteA5CutoffWeights_56 finiteA5CutoffWeights_56_valid
    (phi (x : K)) (phi (y : K)) (phi (c : K)) hYsq hnorm hy0 hC hCY i

end D1Bound5
