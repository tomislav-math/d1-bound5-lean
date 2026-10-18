import D1Bound5.FiveRegionParameters
import D1Bound5.CommonIntervalWindows
import D1Bound5.FinitePAdaptiveInterval

open scoped NumberField
open Module

namespace D1Bound5

/-- The actual adaptive P window, weakened only to the exact printed
rational residual rate for the chosen first-pair region. -/
theorem full_ring_finiteP_five_region_interval_excluded
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (a : Fin 3 → 𝓞 K) (c d : 𝓞 K)
    (haS : ∀ j, a j ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hinj : Function.Injective a) (hac : ∀ j, a j ≠ c)
    (had : ∀ j, a j ≠ d) (hcd : c ≠ d)
    (hmon : Monotone (fun j => ‖phi (a j : K)‖))
    (hCT : 200*‖phi (a 2 : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (hAC : 1000 ≤ ‖phi (a 0 : K)‖*‖phi (c : K)‖)
    (r : Fin 5) (hratio : fiveRegionQ r*‖phi (a 0 : K)‖ ≤ ‖phi (a 1 : K)‖)
    (hleft : (commonWindowP ‖phi (a 0 : K)‖ ‖phi (a 1 : K)‖ ‖phi (a 2 : K)‖
      ‖phi (c : K)‖ (fiveRegionPResidual r)).1 ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤
      (commonWindowP ‖phi (a 0 : K)‖ ‖phi (a 1 : K)‖ ‖phi (a 2 : K)‖
        ‖phi (c : K)‖ (fiveRegionPResidual r)).2) : False := by
  have hq : 1 ≤ fiveRegionQ r := (fiveRegion_parameters r).2.2.2.1
  have hq0 : 0 < fiveRegionQ r := by linarith only [hq]
  have hR : 0 < finitePAdaptiveRate (1/fiveRegionQ r) :=
    finitePAdaptiveRate_pos _ (by positivity)
  have hRbound : finitePAdaptiveRate (1/fiveRegionQ r) < fiveRegionPResidual r :=
    (fiveRegion_parameters r).2.2.2.2.2.2.2.2.2.2.2.2.1
  have hS1 := one_le_norm_integer hK phi (hS.1 _ (haS 2))
  have hS0 : 0 < ‖phi (a 2 : K)‖ := by linarith only [hS1]
  apply full_ring_finiteP_adaptive_closed_interval_excluded hK phi hS a c d
    haS hcS hdS hinj hac had hcd hmon hCT hCD hAC (fiveRegionQ r) hq hratio hleft
  apply hright.trans
  change ‖phi (a 0 : K)‖^6*‖phi (c : K)‖^9/
      (4*(fiveRegionPResidual r)^2*‖phi (a 2 : K)‖^4*(1+1/4000 : ℝ)) ≤ _
  apply div_le_div_of_nonneg_left (by positivity) (by positivity)
  gcongr

end D1Bound5
