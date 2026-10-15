import D1Bound5.FiniteTail
import D1Bound5.FullRingBridge

namespace D1Bound5

/-- In the normalized full integral basis, a positive discriminant at most
60 forces the remaining generator coefficient to lie between 1 and 15.
This stronger uniform rectangular reduction deliberately includes all
30 trace/parameter pairs, even models not needed for maximal orders. -/
theorem small_tail_parameter_range (tau nu : ℤ)
    (htau : tau = 0 ∨ tau = 1)
    (hpos : 0 < QuadInt.discriminant tau nu)
    (hcut : QuadInt.discriminant tau nu ≤ 60) :
    1 ≤ nu ∧ nu ≤ 15 := by
  rcases htau with rfl | rfl
  · change 0 < 4*nu-0^2 at hpos
    change 4*nu-0^2 ≤ 60 at hcut
    omega
  · change 0 < 4*nu-1^2 at hpos
    change 4*nu-1^2 ≤ 60 at hcut
    omega

/-- A complete checker for the 30-element parameter rectangle suffices
for the small-tail regular-completion obstruction. The finite Boolean
certificates are separate, still-open obligations. -/
theorem small_tail_of_rectangular_certificates
    (certificate : ∀ tau nu : ℤ,
      (tau = 0 ∨ tau = 1) →
      1 ≤ nu → nu ≤ 15 →
      0 < QuadInt.discriminant tau nu →
      SmallTailCheck tau nu)
    {tau nu : ℤ} (htau : tau = 0 ∨ tau = 1)
    (hpos : 0 < QuadInt.discriminant tau nu)
    (a b c d : QuadInt tau nu)
    (ha0 : a ≠ 0) (hd0 : d ≠ 0)
    (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hdb : d ≠ b) (hdc : d ≠ c)
    (hNa : a.norm ≤ b.norm) (hNb : 9 ≤ b.norm)
    (hNbc : b.norm ≤ c.norm) (hNc : c.norm ≤ 15) (hNcd : c.norm ≤ d.norm)
    (hsbc : ∃ r, r*r = b*c+1) (hsab : ∃ r, r*r = a*b+1)
    (hsac : ∃ r, r*r = a*c+1) (hsad : ∃ r, r*r = a*d+1)
    (hreg : regularDefect b c d = 0) : False := by
  obtain ⟨r,hr⟩ := hsbc
  have hdiscr := small_tail_discriminant_bound hpos b c r hbc hNb hNbc hNc hr
  obtain ⟨hlo,hhi⟩ := small_tail_parameter_range tau nu htau hpos hdiscr
  exact smallTailCheck_sound hpos (certificate tau nu htau hlo hhi hpos)
    a b c d ha0 hd0 hab hac had hbc hdb hdc
    hNa hNb hNbc hNc hNcd ⟨r,hr⟩ hsab hsac hsad hreg

end D1Bound5
