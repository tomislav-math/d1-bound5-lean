import D1Bound5.EisensteinExceptionalPair
import D1Bound5.EisensteinImaginaryExtensions
import Mathlib.Data.Fintype.EquivFin

namespace D1Bound5

/-- A D(1)-tuple containing the exceptional product-minus-one Eisenstein
pair has at most four entries. The actual Pell descent supplies the
trace-zero classification of every remaining entry. -/
theorem IsD1.card_le_four_of_eisenstein_exceptional_pair
    {A : Finset (QuadInt 1 1)} (hA : IsD1 A)
    (ha : (⟨0,-1⟩ : QuadInt 1 1) ∈ A)
    (hb : (⟨1,-1⟩ : QuadInt 1 1) ∈ A) : A.card ≤ 4 := by
  classical
  let a : QuadInt 1 1 := ⟨0,-1⟩
  let b : QuadInt 1 1 := ⟨1,-1⟩
  let B := (A.erase a).erase b
  have hmem (z : QuadInt 1 1) (hz : z ∈ B) : z ∈ A ∧ z ≠ a ∧ z ≠ b := by
    simp only [B, Finset.mem_erase] at hz
    exact ⟨hz.2.2, hz.2.1, hz.1⟩
  have htrace (z : QuadInt 1 1) (hz : z ∈ B) : 2*z.re+z.im = 0 := by
    obtain ⟨hzA, hza, hzb⟩ := hmem z hz
    exact eisenstein_exceptional_pair_extension_trace_zero z
      (hA.2 a ha z hzA hza.symm) (hA.2 b hb z hzA hzb.symm)
  have hB : B.card ≤ 2 := by
    by_contra hle
    obtain ⟨C, hCB, hCcard⟩ :=
      Finset.exists_subset_card_eq (show 3 ≤ B.card by omega)
    let e : Fin 3 ≃ C := (Fintype.equivFinOfCardEq (by simpa using hCcard)).symm
    let f : Fin 3 → QuadInt 1 1 := fun i => (e i).val
    have hf (i : Fin 3) : f i ∈ B := hCB (e i).property
    have hinj : Function.Injective f := by
      intro i j hij
      apply e.injective
      exact Subtype.ext hij
    have hnz (i : Fin 3) : f i ≠ 0 := hA.1 (f i) (hmem (f i) (hf i)).1
    have hpair (i j : Fin 3) (hij : i ≠ j) :
        ∃ r : QuadInt 1 1, r*r = f i*f j+1 :=
      hA.2 (f i) (hmem (f i) (hf i)).1 (f j) (hmem (f j) (hf j)).1
        (fun h => hij (hinj h))
    exact eisenstein_no_three_trace_zero_extensions (f 0) (f 1) (f 2)
      (hnz 0) (hnz 1) (hnz 2)
      (htrace (f 0) (hf 0)) (htrace (f 1) (hf 1)) (htrace (f 2) (hf 2))
      (hpair 0 1 (by decide)) (hpair 0 2 (by decide)) (hpair 1 2 (by decide))
  have hca := Finset.card_erase_add_one ha
  have hb' : b ∈ A.erase a :=
    Finset.mem_erase.mpr ⟨by decide, hb⟩
  have hcb := Finset.card_erase_add_one hb'
  dsimp [B, a, b] at hB hb' hcb
  omega

/-- The exceptional-pair bound transports through an actual ring
equivalence. In particular this applies to the full Eisenstein integer
ring in any of its proved number-field presentations. -/
theorem IsD1.card_le_four_of_eisenstein_exceptional_pair_equiv
    {R : Type*} [CommRing R] (e : QuadInt 1 1 ≃+* R)
    {A : Finset R} (hA : IsD1 A)
    (ha : e (⟨0,-1⟩ : QuadInt 1 1) ∈ A)
    (hb : e (⟨1,-1⟩ : QuadInt 1 1) ∈ A) : A.card ≤ 4 := by
  classical
  let B := A.map ⟨e.symm, e.symm.injective⟩
  have hB : IsD1 B := hA.map_equiv e.symm
  have ha' : (⟨0,-1⟩ : QuadInt 1 1) ∈ B := by
    apply Finset.mem_map.mpr
    exact ⟨e (⟨0,-1⟩ : QuadInt 1 1), ha, e.symm_apply_apply _⟩
  have hb' : (⟨1,-1⟩ : QuadInt 1 1) ∈ B := by
    apply Finset.mem_map.mpr
    exact ⟨e (⟨1,-1⟩ : QuadInt 1 1), hb, e.symm_apply_apply _⟩
  have hc := hB.card_le_four_of_eisenstein_exceptional_pair ha' hb'
  simpa only [B, Finset.card_map] using hc

end D1Bound5
