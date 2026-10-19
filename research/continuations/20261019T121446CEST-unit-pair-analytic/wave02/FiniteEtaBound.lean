import Mathlib.Analysis.SpecialFunctions.Pow.Real
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.GCongr

namespace D1Bound5

/-- A single rational comparison controls every exponent appearing in
the finite two-anchor families (their largest exponent is17/2). -/
theorem finite_eta_power_lower (T e : ℝ) (hT : 1000 ≤ T) (he : e ≤ 9) :
    (100/101 : ℝ) < (1-1/T)^e := by
  have hTpos : 0 < T := by linarith only [hT]
  have hinv : 1/T ≤ (1/1000 : ℝ) := by
    exact (div_le_div_iff₀ hTpos (by norm_num)).mpr (by simpa using hT)
  have hlow : (999/1000 : ℝ) ≤ 1-1/T := by linarith only [hinv]
  have hpos : 0 < 1-1/T := by linarith only [hlow]
  have hupper : 1-1/T ≤ 1 := sub_le_self _ (div_nonneg (by norm_num) hTpos.le)
  have hmono : (1-1/T)^(9 : ℕ) ≤ (1-1/T)^e := by
    simpa only [Real.rpow_natCast] using
      (Real.rpow_le_rpow_of_exponent_ge hpos hupper (show e ≤ (9 : ℕ) from he))
  calc
    (100/101 : ℝ) < (999/1000 : ℝ)^(9 : ℕ) := by norm_num
    _ ≤ (1-1/T)^(9 : ℕ) := by gcongr
    _ ≤ _ := hmono

theorem finite_eta_reciprocal_lt (T e : ℝ) (hT : 1000 ≤ T) (he : e ≤ 9) :
    1/(1-1/T)^e < (101/100 : ℝ) := by
  have h := finite_eta_power_lower T e hT he
  have hp : 0 < (1-1/T)^e := by linarith only [h]
  exact (div_lt_iff₀ hp).mpr (by linarith only [h])

end D1Bound5
