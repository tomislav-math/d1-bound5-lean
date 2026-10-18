import D1Bound5.UnitPairPellClassification

open scoped NumberField QuadraticAlgebra
open Module

namespace D1Bound5

/-- The actual norm-two real and norm-one imaginary Pell alternatives.
The signed integer v is required to be nonzero. -/
def UnitPairPellDescription {R : Type*} [Ring R] (d : ℤ) (w z : R) : Prop :=
  (∃ u v : ℤ, v ≠ 0 ∧ u^2-d*v^2 = 2 ∧
    (z = ((d*v^2+1 : ℤ) : R) ∨ z = -((d*v^2+1 : ℤ) : R))) ∨
  (∃ u v : ℤ, v ≠ 0 ∧ u^2-d*v^2 = 1 ∧ z = ((2*u*v : ℤ) : R)*w)

/-- Every imaginary quadratic full ring admits one fixed positive squarefree
parameter d and an integral square root of -d for which every nonzero
common extension of {-1,1} has the exact Pell description. The half-integral
basis is handled by a proved root-lifting lemma, not omitted or assumed. -/
theorem full_ring_unit_pair_pell_model
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) :
    ∃ d : ℤ, 0 < d ∧ Squarefree d ∧
      ∃ w : 𝓞 K, w*w = -(d : 𝓞 K) ∧
        ∀ z r s : 𝓞 K, z ≠ 0 → r*r = z+1 → s*s = 1-z →
          UnitPairPellDescription d w z := by
  obtain ⟨tau,nu,htau,hd,⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  rcases htau with rfl | rfl
  · have hnu : 0 < nu := by
      unfold QuadInt.discriminant at hd
      norm_num at hd
      omega
    have hsq : Squarefree nu := squarefree_trace_zero_parameter e hd
    let w : 𝓞 K := e QuadraticAlgebra.omega
    have hw : w*w = -(nu : 𝓞 K) := by
      have hh : (QuadraticAlgebra.omega : QuadInt 0 nu)*QuadraticAlgebra.omega =
          -(nu : QuadInt 0 nu) := by ext <;> simp [QuadraticAlgebra.omega]
      simpa only [w,map_mul,map_neg,map_intCast] using congrArg e hh
    refine ⟨nu,hnu,hsq,w,hw,?_⟩
    intro z r s hz hr hs
    have hz' : e.symm z ≠ 0 := by simpa using hz
    have hr' : e.symm r*e.symm r = e.symm z+1 := by
      simpa only [map_mul,map_add,map_one] using congrArg e.symm hr
    have hs' : e.symm s*e.symm s = 1-e.symm z := by
      simpa only [map_mul,map_sub,map_one] using congrArg e.symm hs
    rcases QuadInt.unit_pair_integer_basis_pell hnu (e.symm z) (e.symm r) (e.symm s)
      hz' hr' hs' with hreal | himag
    · left
      obtain ⟨u,v,hv,hPell,hplus | hminus⟩ := hreal
      · exact ⟨u,v,hv,hPell,Or.inl (by simpa using congrArg e hplus)⟩
      · exact ⟨u,v,hv,hPell,Or.inr (by simpa using congrArg e hminus)⟩
    · right
      obtain ⟨u,v,hv,hPell,hcoord⟩ := himag
      refine ⟨u,v,hv,hPell,?_⟩
      have hh : (⟨0,2*u*v⟩ : QuadInt 0 nu) =
          ((2*u*v : ℤ) : QuadInt 0 nu)*QuadraticAlgebra.omega := by
        ext <;> simp [QuadraticAlgebra.omega]
      rw [hh] at hcoord
      simpa only [w,map_mul,map_intCast,RingEquiv.apply_symm_apply] using congrArg e hcoord
  · have hd' : 0 < 4*nu-1 := by simpa [QuadInt.discriminant] using hd
    have hsq : Squarefree (4*nu-1) := by
      simpa [QuadInt.discriminant] using squarefree_trace_one_discriminant e hd
    let w : 𝓞 K := e ⟨-1,2⟩
    have hw : w*w = -((4*nu-1 : ℤ) : 𝓞 K) := by
      have hh : (⟨-1,2⟩ : QuadInt 1 nu)*⟨-1,2⟩ =
          -((4*nu-1 : ℤ) : QuadInt 1 nu) := by ext <;> simp <;> ring
      simpa only [w,map_mul,map_neg,map_intCast] using congrArg e hh
    refine ⟨4*nu-1,hd',hsq,w,hw,?_⟩
    intro z r s hz hr hs
    have hz' : e.symm z ≠ 0 := by simpa using hz
    have hr' : e.symm r*e.symm r = e.symm z+1 := by
      simpa only [map_mul,map_add,map_one] using congrArg e.symm hr
    have hs' : e.symm s*e.symm s = 1-e.symm z := by
      simpa only [map_mul,map_sub,map_one] using congrArg e.symm hs
    rcases QuadInt.unit_pair_half_basis_pell hd (e.symm z) (e.symm r) (e.symm s)
      hz' hr' hs' with hreal | himag
    · left
      obtain ⟨u,v,hv,hPell,hplus | hminus⟩ := hreal
      · exact ⟨u,v,hv,hPell,Or.inl (by simpa using congrArg e hplus)⟩
      · exact ⟨u,v,hv,hPell,Or.inr (by simpa using congrArg e hminus)⟩
    · right
      obtain ⟨u,v,hv,hPell,hcoord⟩ := himag
      refine ⟨u,v,hv,hPell,?_⟩
      have hh : (⟨-2*u*v,4*u*v⟩ : QuadInt 1 nu) =
          ((2*u*v : ℤ) : QuadInt 1 nu)*⟨-1,2⟩ := by ext <;> simp <;> ring
      rw [hh] at hcoord
      simpa only [w,map_mul,map_intCast,RingEquiv.apply_symm_apply] using congrArg e hcoord

end D1Bound5
