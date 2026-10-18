import D1Bound5.RationalSquares

namespace D1Bound5

private theorem trace_axis_one_sub_mul_neg (d p : ℤ) (hd : 1 < d) (hp : 0 < p) :
    1 - d * p < 0 := by
  have hp1 : 1 ≤ p := by omega
  have hd0 : 0 ≤ d := by omega
  have hmul := mul_le_mul_of_nonneg_left hp1 hd0
  nlinarith only [hd, hmul]

private theorem trace_axis_one_sub_mul_ne_neg_square (d p n : ℤ) (hd : 1 < d)
    (h : 1 - d * p = -d * n ^ 2) : False := by
  have hdiv : d ∣ (1 : ℤ) := ⟨p - n ^ 2, by nlinarith only [h]⟩
  have hle : d ≤ 1 := Int.le_of_dvd (by norm_num) hdiv
  omega

/-- Nonzero trace-zero elements in the trace-zero basis have nonzero
imaginary coordinate. -/
theorem trace_zero_tau_zero_im_ne_zero {nu : ℤ} (z : QuadInt 0 nu)
    (hz0 : z ≠ 0) (hz : 2 * z.re = 0) : z.im ≠ 0 := by
  have hre : z.re = 0 := by omega
  intro him
  apply hz0
  apply QuadraticAlgebra.ext
  · simpa only [QuadraticAlgebra.re_zero] using hre
  · simpa only [QuadraticAlgebra.im_zero] using him

/-- Exact product on the imaginary axis in the trace-zero basis. -/
theorem trace_zero_tau_zero_product {nu : ℤ} (z w : QuadInt 0 nu)
    (hz : 2 * z.re = 0) (hw : 2 * w.re = 0) :
    z * w + 1 = ((1 - nu * z.im * w.im : ℤ) : QuadInt 0 nu) := by
  have hzr : z.re = 0 := by omega
  have hwr : w.re = 0 := by omega
  apply QuadraticAlgebra.ext <;>
    simp only [QuadraticAlgebra.re_mul, QuadraticAlgebra.im_mul,
      QuadraticAlgebra.re_add, QuadraticAlgebra.im_add,
      QuadraticAlgebra.re_one, QuadraticAlgebra.im_one,
      QuadraticAlgebra.re_intCast, QuadraticAlgebra.im_intCast, Int.cast_id, hzr, hwr] <;>
    ring

/-- Two compatible nonzero imaginary-axis elements have opposite signs.
The assumption nu>1 excludes the Gaussian case. -/
theorem trace_zero_tau_zero_compatible_opposite {nu : ℤ} (hnu : 1 < nu)
    (z w : QuadInt 0 nu) (hz0 : z ≠ 0) (hw0 : w ≠ 0)
    (hz : 2 * z.re = 0) (hw : 2 * w.re = 0)
    (hsquare : ∃ r : QuadInt 0 nu, r * r = z * w + 1) :
    z.im * w.im < 0 := by
  have hzn := trace_zero_tau_zero_im_ne_zero z hz0 hz
  have hwn := trace_zero_tau_zero_im_ne_zero w hw0 hw
  have hprod0 : z.im * w.im ≠ 0 := mul_ne_zero hzn hwn
  by_contra hneg
  have hpos : 0 < z.im * w.im := by omega
  have hm : 1 - nu * z.im * w.im < 0 := by
    simpa only [mul_assoc] using trace_axis_one_sub_mul_neg nu (z.im * w.im) hnu hpos
  have hsquare' : ∃ r : QuadInt 0 nu,
      r * r = ((1 - nu * z.im * w.im : ℤ) : QuadInt 0 nu) := by
    simpa only [trace_zero_tau_zero_product z w hz hw] using hsquare
  obtain ⟨n, hn⟩ := negative_integer_square_trace_zero hm hsquare'
  apply trace_axis_one_sub_mul_ne_neg_square nu (z.im * w.im) n hnu
  simpa only [mul_assoc] using hn

/-- Three nonzero trace-zero elements cannot be pairwise compatible
in a trace-zero quadratic basis with nu>1. Zero square roots are allowed. -/
theorem trace_zero_no_three_tau_zero {nu : ℤ} (hnu : 1 < nu)
    (x y z : QuadInt 0 nu) (hx0 : x ≠ 0) (hy0 : y ≠ 0) (hz0 : z ≠ 0)
    (hx : 2 * x.re = 0) (hy : 2 * y.re = 0) (hz : 2 * z.re = 0)
    (hxy : ∃ r : QuadInt 0 nu, r * r = x * y + 1)
    (hxz : ∃ r : QuadInt 0 nu, r * r = x * z + 1)
    (hyz : ∃ r : QuadInt 0 nu, r * r = y * z + 1) : False := by
  have h1 := trace_zero_tau_zero_compatible_opposite hnu x y hx0 hy0 hx hy hxy
  have h2 := trace_zero_tau_zero_compatible_opposite hnu x z hx0 hz0 hx hz hxz
  have h3 := trace_zero_tau_zero_compatible_opposite hnu y z hy0 hz0 hy hz hyz
  have hp := mul_pos_of_neg_of_neg h1 h2
  have hn := mul_nonpos_of_nonneg_of_nonpos (sq_nonneg x.im) h3.le
  nlinarith only [hp, hn]

/-- Nonzero trace-zero elements in the trace-one basis have nonzero
real coordinate. -/
theorem trace_zero_tau_one_re_ne_zero {nu : ℤ} (z : QuadInt 1 nu)
    (hz0 : z ≠ 0) (hz : 2 * z.re + z.im = 0) : z.re ≠ 0 := by
  intro hre
  have him : z.im = 0 := by omega
  apply hz0
  apply QuadraticAlgebra.ext
  · simpa only [QuadraticAlgebra.re_zero] using hre
  · simpa only [QuadraticAlgebra.im_zero] using him

/-- Exact product on the imaginary axis in the trace-one basis. -/
theorem trace_zero_tau_one_product {nu : ℤ} (z w : QuadInt 1 nu)
    (hz : 2 * z.re + z.im = 0) (hw : 2 * w.re + w.im = 0) :
    z * w + 1 = ((1 - (4 * nu - 1) * z.re * w.re : ℤ) : QuadInt 1 nu) := by
  have hzi : z.im = -2 * z.re := by omega
  have hwi : w.im = -2 * w.re := by omega
  apply QuadraticAlgebra.ext <;>
    simp only [QuadraticAlgebra.re_mul, QuadraticAlgebra.im_mul,
      QuadraticAlgebra.re_add, QuadraticAlgebra.im_add,
      QuadraticAlgebra.re_one, QuadraticAlgebra.im_one,
      QuadraticAlgebra.re_intCast, QuadraticAlgebra.im_intCast, Int.cast_id, hzi, hwi] <;>
    ring

/-- Two compatible nonzero trace-zero elements in a trace-one basis
have real coordinates of opposite signs. -/
theorem trace_zero_tau_one_compatible_opposite {nu : ℤ} (hnu : 1 < 4 * nu - 1)
    (z w : QuadInt 1 nu) (hz0 : z ≠ 0) (hw0 : w ≠ 0)
    (hz : 2 * z.re + z.im = 0) (hw : 2 * w.re + w.im = 0)
    (hsquare : ∃ r : QuadInt 1 nu, r * r = z * w + 1) :
    z.re * w.re < 0 := by
  have hzn := trace_zero_tau_one_re_ne_zero z hz0 hz
  have hwn := trace_zero_tau_one_re_ne_zero w hw0 hw
  have hprod0 : z.re * w.re ≠ 0 := mul_ne_zero hzn hwn
  by_contra hneg
  have hpos : 0 < z.re * w.re := by omega
  have hm : 1 - (4 * nu - 1) * z.re * w.re < 0 := by
    simpa only [mul_assoc] using
      trace_axis_one_sub_mul_neg (4 * nu - 1) (z.re * w.re) hnu hpos
  have hsquare' : ∃ r : QuadInt 1 nu,
      r * r = ((1 - (4 * nu - 1) * z.re * w.re : ℤ) : QuadInt 1 nu) := by
    simpa only [trace_zero_tau_one_product z w hz hw] using hsquare
  obtain ⟨n, hn⟩ := negative_integer_square_trace_one hm hsquare'
  apply trace_axis_one_sub_mul_ne_neg_square (4 * nu - 1) (z.re * w.re) n hnu
  simpa only [mul_assoc] using hn

/-- Three nonzero trace-zero elements cannot be pairwise compatible
in the trace-one basis when 4*nu-1>1. -/
theorem trace_zero_no_three_tau_one {nu : ℤ} (hnu : 1 < 4 * nu - 1)
    (x y z : QuadInt 1 nu) (hx0 : x ≠ 0) (hy0 : y ≠ 0) (hz0 : z ≠ 0)
    (hx : 2 * x.re + x.im = 0) (hy : 2 * y.re + y.im = 0)
    (hz : 2 * z.re + z.im = 0)
    (hxy : ∃ r : QuadInt 1 nu, r * r = x * y + 1)
    (hxz : ∃ r : QuadInt 1 nu, r * r = x * z + 1)
    (hyz : ∃ r : QuadInt 1 nu, r * r = y * z + 1) : False := by
  have h1 := trace_zero_tau_one_compatible_opposite hnu x y hx0 hy0 hx hy hxy
  have h2 := trace_zero_tau_one_compatible_opposite hnu x z hx0 hz0 hx hz hxz
  have h3 := trace_zero_tau_one_compatible_opposite hnu y z hy0 hz0 hy hz hyz
  have hp := mul_pos_of_neg_of_neg h1 h2
  have hn := mul_nonpos_of_nonneg_of_nonpos (sq_nonneg x.re) h3.le
  nlinarith only [hp, hn]

/-- Uniform algebraic endpoint for the two supported quadratic bases.
This needs only actual nonzero trace-zero vertices and square witnesses;
there is no finite graph or pairwise nonvanishing certificate premise. -/
theorem quadInt_no_three_nonzero_trace_zero {tau nu : ℤ}
    (hmodel : (tau = 0 ∧ 1 < nu) ∨ (tau = 1 ∧ 1 < 4 * nu - 1))
    (x y z : QuadInt tau nu) (hx0 : x ≠ 0) (hy0 : y ≠ 0) (hz0 : z ≠ 0)
    (hx : 2 * x.re + tau * x.im = 0) (hy : 2 * y.re + tau * y.im = 0)
    (hz : 2 * z.re + tau * z.im = 0)
    (hxy : ∃ r : QuadInt tau nu, r * r = x * y + 1)
    (hxz : ∃ r : QuadInt tau nu, r * r = x * z + 1)
    (hyz : ∃ r : QuadInt tau nu, r * r = y * z + 1) : False := by
  rcases hmodel with ⟨ht, hnu⟩ | ⟨ht, hnu⟩
  · subst tau
    apply trace_zero_no_three_tau_zero hnu x y z hx0 hy0 hz0
      (by simpa only [zero_mul, add_zero] using hx)
      (by simpa only [zero_mul, add_zero] using hy)
      (by simpa only [zero_mul, add_zero] using hz) hxy hxz hyz
  · subst tau
    apply trace_zero_no_three_tau_one hnu x y z hx0 hy0 hz0
      (by simpa only [one_mul] using hx)
      (by simpa only [one_mul] using hy)
      (by simpa only [one_mul] using hz) hxy hxz hyz

end D1Bound5
