import D1Bound5.UnitPairArithmeticModel
import D1Bound5.UnitPairPellParity

open scoped NumberField
open Module

namespace D1Bound5

def UnitPairRealDescription {R : Type*} [Ring R] (d : ℤ) (z : R) : Prop :=
  ∃ u v : ℤ, v ≠ 0 ∧ u^2-d*v^2 = 2 ∧
    (z = ((d*v^2+1 : ℤ) : R) ∨ z = -((d*v^2+1 : ℤ) : R))

theorem UnitPairRealDescription.is_integer {R : Type*} [Ring R]
    (d : ℤ) (z : R) (h : UnitPairRealDescription d z) : ∃ m : ℤ, z = (m : R) := by
  obtain ⟨u,v,hv,hpell,h | h⟩ := h
  · exact ⟨d*v^2+1,h⟩
  · exact ⟨-(d*v^2+1),by simpa only [Int.cast_neg] using h⟩

theorem UnitPairArithmeticModel.real_imaginary_disjoint
    {R : Type*} [CommRing R] [IsDomain R] [CharZero R]
    (M : UnitPairArithmeticModel R) (z : R) (hz : z ≠ 0)
    (hm : ∃ m : ℤ, z = (m : R)) (hn : ∃ n : ℤ, z = (n : R)*M.w) : False := by
  obtain ⟨m,hm⟩ := hm
  obtain ⟨n,hn⟩ := hn
  have hfix : M.conjugate z = z := by rw [hm,map_intCast]
  have hneg : M.conjugate z = -z := by
    rw [hn,map_mul,map_intCast,M.conjugate_w,mul_neg]
  have htwo : (2 : R)*z = 0 := by linear_combination hfix-hneg
  exact hz ((mul_eq_zero.mp htwo).resolve_left (by norm_num))

theorem UnitPairArithmeticModel.mixed_impossible
    {R : Type*} [CommRing R] (M : UnitPairArithmeticModel R)
    (f : R →+* ℂ) (hdiscrete : ∀ z : R, z ≠ 0 → 1 ≤ ‖f z‖)
    (a b : R) (hA : 3 ≤ ‖f a‖) (hB : 3 ≤ ‖f b‖)
    (ha : ∃ m : ℤ, a = (m : R)) (hb : ∃ n : ℤ, b = (n : R)*M.w)
    (ham : ∃ r : R, r^2 = 1-a) (hap : ∃ r : R, r^2 = 1+a)
    (hbm : ∃ r : R, r^2 = 1-b) (hbp : ∃ r : R, r^2 = 1+b)
    (hab : ∃ r : R, r^2 = 1+a*b) : False := by
  obtain ⟨m,hm⟩ := ha
  obtain ⟨n,hn⟩ := hb
  have hminus : ∃ r : R, r^2 = 1-a*b := by
    rw [hm,hn] at hab ⊢
    exact M.mixed_product_square m n hab
  exact discrete_unit_pair_symmetric_obstruction f hdiscrete a b hA hB
    ham hap hbm hbp hminus hab

private theorem three_nonzero_same_sign (a b c : ℤ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hc : c ≠ 0) :
    0 < a*b ∨ 0 < a*c ∨ 0 < b*c := by
  rcases lt_or_gt_of_ne ha with ha | ha <;>
    rcases lt_or_gt_of_ne hb with hb | hb <;>
    rcases lt_or_gt_of_ne hc with hc | hc
  all_goals first
    | exact Or.inl (mul_pos ha hb)
    | exact Or.inl (mul_pos_of_neg_of_neg ha hb)
    | exact Or.inr (Or.inl (mul_pos ha hc))
    | exact Or.inr (Or.inl (mul_pos_of_neg_of_neg ha hc))
    | exact Or.inr (Or.inr (mul_pos hb hc))
    | exact Or.inr (Or.inr (mul_pos_of_neg_of_neg hb hc))

/-- Among four mutually compatible extensions of the unit pair, every
extension is real. All axis, parity and discreteness inputs are supplied
by the single arithmetic model and the actual square witnesses. -/
theorem UnitPairArithmeticModel.four_extensions_real
    {R : Type*} [CommRing R] [IsDomain R] [CharZero R]
    (M : UnitPairArithmeticModel R) (f : R →+* ℂ)
    (hdiscrete : ∀ z : R, z ≠ 0 → 1 ≤ ‖f z‖)
    (z : Fin 4 → R) (hz : ∀ i, z i ≠ 0)
    (hroots : ∀ i, (∃ r : R, r^2 = 1-z i) ∧ (∃ r : R, r^2 = 1+z i))
    (hpair : ∀ i j, i ≠ j → ∃ r : R, r^2 = 1+z i*z j) :
    ∀ i, UnitPairRealDescription M.d (z i) := by
  classical
  have hpell (i : Fin 4) : UnitPairPellDescription M.d M.w (z i) := by
    obtain ⟨r,hr⟩ := (hroots i).2
    obtain ⟨s,hs⟩ := (hroots i).1
    exact M.pell (z i) r s (hz i)
      (by simpa only [pow_two,add_comm] using hr) (by simpa only [pow_two] using hs)
  have hd : 2 ≤ M.d := (hpell 0).two_le_parameter M.d M.w (z 0) M.positive
  have hnorm (i : Fin 4) : 3 ≤ ‖f (z i)‖ := by
    have hw : f M.w*f M.w = -(M.d : ℂ) := by
      simpa only [map_mul,map_neg,map_intCast] using congrArg f M.square
    have hh := UnitPairPellDescription.norm_lower M.d (f M.w) (f (z i)) M.positive hw
      (UnitPairPellDescription.map f M.d M.w (z i) (hpell i))
    have hdR : (2 : ℝ) ≤ (M.d : ℝ) := by exact_mod_cast hd
    linarith only [hh,hdR]
  have hex : ∃ i, UnitPairRealDescription M.d (z i) := by
    by_contra hnone
    have himag (i : Fin 4) : ∃ n : ℤ, n ≠ 0 ∧ z i = (n : R)*M.w := by
      rcases hpell i with hreal | hi
      · exact (hnone ⟨i,hreal⟩).elim
      · obtain ⟨u,v,hv,hPell,hi⟩ := hi
        refine ⟨2*u*v,?_,hi⟩
        intro hh
        apply hz i
        simpa only [hh,Int.cast_zero,zero_mul] using hi
    obtain ⟨a,ha,hea⟩ := himag 0
    obtain ⟨b,hb,heb⟩ := himag 1
    obtain ⟨c,hc,hec⟩ := himag 2
    have hno (i j : Fin 4) (hij : i ≠ j) (m n : ℤ)
        (hi : z i = (m : R)*M.w) (hj : z j = (n : R)*M.w)
        (hmn : 0 < m*n) : False := by
      obtain ⟨r,hr⟩ := hpair i j hij
      apply M.imaginary_same_axis_impossible hd m n hmn
      exact ⟨r,by simpa only [pow_two,hi,hj,add_comm] using hr⟩
    rcases three_nonzero_same_sign a b c ha hb hc with hab | hac | hbc
    · exact hno 0 1 (by decide) a b hea heb hab
    · exact hno 0 2 (by decide) a c hea hec hac
    · exact hno 1 2 (by decide) b c heb hec hbc
  obtain ⟨i,hi⟩ := hex
  intro j
  rcases hpell j with hreal | himag
  · exact hreal
  · obtain ⟨u,v,hv,hPell,hj⟩ := himag
    have hint := hi.is_integer M.d (z i)
    have hji : ∃ n : ℤ, z j = (n : R)*M.w := ⟨2*u*v,hj⟩
    by_cases hij : i = j
    · subst j
      exact (M.real_imaginary_disjoint (z i) (hz i) hint hji).elim
    · exact (M.mixed_impossible f hdiscrete (z i) (z j) (hnorm i) (hnorm j)
        hint hji (hroots i).1 (hroots i).2 (hroots j).1 (hroots j).2
        (hpair i j hij)).elim

/-- Three real extensions are impossible when the field parameter is even.
The argument uses actual full-ring squares, so it also covers both choices
of sign for each real extension. -/
theorem full_ring_unit_pair_even_three_real_impossible
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (d : ℤ) (hd : 0 < d) (heven : d % 2 = 0)
    (z : Fin 3 → 𝓞 K) (hreal : ∀ i, UnitPairRealDescription d (z i))
    (hpair : ∀ i j, i ≠ j → ∃ r : 𝓞 K, r^2 = 1+z i*z j) : False := by
  obtain ⟨u0,v0,hv0,hp0,hz0⟩ := hreal 0
  obtain ⟨u1,v1,hv1,hp1,hz1⟩ := hreal 1
  obtain ⟨u2,v2,hv2,hp2,hz2⟩ := hreal 2
  have hpositive (v : ℤ) : 0 < d*v^2+1 := by
    nlinarith only [mul_nonneg hd.le (sq_nonneg v)]
  have hmod0 := unit_pair_pell_even_magnitude d u0 v0 heven hp0
  have hmod1 := unit_pair_pell_even_magnitude d u1 v1 heven hp1
  have hmod2 := unit_pair_pell_even_magnitude d u2 v2 heven hp2
  have hno (i j : Fin 3) (hij : i ≠ j) (m n : ℤ)
      (hm : 0 < m) (hn : 0 < n) (hm4 : m % 4 = 3) (hn4 : n % 4 = 3)
      (hprod : z i*z j = ((m*n : ℤ) : 𝓞 K)) : False := by
    obtain ⟨r,hr⟩ := hpair i j hij
    apply full_ring_unit_pair_even_same_sign_impossible hK m n hm hn hm4 hn4
    refine ⟨r,?_⟩
    rw [pow_two,hprod] at hr
    simpa only [Int.cast_add,Int.cast_one,add_comm] using hr
  rcases hz0 with hz0 | hz0 <;> rcases hz1 with hz1 | hz1 <;> rcases hz2 with hz2 | hz2
  · exact hno 0 1 (by decide) _ _ (hpositive v0) (hpositive v1) hmod0 hmod1
      (by rw [hz0,hz1,Int.cast_mul])
  · exact hno 0 1 (by decide) _ _ (hpositive v0) (hpositive v1) hmod0 hmod1
      (by rw [hz0,hz1,Int.cast_mul])
  · exact hno 0 2 (by decide) _ _ (hpositive v0) (hpositive v2) hmod0 hmod2
      (by rw [hz0,hz2,Int.cast_mul])
  · exact hno 1 2 (by decide) _ _ (hpositive v1) (hpositive v2) hmod1 hmod2
      (by rw [hz1,hz2,neg_mul_neg,Int.cast_mul])
  · exact hno 1 2 (by decide) _ _ (hpositive v1) (hpositive v2) hmod1 hmod2
      (by rw [hz1,hz2,Int.cast_mul])
  · exact hno 0 2 (by decide) _ _ (hpositive v0) (hpositive v2) hmod0 hmod2
      (by rw [hz0,hz2,neg_mul_neg,Int.cast_mul])
  · exact hno 0 1 (by decide) _ _ (hpositive v0) (hpositive v1) hmod0 hmod1
      (by rw [hz0,hz1,neg_mul_neg,Int.cast_mul])
  · exact hno 0 1 (by decide) _ _ (hpositive v0) (hpositive v1) hmod0 hmod1
      (by rw [hz0,hz1,neg_mul_neg,Int.cast_mul])

/-- The exact arithmetic reduction for a genuine unit-pair sextuple:
all four other entries are signed norm-two Pell magnitudes for one fixed
positive squarefree d congruent to seven modulo eight. -/
theorem full_ring_unit_pair_four_real_model
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hm : t 0 = -1) (hp : t 1 = 1) :
    ∃ M : UnitPairArithmeticModel (𝓞 K), M.d % 8 = 7 ∧
      ∀ i : Fin 4, UnitPairRealDescription M.d (t ⟨i.val+2,by omega⟩) := by
  classical
  obtain ⟨M⟩ := full_ring_unit_pair_arithmetic_model hK
  let e : Fin 4 → Fin 6 := fun i => ⟨i.val+2,by omega⟩
  let z : Fin 4 → 𝓞 K := fun i => t (e i)
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have he (i j : Fin 4) (hij : i ≠ j) : e i ≠ e j := by
    intro h
    apply hij
    apply Fin.ext
    have hh := congrArg Fin.val h
    dsimp [e] at hh
    omega
  have hz (i : Fin 4) : z i ≠ 0 := ht.2.1 (e i)
  have hroots (i : Fin 4) :
      (∃ r : 𝓞 K, r^2 = 1-z i) ∧ (∃ r : 𝓞 K, r^2 = 1+z i) := by
    have hi0 : (0 : Fin 6) ≠ e i := by dsimp [e]; omega
    have hi1 : (1 : Fin 6) ≠ e i := by dsimp [e]; omega
    obtain ⟨r,hr⟩ := ht.2.2 0 (e i) hi0
    obtain ⟨s,hs⟩ := ht.2.2 1 (e i) hi1
    constructor
    · refine ⟨r,?_⟩
      rw [pow_two,hr,hm]
      dsimp [z]
      ring
    · exact ⟨s,by simpa only [pow_two,hp,one_mul,add_comm] using hs⟩
  have hpair (i j : Fin 4) (hij : i ≠ j) :
      ∃ r : 𝓞 K, r^2 = 1+z i*z j := by
    obtain ⟨r,hr⟩ := ht.2.2 (e i) (e j) (he i j hij)
    exact ⟨r,by simpa only [pow_two,add_comm] using hr⟩
  have hreal := M.four_extensions_real f (fun x hx => one_le_norm_integer hK phi hx)
    z hz hroots hpair
  have hodd : M.d % 2 ≠ 0 := by
    intro heven
    apply full_ring_unit_pair_even_three_real_impossible hK M.d M.positive heven
      (fun i : Fin 3 => z i.castSucc) (fun i => hreal i.castSucc)
    intro i j hij
    apply hpair i.castSucc j.castSucc
    exact fun h => hij (Fin.castSucc_injective 3 h)
  obtain ⟨u,v,_,hPell,_⟩ := hreal 0
  exact ⟨M,unit_pair_pell_odd_parameter M.d u v hodd hPell,hreal⟩

theorem full_ring_unit_pair_four_real_pell
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 6 → 𝓞 K) (ht : IsD1Tuple t)
    (hm : t 0 = -1) (hp : t 1 = 1) :
    ∃ d : ℤ, 0 < d ∧ Squarefree d ∧ d % 8 = 7 ∧
      ∀ i : Fin 4, UnitPairRealDescription d (t ⟨i.val+2,by omega⟩) := by
  obtain ⟨M,hmod,hreal⟩ := full_ring_unit_pair_four_real_model hK phi t ht hm hp
  exact ⟨M.d,M.positive,M.squarefree,hmod,hreal⟩

end D1Bound5
