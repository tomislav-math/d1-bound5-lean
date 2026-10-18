import D1Bound5.FrontierLargeCofactors
import Mathlib.Tactic.GCongr

namespace D1Bound5

/-- A product of three near-half factors has the exact leading one-eighth
and a remainder bounded by the corresponding product of envelopes. -/
theorem frontier_cubic_product_bounds (x y z : ℂ) (k l : ℝ)
    (hk : (1/2 : ℝ) ≤ k) (hl : (1/2 : ℝ) ≤ l)
    (hx : ‖x-(1/2 : ℂ)‖ ≤ k-1/2)
    (hy : ‖y-(1/2 : ℂ)‖ ≤ k-1/2)
    (hz : ‖z-(1/2 : ℂ)‖ ≤ l-1/2) :
    ‖x*y*z‖ ≤ k^2*l ∧ ‖x*y*z-(1/8 : ℂ)‖ ≤ k^2*l-1/8 := by
  have hk0 : 0 ≤ k := by linarith only [hk]
  have hl0 : 0 ≤ l := by linarith only [hl]
  have hke0 : 0 ≤ k-1/2 := sub_nonneg.mpr hk
  have hle0 : 0 ≤ l-1/2 := sub_nonneg.mpr hl
  have hnx : ‖x‖ ≤ k := by
    have h := norm_add_le (x-(1/2 : ℂ)) (1/2 : ℂ)
    norm_num at h
    linarith only [h, hx]
  have hny : ‖y‖ ≤ k := by
    have h := norm_add_le (y-(1/2 : ℂ)) (1/2 : ℂ)
    norm_num at h
    linarith only [h, hy]
  have hnz : ‖z‖ ≤ l := by
    have h := norm_add_le (z-(1/2 : ℂ)) (1/2 : ℂ)
    norm_num at h
    linarith only [h, hz]
  constructor
  · rw [norm_mul, norm_mul]
    calc
      ‖x‖*‖y‖*‖z‖ ≤ k*k*l := by gcongr
      _ = k^2*l := by ring
  · have hid : x*y*z-(1/8 : ℂ) =
        (x-1/2)*y*z+(1/2 : ℂ)*(y-1/2)*z+(1/4 : ℂ)*(z-1/2) := by ring
    rw [hid]
    calc
      _ ≤ ‖(x-1/2)*y*z+(1/2 : ℂ)*(y-1/2)*z‖+
          ‖(1/4 : ℂ)*(z-1/2)‖ := norm_add_le _ _
      _ ≤ (‖(x-1/2)*y*z‖+‖(1/2 : ℂ)*(y-1/2)*z‖)+
          ‖(1/4 : ℂ)*(z-1/2)‖ := add_le_add (norm_add_le _ _) le_rfl
      _ = ‖x-1/2‖*‖y‖*‖z‖+(1/2 : ℝ)*‖y-1/2‖*‖z‖+
          (1/4 : ℝ)*‖z-1/2‖ := by norm_num [norm_mul]
      _ ≤ (k-1/2)*k*l+(1/2 : ℝ)*(k-1/2)*l+(1/4 : ℝ)*(l-1/2) := by
        gcongr
      _ = k^2*l-1/8 := by ring

/-- The three signed cubic cofactor terms cancel at the leading level.
Retaining this cancellation gives 3K-1/4 instead of the weaker 3K. -/
theorem frontier_three_cubic_cofactor (p q r : ℂ) (K : ℝ)
    (hp : ‖p-(1/8 : ℂ)‖ ≤ K-1/8)
    (hq : ‖q-(1/8 : ℂ)‖ ≤ K-1/8)
    (hr : ‖r-(1/8 : ℂ)‖ ≤ K-1/8) :
    ‖p-q-r‖ ≤ 3*K-1/4 := by
  have hid : p-q-r = (p-1/8)-(q-1/8)-(r-1/8)-(1/8 : ℂ) := by ring
  rw [hid]
  have h1 := norm_sub_le ((p-1/8)-(q-1/8)-(r-1/8)) (1/8 : ℂ)
  have h2 := norm_sub_le ((p-1/8)-(q-1/8)) (r-1/8)
  have h3 := norm_sub_le (p-(1/8 : ℂ)) (q-1/8)
  norm_num at h1
  linarith only [h1, h2, h3, hp, hq, hr]

/-- The quartic determinant polynomial has nine absolute coefficient
units when its three disjoint-edge products have modulus at most L. -/
theorem frontier_quartic_polynomial (P Q R : ℂ) (L : ℝ) (hL : 0 ≤ L)
    (hP : ‖P‖ ≤ L) (hQ : ‖Q‖ ≤ L) (hR : ‖R‖ ≤ L) :
    ‖P^2+Q^2+R^2-2*(P*Q+P*R+Q*R)‖ ≤ 9*L^2 := by
  have hpair (x y : ℂ) (hx : ‖x‖ ≤ L) (hy : ‖y‖ ≤ L) : ‖x*y‖ ≤ L^2 := by
    rw [norm_mul]
    nlinarith only [mul_le_mul hx hy (norm_nonneg _) hL]
  have hPP := hpair P P hP hP
  have hQQ := hpair Q Q hQ hQ
  have hRR := hpair R R hR hR
  have hPQ := hpair P Q hP hQ
  have hPR := hpair P R hP hR
  have hQR := hpair Q R hQ hR
  have hs1 : ‖P^2+Q^2+R^2‖ ≤ 3*L^2 := by
    have h1 := norm_add_le (P^2+Q^2) (R^2)
    have h2 := norm_add_le (P^2) (Q^2)
    simp only [← pow_two] at hPP hQQ hRR
    linarith only [h1, h2, hPP, hQQ, hRR]
  have hs2 : ‖P*Q+P*R+Q*R‖ ≤ 3*L^2 := by
    have h1 := norm_add_le (P*Q+P*R) (Q*R)
    have h2 := norm_add_le (P*Q) (P*R)
    linarith only [h1, h2, hPQ, hPR, hQR]
  have h := norm_sub_le (P^2+Q^2+R^2) (2*(P*Q+P*R+Q*R))
  rw [norm_mul, Complex.norm_two] at h
  linarith only [h, hs1, hs2]

end D1Bound5
