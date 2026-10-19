import D1Bound5.UnitPairCubic
import D1Bound5.UnitPairSymmetric

open scoped NumberField
open Module

namespace D1Bound5

/-- Three unit cubic gaps have the exact accumulated denominator 2^13. -/
theorem unit_pair_three_cubic_gaps (S T C D : ℝ) (hS : 9 ≤ S)
    (hST : S^3/2 < T) (hTC : T^3/2 < C) (hCD : C^3/2 < D) :
    S^27/8192 < D := by
  have hS0 : 0 < S := by linarith only [hS]
  have hT0 : 0 < T := lt_trans (by positivity : 0 < S^3/2) hST
  have hC0 : 0 < C := lt_trans (by positivity : 0 < T^3/2) hTC
  have hSTcube : (S^3/2)^3 < T^3 := by gcongr
  have hSC : S^9/16 < C := by nlinarith only [hSTcube,hTC]
  have hSCcube : (S^9/16)^3 < C^3 := by gcongr
  nlinarith only [hSCcube,hCD]

/-- The actual unit-pair sextuple already supplies every opposite-pair
exclusion through the symmetric-five obstruction. Thus the three cubic
steps require no extra hypothesis about signs of its four extensions. -/
theorem IsD1Tuple.unit_pair_cubic_iteration
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hminus : a 0 = -1) (hplus : a 1 = 1)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hS : 9 ≤ ‖phi (a 2 : K)‖) :
    ‖phi (a 2 : K)‖^27/8192 < ‖phi (a 5 : K)‖ := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hdiscrete (x : 𝓞 K) (hx : x ≠ 0) : 1 ≤ ‖f x‖ :=
    one_le_norm_integer hK phi hx
  have hlarge (i : Fin 6) (hi : 2 ≤ i) : 9 ≤ ‖f (a i)‖ :=
    hS.trans (hmon hi)
  have hroots (i : Fin 6) (hi : 2 ≤ i) :
      (∃ r : 𝓞 K, r^2 = a i+1) ∧ (∃ r : 𝓞 K, r^2 = 1-a i) := by
    obtain ⟨p,hp⟩ := ha.2.2 1 i (by omega)
    obtain ⟨m,hm⟩ := ha.2.2 0 i (by omega)
    constructor
    · exact ⟨p,by simpa only [pow_two,hplus,one_mul] using hp⟩
    · refine ⟨m,?_⟩
      rw [pow_two,hm,hminus]
      ring
  have hnoOpp (i j k : Fin 6) (hi : 2 ≤ i) (hk : 2 ≤ k)
      (hik : i ≠ k) (hjk : j ≠ k) : a j ≠ -a i := by
    intro hopp
    obtain ⟨hip,him⟩ := hroots i hi
    obtain ⟨hkp,hkm⟩ := hroots k hk
    obtain ⟨p,hp⟩ := ha.2.2 i k hik
    obtain ⟨m,hm⟩ := ha.2.2 j k hjk
    apply discrete_unit_pair_symmetric_obstruction f hdiscrete (a i) (a k)
      (by linarith only [hlarge i hi]) (by linarith only [hlarge k hk])
      him (by simpa only [add_comm] using hip)
      hkm (by simpa only [add_comm] using hkp)
    · refine ⟨m,?_⟩
      rw [pow_two,hm,hopp]
      ring
    · exact ⟨p,by simpa only [pow_two,add_comm] using hp⟩
  have hgap (i j k : Fin 6) (hi : 2 ≤ i) (hj : 2 ≤ j) (hk : 2 ≤ k)
      (hij : i < j) (hik : i ≠ k) (hjk : j ≠ k) :
      ‖f (a i)‖^3/2 < ‖f (a j)‖ := by
    obtain ⟨hip,him⟩ := hroots i hi
    obtain ⟨hjp,hjm⟩ := hroots j hj
    obtain ⟨r,hr⟩ := ha.2.2 i j (ne_of_lt hij)
    exact full_ring_unit_pair_cubic_growth hK phi (a i) (a j)
      (hlarge i hi) (hmon hij.le) (hnoOpp i j k hi hk hik hjk)
      hip him hjp hjm ⟨r,by simpa only [pow_two] using hr⟩
  exact unit_pair_three_cubic_gaps ‖f (a 2)‖ ‖f (a 3)‖ ‖f (a 4)‖ ‖f (a 5)‖ hS
    (hgap 2 3 4 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide))
    (hgap 3 4 2 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide))
    (hgap 4 5 2 (by decide) (by decide) (by decide) (by decide) (by decide) (by decide))

end D1Bound5
