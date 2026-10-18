import D1Bound5.OrdinaryHeightScalar

namespace D1Bound5

noncomputable def ordinaryLog10 (x : ℝ) : ℝ := Real.log x/Real.log 10

theorem ordinaryLog10_base_pos : 0 < Real.log (10 : ℝ) :=
  Real.log_pos (by norm_num)

theorem ordinaryLog10_mul (x y : ℝ) (hx : x ≠ 0) (hy : y ≠ 0) :
    ordinaryLog10 (x*y) = ordinaryLog10 x+ordinaryLog10 y := by
  simp only [ordinaryLog10,Real.log_mul hx hy]
  ring

theorem ordinaryLog10_pow (x : ℝ) (n : ℕ) :
    ordinaryLog10 (x^n) = n*ordinaryLog10 x := by
  simp only [ordinaryLog10,Real.log_pow]
  ring

theorem ordinaryLog10_ten : ordinaryLog10 10 = 1 := by
  exact div_self ordinaryLog10_base_pos.ne'

theorem ordinaryLog10_strictMono {x y : ℝ} (hx : 0 < x) (hxy : x < y) :
    ordinaryLog10 x < ordinaryLog10 y :=
  div_lt_div_of_pos_right (Real.log_lt_log hx hxy) ordinaryLog10_base_pos

theorem ordinaryLog10_mono {x y : ℝ} (hx : 0 < x) (hxy : x ≤ y) :
    ordinaryLog10 x ≤ ordinaryLog10 y := by
  exact div_le_div_of_nonneg_right (Real.log_le_log hx hxy) ordinaryLog10_base_pos.le

theorem ordinaryLog10_nonneg {x : ℝ} (hx : 1 ≤ x) : 0 ≤ ordinaryLog10 x :=
  div_nonneg (Real.log_nonneg hx) ordinaryLog10_base_pos.le

/-- Exact integer-power comparisons certify all decimal logarithm
parameters; no decimal approximation or external numerical oracle is used. -/
theorem ordinaryLog10_lt_of_pow_lt (x : ℝ) (m n : ℕ)
    (hx : 0 < x) (hpow : x^n < (10 : ℝ)^m) :
    (n : ℝ)*ordinaryLog10 x < m := by
  have h := ordinaryLog10_strictMono (pow_pos hx n) hpow
  simpa only [ordinaryLog10_pow,ordinaryLog10_ten,mul_one] using h

theorem ordinaryLog10_two_lt : ordinaryLog10 2 < (2/5 : ℝ) := by
  have h := ordinaryLog10_lt_of_pow_lt 2 2 5 (by norm_num) (by norm_num)
  norm_num at h
  linarith only [h]

theorem ordinaryLog10_unit_parameters :
    ordinaryLog10 42 < (163/100 : ℝ) ∧
    -(2/5 : ℝ) < ordinaryLog10 (2/5) ∧
    ordinaryLog10 253 < (241/100 : ℝ) := by
  have h42 := ordinaryLog10_lt_of_pow_lt 42 163 100 (by norm_num) (by norm_num)
  have h52 := ordinaryLog10_lt_of_pow_lt (5/2) 2 5 (by norm_num) (by norm_num)
  have h253 := ordinaryLog10_lt_of_pow_lt 253 241 100 (by norm_num) (by norm_num)
  have hrec : ordinaryLog10 (2/5)+ordinaryLog10 (5/2) = 0 := by
    rw [← ordinaryLog10_mul (2/5) (5/2) (by norm_num) (by norm_num)]
    norm_num [ordinaryLog10]
  norm_num at h42 h52 h253
  exact ⟨by linarith only [h42],by linarith only [h52,hrec],by linarith only [h253]⟩

end D1Bound5
