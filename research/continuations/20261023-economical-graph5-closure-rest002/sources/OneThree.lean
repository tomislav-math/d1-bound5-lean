import D1Bound5.Coordinates
import Mathlib.Tactic.LinearCombination

namespace D1Bound5

/-- Every positive discriminant of an integral quadratic coordinate ring is
at least three, including nonmaximal orders. -/
theorem QuadInt.three_le_discriminant {tau nu : ℤ}
    (hd : 0 < QuadInt.discriminant tau nu) :
    3 ≤ QuadInt.discriminant tau nu := by
  have hm : tau^2 % 4 = ((tau % 4)*(tau % 4)) % 4 := by
    rw [pow_two, Int.mul_emod]
  have ht : tau % 4 = 0 ∨ tau % 4 = 1 ∨ tau % 4 = 2 ∨ tau % 4 = 3 := by omega
  have hs : tau^2 % 4 = 0 ∨ tau^2 % 4 = 1 := by
    rcases ht with ht | ht | ht | ht <;> norm_num [hm, ht]
  unfold QuadInt.discriminant at hd ⊢
  rcases hs with hs | hs <;> omega


/-- The integral conic obstruction in lem:pr-one-three. Positivity of both
factors already forces k nonzero; no separate irrationality argument is needed. -/
theorem one_three_integer_obstruction (delta e f g h k : ℤ)
    (hd : 3 ≤ delta) (hf : f ≠ 0) (hg : g ≠ 0)
    (him : g*h = 3*e*f)
    (hre : 3*e^2-g^2+delta*(h^2-3*f^2) = 8)
    (hk : e*h-f*g = 2*k) : False := by
  let X := 3*e^2-g^2
  let V := h^2-3*f^2
  have hsum : X+delta*V = 8 := hre
  have hg2 : 0 < g^2 := sq_pos_of_ne_zero hg
  have hf2 : 0 < f^2 := sq_pos_of_ne_zero hf
  have hrel : g^2*V = 3*f^2*X := by
    dsimp [X, V]
    linear_combination (g*h+3*e*f)*him
  have hprod : X*V = 12*k^2 := by
    calc
      _ = 3*(e*h-f*g)^2-(g*h-3*e*f)^2 := by dsimp [X,V]; ring
      _ = 12*k^2 := by rw [him, hk]; ring
  have hX : 0 < X := by
    by_contra hX
    have hXle : X ≤ 0 := le_of_not_gt hX
    have hR : 3*f^2*X ≤ 0 :=
      mul_nonpos_of_nonneg_of_nonpos (mul_nonneg (by norm_num) hf2.le) hXle
    have hVle : V ≤ 0 := by
      by_contra hV
      have hp : 0 < g^2*V := mul_pos hg2 (lt_of_not_ge hV)
      linarith [hrel]
    have hDV : delta*V ≤ 0 := mul_nonpos_of_nonneg_of_nonpos (by omega) hVle
    linarith [hsum]
  have hV : 0 < V := by
    by_contra hV
    have hp : g^2*V ≤ 0 := mul_nonpos_of_nonneg_of_nonpos hg2.le (le_of_not_gt hV)
    have hq : 0 < 3*f^2*X := mul_pos (mul_pos (by norm_num) hf2) hX
    linarith [hrel]
  have hXV : 0 < X*V := mul_pos hX hV
  have hk1 : 1 ≤ k^2 := by omega
  have hdk : 3 ≤ delta*k^2 := by
    have hp := mul_le_mul_of_nonneg_right hd (sq_nonneg k)
    linarith
  have hid : (X+delta*V)^2-(X-delta*V)^2 = 4*delta*(X*V) := by ring
  rw [hsum, hprod] at hid
  nlinarith [sq_nonneg (X-delta*V)]

/-- Every common extension of 1 and 3 has zero imaginary coordinate.
This theorem is over the exact quadratic-coordinate model; the global
full-ring bridge is not assumed or supplied by this declaration. -/
theorem one_three_im_zero (tau nu : ℤ)
    (hd : 0 < QuadInt.discriminant tau nu)
    {z r s : QuadInt tau nu} (hr : r*r = z+1) (hs : s*s = 3*z+1) :
    z.im = 0 := by
  by_contra hz
  have hrI : 2*r.re*r.im+tau*r.im*r.im = z.im := by
    have hi := congrArg (fun q : QuadInt tau nu => q.im) hr
    simp only [QuadraticAlgebra.im_mul, QuadraticAlgebra.im_add,
      QuadraticAlgebra.im_one, add_zero] at hi
    nlinarith [hi]
  have hsI : 2*s.re*s.im+tau*s.im*s.im = 3*z.im := by
    have hi := congrArg (fun q : QuadInt tau nu => q.im) hs
    simp [QuadraticAlgebra.im_one, QuadraticAlgebra.re_ofNat,
      QuadraticAlgebra.im_ofNat] at hi
    nlinarith [hi]
  have hrR : r.re*r.re-nu*r.im*r.im = z.re+1 := by
    have he := congrArg (fun q : QuadInt tau nu => q.re) hr
    simpa only [QuadraticAlgebra.re_mul, QuadraticAlgebra.re_add,
      QuadraticAlgebra.re_one, neg_mul, sub_eq_add_neg] using he
  have hsR : s.re*s.re-nu*s.im*s.im = 3*z.re+1 := by
    have he := congrArg (fun q : QuadInt tau nu => q.re) hs
    simpa [QuadraticAlgebra.re_one, QuadraticAlgebra.re_ofNat,
      QuadraticAlgebra.im_ofNat, neg_mul, sub_eq_add_neg] using he
  let e := 2*r.re+tau*r.im
  let f := r.im
  let g := 2*s.re+tau*s.im
  let h := s.im
  let k := r.re*s.im-r.im*s.re
  have heq : e*f = z.im := by dsimp [e,f]; nlinarith [hrI]
  have hgeq : g*h = 3*z.im := by dsimp [g,h]; nlinarith [hsI]
  have hf : f ≠ 0 := by
    intro hf
    rw [hf, mul_zero] at heq
    exact hz heq.symm
  have hg : g ≠ 0 := by
    intro hg
    rw [hg, zero_mul] at hgeq
    omega
  have him : g*h = 3*e*f := by nlinarith [heq, hgeq]
  have hre : 3*e^2-g^2+QuadInt.discriminant tau nu*(h^2-3*f^2) = 8 := by
    dsimp [e,f,g,h,QuadInt.discriminant]
    linear_combination 12*hrR-4*hsR+6*tau*hrI-2*tau*hsI
  have hk : e*h-f*g = 2*k := by dsimp [e,f,g,h,k]; ring
  exact one_three_integer_obstruction (QuadInt.discriminant tau nu) e f g h k
    (QuadInt.three_le_discriminant hd) hf hg him hre hk

/-- Coordinate-model form of the rationality part of lem:pr-one-three. -/
theorem one_three_common_extension_is_integer (tau nu : ℤ)
    (hd : 0 < QuadInt.discriminant tau nu) {z : QuadInt tau nu}
    (hr : ∃ r, r*r = z+1) (hs : ∃ s, s*s = 3*z+1) :
    ∃ n : ℤ, z = (n : QuadInt tau nu) := by
  obtain ⟨r, hr⟩ := hr
  obtain ⟨s, hs⟩ := hs
  refine ⟨z.re, ?_⟩
  apply QuadraticAlgebra.ext
  · rfl
  · exact one_three_im_zero tau nu hd hr hs

end D1Bound5
