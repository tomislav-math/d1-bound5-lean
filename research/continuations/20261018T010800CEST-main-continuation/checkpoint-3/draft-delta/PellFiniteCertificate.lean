import D1Bound5.PellCFPrefixCheck
import D1Bound5.PellMatchingCheck
import D1Bound5.UnitPairRealReduction
import D1Bound5.FullRingBridge

open scoped NumberField
open Module

namespace D1Bound5

/-- The matching is linked to the actual computed continued-fraction list.
Thus completeness is a proved field of the eventual endpoint, not an
external assertion about a supplied list of Pell solutions. -/
structure PellFiniteCertificate (d X : ℤ) where
  a0 : ℤ
  lastIndex : ℕ
  graph : PellMatchingCertificate d
  prefix_checked : pellCFPrefixCheck d a0 lastIndex = true
  stopping : X < (pellCFAt d a0 (pellCFInit a0) lastIndex).p
  magnitudes_eq :
    (pellCFSolutions d a0 X lastIndex).map (fun uv => uv.1^2-1) = graph.magnitudes

theorem PellFiniteCertificate.signed_member {d X : ℤ}
    (C : PellFiniteCertificate d X) (hd : 7 ≤ d) (hX : 1 ≤ X)
    (u v z : ℤ) (hv : v ≠ 0) (heq : u^2-d*v^2=2)
    (hbound : u^2-1 ≤ X^2) (hz : z=d*v^2+1 ∨ z=-(d*v^2+1)) :
    PellSignedMember C.graph.magnitudes z := by
  have hsol := pellCFSolutions_complete_abs hd C.prefix_checked C.stopping hX hv heq hbound
  have hmem : |u|^2-1 ∈
      (pellCFSolutions d C.a0 X C.lastIndex).map (fun uv => uv.1^2-1) :=
    List.mem_map.mpr ⟨(|u|,|v|),hsol,rfl⟩
  rw [C.magnitudes_eq] at hmem
  rw [sq_abs] at hmem
  refine ⟨u^2-1,hmem,?_⟩
  rcases hz with hz | hz
  · exact Or.inl (by nlinarith [heq])
  · exact Or.inr (by nlinarith [heq])

/-- Convert actual full-ring squares of ordinary integers using the same
fixed d as the Pell description, including zero and negative radicands. -/
theorem UnitPairArithmeticModel.pellIntegerSquare
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (M : UnitPairArithmeticModel (𝓞 K))
    (m : ℤ) (hs : ∃ r : 𝓞 K, r*r = (m : 𝓞 K)) : PellIntegerSquare M.d m := by
  by_cases hm : 0 < m
  · obtain ⟨r,hr⟩ := full_ring_positive_integer_square hK hm hs
    exact Or.inl ⟨r,by nlinarith [hr]⟩
  · obtain ⟨r,hr⟩ := M.negative_square m (by omega) hs
    exact Or.inr ⟨r,by nlinarith [hr]⟩

/-- Closed radius X^2 is represented by squared complex norm at most X^4.
Both signs of each real Pell extension are retained. -/
theorem PellFiniteCertificate.full_ring_member
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ) {d X : ℤ}
    (C : PellFiniteCertificate d X) (hd : 7 ≤ d) (hX : 1 ≤ X)
    (z : 𝓞 K) (hreal : UnitPairRealDescription d z)
    (hbound : ‖phi (z : K)‖^2 ≤ (X : ℝ)^4) :
    ∃ m : ℤ, z=(m : 𝓞 K) ∧ PellSignedMember C.graph.magnitudes m := by
  obtain ⟨u,v,hv,heq,hz⟩ := hreal
  let m : ℤ := d*v^2+1
  have hm : 0 < m := by
    dsimp [m]
    have hp := mul_nonneg (show 0 ≤ d by omega) (sq_nonneg v)
    omega
  obtain ⟨tau,nu,_,_,⟨e⟩⟩ := exists_imaginary_quadratic_ring_equiv hK
  have hint : ‖phi ((m : 𝓞 K) : K)‖^2 = (m : ℝ)^2 := by
    have hh := norm_sq_full_ring_equiv e phi (m : QuadInt tau nu)
    simpa [QuadInt.norm_formula] using hh
  have hn : ‖phi (z : K)‖^2 = (m : ℝ)^2 := by
    rcases hz with hz | hz
    · simpa [m,hz] using hint
    · simpa [m,hz] using hint
  have hbound' : m^2 ≤ X^4 := by
    rw [hn] at hbound
    exact_mod_cast hbound
  have hmag : u^2-1 ≤ X^2 := by
    have hrel : u^2-1=m := by dsimp [m]; nlinarith [heq]
    rw [hrel]
    by_contra h
    have hlo : 0 < m-X^2 := by omega
    have hhi : 0 < m+X^2 := by positivity
    have hp := mul_pos hlo hhi
    nlinarith
  rcases hz with hz | hz
  · exact ⟨m,hz,C.signed_member hd hX u v m hv heq hmag (Or.inl rfl)⟩
  · refine ⟨-m,by simpa only [m,Int.cast_neg] using hz,?_⟩
    exact C.signed_member hd hX u v (-m) hv heq hmag (Or.inr rfl)

/-- The complete finite theorem in the actual full ring. Its only finite
input is a concrete kernel-checked certificate whose list is proved complete
by the ordinary continued-fraction theorem. -/
theorem PellFiniteCertificate.full_ring_no_three
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (M : UnitPairArithmeticModel (𝓞 K)) {X : ℤ}
    (C : PellFiniteCertificate M.d X) (hd : 7 ≤ M.d) (hX : 1 ≤ X)
    (t : Fin 3 → 𝓞 K) (ht : IsD1Tuple t)
    (hreal : ∀ i, UnitPairRealDescription M.d (t i))
    (hbound : ∀ i, ‖phi (t i : K)‖^2 ≤ (X : ℝ)^4) : False := by
  choose z hz hmem using fun i => C.full_ring_member hK phi hd hX (t i) (hreal i) (hbound i)
  have hne (i j : Fin 3) (hij : i ≠ j) : z i ≠ z j := by
    intro he
    apply hij
    apply ht.1
    rw [hz i,hz j,he]
  have hs (i j : Fin 3) (hij : i ≠ j) : PellIntegerSquare M.d (z i*z j+1) := by
    apply M.pellIntegerSquare hK
    obtain ⟨r,hr⟩ := ht.2.2 i j hij
    exact ⟨r,by simpa only [hz i,hz j,Int.cast_add,Int.cast_mul,Int.cast_one] using hr⟩
  exact C.graph.no_three M.positive (z 0) (z 1) (z 2) (hmem 0) (hmem 1) (hmem 2)
    (hne 0 1 (by decide)) (hne 0 2 (by decide)) (hne 1 2 (by decide))
    (hs 0 1 (by decide)) (hs 0 2 (by decide))

end D1Bound5
