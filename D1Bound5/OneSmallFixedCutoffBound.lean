import D1Bound5.OneSmallFixedForcedP
import D1Bound5.FinitePAdaptiveInterval

open Finset
open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

theorem OneSmallCutoffRow.adaptive_rate (r : OneSmallCutoffRow) :
    finitePAdaptiveRate (1/(r.q : ℝ)) = (r.Rp : ℝ) := by
  simp only [finitePAdaptiveRate,OneSmallCutoffRow.Rp]
  push_cast
  <;> ring

/-- The printed fixed-triple cutoff for an actual full-ring sextuple,
normalized by the indicated simultaneous sign and conjugation. All
finite-family windows and the infinite ordinary tail are supplied by
proved approximation forms, so no abstract exclusion premise remains. -/
theorem IsD1Tuple.fixed_cutoff_fourth_norm_sq_lt
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (r : OneSmallCutoffRow) (hr : r ∈ oneSmallCutoffRows)
    (e : QuadInt r.triple.tau r.triple.nu ≃+* 𝓞 K)
    (sgn conj : Bool)
    (h0 : smallExtensionSymmetry sgn conj (e.symm (a 0)) = r.triple.anchorA)
    (h1 : smallExtensionSymmetry sgn conj (e.symm (a 1)) = r.triple.anchorB)
    (h2 : smallExtensionSymmetry sgn conj (e.symm (a 2)) = r.triple.anchorS) :
    ‖phi (a 3 : K)‖^2 < (r.triple.cutoff : ℝ) := by
  classical
  by_contra hn
  have hlarge := le_of_not_gt hn
  let A := ‖phi (a 0 : K)‖
  let B := ‖phi (a 1 : K)‖
  let S := ‖phi (a 2 : K)‖
  let C := ‖phi (a 4 : K)‖
  let D := ‖phi (a 5 : K)‖
  have hA1 : 1 ≤ A := one_le_norm_integer hK phi (ha.2.1 0)
  have hA : 0 < A := by linarith only [hA1]
  have hAB : A ≤ B := hmon (by decide : (0 : Fin 6) ≤ 1)
  have hB : 0 < B := hA.trans_le hAB
  have hS : 0 < S := hB.trans_le (hmon (by decide : (1 : Fin 6) ≤ 2))
  obtain ⟨hAsq,hBsq,_,_⟩ := oneSmall_fixed_pair_geometry phi r hr e sgn conj (a 0) (a 1) h0 h1
  change A^2 = (r.a0 : ℝ) at hAsq
  change B^2 = (r.b0 : ℝ) at hBsq
  have hv := oneSmallCutoffRows_valid r hr
  obtain ⟨_,_,_,_,hq,hqSq,_⟩ := hv
  have hq1 : 1 ≤ (r.q : ℝ) := by exact_mod_cast (show (1 : ℚ) ≤ r.q by linarith only [hq])
  have hqAB : (r.q : ℝ)*A ≤ B := by
    have hh : (r.q : ℝ)^2 ≤ (r.b0 : ℝ)/(r.a0 : ℝ) := by exact_mod_cast hqSq
    rw [←hAsq,←hBsq] at hh
    have hh' := (le_div_iff₀ (sq_pos_of_pos hA)).mp hh
    apply (sq_le_sq₀ (by positivity) hB.le).mp
    nlinarith only [hh']
  have hret := IsD1Tuple.fixed_cutoff_retained_gap hK phi a ha hmon r hr e sgn conj h0 h1 h2 hlarge
  obtain ⟨_,_,_,hC1000,hC200S,_,_,_⟩ := hret
  change 1000 < C at hC1000
  change 200*S < C at hC200S
  have hC : 0 < C := by linarith only [hC1000]
  have hAC : 1000 ≤ A*C := by
    have hh := mul_le_mul_of_nonneg_right hA1 hC.le
    linarith only [hh,hC1000]
  obtain ⟨hPlower,hPupper⟩ := IsD1Tuple.fixed_cutoff_forced_P_window
    hK phi a ha hmon r hr e sgn conj h0 h1 h2 hlarge
  change (fixedWindowP r B S C).1 ≤ D at hPlower
  change D ≤ (fixedWindowP r B S C).2 at hPupper
  have hu : D ≤ A^6*C^9/(4*(finitePAdaptiveRate (1/(r.q : ℝ)))^2*S^4*(1+1/4000 : ℝ)) := by
    rw [r.adaptive_rate]
    apply hPupper.trans
    simp only [fixedWindowP]
    gcongr
    have hA6 : (1 : ℝ) ≤ A^6 := one_le_pow₀ hA1
    simpa only [one_mul] using
      mul_le_mul_of_nonneg_right hA6 (pow_nonneg hC.le 9)
  let Tup : Finset (𝓞 K) := Finset.univ.image a
  have hmem (i : Fin 6) : a i ∈ Tup := Finset.mem_image.mpr ⟨i,Finset.mem_univ i,rfl⟩
  have hTup : IsD1 Tup := by
    constructor
    · intro x hx
      obtain ⟨i,_,rfl⟩ := Finset.mem_image.mp hx
      exact ha.2.1 i
    · intro x hx y hy hxy
      obtain ⟨i,_,rfl⟩ := Finset.mem_image.mp hx
      obtain ⟨j,_,rfl⟩ := Finset.mem_image.mp hy
      exact ha.2.2 i j (fun hij => hxy (congrArg a hij))
  let ii : Fin 3 → Fin 6 := ![0,1,2]
  let b : Fin 3 → 𝓞 K := fun j => a (ii j)
  have hi : Function.Injective ii := by decide
  have hm : Monotone ii := by decide
  exact full_ring_finiteP_adaptive_closed_interval_excluded hK phi hTup b (a 4) (a 5)
    (fun j => hmem (ii j)) (hmem 4) (hmem 5) (ha.1.comp hi)
    (fun j => ha.1.ne (by fin_cases j <;> decide))
    (fun j => ha.1.ne (by fin_cases j <;> decide))
    (ha.1.ne (by decide : (4 : Fin 6) ≠ 5)) (hmon.comp hm) hC200S.le
    (hmon (by decide : (4 : Fin 6) ≤ 5)) hAC (r.q : ℝ) hq1 hqAB hPlower hu

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.fixed_cutoff_fourth_norm_sq_lt
