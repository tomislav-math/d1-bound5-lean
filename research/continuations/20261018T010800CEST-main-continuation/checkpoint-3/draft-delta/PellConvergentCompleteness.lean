import Mathlib.NumberTheory.DiophantineApproximation.Basic
import Mathlib.NumberTheory.Real.Irrational
import Mathlib.Data.Rat.Lemmas
import Mathlib.RingTheory.Coprime.Lemmas
import Mathlib.Tactic

namespace D1Bound5

/-- Integral numerator and denominator before rational normalization. The
recursion follows the real complete quotients; below we prove that these
integers are already relatively prime and positive. -/
noncomputable def pellConvergentPair (x : ℝ) : ℕ → ℤ × ℤ
  | 0 => (⌊x⌋, 1)
  | n+1 =>
      let t := pellConvergentPair (Int.fract x)⁻¹ n
      (⌊x⌋ * t.1 + t.2, t.1)

private theorem pell_tail_irrational {x : ℝ} (hx : Irrational x) :
    Irrational (Int.fract x)⁻¹ := by
  exact (show Irrational (x - (⌊x⌋ : ℝ)) from hx.sub_intCast _).inv

private theorem pell_tail_gt_one {x : ℝ} (hx : Irrational x) :
    1 < (Int.fract x)⁻¹ := by
  have hfr : 0 < Int.fract x := Int.fract_pos.mpr (hx.ne_int _)
  exact (one_lt_inv₀ hfr).mpr (Int.fract_lt_one x)

theorem pellConvergentPair_pos {x : ℝ} (hx : Irrational x) (hx1 : 1 < x)
    (n : ℕ) :
    0 < (pellConvergentPair x n).1 ∧ 0 < (pellConvergentPair x n).2 := by
  induction n generalizing x with
  | zero =>
      have hf : (1 : ℤ) ≤ ⌊x⌋ := Int.le_floor.mpr (by simpa using hx1.le)
      simpa only [pellConvergentPair] using And.intro (by omega : 0 < ⌊x⌋)
        (by norm_num : (0 : ℤ) < 1)
  | succ n ih =>
      obtain ⟨hp,hq⟩ := ih (pell_tail_irrational hx) (pell_tail_gt_one hx)
      have hf : (1 : ℤ) ≤ ⌊x⌋ := Int.le_floor.mpr (by simpa using hx1.le)
      change 0 < ⌊x⌋ * (pellConvergentPair (Int.fract x)⁻¹ n).1 +
        (pellConvergentPair (Int.fract x)⁻¹ n).2 ∧
        0 < (pellConvergentPair (Int.fract x)⁻¹ n).1
      exact ⟨by positivity, hp⟩

theorem pellConvergentPair_coprime (x : ℝ) (n : ℕ) :
    IsCoprime (pellConvergentPair x n).1 (pellConvergentPair x n).2 := by
  induction n generalizing x with
  | zero => simp [pellConvergentPair]
  | succ n ih =>
      simpa only [pellConvergentPair, add_comm] using
        (ih (Int.fract x)⁻¹).symm.add_mul_right_left ⌊x⌋

theorem pellConvergentPair_div {x : ℝ} (hx : Irrational x) (hx1 : 1 < x)
    (n : ℕ) :
    ((pellConvergentPair x n).1 : ℚ) / (pellConvergentPair x n).2 = x.convergent n := by
  induction n generalizing x with
  | zero => simp [pellConvergentPair]
  | succ n ih =>
      have ht := pell_tail_irrational hx
      have ht1 := pell_tail_gt_one hx
      obtain ⟨hp,hq⟩ := pellConvergentPair_pos ht ht1 n
      have hp' : ((pellConvergentPair (Int.fract x)⁻¹ n).1 : ℚ) ≠ 0 := by
        exact_mod_cast hp.ne'
      have hq' : ((pellConvergentPair (Int.fract x)⁻¹ n).2 : ℚ) ≠ 0 := by
        exact_mod_cast hq.ne'
      rw [Real.convergent_succ, ← ih ht ht1]
      simp only [pellConvergentPair, Int.cast_add, Int.cast_mul]
      field_simp [hp', hq']
      <;> ring

theorem pellConvergentPair_step_mono {x : ℝ} (hx : Irrational x) (hx1 : 1 < x)
    (n : ℕ) :
    (pellConvergentPair x n).1 ≤ (pellConvergentPair x (n+1)).1 ∧
    (pellConvergentPair x n).2 ≤ (pellConvergentPair x (n+1)).2 := by
  induction n generalizing x with
  | zero =>
      have hf : (1 : ℤ) ≤ ⌊x⌋ := Int.le_floor.mpr (by simpa using hx1.le)
      have ht : (1 : ℤ) ≤ ⌊(Int.fract x)⁻¹⌋ :=
        Int.le_floor.mpr (by simpa using (pell_tail_gt_one hx).le)
      simp only [pellConvergentPair]
      constructor
      · nlinarith
      · exact ht
  | succ n ih =>
      have hf : (1 : ℤ) ≤ ⌊x⌋ := Int.le_floor.mpr (by simpa using hx1.le)
      obtain ⟨hp,hq⟩ := ih (pell_tail_irrational hx) (pell_tail_gt_one hx)
      simp only [pellConvergentPair]
      constructor
      · exact add_le_add (mul_le_mul_of_nonneg_left hp (by omega)) hq
      · exact hp

theorem pellConvergentPair_num_mono {x : ℝ} (hx : Irrational x) (hx1 : 1 < x) :
    Monotone (fun n => (pellConvergentPair x n).1) :=
  monotone_nat_of_le_succ (fun n => (pellConvergentPair_step_mono hx hx1 n).1)

theorem pell_norm_two_coprime {d x y : ℤ} (hx : 0 < x)
    (heq : x^2-d*y^2=2) : IsCoprime x y := by
  let g : ℤ := Int.gcd x y
  obtain ⟨u,hu⟩ := Int.gcd_dvd_left x y
  obtain ⟨v,hv⟩ := Int.gcd_dvd_right x y
  change x = g*u at hu
  change y = g*v at hv
  have hg0 : g ≠ 0 := by
    intro hg
    have : x = 0 := by simpa only [hg, zero_mul] using hu
    omega
  have hgpos : 0 < g := lt_of_le_of_ne (Int.natCast_nonneg _) hg0.symm
  have hdiv : g^2 ∣ (2 : ℤ) := by
    refine ⟨u^2-d*v^2, ?_⟩
    rw [← heq,hu,hv]
    ring
  have hbound : g^2 ≤ 2 := Int.le_of_dvd (by norm_num) hdiv
  have hg1 : g = 1 := by nlinarith
  apply Int.isCoprime_iff_gcd_eq_one.mpr
  exact_mod_cast hg1

/-- The norm-two equation gives the strict Legendre approximation, including
the reduced denominator. This is an actual Pell theorem, not an assumed
continued-fraction enumeration. -/
theorem pell_norm_two_is_convergent {d x y : ℤ} (hd : 7 ≤ d)
    (hx : 0 < x) (hy : 0 < y) (heq : x^2-d*y^2=2) :
    ∃ n, (x/y : ℚ) = (Real.sqrt (d : ℝ)).convergent n := by
  have hcop := pell_norm_two_coprime hx heq
  have hcop' := isCoprime_iff_nat_coprime.mp hcop
  have hden := Rat.den_div_eq_of_coprime hy hcop'
  have hd0 : (0 : ℝ) ≤ d := by exact_mod_cast (show 0 ≤ d by omega)
  have hs := Real.sq_sqrt hd0
  have hs0 := Real.sqrt_nonneg (d : ℝ)
  have hs2 : (2 : ℝ) < Real.sqrt d := by
    have hd' : (7 : ℝ) ≤ d := by exact_mod_cast hd
    nlinarith
  have hx' : (0 : ℝ) < x := by exact_mod_cast hx
  have hy' : (0 : ℝ) < y := by exact_mod_cast hy
  have heq' : (x : ℝ)^2-d*(y : ℝ)^2=2 := by exact_mod_cast heq
  have hsY : (Real.sqrt (d : ℝ)*y)^2 = d*(y : ℝ)^2 := by
    rw [mul_pow,hs]
  have hxy : Real.sqrt d * y < x := by nlinarith [sq_nonneg (Real.sqrt d*y)]
  have hdiff : |Real.sqrt (d : ℝ) - (x : ℝ)/y| =
      2 / ((y : ℝ) * (x+Real.sqrt d*y)) := by
    rw [abs_of_neg (sub_neg.mpr ((lt_div_iff₀ hy').mpr hxy))]
    have hh : (x : ℝ)+Real.sqrt d*y ≠ 0 := by positivity
    field_simp [hy'.ne', hh]
    nlinarith
  have happrox : |Real.sqrt (d : ℝ) - (x : ℝ)/y| <
      1 / (2*(y : ℝ)^2) := by
    rw [hdiff]
    apply (div_lt_div_iff₀ (by positivity) (by positivity)).mpr
    have hsprod : 2*(y : ℝ) < Real.sqrt d*y := mul_lt_mul_of_pos_right hs2 hy'
    nlinarith [mul_lt_mul_of_pos_left hxy hy',mul_lt_mul_of_pos_left hsprod hy']
  apply Real.exists_rat_eq_convergent
  have hden' : (((x/y : ℚ).den : ℕ) : ℝ) = y := by exact_mod_cast hden
  simpa only [Rat.cast_div, Rat.cast_intCast, hden'] using happrox

/-- A checked stopping numerator makes the finite prefix complete for every
positive norm-two solution with bounded numerator. No solution list is an
input hypothesis. -/
theorem pell_norm_two_bounded_prefix {d x y X : ℤ} {N : ℕ}
    (hd : 7 ≤ d) (hns : ¬IsSquare d) (hx : 0 < x) (hy : 0 < y)
    (heq : x^2-d*y^2=2) (hX : x ≤ X)
    (hstop : X < (pellConvergentPair (Real.sqrt (d : ℝ)) N).1) :
    ∃ n < N, pellConvergentPair (Real.sqrt (d : ℝ)) n = (x,y) := by
  have hirr : Irrational (Real.sqrt (d : ℝ)) :=
    (irrational_sqrt_intCast_iff_of_nonneg (by omega)).mpr hns
  have hs1 : (1 : ℝ) < Real.sqrt (d : ℝ) := by
    have hs := Real.sq_sqrt (show (0 : ℝ) ≤ d by exact_mod_cast (show 0 ≤ d by omega))
    have hs0 := Real.sqrt_nonneg (d : ℝ)
    have hd' : (7 : ℝ) ≤ d := by exact_mod_cast hd
    nlinarith
  obtain ⟨n,hn⟩ := pell_norm_two_is_convergent hd hx hy heq
  have hpair := pellConvergentPair_pos hirr hs1 n
  have hcop := pellConvergentPair_coprime (Real.sqrt (d : ℝ)) n
  have hxy := Rat.div_int_inj hy hpair.2
    (isCoprime_iff_nat_coprime.mp (pell_norm_two_coprime hx heq))
    (isCoprime_iff_nat_coprime.mp hcop)
    (hn.trans (pellConvergentPair_div hirr hs1 n).symm)
  have hlt : n < N := by
    by_contra hnN
    have hle := pellConvergentPair_num_mono hirr hs1 (show N ≤ n by omega)
    omega
  exact ⟨n,hlt,Prod.ext hxy.1.symm hxy.2.symm⟩

end D1Bound5
