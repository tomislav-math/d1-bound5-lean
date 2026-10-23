import D1Bound5.FiniteMMatrix
import Mathlib.Analysis.Complex.Basic
import Mathlib.Tactic.GCongr
import Mathlib.Tactic.Linarith
import Lean.Elab.Tactic.Omega

namespace D1Bound5

private theorem finiteM_weight_monomial (B S C : ℝ) (p q r : ℕ)
    (hB : 1 ≤ B) (hBS : B ≤ S) (hC : 1 ≤ C)
    (hq : q ≤ 8) (hpq : p+q ≤ 11) (hr : r ≤ 2) :
    B^p*S^q*C^r ≤ B^3*S^8*C^2 := by
  have hS : 1 ≤ S := hB.trans hBS
  have hB0 : 0 ≤ B := by linarith
  have hS0 : 0 ≤ S := by linarith
  have hC0 : 0 ≤ C := by linarith
  have hanchor : B^p*S^q ≤ B^3*S^8 := by
    by_cases hp : p ≤ 3
    · exact mul_le_mul (pow_le_pow_right₀ hB hp)
        (pow_le_pow_right₀ hS hq) (pow_nonneg hS0 _) (pow_nonneg hB0 _)
    · have hp3 : 3 ≤ p := by omega
      have hrem : p-3+q ≤ 8 := by omega
      calc
        B^p*S^q = B^3*(B^(p-3)*S^q) := by
          conv_lhs => rw [show p=3+(p-3) by omega, pow_add]
          ring
        _ ≤ B^3*(S^(p-3)*S^q) := by gcongr
        _ = B^3*S^(p-3+q) := by rw [pow_add]
        _ ≤ B^3*S^8 := by
          exact mul_le_mul_of_nonneg_left (pow_le_pow_right₀ hS hrem) (by positivity)
  exact mul_le_mul hanchor (pow_le_pow_right₀ hC hr)
    (pow_nonneg hC0 _) (by positivity)

/-- A single factored integer monomial has the advertised weighted height.
The admissibility condition is discharged for every actual term by a finite
natural-number certificate in FiniteMMatrix. -/
theorem finiteMTermEval_norm_le (t : FiniteMTerm) (a b s v : ℂ)
    (B S C : ℝ) (hB : 1 ≤ B) (hBS : B ≤ S) (hC : 1 ≤ C)
    (ha : ‖a‖ ≤ B) (hb : ‖b‖ ≤ B) (hs : ‖s‖ ≤ S)
    (hv : ‖v‖ ≤ 2*S*C) (ht : finiteMTermAdmissible t) :
    ‖finiteMTermEval t a b s v‖ ≤ (finiteMTermWeight t : ℝ)*B^3*S^8*C^2 := by
  have hB0 : 0 ≤ B := by linarith
  have hS0 : 0 ≤ S := by linarith
  have hC0 : 0 ≤ C := by linarith
  have hab : ‖a-b‖ ≤ 2*B := (norm_sub_le a b).trans (by linarith)
  have has : ‖a-s‖ ≤ 2*S := (norm_sub_le a s).trans (by linarith)
  have hbs : ‖b-s‖ ≤ 2*S := (norm_sub_le b s).trans (by linarith)
  have hn : ‖(t.coeff : ℂ)‖ = (t.coeff.natAbs : ℝ) := by simp
  have hraw : ‖finiteMTermEval t a b s v‖ ≤
      (t.coeff.natAbs : ℝ)*B^t.ap*B^t.bp*S^t.sp*
        (2*B)^t.abp*(2*S)^t.asp*(2*S)^t.bsp*(2*S*C)^t.vp := by
    simp only [finiteMTermEval, norm_mul, norm_pow, hn]
    gcongr
  rcases ht with ⟨hq, hpq, hr⟩
  have hweight := finiteM_weight_monomial B S C
    (t.ap+t.bp+t.abp) (t.sp+t.asp+t.bsp+t.vp) t.vp
    hB hBS hC hq (by omega) hr
  calc
    _ ≤ _ := hraw
    _ = (finiteMTermWeight t : ℝ)*
        (B^(t.ap+t.bp+t.abp)*S^(t.sp+t.asp+t.bsp+t.vp)*C^t.vp) := by
      simp only [finiteMTermWeight, Nat.cast_mul, Nat.cast_pow, Nat.cast_ofNat,
        pow_add, mul_pow]
      ring
    _ ≤ (finiteMTermWeight t : ℝ)*(B^3*S^8*C^2) :=
      mul_le_mul_of_nonneg_left hweight (by positivity)
    _ = _ := by ring

private theorem finiteM_list_height (L : List FiniteMTerm)
    (a b s v : ℂ) (B S C : ℝ)
    (hB : 1 ≤ B) (hBS : B ≤ S) (hC : 1 ≤ C)
    (ha : ‖a‖ ≤ B) (hb : ‖b‖ ≤ B) (hs : ‖s‖ ≤ S)
    (hv : ‖v‖ ≤ 2*S*C) (hL : ∀ t ∈ L, finiteMTermAdmissible t) :
    ‖(L.map (fun t => finiteMTermEval t a b s v)).sum‖ ≤
      ((L.map finiteMTermWeight).sum : ℕ)*B^3*S^8*C^2 := by
  induction L with
  | nil => simp
  | cons t L ih =>
    simp only [List.map_cons, List.sum_cons, Nat.cast_add]
    have ht := finiteMTermEval_norm_le t a b s v B S C
      hB hBS hC ha hb hs hv (hL t (by simp))
    have htail := ih (fun t ht => hL t (by simp [ht]))
    calc
      _ ≤ ‖finiteMTermEval t a b s v‖+
          ‖(L.map (fun t => finiteMTermEval t a b s v)).sum‖ := norm_add_le _ _
      _ ≤ _ := add_le_add ht htail
      _ = _ := by ring

/-- The complete actual divided M matrix satisfies a deliberately generous
height bound. This avoids the manuscript's sharper geometric row estimates,
while leaving ample room in its stated approximation constant. -/
theorem finiteMDividedMatrix_root_height (a b s c : ℂ)
    (hB : 1 ≤ ‖b‖) (hab : ‖a‖ ≤ ‖b‖) (hbs : ‖b‖ ≤ ‖s‖)
    (hC : 1 ≤ ‖c‖) (i : Fin 4) :
    (∑ j : Fin 3, ‖finiteMDividedMatrix a b s c i j.succ‖) ≤
      169728*‖b‖^3*‖s‖^8*‖c‖^2 := by
  have hS : 1 ≤ ‖s‖ := hB.trans hbs
  have hSC : 1 ≤ ‖s‖*‖c‖ := by
    have hh := mul_le_mul hS hC (by norm_num : (0 : ℝ) ≤ 1) (norm_nonneg s)
    simpa only [one_mul] using hh
  have hvu (u : ℂ) (hu : ‖u‖ ≤ ‖s‖) : ‖u*c+1‖ ≤ 2*‖s‖*‖c‖ := by
    calc
      _ ≤ ‖u*c‖+‖(1 : ℂ)‖ := norm_add_le _ _
      _ = ‖u‖*‖c‖+1 := by rw [norm_mul, norm_one]
      _ ≤ 2*‖s‖*‖c‖ := by
        have hmul := mul_le_mul_of_nonneg_right hu (norm_nonneg c)
        nlinarith only [hSC, hmul]
  have hv (j : Fin 3) : ‖![c,a*c+1,b*c+1,s*c+1] j.succ‖ ≤ 2*‖s‖*‖c‖ := by
    fin_cases j
    · exact hvu a (hab.trans hbs)
    · exact hvu b hbs
    · exact hvu s le_rfl
  have hentry (j : Fin 3) : ‖finiteMDividedMatrix a b s c i j.succ‖ ≤
      (((finiteMTerms i j.succ).map finiteMTermWeight).sum : ℕ)*
        ‖b‖^3*‖s‖^8*‖c‖^2 :=
    finiteM_list_height _ a b s _ _ _ _ hB hbs hC hab le_rfl le_rfl (hv j)
      (finiteMTerms_admissible i j)
  calc
    _ ≤ ∑ j : Fin 3, (((finiteMTerms i j.succ).map finiteMTermWeight).sum : ℕ)*
        ‖b‖^3*‖s‖^8*‖c‖^2 := Finset.sum_le_sum (fun j _ => hentry j)
    _ = ((∑ j : Fin 3, ((finiteMTerms i j.succ).map finiteMTermWeight).sum : ℕ) : ℝ)*
        ‖b‖^3*‖s‖^8*‖c‖^2 := by simp [Finset.sum_mul, Nat.cast_sum]
    _ ≤ _ := by
      gcongr
      exact_mod_cast finiteMTerms_weight i

end D1Bound5
