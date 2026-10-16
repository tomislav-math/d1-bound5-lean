import D1Bound5.AdjugateCoverage

open scoped Matrix.Norms.L2Operator
open Matrix

namespace D1Bound5

/-- A product of three independently perturbed complex half-units. -/
theorem mixed_triple_cofactor_radius (x y z : ℂ) (a b c : ℝ)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c)
    (hx : ‖x-(1/2 : ℂ)‖ ≤ a)
    (hy : ‖y-(1/2 : ℂ)‖ ≤ b)
    (hz : ‖z-(1/2 : ℂ)‖ ≤ c) :
    ‖2*x*y*z-(1/4 : ℂ)‖ ≤
      2*a*(1/2+b)*(1/2+c) + b*(1/2+c) + c/2 := by
  have hny : ‖y‖ ≤ 1/2+b := by
    have h := norm_add_le (y-(1/2 : ℂ)) (1/2 : ℂ)
    have heq : y-(1/2 : ℂ)+(1/2 : ℂ)=y := by ring
    rw [heq] at h
    have hhalf : ‖(1/2 : ℂ)‖ = (1/2 : ℝ) := by norm_num
    rw [hhalf] at h
    linarith
  have hnz : ‖z‖ ≤ 1/2+c := by
    have h := norm_add_le (z-(1/2 : ℂ)) (1/2 : ℂ)
    have heq : z-(1/2 : ℂ)+(1/2 : ℂ)=z := by ring
    rw [heq] at h
    have hhalf : ‖(1/2 : ℂ)‖ = (1/2 : ℝ) := by norm_num
    rw [hhalf] at h
    linarith
  have hprod : ‖x-(1/2 : ℂ)‖ * ‖y‖ * ‖z‖ ≤ a*(1/2+b)*(1/2+c) := by
    gcongr
  have hprod2 : ‖y-(1/2 : ℂ)‖ * ‖z‖ ≤ b*(1/2+c) := by
    gcongr
  have hid : 2*x*y*z-(1/4 : ℂ) =
      2*(x-1/2)*y*z + (y-1/2)*z + (z-1/2)/2 := by ring
  rw [hid]
  have htri :
      ‖2*(x-1/2)*y*z + (y-1/2)*z + (z-1/2)/2‖ ≤
      ‖2*(x-1/2)*y*z‖ + ‖(y-1/2)*z‖ + ‖(z-1/2)/2‖ := by
    have h1 := norm_add_le (2*(x-1/2)*y*z + (y-1/2)*z) ((z-1/2)/2)
    have h2 := norm_add_le (2*(x-1/2)*y*z) ((y-1/2)*z)
    linarith
  have hn1 : ‖2*(x-1/2)*y*z‖ ≤ 2*(a*(1/2+b)*(1/2+c)) := by
    have heq : ‖2*(x-1/2)*y*z‖ = 2*(‖x-1/2‖*‖y‖*‖z‖) := by
      simp [norm_mul]
      ring
    rw [heq]
    exact mul_le_mul_of_nonneg_left hprod (by norm_num)
  have hn2 : ‖(y-1/2)*z‖ ≤ b*(1/2+c) := by
    rw [norm_mul]
    exact hprod2
  have hn3 : ‖(z-1/2)/2‖ ≤ c/2 := by
    have heq : ‖(z-1/2)/2‖ = ‖z-1/2‖/2 := by simp [norm_div]
    rw [heq]
    linarith
  linarith only [htri,hn1,hn2,hn3]

/-- Later-block diagonal cofactor: three small radius perturbations. -/
theorem mixed_triple_later (x y z : ℂ)
    (hx : ‖x-(1/2 : ℂ)‖ < (1/64 : ℝ))
    (hy : ‖y-(1/2 : ℂ)‖ < (1/64 : ℝ))
    (hz : ‖z-(1/2 : ℂ)‖ < (1/64 : ℝ)) :
    ‖2*x*y*z-(1/4 : ℂ)‖ < (1/40 : ℝ) := by
  have h := mixed_triple_cofactor_radius x y z (1/64) (1/64) (1/64)
    (by norm_num) (by norm_num) (by norm_num) hx.le hy.le hz.le
  have hn : 2*(1/64 : ℝ)*(1/2+1/64)*(1/2+1/64) +
      (1/64)*(1/2+1/64)+(1/64)/2 < 1/40 := by norm_num
  exact lt_of_le_of_lt h hn

/-- Positive-index diagonal cofactor: two large and one small perturbation. -/
theorem mixed_triple_first_first_later (x y z : ℂ)
    (hx : ‖x-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hy : ‖y-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hz : ‖z-(1/2 : ℂ)‖ < (1/64 : ℝ)) :
    ‖2*x*y*z-(1/4 : ℂ)‖ < (7/100 : ℝ) := by
  have h := mixed_triple_cofactor_radius x y z (1/18) (1/18) (1/64)
    (by norm_num) (by norm_num) (by norm_num) hx.le hy.le hz.le
  have hn : 2*(1/18 : ℝ)*(1/2+1/18)*(1/2+1/64) +
      (1/18)*(1/2+1/64)+(1/64)/2 < 7/100 := by norm_num
  exact lt_of_le_of_lt h hn

end D1Bound5


namespace D1Bound5

/-- Cubic cofactor perturbation bound with six independent error radii. -/
theorem mixed_offDiagonal_cofactor_radius (x y z u v w : ℂ)
    (rx ry rz ru rv rw : ℝ)
    (hrx : 0 ≤ rx) (hry : 0 ≤ ry) (hrz : 0 ≤ rz)
    (hru : 0 ≤ ru) (hrv : 0 ≤ rv) (hrw : 0 ≤ rw)
    (hx : ‖x-(1/2 : ℂ)‖ ≤ rx)
    (hy : ‖y-(1/2 : ℂ)‖ ≤ ry)
    (hz : ‖z-(1/2 : ℂ)‖ ≤ rz)
    (hu : ‖u-(1/2 : ℂ)‖ ≤ ru)
    (hv : ‖v-(1/2 : ℂ)‖ ≤ rv)
    (hw : ‖w-(1/2 : ℂ)‖ ≤ rw) :
    ‖w^2*x-w*z*u-w*y*v+(1/8 : ℂ)‖ ≤
      (rx+rz+ru+ry+rv)/4 +
      rw*(rx+(rz+ru+ry+rv)/2) +
      (rw^2+rz*ru+ry*rv)/2 +
      rw*(rx*rw+rz*ru+ry*rv) := by
  let a : ℂ := x-1/2
  let b : ℂ := z-1/2
  let c : ℂ := u-1/2
  let d : ℂ := y-1/2
  let e : ℂ := v-1/2
  let f : ℂ := w-1/2
  have ha : ‖a‖ ≤ rx := hx
  have hb : ‖b‖ ≤ rz := hz
  have hc : ‖c‖ ≤ ru := hu
  have hd : ‖d‖ ≤ ry := hy
  have he : ‖e‖ ≤ rv := hv
  have hf : ‖f‖ ≤ rw := hw
  have hpair (p q : ℂ) (rp rq : ℝ) (hrp : 0 ≤ rp)
      (hp : ‖p‖ ≤ rp) (hq : ‖q‖ ≤ rq) :
      ‖p*q‖ ≤ rp*rq := by
    rw [norm_mul]
    exact (mul_le_mul_of_nonneg_right hp (norm_nonneg q)).trans
      (mul_le_mul_of_nonneg_left hq hrp)
  have hff : ‖f^2‖ ≤ rw^2 := by
    simpa only [pow_two] using hpair f f rw rw hrw hf hf
  have hbc : ‖b*c‖ ≤ rz*ru := hpair b c rz ru hrz hb hc
  have hde : ‖d*e‖ ≤ ry*rv := hpair d e ry rv hry hd he
  have haf : ‖a*f‖ ≤ rx*rw := hpair a f rx rw hrx ha hf
  let B : ℂ := a-b-c-d-e
  let C : ℂ := a-(b+c+d+e)/2
  let D : ℂ := f^2-b*c-d*e
  let T : ℂ := a*f-b*c-d*e
  have hB : ‖B‖ ≤ rx+rz+ru+ry+rv := by
    have h1 := norm_sub_le a b
    have h2 := norm_sub_le (a-b) c
    have h3 := norm_sub_le (a-b-c) d
    have h4 := norm_sub_le (a-b-c-d) e
    dsimp [B]
    linarith only [h1,h2,h3,h4,ha,hb,hc,hd,he]
  have hsum : ‖b+c+d+e‖ ≤ rz+ru+ry+rv := by
    have h1 := norm_add_le b c
    have h2 := norm_add_le (b+c) d
    have h3 := norm_add_le (b+c+d) e
    linarith only [h1,h2,h3,hb,hc,hd,he]
  have hC : ‖C‖ ≤ rx+(rz+ru+ry+rv)/2 := by
    have h1 := norm_sub_le a ((b+c+d+e)/2)
    have h2 : ‖(b+c+d+e)/2‖ ≤ (rz+ru+ry+rv)/2 := by
      have hnorm : ‖(b+c+d+e)/2‖ = ‖b+c+d+e‖/2 := by simp
      rw [hnorm]
      exact div_le_div_of_nonneg_right hsum (by norm_num)
    dsimp [C]
    linarith only [h1,h2,ha]
  have hD : ‖D‖ ≤ rw^2+rz*ru+ry*rv := by
    have h1 := norm_sub_le (f^2-b*c) (d*e)
    have h2 := norm_sub_le (f^2) (b*c)
    dsimp [D]
    linarith only [h1,h2,hff,hbc,hde]
  have hT : ‖T‖ ≤ rx*rw+rz*ru+ry*rv := by
    have h1 := norm_sub_le (a*f-b*c) (d*e)
    have h2 := norm_sub_le (a*f) (b*c)
    dsimp [T]
    linarith only [h1,h2,haf,hbc,hde]
  have hfC : ‖f*C‖ ≤ rw*(rx+(rz+ru+ry+rv)/2) := by
    rw [norm_mul]
    exact (mul_le_mul_of_nonneg_right hf (norm_nonneg C)).trans
      (mul_le_mul_of_nonneg_left hC hrw)
  have hfT : ‖f*T‖ ≤ rw*(rx*rw+rz*ru+ry*rv) := by
    rw [norm_mul]
    exact (mul_le_mul_of_nonneg_right hf (norm_nonneg T)).trans
      (mul_le_mul_of_nonneg_left hT hrw)
  have hid : w^2*x-w*z*u-w*y*v+(1/8 : ℂ) =
      B/4 + f*C + D/2 + f*T := by
    dsimp [B,C,D,T,a,b,c,d,e,f]
    ring
  have htri : ‖B/4 + f*C + D/2 + f*T‖ ≤
      ‖B/4‖ + ‖f*C‖ + ‖D/2‖ + ‖f*T‖ := by
    have h1 := norm_add_le (B/4+f*C+D/2) (f*T)
    have h2 := norm_add_le (B/4+f*C) (D/2)
    have h3 := norm_add_le (B/4) (f*C)
    linarith only [h1,h2,h3]
  have hB4 : ‖B/4‖ ≤ (rx+rz+ru+ry+rv)/4 := by
    have hnorm : ‖B/4‖ = ‖B‖/4 := by simp
    rw [hnorm]
    exact div_le_div_of_nonneg_right hB (by norm_num)
  have hD2 : ‖D/2‖ ≤ (rw^2+rz*ru+ry*rv)/2 := by
    have hnorm : ‖D/2‖ = ‖D‖/2 := by simp
    rw [hnorm]
    exact div_le_div_of_nonneg_right hD (by norm_num)
  rw [hid]
  linarith only [htri,hB4,hfC,hD2,hfT]

/-- First-row off-diagonal cofactor bound with three loose and three tight radii. -/
theorem mixed_offDiagonal_first (x y z u v w : ℂ)
    (hx : ‖x-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hy : ‖y-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hz : ‖z-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hu : ‖u-(1/2 : ℂ)‖ < (1/64 : ℝ))
    (hv : ‖v-(1/2 : ℂ)‖ < (1/64 : ℝ))
    (hw : ‖w-(1/2 : ℂ)‖ < (1/64 : ℝ)) :
    ‖w^2*x-w*z*u-w*y*v+(1/8 : ℂ)‖ < (53/1000 : ℝ) := by
  have h := mixed_offDiagonal_cofactor_radius x y z u v w
    (1/18) (1/18) (1/18) (1/64) (1/64) (1/64)
    (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num) (by norm_num)
    hx.le hy.le hz.le hu.le hv.le hw.le
  have hn :
      ((1/18+1/18+1/64+1/18+1/64)/4 +
      (1/64)*(1/18+(1/18+1/64+1/18+1/64)/2) +
      ((1/64)^2+(1/18)*(1/64)+(1/18)*(1/64))/2 +
      (1/64)*((1/18)*(1/64)+(1/18)*(1/64)+(1/18)*(1/64)) : ℝ) <
      53/1000 := by norm_num
  exact lt_of_le_of_lt h hn

/-- Off-diagonal cofactor for distinct positive row/column indices. -/
theorem mixed_offDiagonal_later (x y z u v w : ℂ)
    (hx : ‖x-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hy : ‖y-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hz : ‖z-(1/2 : ℂ)‖ < (1/18 : ℝ))
    (hu : ‖u-(1/2 : ℂ)‖ < (1/64 : ℝ))
    (hv : ‖v-(1/2 : ℂ)‖ < (1/64 : ℝ))
    (hw : ‖w-(1/2 : ℂ)‖ < (1/64 : ℝ)) :
    ‖z^2*u-z*y*v-z*x*w+(1/8 : ℂ)‖ < (47/1000 : ℝ) := by
  have h := mixed_offDiagonal_cofactor_radius u x y v w z
    (1/64) (1/18) (1/18) (1/64) (1/64) (1/18)
    (by norm_num) (by norm_num) (by norm_num)
    (by norm_num) (by norm_num) (by norm_num)
    hu.le hx.le hy.le hv.le hw.le hz.le
  have hn :
      ((1/64+1/18+1/64+1/18+1/64)/4 +
      (1/18)*(1/64+(1/18+1/64+1/18+1/64)/2) +
      ((1/18)^2+(1/18)*(1/64)+(1/18)*(1/64))/2 +
      (1/18)*((1/64)*(1/18)+(1/18)*(1/64)+(1/18)*(1/64)) : ℝ) <
      47/1000 := by norm_num
  exact lt_of_le_of_lt h hn

end D1Bound5
