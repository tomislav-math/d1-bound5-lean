import D1Bound5.PairExtensionCore
import D1Bound5.SmallQuadrupleData

namespace D1Bound5
open QuadInt

/-- A root of a first-pair product needs only the norm-eight disk. -/
theorem first_pair_root_norm_le_eight {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b q : QuadInt tau nu)
    (hab : a.norm*b.norm ≤ 63) (hq : q*q = a*b+1) : q.norm ≤ 8 := by
  let z := a*b
  let v : ℤ := 2*z.re+tau*z.im
  have hv : v^2 ≤ 4*z.norm := by
    have hdisc := mul_nonneg (le_of_lt hd) (sq_nonneg z.im)
    have hfour : 4*z.norm = v^2+discriminant tau nu*z.im^2 := by
      simp only [norm_formula, discriminant]
      dsimp [v]
      ring
    nlinarith only [hfour, hdisc]
  have hz : z.norm ≤ 63 := by simpa only [z, map_mul] using hab
  have hv15 : v ≤ 15 := by
    by_contra h
    have hv16 : 16 ≤ v := by omega
    nlinarith
  have hid : (z+1).norm = z.norm+v+1 := by
    simp only [norm_formula, QuadraticAlgebra.re_add, QuadraticAlgebra.im_add,
      QuadraticAlgebra.re_one, QuadraticAlgebra.im_one]
    dsimp [v]
    ring
  have hsq : q.norm*q.norm = (z+1).norm := by rw [← map_mul, hq]
  by_contra h
  have hq9 : 9 ≤ q.norm := by omega
  nlinarith

/-- A uniform root bound for all 56 fourth-entry certificates. -/
theorem one_small_fourth_root_norm_le {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a z q : QuadInt tau nu)
    (ha : a.norm ≤ 2) (hz : z.norm ≤ 21270) (hq : q*q = a*z+1) :
    q.norm ≤ 300 := by
  have hz0 := norm_nonneg hd z
  have hsum := quadInt_norm_add_le_twice hd (a*z) 1
  have hsq : q.norm*q.norm = (a*z+1).norm := by rw [← map_mul, hq]
  have hone : (1 : QuadInt tau nu).norm = 1 := by norm_num [norm_formula]
  rw [map_mul, hone] at hsum
  have hprod : a.norm*z.norm ≤ 2*21270 := mul_le_mul ha hz hz0 (by norm_num)
  by_contra h
  have h301 : 301 ≤ q.norm := by omega
  nlinarith

/-- Ordered coordinates retain which anchor is small. -/
def firstPairCoordinates {tau nu : ℤ} (a b : QuadInt tau nu) :
    (ℤ × ℤ) × (ℤ × ℤ) := ((a.re,a.im),(b.re,b.im))

/-- Exact first-pair size restrictions after the analytic region reduction. -/
def FirstPairNorms {tau nu : ℤ} (a b : QuadInt tau nu) : Prop :=
  (a.norm = 1 ∧ 9 ≤ b.norm ∧ b.norm ≤ 63) ∨
  (a.norm = 2 ∧ 9 ≤ b.norm ∧ b.norm ≤ 15)

instance {tau nu : ℤ} (a b : QuadInt tau nu) : Decidable (FirstPairNorms a b) := by
  unfold FirstPairNorms
  infer_instance

def firstPairClassifiedBool {tau nu : ℤ}
    (small roots : List (QuadInt tau nu))
    (rows : List ((ℤ × ℤ) × (ℤ × ℤ))) : Bool :=
  small.all fun a =>
    if decide (a ≠ 0) then
      roots.all fun q =>
        let b := pairSeedCandidate a q
        if decide (q*q = a*b+1 ∧ FirstPairNorms a b) then
          decide ((a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨
            firstPairCoordinates a b ∈ rows)
        else true
    else true

theorem firstPairClassified_of_checked {tau nu : ℤ}
    (hd : 0 < discriminant tau nu)
    (small roots : List (QuadInt tau nu))
    (rows : List ((ℤ × ℤ) × (ℤ × ℤ)))
    (hsmall : ∀ a ∈ disk tau nu 8, a ∈ small)
    (hroots : ∀ q ∈ disk tau nu 8, q ∈ roots)
    (hcheck : firstPairClassifiedBool small roots rows = true)
    (a b : QuadInt tau nu) (hnorm : FirstPairNorms a b)
    (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ rows := by
  have ha : a ≠ 0 := by
    intro h
    rcases hnorm with hN | hN <;> simp [h, norm_formula] at hN
  have hNa : a.norm ≤ 8 := by rcases hnorm with hN | hN <;> omega
  have hprod : a.norm*b.norm ≤ 63 := by
    rcases hnorm with hN | hN
    · rw [hN.1]
      simpa using hN.2.2
    · rw [hN.1]
      omega
  obtain ⟨q,hq⟩ := hroot
  have hNq := first_pair_root_norm_le_eight hd a b q hprod hq
  have hma := hsmall a ((mem_disk_iff hd 8 a).2 hNa)
  have hmq := hroots q ((mem_disk_iff hd 8 q).2 hNq)
  have hc := List.all_eq_true.mp hcheck a hma
  have ga : decide (a ≠ 0) = true := by simp [ha]
  simp only [ga, if_true] at hc
  have hcq := List.all_eq_true.mp hc q hmq
  have heq := pairSeedCandidate_eq hd a b q ha hq
  simpa [heq, hq, hnorm] using hcq

/-- The full third-entry disk is small enough to check directly. -/
def oneSmallThirdCoveredBool {tau nu : ℤ} (a b : QuadInt tau nu)
    (diskEntries allowed : List (QuadInt tau nu)) : Bool :=
  diskEntries.all fun s =>
    if decide (b.norm ≤ s.norm ∧ s ≠ a ∧ s ≠ b) then
      if hasSquareRoot (a*s+1) && hasSquareRoot (b*s+1) then
        decide (s ∈ allowed)
      else true
    else true

theorem oneSmallThirdCovered_of_checked {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b : QuadInt tau nu)
    (diskEntries allowed : List (QuadInt tau nu))
    (hcover : ∀ s ∈ disk tau nu 224, s ∈ diskEntries)
    (hcheck : oneSmallThirdCoveredBool a b diskEntries allowed = true)
    (s : QuadInt tau nu) (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) : s ∈ allowed := by
  have hm := hcover s ((mem_disk_iff hd 224 s).2 hbound)
  have hc := List.all_eq_true.mp hcheck s hm
  have hra := (hasSquareRoot_iff hd _).2 hpair.1
  have hrb := (hasSquareRoot_iff hd _).2 hpair.2
  simpa [horder, ha, hb, hra, hrb] using hc

/-- No intermediate or final nonzero/distinctness condition is needed here. -/
def oneSmallFourthGrowthBool {tau nu : ℤ} (a b s : QuadInt tau nu)
    (cutoff : ℤ) (roots : List (QuadInt tau nu)) : Bool :=
  roots.all fun q =>
    let z := pairSeedCandidate a q
    if decide (q*q = a*z+1 ∧ z.norm < cutoff) then
      if hasSquareRoot (b*z+1) && hasSquareRoot (s*z+1) then
        decide (z.norm ≤ 4*b.norm*s.norm)
      else true
    else true

theorem oneSmallFourthGrowth_of_checked {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b s : QuadInt tau nu)
    (ha : a ≠ 0) (hNa : a.norm ≤ 2) (cutoff : ℤ) (hcutoff : cutoff ≤ 21270)
    (roots : List (QuadInt tau nu))
    (hcover : ∀ q ∈ disk tau nu 300, q ∈ roots)
    (hcheck : oneSmallFourthGrowthBool a b s cutoff roots = true)
    (z : QuadInt tau nu) (hz : z.norm < cutoff)
    (hza : ∃ q, q*q = a*z+1) (hzb : ∃ q, q*q = b*z+1)
    (hzs : ∃ q, q*q = s*z+1) : z.norm ≤ 4*b.norm*s.norm := by
  obtain ⟨q,hq⟩ := hza
  have hNq := one_small_fourth_root_norm_le hd a z q hNa (by omega) hq
  have hmq := hcover q ((mem_disk_iff hd 300 q).2 hNq)
  have hc := List.all_eq_true.mp hcheck q hmq
  have heq := pairSeedCandidate_eq hd a z q ha hq
  have hrb := (hasSquareRoot_iff hd _).2 hzb
  have hrs := (hasSquareRoot_iff hd _).2 hzs
  simpa [heq, hq, hz, hrb, hrs] using hc

end D1Bound5
