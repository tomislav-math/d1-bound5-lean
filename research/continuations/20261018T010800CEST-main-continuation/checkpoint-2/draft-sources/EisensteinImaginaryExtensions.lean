import D1Bound5.Basic
import D1Bound5.RationalSquares

namespace D1Bound5

/-- A nonzero purely imaginary Eisenstein integer has nonzero real
coordinate in the basis omega^2-omega+1=0. -/
theorem eisenstein_trace_zero_re_ne_zero (z : QuadInt 1 1)
    (hz : z ≠ 0) (htrace : 2 * z.re + z.im = 0) : z.re ≠ 0 := by
  intro hre
  have him : z.im = 0 := by omega
  apply hz
  apply QuadraticAlgebra.ext
  · simpa only [QuadraticAlgebra.re_zero] using hre
  · simpa only [QuadraticAlgebra.im_zero] using him

/-- The product of two purely imaginary Eisenstein integers is the
ordinary integer -3 times the product of their real coordinates. -/
theorem eisenstein_trace_zero_product (z w : QuadInt 1 1)
    (hz : 2 * z.re + z.im = 0) (hw : 2 * w.re + w.im = 0) :
    z * w + 1 = ((1 - 3 * z.re * w.re : ℤ) : QuadInt 1 1) := by
  have hzi : z.im = -2 * z.re := by omega
  have hwi : w.im = -2 * w.re := by omega
  apply QuadraticAlgebra.ext <;>
    simp only [QuadraticAlgebra.re_mul, QuadraticAlgebra.im_mul,
      QuadraticAlgebra.re_add, QuadraticAlgebra.im_add,
      QuadraticAlgebra.re_one, QuadraticAlgebra.im_one,
      QuadraticAlgebra.re_intCast, QuadraticAlgebra.im_intCast, hzi, hwi] <;>
    ring

/-- Two compatible nonzero purely imaginary Eisenstein integers must
lie on opposite half-axes. The zero-root case is included in the input. -/
theorem eisenstein_trace_zero_compatible_opposite
    (z w : QuadInt 1 1) (hz0 : z ≠ 0) (hw0 : w ≠ 0)
    (hz : 2 * z.re + z.im = 0) (hw : 2 * w.re + w.im = 0)
    (hsquare : ∃ r : QuadInt 1 1, r * r = z * w + 1) :
    z.re * w.re < 0 := by
  have hzn := eisenstein_trace_zero_re_ne_zero z hz0 hz
  have hwn := eisenstein_trace_zero_re_ne_zero w hw0 hw
  have hprod0 : z.re * w.re ≠ 0 := mul_ne_zero hzn hwn
  by_contra hneg
  have hpos : 0 < z.re * w.re := by omega
  have hm : 1 - 3 * z.re * w.re < 0 := by nlinarith only [hpos]
  have hsquare' : ∃ r : QuadInt 1 1,
      r * r = ((1 - 3 * z.re * w.re : ℤ) : QuadInt 1 1) := by
    simpa only [eisenstein_trace_zero_product z w hz hw] using hsquare
  obtain ⟨n, hn⟩ := negative_integer_square_trace_one (nu := 1) hm hsquare'
  norm_num at hn
  ring_nf at hn
  omega

/-- Three nonzero imaginary Eisenstein integers cannot be pairwise
compatible. This arithmetic endpoint is independent of any coordinate
classification or Pell/descent completeness premise. -/
theorem eisenstein_no_three_trace_zero_extensions
    (x y z : QuadInt 1 1) (hx0 : x ≠ 0) (hy0 : y ≠ 0) (hz0 : z ≠ 0)
    (hx : 2 * x.re + x.im = 0) (hy : 2 * y.re + y.im = 0)
    (hz : 2 * z.re + z.im = 0)
    (hxy : ∃ r : QuadInt 1 1, r * r = x * y + 1)
    (hxz : ∃ r : QuadInt 1 1, r * r = x * z + 1)
    (hyz : ∃ r : QuadInt 1 1, r * r = y * z + 1) : False := by
  have h1 := eisenstein_trace_zero_compatible_opposite x y hx0 hy0 hx hy hxy
  have h2 := eisenstein_trace_zero_compatible_opposite x z hx0 hz0 hx hz hxz
  have h3 := eisenstein_trace_zero_compatible_opposite y z hy0 hz0 hy hz hyz
  have hp := mul_pos_of_neg_of_neg h1 h2
  have hn := mul_nonpos_of_nonneg_of_nonpos (sq_nonneg x.re) h3.le
  nlinarith only [hp, hn]

/-- Indexed form suitable for extracting three proper extensions from
a purported tuple containing the exceptional product-minus-one pair. -/
theorem IsD1Tuple.not_all_trace_zero_eisenstein
    (t : Fin 3 → QuadInt 1 1) (ht : IsD1Tuple t)
    (htrace : ∀ i, 2 * (t i).re + (t i).im = 0) : False := by
  exact eisenstein_no_three_trace_zero_extensions (t 0) (t 1) (t 2)
    (ht.2.1 0) (ht.2.1 1) (ht.2.1 2)
    (htrace 0) (htrace 1) (htrace 2)
    (ht.2.2 0 1 (by decide)) (ht.2.2 0 2 (by decide))
    (ht.2.2 1 2 (by decide))

end D1Bound5
