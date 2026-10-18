import D1Bound5.OneSmallFixedCutoffBound
import D1Bound5.OneSmallFixedCutoffMember
import D1Bound5.OneSmallFullRingFinite
import D1Bound5.OneThreeNegative
import D1Bound5.TailIrregular

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

private theorem normalized_integer_anchor
    {K : Type*} [Field K] [NumberField K]
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K) (sgn conj : Bool)
    (z : 𝓞 K) (n : ℤ)
    (h : smallExtensionSymmetry sgn conj (e.symm z) = (n : QuadInt tau nu)) :
    (if sgn then -z else z) = (n : 𝓞 K) := by
  have hc : (if sgn then -e.symm z else e.symm z) = (n : QuadInt tau nu) := by
    cases sgn <;> cases conj
    · simpa [smallExtensionSymmetry] using h
    · simpa [smallExtensionSymmetry] using congrArg star h
    · simpa [smallExtensionSymmetry] using h
    · simpa [smallExtensionSymmetry] using congrArg star h
  cases sgn <;>
    simpa only [Bool.false_eq_true,if_false,if_true,map_neg,map_intCast,
      RingEquiv.apply_symm_apply] using congrArg e hc

private theorem normalized_one_neg_three_three_impossible
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K) (sgn conj : Bool)
    (h0 : smallExtensionSymmetry sgn conj (e.symm (a 0)) = 1)
    (h1 : smallExtensionSymmetry sgn conj (e.symm (a 1)) = -3)
    (h2 : smallExtensionSymmetry sgn conj (e.symm (a 2)) = 3) : False := by
  classical
  let u : Fin 6 → 𝓞 K := fun i => if sgn then -a i else a i
  have hu : IsD1Tuple u := by
    cases sgn
    · exact ha
    · refine ⟨?_,?_,?_⟩
      · intro i j hij
        exact ha.1 (neg_injective hij)
      · intro i hi
        exact ha.2.1 i (neg_eq_zero.mp hi)
      · intro i j hij
        obtain ⟨r,hr⟩ := ha.2.2 i j hij
        exact ⟨r,by simpa only [neg_mul_neg] using hr⟩
  have hu0 : u 0=1 := normalized_integer_anchor e sgn conj (a 0) 1 (by simpa using h0)
  have hu1 : u 1=-3 := normalized_integer_anchor e sgn conj (a 1) (-3) (by simpa using h1)
  have hu2 : u 2=3 := normalized_integer_anchor e sgn conj (a 2) 3 (by simpa using h2)
  let S : Finset (𝓞 K) := Finset.univ.image u
  have hmem (i : Fin 6) : u i ∈ S := Finset.mem_image.mpr ⟨i,Finset.mem_univ i,rfl⟩
  have hS : IsD1 S := by
    constructor
    · intro x hx
      obtain ⟨i,_,rfl⟩ := Finset.mem_image.mp hx
      exact hu.2.1 i
    · intro x hx y hy hxy
      obtain ⟨i,_,rfl⟩ := Finset.mem_image.mp hx
      obtain ⟨j,_,rfl⟩ := Finset.mem_image.mp hy
      exact hu.2.2 i j (fun hij => hxy (congrArg u hij))
  have hcard : S.card=6 := by
    rw [S,Finset.card_image_of_injective Finset.univ hu.1]
    simp
  have hbound := hS.card_le_four_of_one_three_negative hK
    (by simpa only [hu0] using hmem 0) (by simpa only [hu2] using hmem 2)
    ⟨-3,by norm_num,by simpa [hu1] using hmem 1⟩
  omega

/-- Complete analytic/finite join for any of the56 normalized nonrational
first-triple rows. It uses the actual fourth-entry cutoff and the exact
finite extension theorem, against the actual tail-growth lower bound. -/
theorem IsD1Tuple.one_small_normalized_rows_impossible
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K)
    (hrows : OneSmallNormalizedThirdRows (e.symm (a 0)) (e.symm (a 1)) (e.symm (a 2))) :
    False := by
  classical
  obtain ⟨sgn,conj,hrows⟩ := hrows
  dsimp only at hrows
  rcases hrows with ⟨h0,h1,h2⟩ | ⟨cutoff,hrow⟩
  · exact normalized_one_neg_three_three_impossible hK a ha e sgn conj h0 h1 h2
  · let F : 𝓞 K → QuadInt tau nu := fun z => smallExtensionSymmetry sgn conj (e.symm z)
    let r : OneSmallTripleRow :=
      ⟨tau,nu,((F (a 0)).re,(F (a 0)).im),((F (a 1)).re,(F (a 1)).im),
        ((F (a 2)).re,(F (a 2)).im),cutoff⟩
    have hr : r ∈ oneSmallFixedRows := hrow
    obtain ⟨c0,hc0,hc0r⟩ := oneSmallFixedRows_cutoff_member r hr
    let c : OneSmallCutoffRow := {c0 with triple := r}
    have hceq : c=c0 := by
      cases c0
      cases hc0r
      rfl
    have hc : c ∈ oneSmallCutoffRows := by rw [hceq]; exact hc0
    have h0 : F (a 0) = c.triple.anchorA := by apply QuadraticAlgebra.ext <;> rfl
    have h1 : F (a 1) = c.triple.anchorB := by apply QuadraticAlgebra.ext <;> rfl
    have h2 : F (a 2) = c.triple.anchorS := by apply QuadraticAlgebra.ext <;> rfl
    have hcut := ha.fixed_cutoff_fourth_norm_sq_lt hK phi a hmon c hc e sgn conj h0 h1 h2
    change ‖phi (a 3 : K)‖^2 < (cutoff : ℝ) at hcut
    obtain ⟨_,_,hBN,_⟩ := oneSmallFixedRows_metadata r hr
    have hnorm : ‖phi (a 1 : K)‖^2 = ((F (a 1)).norm : ℝ) := by
      simpa only [F,smallExtensionSymmetry_norm,RingEquiv.apply_symm_apply] using
        norm_sq_full_ring_equiv e phi (e.symm (a 1))
    have hBsq : (9 : ℝ) ≤ ‖phi (a 1 : K)‖^2 := by
      rw [hnorm]
      exact_mod_cast hBN
    have hB : 3 ≤ ‖phi (a 1 : K)‖ :=
      (sq_le_sq₀ (by norm_num) (norm_nonneg _)).mp (by simpa using hBsq)
    let ii : Fin 4 → Fin 6 := ![0,1,2,3]
    have hi : Function.Injective ii := by decide
    have him : Monotone ii := by decide
    let t : Fin 4 → 𝓞 K := fun i => a (ii i)
    have ht : IsD1Tuple t := by
      refine ⟨ha.1.comp hi,fun i => ha.2.1 (ii i),?_⟩
      intro i j hij
      exact ha.2.2 (ii i) (ii j) (fun h => hij (hi h))
    have hg : 2*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖ < ‖phi (a 3 : K)‖ :=
      (ht.tail_irregular_and_growth hK phi t (hmon.comp him) hB).2
    have hg2 : 4*‖phi (a 1 : K)‖^2*‖phi (a 2 : K)‖^2 < ‖phi (a 3 : K)‖^2 := by
      have hh := (sq_lt_sq₀ (by positivity : 0 ≤ 2*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖)
        (norm_nonneg (phi (a 3 : K)))).mpr hg
      nlinarith only [hh]
    exact oneSmallRowMembership_full_ring_excludes_irregular_bound e phi sgn conj
      (a 0) (a 1) (a 2) (a 3) cutoff hrow hcut
      (ha.2.2 0 3 (by decide)) (ha.2.2 1 3 (by decide)) (ha.2.2 2 3 (by decide)) hg2

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.one_small_normalized_rows_impossible
