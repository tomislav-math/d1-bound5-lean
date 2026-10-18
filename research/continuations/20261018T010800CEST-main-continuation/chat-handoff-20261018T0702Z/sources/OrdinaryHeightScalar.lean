import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Algebra.Order.Floor.Semiring
import Mathlib.Tactic

namespace D1Bound5

/-- Selecting the actual positive integer order from the logarithmic
floor gives a division-free logarithmic inequality. This is the scalar
step from all integer orders to the ordinary height envelope. -/
theorem ordinary_integer_orders_log_bound (H R Z X : ℝ)
    (hH : 1 ≤ H) (hR : 1 < R) (hZ : 1 ≤ Z) (hX : 0 < X)
    (horders : ∀ k : ℕ, 1 ≤ k → 1 < X*H^k/Z+Z/(2*R^k)) :
    Real.log Z*(Real.log R-Real.log H) < Real.log (2*X*H)*Real.log R := by
  have hH0 : 0 < H := lt_of_lt_of_le (by norm_num) hH
  have hR0 : 0 < R := lt_trans (by norm_num) hR
  have hZ0 : 0 < Z := lt_of_lt_of_le (by norm_num) hZ
  have hlR : 0 < Real.log R := Real.log_pos hR
  have hlH : 0 ≤ Real.log H := Real.log_nonneg hH
  have hlZ : 0 ≤ Real.log Z := Real.log_nonneg hZ
  let k : ℕ := ⌊Real.log Z/Real.log R⌋₊+1
  have hk : 1 ≤ k := by dsimp [k]; omega
  have hklo : Real.log Z < (k : ℝ)*Real.log R := by
    have h := Nat.lt_floor_add_one (Real.log Z/Real.log R)
    have h' : Real.log Z/Real.log R < (k : ℝ) := by
      simpa only [k,Nat.cast_add,Nat.cast_one] using h
    exact (div_lt_iff₀ hlR).mp h'
  have hkhi : (k : ℝ)*Real.log R ≤ Real.log Z+Real.log R := by
    have h := Nat.floor_le (div_nonneg hlZ hlR.le)
    have h' : (k : ℝ) ≤ Real.log Z/Real.log R+1 := by
      simp only [k,Nat.cast_add,Nat.cast_one]
      linarith only [h]
    have hm := mul_le_mul_of_nonneg_right h' hlR.le
    have heq : (Real.log Z/Real.log R+1)*Real.log R = Real.log Z+Real.log R := by
      field_simp [hlR.ne']
    rwa [heq] at hm
  have hZR : Z < R^k := by
    apply (Real.log_lt_log_iff hZ0 (pow_pos hR0 k)).mp
    simpa only [Real.log_pow] using hklo
  have hres : Z/(2*R^k) < (1/2 : ℝ) := by
    apply (div_lt_iff₀ (by positivity : 0 < 2*R^k)).mpr
    nlinarith only [hZR]
  have hfirst : (1/2 : ℝ) < X*H^k/Z := by
    have h := horders k hk
    linarith only [h,hres]
  have hheight : Z < 2*X*H^k := by
    have h := (lt_div_iff₀ hZ0).mp hfirst
    nlinarith only [h]
  have hlog := Real.log_lt_log hZ0 hheight
  rw [Real.log_mul (by positivity : (2:ℝ)*X ≠ 0) (pow_ne_zero k hH0.ne'),
    Real.log_pow] at hlog
  have hp := mul_lt_mul_of_pos_right hlog hlR
  have hq := mul_le_mul_of_nonneg_left hkhi hlH
  rw [Real.log_mul (by positivity : (2:ℝ)*X ≠ 0) hH0.ne']
  nlinarith only [hp,hq]

/-- The exact rational-parameter algebra of the ordinary height
envelope. Here x,z,d are base-ten logarithms and p,q are the residual
rate and coefficient-height logarithms. -/
theorem ordinary_height_scalar_envelope (x z d p q h r u : ℝ)
    (hz : 0 ≤ z) (hq : 0 ≤ q)
    (hp : 2*x+r < p) (hp0 : 0 < 2*x+r)
    (hqh : q < x+h) (hxt : h-r < x)
    (hbound : z*(p-q) < (2*x+u)*p)
    (hd : d < (2/5 : ℝ)-x+2*z) :
    d < 7*x+(4*u+8*h-4*r)+
      (2*u*r+(4*u+8*h-4*r)*(h-r))/(x-(h-r))+(2/5 : ℝ) := by
  have hpPos : 0 < p := hp0.trans hp
  have hxPos : 0 < x-(h-r) := sub_pos.mpr hxt
  have hHpos : 0 < x+h := hq.trans_lt hqh
  have hprod1 := mul_pos (sub_pos.mpr hp) hHpos
  have hprod2 := mul_pos (sub_pos.mpr hqh) hp0
  have hratio : p*(x-(h-r)) < (p-q)*(2*x+r) := by
    nlinarith only [hprod1,hprod2]
  have hlo := mul_le_mul_of_nonneg_left hratio.le hz
  have hhi := mul_lt_mul_of_pos_right hbound hp0
  have hzmul : z*(x-(h-r)) < (2*x+u)*(2*x+r) := by
    by_contra hbad
    have hm := mul_nonneg (sub_nonneg.mpr (le_of_not_gt hbad)) hpPos.le
    nlinarith only [hlo,hhi,hm]
  have hzupper : z < (2*x+u)*(2*x+r)/(x-(h-r)) :=
    (lt_div_iff₀ hxPos).mpr hzmul
  have hid : (2/5 : ℝ)-x+2*((2*x+u)*(2*x+r)/(x-(h-r))) =
      7*x+(4*u+8*h-4*r)+
        (2*u*r+(4*u+8*h-4*r)*(h-r))/(x-(h-r))+(2/5 : ℝ) := by
    field_simp [hxPos.ne'] <;> ring
  rw [← hid]
  linarith only [hd,hzupper]

/-- Exact scalar contradiction used in the unit-pair branch. The
reciprocal is decreasing on x>=4, so no calculus is necessary. -/
theorem unit_pair_height_cutoff_scalar (s d : ℝ) (hs : 4 ≤ s)
    (hlower : 27*s-4 < d)
    (hupper : d < 7*s+617/25+(118401/2500)/(s-203/100)) : False := by
  have hden : 0 < s-(203/100 : ℝ) := by linarith only [hs]
  have hinv : (118401/2500 : ℝ)/(s-203/100) ≤ 118401/4925 := by
    apply (div_le_iff₀ hden).mpr
    nlinarith only [hs]
  linarith only [hs,hlower,hupper,hinv]

end D1Bound5
