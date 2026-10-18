import D1Bound5.ComplexCoordinates
import Mathlib.Data.Int.GCD
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring
import Lean.Elab.Tactic.Omega

namespace D1Bound5

/-- Orthogonal integral vectors of difference norm eight have either an
axis direction or equal absolute first coordinates. Bezout supplies an
integral perpendicular vector; no classification of Pell solutions is used. -/
theorem unit_pair_integer_orthogonal_axes
    (d x y u v : ℤ) (hd : 0 < d)
    (hn : x^2 + u^2 - d*(y^2+v^2) = 8)
    (ho : x*y + u*v = 0) : x*y = 0 ∨ x^2 = u^2 := by
  let g : ℤ := Int.gcd x u
  obtain ⟨p, hp⟩ := Int.gcd_dvd_left x u
  obtain ⟨q, hq⟩ := Int.gcd_dvd_right x u
  change x = g*p at hp
  change u = g*q at hq
  have hg : g ≠ 0 := by
    intro hg
    have hx : x = 0 := by simpa [hg] using hp
    have hu : u = 0 := by simpa [hg] using hq
    have hnonneg := mul_nonneg hd.le (add_nonneg (sq_nonneg y) (sq_nonneg v))
    rw [hx, hu] at hn
    nlinarith only [hn, hnonneg]
  let A := Int.gcdA x u
  let B := Int.gcdB x u
  have hb : p*A + q*B = 1 := by
    apply mul_left_cancel₀ hg
    calc
      g*(p*A+q*B) = x*A+u*B := by rw [hp, hq]; ring
      _ = g := (Int.gcd_eq_gcd_ab x u).symm
      _ = g*1 := by ring
  have hop : p*y + q*v = 0 := by
    have hh : g*(p*y+q*v) = 0 := by
      rw [hp, hq] at ho
      linear_combination ho
    exact (mul_eq_zero.mp hh).resolve_left hg
  let h := B*y-A*v
  have hy : y = h*q := by dsimp [h]; linear_combination A*hop-y*hb
  have hv : v = -h*p := by dsimp [h]; linear_combination B*hop-v*hb
  have hf : (p^2+q^2)*(g^2-d*h^2) = 8 := by
    rw [hp, hq, hy, hv] at hn
    nlinarith only [hn]
  have hpqpos : 0 < p^2+q^2 := by
    by_contra hh
    have hp0 : p = 0 := by nlinarith [sq_nonneg q]
    have hq0 : q = 0 := by nlinarith [sq_nonneg p]
    simp [hp0, hq0] at hb
  have hepos : 0 < g^2-d*h^2 := by
    by_contra hh
    have hnonpos := mul_nonpos_of_nonneg_of_nonpos hpqpos.le (le_of_not_gt hh)
    nlinarith only [hf, hnonpos]
  have heone : 1 ≤ g^2-d*h^2 := by omega
  have hpqle : p^2+q^2 ≤ 8 := by
    have hh := mul_le_mul_of_nonneg_left heone hpqpos.le
    nlinarith only [hh, hf]
  have hpbound : -2 ≤ p ∧ p ≤ 2 := by constructor <;> nlinarith [sq_nonneg q]
  have hqbound : -2 ≤ q ∧ q ≤ 2 := by constructor <;> nlinarith [sq_nonneg p]
  have hpq : p*q = 0 ∨ p^2 = q^2 := by
    interval_cases p <;> interval_cases q <;> norm_num at hf ⊢ <;> omega
  rcases hpq with hpq | hpq
  · left
    rw [hp, hy]
    linear_combination g*h*hpq
  · right
    rw [hp, hq]
    linear_combination g^2*hpq

/-- The second case of the integral orthogonality lemma fixes the real
part of either square. This version is convenient in doubled coordinates. -/
theorem unit_pair_integer_orthogonal_axis_equations
    (d x y u v : ℤ) (hd : 0 < d)
    (hn : x^2+u^2-d*(y^2+v^2) = 8)
    (ho : x*y+u*v = 0) : x*y = 0 ∨ x^2-d*y^2 = 4 := by
  rcases unit_pair_integer_orthogonal_axes d x y u v hd hn ho with h | h
  · exact Or.inl h
  by_cases hx : x = 0
  · exact Or.inl (by simp [hx])
  have hx2 : x^2 ≠ 0 := pow_ne_zero _ hx
  have hyv : y^2 = v^2 := by
    apply mul_left_cancel₀ hx2
    calc
      x^2*y^2 = (x*y)^2 := by ring
      _ = (-u*v)^2 := by congr 1; linarith only [ho]
      _ = u^2*v^2 := by ring
      _ = x^2*v^2 := by rw [h]
  right
  nlinarith only [hn, h, hyv]

namespace QuadInt

/-- Every common extension of {-1,1} lies on the real or imaginary axis.
This holds in every positive-discriminant coordinate order, so both integral
and half-integral full quadratic bases are included. Zero roots are allowed. -/
theorem unit_pair_extension_axes {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (z r s : QuadInt tau nu)
    (hr : r*r = z+1) (hs : s*s = 1-z) :
    z.im = 0 ∨ 2*z.re+tau*z.im = 0 := by
  have hrr := congrArg QuadraticAlgebra.re hr
  have hri := congrArg QuadraticAlgebra.im hr
  have hsr := congrArg QuadraticAlgebra.re hs
  have hsi := congrArg QuadraticAlgebra.im hs
  simp only [QuadraticAlgebra.mul_re, QuadraticAlgebra.mul_im,
    QuadraticAlgebra.add_re, QuadraticAlgebra.add_im,
    QuadraticAlgebra.sub_re, QuadraticAlgebra.sub_im,
    QuadraticAlgebra.one_re, QuadraticAlgebra.one_im] at hrr hri hsr hsi
  let x := 2*r.re+tau*r.im
  let u := 2*s.re+tau*s.im
  have hn : x^2+u^2-discriminant tau nu*(r.im^2+s.im^2) = 8 := by
    dsimp [x, u, discriminant]
    linear_combination 4*hrr+4*hsr+2*tau*hri+2*tau*hsi
  have ho : x*r.im+u*s.im = 0 := by
    dsimp [x, u]
    linear_combination hri+hsi
  rcases unit_pair_integer_orthogonal_axis_equations
    (discriminant tau nu) x r.im u s.im hd hn ho with him | hre
  · left
    dsimp [x] at him
    linear_combination him-hri
  · right
    dsimp [x, discriminant] at hre
    have htrace : 2*(2*z.re+tau*z.im) = 0 := by
      linear_combination hre-4*hrr-2*tau*hri
    omega

end QuadInt
end D1Bound5
