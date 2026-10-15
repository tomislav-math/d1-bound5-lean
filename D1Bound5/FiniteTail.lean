import D1Bound5.SquareTest
import D1Bound5.DiskEnumeration
import D1Bound5.Regular
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.IntervalCases

namespace D1Bound5

open QuadInt

/-- A positive-discriminant coordinate ring has no zero divisors, proved
from its positive multiplicative norm rather than assumed. -/
theorem coordinate_mul_eq_zero {tau nu : ℤ} (hd : 0 < QuadInt.discriminant tau nu)
    (a b : QuadInt tau nu) (h : a*b = 0) : a = 0 ∨ b = 0 := by
  have hn := congrArg (QuadraticAlgebra.norm : QuadInt tau nu → ℤ) h
  rw [map_mul, QuadraticAlgebra.norm_zero] at hn
  rcases mul_eq_zero.mp hn with ha | hb
  · exact Or.inl ((QuadInt.norm_eq_zero_iff hd a).mp ha)
  · exact Or.inr ((QuadInt.norm_eq_zero_iff hd b).mp hb)

/-- Every regular completion is one of the two completions formed from
any chosen root of bc+1. Zero roots cause no exception. -/
theorem regular_completion_cases {tau nu : ℤ} (hd : 0 < QuadInt.discriminant tau nu)
    (b c d r : QuadInt tau nu) (hr : r*r = b*c+1) (hreg : regularDefect b c d = 0) :
    d = b+c+2*r ∨ d = b+c-2*r := by
  have hp : (d-b-c-2*r)*(d-b-c+2*r) = 0 := by
    unfold regularDefect at hreg
    linear_combination hreg-4*hr
  rcases coordinate_mul_eq_zero hd _ _ hp with h | h
  · left
    linear_combination h
  · right
    linear_combination h

/-- Finite exhaustive check for the small-tail case of lem:tail-irregular.
The disk and square-test procedures have independent completeness proofs. -/
def SmallTailCheck (tau nu : ℤ) : Prop :=
  ∀ b ∈ disk tau nu 15, ∀ c ∈ disk tau nu 15,
    9 ≤ b.norm → b.norm ≤ c.norm → b ≠ c →
    hasSquareRoot (b*c+1) = true →
      ∀ d ∈ ({b+c+2*rootCandidate (b*c+1),b+c-2*rootCandidate (b*c+1)} :
          Finset (QuadInt tau nu)),
        d ≠ 0 → d ≠ b → d ≠ c → c.norm ≤ d.norm →
        ∀ a ∈ disk tau nu 15,
          a ≠ 0 → a ≠ b → a ≠ c → a ≠ d → a.norm ≤ b.norm →
          hasSquareRoot (a*b+1) = true → hasSquareRoot (a*c+1) = true →
          hasSquareRoot (a*d+1) = false

/-- A checked finite tail excludes every quadruple covered by its norm
bounds. This theorem proves the enumeration and edge-coverage implication. -/
theorem smallTailCheck_sound {tau nu : ℤ} (hd : 0 < QuadInt.discriminant tau nu)
    (check : SmallTailCheck tau nu) (a b c d : QuadInt tau nu)
    (ha0 : a ≠ 0) (hd0 : d ≠ 0)
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hdb : d ≠ b) (hdc : d ≠ c)
    (hNa : a.norm ≤ b.norm) (hNb : 9 ≤ b.norm)
    (hNbc : b.norm ≤ c.norm) (hNc : c.norm ≤ 15) (hNcd : c.norm ≤ d.norm)
    (hsbc : ∃ r, r*r = b*c+1) (hsab : ∃ r, r*r = a*b+1)
    (hsac : ∃ r, r*r = a*c+1) (hsad : ∃ r, r*r = a*d+1)
    (hreg : regularDefect b c d = 0) : False := by
  have hbmem := (mem_disk_iff hd 15 b).mpr (hNbc.trans hNc)
  have hcmem := (mem_disk_iff hd 15 c).mpr hNc
  have hamem := (mem_disk_iff hd 15 a).mpr (hNa.trans (hNbc.trans hNc))
  have hcheck := check b hbmem c hcmem hNb hNbc hbc
    ((hasSquareRoot_iff hd _).mpr hsbc)
  have hrc := rootCandidate_complete hd hsbc
  have hdmem : d ∈ ({b+c+2*rootCandidate (b*c+1),b+c-2*rootCandidate (b*c+1)} :
      Finset (QuadInt tau nu)) := by
    simpa only [Finset.mem_insert, Finset.mem_singleton] using
      regular_completion_cases hd b c d (rootCandidate (b*c+1)) hrc hreg
  have hfalse := hcheck d hdmem hd0 hdb hdc hNcd a hamem ha0 hab hac had hNa
    ((hasSquareRoot_iff hd _).mpr hsab) ((hasSquareRoot_iff hd _).mpr hsac)
  have htrue := (hasSquareRoot_iff hd _).mpr hsad
  rw [htrue] at hfalse
  contradiction


/-- Integer real coordinates of squared size from nine through fifteen
are precisely plus or minus three. -/
theorem integer_square_nine_fifteen (n : ℤ) (hlo : 9 ≤ n^2) (hhi : n^2 ≤ 15) :
    n = 3 ∨ n = -3 := by
  have h1 : n < 4 := by nlinarith [sq_nonneg (n-4)]
  have h2 : -4 < n := by nlinarith [sq_nonneg (n+4)]
  have h3 : -3 ≤ n := by omega
  have h4 : n ≤ 3 := by omega
  interval_cases n <;> norm_num at *

/-- The small-tail search reduces to Delta<=60 even when both entries
are real. In that case their nonreal square root supplies the cutoff. -/
theorem small_tail_discriminant_bound {tau nu : ℤ}
    (hd : 0 < QuadInt.discriminant tau nu) (b c r : QuadInt tau nu)
    (hbc : b ≠ c) (hNb : 9 ≤ b.norm) (hNbc : b.norm ≤ c.norm)
    (hNc : c.norm ≤ 15) (hr : r*r = b*c+1) : QuadInt.discriminant tau nu ≤ 60 := by
  by_contra hdelta
  have hbim : b.im = 0 := by
    by_contra h
    have := QuadInt.discriminant_le_four_bound hd (hNbc.trans hNc) h
    omega
  have hcim : c.im = 0 := by
    by_contra h
    have := QuadInt.discriminant_le_four_bound hd hNc h
    omega
  have hbN : b.norm = b.re^2 := by simp [QuadInt.norm_formula, hbim]
  have hcN : c.norm = c.re^2 := by simp [QuadInt.norm_formula, hcim]
  have hbchoices := integer_square_nine_fifteen b.re (by omega) (by omega)
  have hcchoices := integer_square_nine_fifteen c.re (by omega) (by omega)
  have hneq : b.re ≠ c.re := by
    intro h
    exact hbc (QuadraticAlgebra.ext h (hbim.trans hcim.symm))
  have hp : b.re*c.re+1 = -8 := by
    rcases hbchoices with h | h <;> rcases hcchoices with h' | h' <;> simp_all
  have hprod : b*c+1 = (⟨-8,0⟩ : QuadInt tau nu) := by
    ext <;> simp [hbim, hcim, QuadraticAlgebra.re_one, QuadraticAlgebra.im_one, hp]
  rw [hprod] at hr
  have hn := congrArg (QuadraticAlgebra.norm : QuadInt tau nu → ℤ) hr
  rw [map_mul] at hn
  have hn2 : r.norm*r.norm = 64 := by simpa [QuadInt.norm_formula] using hn
  have hnr : r.norm = 8 := by
    have hnonneg := QuadInt.norm_nonneg hd r
    nlinarith
  have hrim : r.im = 0 := by
    by_contra h
    have hh := QuadInt.discriminant_le_four_bound hd (le_of_eq hnr) h
    omega
  have hrre := congrArg (fun z : QuadInt tau nu => z.re) hr
  simp [hrim] at hrre
  nlinarith [sq_nonneg r.re]

end D1Bound5
