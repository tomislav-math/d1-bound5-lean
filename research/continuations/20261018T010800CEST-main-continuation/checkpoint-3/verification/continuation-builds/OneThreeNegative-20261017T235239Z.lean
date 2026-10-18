import D1Bound5.FullRingRationalSquares
import Mathlib.Tactic.IntervalCases
import Mathlib.Data.Fintype.EquivFin

open scoped NumberField
open Module

namespace D1Bound5

/-- The same field parameter represents every nonpositive integer square;
zero square roots are included. -/
theorem nonpositive_integer_square_trace_zero {d m : ℤ} (hm : m ≤ 0)
    (hr : ∃ r : QuadInt 0 d, r*r = (m : QuadInt 0 d)) :
    ∃ y : ℤ, m = -d*y^2 := by
  rcases eq_or_lt_of_le hm with h | h
  · exact ⟨0, by simp [h]⟩
  · exact negative_integer_square_trace_zero h hr

theorem nonpositive_integer_square_trace_one {nu m : ℤ} (hm : m ≤ 0)
    (hr : ∃ r : QuadInt 1 nu, r*r = (m : QuadInt 1 nu)) :
    ∃ y : ℤ, m = -(4*nu-1)*y^2 := by
  rcases eq_or_lt_of_le hm with h | h
  · exact ⟨0, by simp [h]⟩
  · exact negative_integer_square_trace_one h hr

/-- A common field parameter works simultaneously for all nonpositive
rational integers which are squares in the full number ring. -/
theorem full_ring_nonpositive_integer_squares_common_parameter
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) :
    ∃ d : ℤ, 0 < d ∧ ∀ m : ℤ, m ≤ 0 →
      (∃ r : 𝓞 K, r*r = (m : 𝓞 K)) → ∃ y : ℤ, m = -d*y^2 := by
  obtain ⟨d,hd,_,hc⟩ := exists_full_integer_coordinates hK
  refine ⟨d,hd,?_⟩
  intro m hm hs
  rcases hc with ⟨hmod,⟨e⟩⟩ | ⟨_,⟨e⟩⟩
  · obtain ⟨y,hy⟩ := nonpositive_integer_square_trace_one hm
      (integer_square_under_ring_equiv e m hs)
    have he : 4*((d+1)/4)-1=d := by omega
    exact ⟨y, by simpa [he] using hy⟩
  · exact nonpositive_integer_square_trace_zero hm
      (integer_square_under_ring_equiv e m hs)

private theorem int_square_mod_three (z : ℤ) : z^2 % 3 = 0 ∨ z^2 % 3 = 1 := by
  have hr : 0 ≤ z % 3 := Int.emod_nonneg z (by norm_num)
  have hu : z % 3 < 3 := Int.emod_lt_of_pos z (by norm_num)
  have he : z^2 % 3 = ((z % 3)*(z % 3)) % 3 := by rw [pow_two, Int.mul_emod]
  interval_cases h : z % 3 <;> norm_num [h] at he ⊢ <;> omega

private theorem int_square_mod_four (z : ℤ) : z^2 % 4 = 0 ∨ z^2 % 4 = 1 := by
  have hr : 0 ≤ z % 4 := Int.emod_nonneg z (by norm_num)
  have hu : z % 4 < 4 := Int.emod_lt_of_pos z (by norm_num)
  have he : z^2 % 4 = ((z % 4)*(z % 4)) % 4 := by rw [pow_two, Int.mul_emod]
  interval_cases h : z % 4 <;> norm_num [h] at he ⊢ <;> omega

/-- The negative branch of the two Pell equations fixes d=2 and makes
its absolute value odd. -/
theorem one_three_negative_parameter {d x u v : ℤ} (hd : 0 < d)
    (hu : x-1=d*u^2) (hv : 3*x-1=d*v^2) : d = 2 ∧ x % 2 = 1 := by
  have hdiv : d ∣ 2 := ⟨v^2-3*u^2, by nlinarith [hu,hv]⟩
  have hle : d ≤ 2 := Int.le_of_dvd (by norm_num) hdiv
  have hd12 : d = 1 ∨ d = 2 := by omega
  rcases hd12 with rfl | rfl
  · have h := int_square_mod_three v
    norm_num at hu hv
    omega
  · constructor
    · rfl
    · omega

/-- Positive rational common extensions of 1 and 3 are multiples of eight. -/
theorem one_three_positive_eight_dvd {p r s : ℤ}
    (hr : p+1=r^2) (hs : 3*p+1=s^2) : 8 ∣ p := by
  have hr0 : 0 ≤ r % 8 := Int.emod_nonneg r (by norm_num)
  have hr8 : r % 8 < 8 := Int.emod_lt_of_pos r (by norm_num)
  have hs0 : 0 ≤ s % 8 := Int.emod_nonneg s (by norm_num)
  have hs8 : s % 8 < 8 := Int.emod_lt_of_pos s (by norm_num)
  have her : r^2 % 8 = ((r % 8)*(r % 8)) % 8 := by rw [pow_two, Int.mul_emod]
  have hes : s^2 % 8 = ((s % 8)*(s % 8)) % 8 := by rw [pow_two, Int.mul_emod]
  apply Int.dvd_of_emod_eq_zero
  interval_cases hri : r % 8 <;> interval_cases hsi : s % 8 <;>
    norm_num [hri,hsi] at her hes <;> omega

/-- A positive common extension cannot coexist with a negative one when
all nonpositive square values use the same imaginary quadratic parameter. -/
theorem one_three_mixed_sign_obstruction {p x w : ℤ}
    (hp : 8 ∣ p) (hw : p*x-1=2*w^2) : False := by
  obtain ⟨t,rfl⟩ := hp
  have he : 8*t*x-1 = 2*(w^2) := hw
  have hmul : 8*t*x = 2*(4*t*x) := by ring
  omega

/-- Three odd negative extensions cannot be pairwise compatible. -/
theorem one_three_three_negative_obstruction (x y z r s t : ℤ)
    (hx : x % 2 = 1) (hy : y % 2 = 1) (hz : z % 2 = 1)
    (hr : x*y+1=r^2) (hs : x*z+1=s^2) (ht : y*z+1=t^2) : False := by
  have hxr : x % 4 = 1 ∨ x % 4 = 3 := by omega
  have hyr : y % 4 = 1 ∨ y % 4 = 3 := by omega
  have hzr : z % 4 = 1 ∨ z % 4 = 3 := by omega
  have her : (x*y+1)%4 = ((x%4)*(y%4)+1)%4 := by simp [Int.add_emod, Int.mul_emod]
  have hes : (x*z+1)%4 = ((x%4)*(z%4)+1)%4 := by simp [Int.add_emod, Int.mul_emod]
  have het : (y*z+1)%4 = ((y%4)*(z%4)+1)%4 := by simp [Int.add_emod, Int.mul_emod]
  have hrr := int_square_mod_four r
  have hss := int_square_mod_four s
  have htt := int_square_mod_four t
  rcases hxr with hx | hx <;> rcases hyr with hy | hy <;> rcases hzr with hz | hz <;>
    norm_num [hx,hy,hz,hr,hs,ht] at her hes het <;> omega


/-- Fixed-field version of the negative common-extension restriction. -/
theorem one_three_negative_integer_restriction {K : Type*} [Field K]
    [NumberField K] [NumberField.IsTotallyComplex K]
    (d : ℤ) (hd : 0 < d)
    (hparam : ∀ m : ℤ, m ≤ 0 → (∃ r : 𝓞 K, r*r = (m : 𝓞 K)) →
      ∃ y : ℤ, m = -d*y^2)
    {n : ℤ} (hn : n < 0)
    (hr : ∃ r : 𝓞 K, r*r = (n : 𝓞 K)+1)
    (hs : ∃ s : 𝓞 K, s*s = 3*(n : 𝓞 K)+1) :
    d=2 ∧ n%2=1 := by
  obtain ⟨u,hu⟩ := hparam (n+1) (by omega) (by simpa using hr)
  obtain ⟨v,hv⟩ := hparam (3*n+1) (by omega) (by simpa using hs)
  obtain ⟨hd2,hodd⟩ := one_three_negative_parameter hd
    (x := -n) (u := u) (v := v) (by nlinarith [hu]) (by nlinarith [hv])
  exact ⟨hd2, by omega⟩

/-- Among extensions of 1 and 3, a negative one forces all other
nonzero compatible entries to be negative odd rational integers. -/
theorem full_ring_one_three_negative_extension
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) {n : ℤ} (hn : n < 0)
    (hnr : ∃ r : 𝓞 K, r*r = (n : 𝓞 K)+1)
    (hns : ∃ s : 𝓞 K, s*s = 3*(n : 𝓞 K)+1)
    {z : 𝓞 K} (hz : z ≠ 0)
    (hzr : ∃ r : 𝓞 K, r*r = z+1)
    (hzs : ∃ s : 𝓞 K, s*s = 3*z+1)
    (hzn : z = (n : 𝓞 K) ∨ ∃ r : 𝓞 K, r*r = z*(n : 𝓞 K)+1) :
    ∃ p : ℤ, z=(p : 𝓞 K) ∧ p<0 ∧ p%2=1 := by
  obtain ⟨d,hd,hparam⟩ := full_ring_nonpositive_integer_squares_common_parameter hK
  obtain ⟨rfl,hnodd⟩ := one_three_negative_integer_restriction d hd hparam hn hnr hns
  obtain ⟨p,rfl⟩ := full_ring_one_three_common_extension_is_integer hK hzr hzs
  have hp0 : p ≠ 0 := by intro hp; simpa [hp] using hz
  rcases lt_or_gt_of_ne hp0 with hp | hp
  · exact ⟨p,rfl,hp,(one_three_negative_integer_restriction 2 (by norm_num)
      hparam hp hzr hzs).2⟩
  · obtain ⟨r,hr⟩ := full_ring_positive_integer_square hK (m := p+1)
      (by omega) (by simpa using hzr)
    obtain ⟨s,hs⟩ := full_ring_positive_integer_square hK (m := 3*p+1)
      (by omega) (by simpa using hzs)
    have hp8 := one_three_positive_eight_dvd hr hs
    have hsq : ∃ r : 𝓞 K, r*r = ((p*n+1 : ℤ) : 𝓞 K) := by
      rcases hzn with he | he
      · have he' : p=n := Int.cast_injective he
        omega
      · simpa using he
    have hpn : p*n+1 ≤ 0 := by nlinarith
    obtain ⟨w,hw⟩ := hparam (p*n+1) hpn hsq
    exact False.elim (one_three_mixed_sign_obstruction hp8
      (x := -n) (w := w) (by nlinarith [hw]))

/-- Three negative odd rational integers cannot form a D(1) triple
in any imaginary quadratic full integer ring. -/
theorem full_ring_three_negative_odd_impossible
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (x y z : ℤ)
    (hx : x<0) (hy : y<0) (hz : z<0)
    (hxo : x%2=1) (hyo : y%2=1) (hzo : z%2=1)
    (hxy : ∃ r : 𝓞 K, r*r = (x : 𝓞 K)*(y : 𝓞 K)+1)
    (hxz : ∃ r : 𝓞 K, r*r = (x : 𝓞 K)*(z : 𝓞 K)+1)
    (hyz : ∃ r : 𝓞 K, r*r = (y : 𝓞 K)*(z : 𝓞 K)+1) : False := by
  obtain ⟨r,hr⟩ := full_ring_positive_integer_square hK (m := x*y+1)
    (by have := mul_pos_of_neg_of_neg hx hy; omega) (by simpa using hxy)
  obtain ⟨s,hs⟩ := full_ring_positive_integer_square hK (m := x*z+1)
    (by have := mul_pos_of_neg_of_neg hx hz; omega) (by simpa using hxz)
  obtain ⟨t,ht⟩ := full_ring_positive_integer_square hK (m := y*z+1)
    (by have := mul_pos_of_neg_of_neg hy hz; omega) (by simpa using hyz)
  exact one_three_three_negative_obstruction x y z r s t hxo hyo hzo hr hs ht


/-- Complete negative-entry branch of the manuscript's {1,3} lemma, over
all imaginary quadratic full rings. The extra entry may be -1. -/
theorem IsD1.card_le_four_of_one_three_negative
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) {A : Finset (𝓞 K)} (hA : IsD1 A)
    (h1 : (1 : 𝓞 K) ∈ A) (h3 : (3 : 𝓞 K) ∈ A)
    (hn : ∃ n : ℤ, n<0 ∧ (n : 𝓞 K) ∈ A) : A.card ≤ 4 := by
  classical
  obtain ⟨n,hn,hnA⟩ := hn
  have hn1 : (1 : 𝓞 K) ≠ (n : 𝓞 K) := by
    intro h
    have he : (1 : ℤ)=n := Int.cast_injective (by simpa using h)
    omega
  have hn3 : (3 : 𝓞 K) ≠ (n : 𝓞 K) := by
    intro h
    have he : (3 : ℤ)=n := Int.cast_injective (by simpa using h)
    omega
  have hnr : ∃ r : 𝓞 K, r*r = (n : 𝓞 K)+1 := by
    simpa only [one_mul] using hA.2 1 h1 n hnA hn1
  have hns := hA.2 3 h3 n hnA hn3
  let B := (A.erase 1).erase 3
  have hb (z : 𝓞 K) (hz : z ∈ B) :
      z ∈ A ∧ z ≠ 1 ∧ z ≠ 3 := by
    simp only [B, Finset.mem_erase] at hz
    exact ⟨hz.2.2,hz.2.1,hz.1⟩
  have hneg (z : 𝓞 K) (hz : z ∈ B) :
      ∃ p : ℤ, z=(p : 𝓞 K) ∧ p<0 ∧ p%2=1 := by
    obtain ⟨hzA,hz1,hz3⟩ := hb z hz
    apply full_ring_one_three_negative_extension hK hn hnr hns (hA.1 z hzA)
    · simpa only [one_mul] using hA.2 1 h1 z hzA hz1.symm
    · exact hA.2 3 h3 z hzA hz3.symm
    · by_cases he : z=(n : 𝓞 K)
      · exact Or.inl he
      · exact Or.inr (hA.2 z hzA n hnA he)
  have hB : B.card ≤ 2 := by
    by_contra hle
    obtain ⟨C,hCB,hCcard⟩ := Finset.exists_subset_card_eq (show 3 ≤ B.card by omega)
    let e : Fin 3 ≃ C := (Fintype.equivFinOfCardEq (by simpa using hCcard)).symm
    let f : Fin 3 → 𝓞 K := fun i => (e i).val
    have hf (i : Fin 3) : f i ∈ B := hCB (e i).property
    have hinj : Function.Injective f := by
      intro i j hij
      apply e.injective
      exact Subtype.ext hij
    obtain ⟨x,hx,hxn,hxo⟩ := hneg (f 0) (hf 0)
    obtain ⟨y,hy,hyn,hyo⟩ := hneg (f 1) (hf 1)
    obtain ⟨z,hz,hzn,hzo⟩ := hneg (f 2) (hf 2)
    have hpair (i j : Fin 3) (hij : i ≠ j) :
        ∃ r : 𝓞 K, r*r = f i*f j+1 :=
      hA.2 (f i) (hb (f i) (hf i)).1 (f j) (hb (f j) (hf j)).1
        (fun h => hij (hinj h))
    apply full_ring_three_negative_odd_impossible hK x y z hxn hyn hzn hxo hyo hzo
    · simpa only [hx,hy] using hpair 0 1 (by decide)
    · simpa only [hx,hz] using hpair 0 2 (by decide)
    · simpa only [hy,hz] using hpair 1 2 (by decide)
  have hc1 := Finset.card_erase_add_one h1
  have h3' : (3 : 𝓞 K) ∈ A.erase 1 := by
    exact Finset.mem_erase.mpr ⟨by norm_num,h3⟩
  have hc3 := Finset.card_erase_add_one h3'
  dsimp [B] at hB
  omega

/-- If a D(1)-set containing 1 and 3 has at least five entries, every
entry is a positive ordinary integer, in the same full number ring. -/
theorem IsD1.one_three_all_positive_integers
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) {A : Finset (𝓞 K)} (hA : IsD1 A)
    (h1 : (1 : 𝓞 K) ∈ A) (h3 : (3 : 𝓞 K) ∈ A) (hcard : 4<A.card) :
    ∀ z ∈ A, ∃ n : ℤ, 0<n ∧ z=(n : 𝓞 K) := by
  intro z hz
  by_cases hz1 : z=1
  · exact ⟨1,by norm_num,by simpa using hz1⟩
  by_cases hz3 : z=3
  · exact ⟨3,by norm_num,by simpa using hz3⟩
  obtain ⟨n,rfl⟩ := full_ring_one_three_common_extension_is_integer hK
    (by simpa only [one_mul] using hA.2 1 h1 z hz (Ne.symm hz1))
    (hA.2 3 h3 z hz (Ne.symm hz3))
  have hn0 : n ≠ 0 := by
    intro he
    subst n
    exact hA.1 0 (by simpa using hz) rfl
  have hn : ¬n<0 := by
    intro hn
    have := hA.card_le_four_of_one_three_negative hK h1 h3 ⟨n,hn,hz⟩
    omega
  exact ⟨n,by omega,rfl⟩

end D1Bound5
