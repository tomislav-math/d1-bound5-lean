import D1Bound5.DegeneratePairClassification
import D1Bound5.UnitPairImpossible
import D1Bound5.EisensteinExceptionalPair
import D1Bound5.EisensteinImaginaryExtensions

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Simultaneous negation preserves the full D(1) condition, including
all root witnesses and distinctness. -/
theorem IsD1Tuple.simultaneous_neg {R : Type*} [CommRing R] {n : ℕ}
    (t : Fin n → R) (ht : IsD1Tuple t) : IsD1Tuple (fun i => -t i) := by
  refine ⟨?_,?_,?_⟩
  · intro i j hij
    apply ht.1
    exact neg_injective hij
  · intro i hi
    apply ht.2.1 i
    exact neg_eq_zero.mp hi
  · intro i j hij
    obtain ⟨r,hr⟩ := ht.2.2 i j hij
    exact ⟨r,by simpa only [neg_mul_neg] using hr⟩

theorem IsD1Tuple.coordinate_equiv {R S : Type*} [CommRing R] [CommRing S]
    {n : ℕ} (t : Fin n → R) (ht : IsD1Tuple t) (e : R ≃+* S) :
    IsD1Tuple (fun i => e (t i)) := by
  refine ⟨e.injective.comp ht.1,?_,?_⟩
  · intro i hi
    apply ht.2.1 i
    apply e.injective
    simpa only [map_zero] using hi
  · intro i j hij
    obtain ⟨r,hr⟩ := ht.2.2 i j hij
    exact ⟨e r,by simpa only [map_mul,map_add,map_one] using congrArg e hr⟩

/-- The exceptional Eisenstein pair excludes three further compatible
entries. Both anchor orientations are handled by exchanging witnesses. -/
theorem IsD1Tuple.eisenstein_canonical_pair_impossible
    (t : Fin 6 → QuadInt 1 1) (ht : IsD1Tuple t)
    (hpair : EisensteinCanonicalPair (t 0) (t 1)) : False := by
  have htrace (i : Fin 6) (hi0 : (0 : Fin 6) ≠ i) (hi1 : (1 : Fin 6) ≠ i) :
      2*(t i).re+(t i).im=0 := by
    have h0 := ht.2.2 0 i hi0
    have h1 := ht.2.2 1 i hi1
    rcases hpair with ⟨ha,hb⟩ | ⟨hb,ha⟩
    · exact eisenstein_exceptional_pair_extension_trace_zero (t i)
        (by simpa only [ha] using h0) (by simpa only [hb] using h1)
    · exact eisenstein_exceptional_pair_extension_trace_zero (t i)
        (by simpa only [ha] using h1) (by simpa only [hb] using h0)
  exact eisenstein_no_three_trace_zero_extensions (t 2) (t 3) (t 4)
    (ht.2.1 2) (ht.2.1 3) (ht.2.1 4)
    (htrace 2 (by decide) (by decide)) (htrace 3 (by decide) (by decide))
    (htrace 4 (by decide) (by decide))
    (ht.2.2 2 3 (by decide)) (ht.2.2 2 4 (by decide)) (ht.2.2 3 4 (by decide))

/-- Either orientation of the rational unit pair is impossible. Negating
the whole tuple changes the orientation while preserving every modulus. -/
theorem IsD1Tuple.rational_unit_pair_impossible
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖))
    (hpair : RationalUnitPair (t 0) (t 1)) : False := by
  rcases hpair with ⟨hm,hp⟩ | ⟨hp,hm⟩
  · exact ht.unit_pair_impossible hK phi t hm hp hmon
  · let u : Fin 6 → 𝓞 K := fun i => -t i
    have hu : IsD1Tuple u := ht.simultaneous_neg t
    have hum : u 0 = -1 := by simp [u,hp]
    have hup : u 1 = 1 := by simp [u,hm]
    have humon : Monotone (fun i => ‖phi (u i : K)‖) := by
      intro i j hij
      change ‖phi (-(t i : K))‖ ≤ ‖phi (-(t j : K))‖
      simpa only [map_neg,norm_neg] using hmon hij
    exact hu.unit_pair_impossible hK phi u hum hup humon

/-- The whole degenerate first-pair case is impossible in any imaginary
quadratic full integer ring. Product minus one first forces norm one;
Gaussian repeated anchors are excluded by injectivity, and the only
nonrational remaining model is treated by actual Eisenstein Pell descent. -/
theorem IsD1Tuple.degenerate_first_pair_impossible
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖))
    (hprod : t 0*t 1+1=0) : False := by
  obtain ⟨tau,nu,htau,hd,⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  let u : Fin 6 → QuadInt tau nu := fun i => e.symm (t i)
  have hu : IsD1Tuple u := ht.coordinate_equiv t e.symm
  have hne : u 0 ≠ u 1 := fun h => (by decide : (0 : Fin 6) ≠ 1) (hu.1 h)
  have huprod : u 0*u 1+1=0 := by
    simpa only [u,map_mul,map_add,map_one,map_zero] using congrArg e.symm hprod
  have hback (h : RationalUnitPair (u 0) (u 1)) : RationalUnitPair (t 0) (t 1) := by
    rcases h with ⟨ha,hb⟩ | ⟨ha,hb⟩
    · left
      constructor
      · simpa only [u,RingEquiv.apply_symm_apply,map_neg,map_one] using congrArg e ha
      · simpa only [u,RingEquiv.apply_symm_apply,map_one] using congrArg e hb
    · right
      constructor
      · simpa only [u,RingEquiv.apply_symm_apply,map_one] using congrArg e ha
      · simpa only [u,RingEquiv.apply_symm_apply,map_neg,map_one] using congrArg e hb
  rcases degenerate_pair_model htau hd (u 0) (u 1) hne huprod with h | ⟨rfl,rfl⟩
  · exact ht.rational_unit_pair_impossible hK phi t hmon (hback h)
  · rcases eisenstein_degenerate_pair (u 0) (u 1) hne huprod with h | h | h
    · exact ht.rational_unit_pair_impossible hK phi t hmon (hback h)
    · exact hu.eisenstein_canonical_pair_impossible u h
    · exact (hu.simultaneous_neg u).eisenstein_canonical_pair_impossible (fun i => -u i) h

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.degenerate_first_pair_impossible
