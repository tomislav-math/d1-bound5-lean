import Mathlib.Analysis.Complex.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

namespace D1Bound5

/-- An actual square root of cd+1 has the relative terminal norm bounds
needed for closed forbidden intervals once |cd|≥4000. -/
theorem finite_tuple_root_relative_norm
    (c d z : ℂ) (hz : z^2 = c*d+1) (hCD : 4000 ≤ ‖c‖*‖d‖) :
    (1-1/4000 : ℝ)*‖c‖*‖d‖ ≤ ‖z‖^2 ∧
      ‖z‖^2 ≤ (1+1/4000 : ℝ)*‖c‖*‖d‖ := by
  have hsquare : ‖z‖^2 = ‖c*d+1‖ := by rw [← norm_pow, hz]
  have hhi := norm_add_le (c*d) (1 : ℂ)
  have hlo := norm_sub_le (c*d+1) (1 : ℂ)
  simp only [norm_mul, norm_one] at hhi
  simp only [add_sub_cancel_right, norm_mul, norm_one] at hlo
  have herr : 1 ≤ (1/4000 : ℝ)*‖c‖*‖d‖ := by nlinarith only [hCD]
  constructor <;> rw [hsquare] <;> nlinarith only [hhi, hlo, herr]

/-- Both endpoints are excluded: each summand is at most one half inside
the closed window, contradicting the strict inequality from an actual
nonzero integral form. -/
theorem finite_closed_window_incompatible
    (C D Z U V eps : ℝ) (hC : 0 < C) (hZ : 0 < Z)
    (hU : 0 < U) (hV : 0 < V) (heps : 0 ≤ eps) (heps1 : eps < 1)
    (hrootlo : (1-eps)*C*D ≤ Z^2) (hroothi : Z^2 ≤ (1+eps)*C*D)
    (hform : 1 < U/Z+V*Z)
    (hlower : 4*U^2/(C*(1-eps)) ≤ D)
    (hupper : D ≤ 1/(4*V^2*C*(1+eps))) : False := by
  have heminus : 0 < 1-eps := sub_pos.mpr heps1
  have heplus : 0 < 1+eps := by linarith
  have hlo := (div_le_iff₀ (mul_pos hC heminus)).1 hlower
  have hsquare : (2*U)^2 ≤ Z^2 := by nlinarith only [hlo, hrootlo]
  have hlinear : 2*U ≤ Z := by
    by_contra h
    have hh : Z < 2*U := lt_of_not_ge h
    have hp := mul_pos (sub_pos.mpr hh) (by positivity : 0 < 2*U+Z)
    nlinarith only [hp, hsquare]
  have hfirst : U/Z ≤ (1/2 : ℝ) := by
    apply (div_le_iff₀ hZ).2
    linarith only [hlinear]
  have hhi := (le_div_iff₀ (by positivity : 0 < 4*V^2*C*(1+eps))).1 hupper
  have hscaled := mul_le_mul_of_nonneg_left hroothi (by positivity : 0 ≤ 4*V^2)
  have hsq : (2*V*Z)^2 ≤ 1 := by nlinarith only [hhi, hscaled]
  have hsecond : V*Z ≤ (1/2 : ℝ) := by
    have hp : 0 ≤ 2*V*Z := by positivity
    nlinarith only [hsq, hp, sq_nonneg (2*V*Z-1)]
  linarith only [hform, hfirst, hsecond]

end D1Bound5
