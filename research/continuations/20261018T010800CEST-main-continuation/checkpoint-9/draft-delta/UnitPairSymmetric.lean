import D1Bound5.FullRingBridge
import Mathlib.Tactic.LinearCombination

open scoped NumberField
open Module

namespace D1Bound5

/-- The factorization in the symmetric-five obstruction for the pair
`{-1,1}`. No root is assumed nonzero. -/
theorem unit_pair_symmetric_factorization
    {R : Type*} [CommRing R] (a b x y v w : R)
    (hx : x ^ 2 = 1 - b) (hy : y ^ 2 = 1 + b)
    (hv : v ^ 2 = 1 - a * b) (hw : w ^ 2 = 1 + a * b) :
    ((2 * a ^ 2 * b ^ 2 - a ^ 2 - 1) - 2 * a * x * y * v * w) *
      ((2 * a ^ 2 * b ^ 2 - a ^ 2 - 1) + 2 * a * x * y * v * w) =
        (a ^ 2 - 1) ^ 2 := by
  calc
    _ = (2 * a ^ 2 * b ^ 2 - a ^ 2 - 1) ^ 2 -
        4 * a ^ 2 * x ^ 2 * y ^ 2 * v ^ 2 * w ^ 2 := by ring
    _ = _ := by rw [hx, hy, hv, hw]; ring

/-- The numerical contradiction behind the symmetric-five obstruction.
The two lower bounds will be supplied by integrality of the factors. -/
theorem unit_pair_symmetric_complex_obstruction
    (a b G J : ℂ) (hA : 3 ≤ ‖a‖) (hAB : ‖a‖ ≤ ‖b‖)
    (hG : G = 2 * a ^ 2 * b ^ 2 - a ^ 2 - 1)
    (hid : (G - J) * (G + J) = (a ^ 2 - 1) ^ 2)
    (hm : 1 ≤ ‖G - J‖) (hp : 1 ≤ ‖G + J‖) : False := by
  have hsum : ‖G - J‖ + ‖G + J‖ ≤ ‖G - J‖ * ‖G + J‖ + 1 := by
    nlinarith only [mul_nonneg (sub_nonneg.mpr hm) (sub_nonneg.mpr hp)]
  have htriangle : 2 * ‖G‖ ≤ ‖G - J‖ + ‖G + J‖ := by
    have h := norm_add_le (G - J) (G + J)
    have he : (G - J) + (G + J) = 2 * G := by ring
    rw [he, norm_mul, Complex.norm_two] at h
    exact h
  have hprod : ‖G - J‖ * ‖G + J‖ = ‖a ^ 2 - 1‖ ^ 2 := by
    simpa only [norm_mul, norm_pow] using congrArg norm hid
  have hsub : ‖a ^ 2 - 1‖ ≤ ‖a‖ ^ 2 + 1 := by
    calc
      ‖a ^ 2 - 1‖ ≤ ‖a ^ 2‖ + ‖(1 : ℂ)‖ := norm_sub_le (a ^ 2) (1 : ℂ)
      _ = _ := by rw [Complex.norm_pow, norm_one]
  have hsubsq : ‖a ^ 2 - 1‖ ^ 2 ≤ (‖a‖ ^ 2 + 1) ^ 2 := by
    nlinarith only [hsub, norm_nonneg (a ^ 2 - 1), sq_nonneg ‖a‖]
  have hupper : 2 * ‖G‖ ≤ (‖a‖ ^ 2 + 1) ^ 2 + 1 := by
    nlinarith only [htriangle, hsum, hprod, hsubsq]
  have hlower : 2 * ‖a‖ ^ 2 * ‖b‖ ^ 2 ≤ ‖G‖ + ‖a‖ ^ 2 + 1 := by
    have h1 := norm_add_le G (a ^ 2)
    have h2 := norm_add_le (G + a ^ 2) (1 : ℂ)
    have he : G + a ^ 2 + 1 = 2 * a ^ 2 * b ^ 2 := by rw [hG]; ring
    rw [he] at h2
    simp only [norm_mul, norm_pow, norm_one, Complex.norm_two] at h1 h2
    linarith
  have hAsq : 9 ≤ ‖a‖ ^ 2 := by nlinarith only [hA, sq_nonneg (‖a‖ - 3)]
  have hABsq : ‖a‖ ^ 2 ≤ ‖b‖ ^ 2 := by
    nlinarith only [hAB, norm_nonneg a, norm_nonneg b]
  have hprodlo : ‖a‖ ^ 4 ≤ ‖a‖ ^ 2 * ‖b‖ ^ 2 := by
    have h := mul_le_mul_of_nonneg_left hABsq (sq_nonneg ‖a‖)
    nlinarith only [h]
  nlinarith only [hlower, hupper, hprodlo, hAsq, sq_nonneg (‖a‖ ^ 2 - 9)]

/-- In a discrete complex ring image, the four square conditions of the
ordered symmetric-five argument are impossible once both moduli are at
least three. In particular no root-nonvanishing hypothesis is needed. -/
theorem discrete_unit_pair_symmetric_ordered_obstruction
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (hdiscrete : ∀ z : R, z ≠ 0 → 1 ≤ ‖f z‖)
    (a b x y v w : R) (hA : 3 ≤ ‖f a‖) (hAB : ‖f a‖ ≤ ‖f b‖)
    (hx : x ^ 2 = 1 - b) (hy : y ^ 2 = 1 + b)
    (hv : v ^ 2 = 1 - a * b) (hw : w ^ 2 = 1 + a * b) : False := by
  let G : R := 2 * a ^ 2 * b ^ 2 - a ^ 2 - 1
  let J : R := 2 * a * x * y * v * w
  have hid : (G - J) * (G + J) = (a ^ 2 - 1) ^ 2 :=
    unit_pair_symmetric_factorization a b x y v w hx hy hv hw
  have himage : (f G - f J) * (f G + f J) = ((f a) ^ 2 - 1) ^ 2 := by
    simpa only [map_mul, map_sub, map_add, map_pow, map_one] using congrArg f hid
  have ha1 : (f a) ^ 2 ≠ 1 := by
    intro h
    have hn := congrArg norm h
    simp only [norm_pow, norm_one] at hn
    nlinarith only [hA, hn, sq_nonneg (‖f a‖ - 3)]
  have hrhs : ((f a) ^ 2 - 1) ^ 2 ≠ 0 :=
    pow_ne_zero 2 (sub_ne_zero.mpr ha1)
  have hm : G - J ≠ 0 := by
    intro h
    have hz : f G - f J = 0 := by
      simpa only [map_sub, map_zero] using congrArg f h
    rw [hz, zero_mul] at himage
    exact hrhs himage.symm
  have hp : G + J ≠ 0 := by
    intro h
    have hz : f G + f J = 0 := by
      simpa only [map_add, map_zero] using congrArg f h
    rw [hz, mul_zero] at himage
    exact hrhs himage.symm
  apply unit_pair_symmetric_complex_obstruction (f a) (f b) (f G) (f J) hA hAB
  · simp only [G, map_sub, map_mul, map_pow, map_ofNat, map_one]
  · exact himage
  · simpa only [map_sub] using hdiscrete (G - J) hm
  · simpa only [map_add] using hdiscrete (G + J) hp

/-- Symmetric form of the obstruction: both entries extend `{-1,1}`
and both signs of their product plus one are squares. Ordering is
supplied internally, so no mutation or artificial tuple extension is used. -/
theorem discrete_unit_pair_symmetric_obstruction
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (hdiscrete : ∀ z : R, z ≠ 0 → 1 ≤ ‖f z‖)
    (a b : R) (hA : 3 ≤ ‖f a‖) (hB : 3 ≤ ‖f b‖)
    (ham : ∃ x : R, x ^ 2 = 1 - a) (hap : ∃ y : R, y ^ 2 = 1 + a)
    (hbm : ∃ x : R, x ^ 2 = 1 - b) (hbp : ∃ y : R, y ^ 2 = 1 + b)
    (habm : ∃ v : R, v ^ 2 = 1 - a * b)
    (habp : ∃ w : R, w ^ 2 = 1 + a * b) : False := by
  obtain ⟨v, hv⟩ := habm
  obtain ⟨w, hw⟩ := habp
  rcases le_total ‖f a‖ ‖f b‖ with hAB | hBA
  · obtain ⟨x, hx⟩ := hbm
    obtain ⟨y, hy⟩ := hbp
    exact discrete_unit_pair_symmetric_ordered_obstruction f hdiscrete a b x y v w
      hA hAB hx hy hv hw
  · obtain ⟨x, hx⟩ := ham
    obtain ⟨y, hy⟩ := hap
    exact discrete_unit_pair_symmetric_ordered_obstruction f hdiscrete b a x y v w
      hB hBA hx hy (by simpa only [mul_comm] using hv)
      (by simpa only [mul_comm] using hw)

/-- The actual full-ring symmetric-five obstruction used in the unit-pair
branch of the manuscript. Membership and distinctness provide every
square witness, and full-ring discreteness provides both factor bounds. -/
theorem full_ring_unit_pair_symmetric_five_impossible
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {T : Finset (𝓞 K)} (hT : IsD1 T) (a b : 𝓞 K)
    (hm : (-1 : 𝓞 K) ∈ T) (hp : (1 : 𝓞 K) ∈ T)
    (ha : a ∈ T) (hna : -a ∈ T) (hb : b ∈ T)
    (hab : a ≠ b) (hnab : -a ≠ b)
    (hA : 3 ≤ ‖phi (a : K)‖) (hB : 3 ≤ ‖phi (b : K)‖) : False := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hlarge_ne_one (z : 𝓞 K) (hz : 3 ≤ ‖f z‖) :
      z ≠ 1 ∧ z ≠ -1 := by
    constructor
    · intro h
      rw [h, map_one, norm_one] at hz
      norm_num at hz
    · intro h
      rw [h, map_neg, map_one, norm_neg, norm_one] at hz
      norm_num at hz
  have ha1 := hlarge_ne_one a hA
  have hb1 := hlarge_ne_one b hB
  have hroots (z : 𝓞 K) (hz : z ∈ T) (hz1 : z ≠ 1 ∧ z ≠ -1) :
      (∃ x : 𝓞 K, x ^ 2 = 1 - z) ∧ (∃ y : 𝓞 K, y ^ 2 = 1 + z) := by
    obtain ⟨x, hx⟩ := hT.2 (-1) hm z hz hz1.2.symm
    obtain ⟨y, hy⟩ := hT.2 1 hp z hz hz1.1.symm
    constructor
    · refine ⟨x, ?_⟩
      linear_combination hx
    · refine ⟨y, ?_⟩
      linear_combination hy
  obtain ⟨ham, hap⟩ := hroots a ha ha1
  obtain ⟨hbm, hbp⟩ := hroots b hb hb1
  obtain ⟨v, hv⟩ := hT.2 (-a) hna b hb hnab
  obtain ⟨w, hw⟩ := hT.2 a ha b hb hab
  exact discrete_unit_pair_symmetric_obstruction f
    (fun z hz => one_le_norm_integer hK phi hz) a b hA hB ham hap hbm hbp
    ⟨v, by linear_combination hv⟩ ⟨w, by linear_combination hw⟩

end D1Bound5
