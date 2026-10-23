import D1Bound5.CoherentRetainedIntegral

open Finset

namespace D1Bound5

/-- The normalized Vandermonde factor in the retained estimate is
positive and at most eight for ordered nonzero distinct anchors. -/
theorem coherent_three_vandermonde_ratio_bounds
    (a : Fin 3 → ℂ) (hinj : Function.Injective a)
    (hA : 0 < ‖a 0‖) (hAB : ‖a 0‖ ≤ ‖a 1‖) (hBS : ‖a 1‖ ≤ ‖a 2‖) :
    0 < ‖coherentVandermonde3 a‖/(‖a 1‖*‖a 2‖^2) ∧
      ‖coherentVandermonde3 a‖/(‖a 1‖*‖a 2‖^2) ≤ 8 := by
  have hB : 0 < ‖a 1‖ := hA.trans_le hAB
  have hS : 0 < ‖a 2‖ := hB.trans_le hBS
  have hDelta : coherentVandermonde3 a ≠ 0 := by
    exact mul_ne_zero
      (mul_ne_zero (sub_ne_zero.mpr (hinj.ne (by decide)))
        (sub_ne_zero.mpr (hinj.ne (by decide))))
      (sub_ne_zero.mpr (hinj.ne (by decide)))
  have h01 : ‖a 0-a 1‖ ≤ 2*‖a 1‖ := by
    have h := norm_sub_le (a 0) (a 1)
    linarith only [h,hAB]
  have h02 : ‖a 0-a 2‖ ≤ 2*‖a 2‖ := by
    have h := norm_sub_le (a 0) (a 2)
    linarith only [h,hAB,hBS]
  have h12 : ‖a 1-a 2‖ ≤ 2*‖a 2‖ := by
    have h := norm_sub_le (a 1) (a 2)
    linarith only [h,hBS]
  have hD : ‖coherentVandermonde3 a‖ ≤ 8*‖a 1‖*‖a 2‖^2 := by
    calc
      _ = ‖a 0-a 1‖*‖a 0-a 2‖*‖a 1-a 2‖ := by simp only [coherentVandermonde3,norm_mul]
      _ ≤ (2*‖a 1‖)*(2*‖a 2‖)*(2*‖a 2‖) :=
        mul_le_mul (mul_le_mul h01 h02 (norm_nonneg _) (by positivity)) h12
          (norm_nonneg _) (by positivity)
      _ = _ := by ring
  refine ⟨div_pos (norm_pos_iff.mpr hDelta) (by positivity), ?_⟩
  apply (div_le_iff₀ (by positivity : 0<‖a 1‖*‖a 2‖^2)).2
  nlinarith only [hD]

/-- The exact chosen terminal root supplies both modulus-square
estimates used by the retained scalar conversion. -/
theorem coherent_terminal_root_norm_sq_bounds
    (p q eta : ℂ) (hp : p ≠ 0) (hq : q ≠ 0) (heta : eta^2=p*q)
    (hPQ : 4000 < ‖p‖*‖q‖) :
    (3999/4000 : ℝ)*‖p‖*‖q‖ < ‖coherentTerminalRoot p q eta‖^2 ∧
      ‖coherentTerminalRoot p q eta‖^2 ≤ ‖p‖*‖q‖+1 := by
  have hs : (coherentTerminalRoot p q eta)^2 = p*q+1 :=
    coherent_analytic_terminal_root_sq p q eta hp hq heta
  have hnorm : ‖coherentTerminalRoot p q eta‖^2 = ‖p*q+1‖ := by
    simpa only [norm_pow] using congrArg norm hs
  have hupper : ‖p*q+1‖ ≤ ‖p‖*‖q‖+1 := by
    simpa only [norm_mul,norm_one] using norm_add_le (p*q) (1:ℂ)
  have hlower : ‖p‖*‖q‖-1 ≤ ‖p*q+1‖ := by
    have h := norm_sub_le (p*q+1) (1:ℂ)
    simp only [add_sub_cancel_right,norm_mul,norm_one] at h
    linarith
  rw [hnorm]
  exact ⟨by nlinarith only [hlower,hPQ],hupper⟩

end D1Bound5

