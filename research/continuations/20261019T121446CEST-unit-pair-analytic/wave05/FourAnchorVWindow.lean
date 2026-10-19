import D1Bound5.FullRingThreeSelection
import D1Bound5.FiniteClosedWindow

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- A convenient smaller closed V window, with rational coefficients
101 and 2/5. The strict actual form estimate excludes its endpoints. -/
theorem four_anchor_V_window_scalar
    (A B T P Q Z : ℝ) (hA : 0 < A) (hB : 0 < B) (hT : 0 < T)
    (hP : 0 < P) (hZ : 0 < Z)
    (hlo : (1-1/4000 : ℝ)*P*Q ≤ Z^2)
    (hhi : Z^2 ≤ (1+1/4000 : ℝ)*P*Q)
    (hform : 1 < 5*B*T^2/Z+3*T*Z/(4*A*P^3)) :
    Q < 101*B^2*T^4/P ∨ (2/5 : ℝ)*A^2*P^5/T^2 < Q := by
  by_contra hbad
  push_neg at hbad
  have hlow : 4*(5*B*T^2)^2/(P*(1-1/4000)) ≤ Q := by
    apply le_trans _ hbad.1
    apply (div_le_div_iff₀ (by positivity) hP).2
    have hh : 0 ≤ B^2*T^4*P := by positivity
    nlinarith only [hh]
  have hupp : Q ≤ 1/(4*(3*T/(4*A*P^3))^2*P*(1+1/4000)) := by
    apply le_trans hbad.2
    have heq : 1/(4*(3*T/(4*A*P^3))^2*P*(1+1/4000)) =
        (16000/36009 : ℝ)*A^2*P^5/T^2 := by field_simp; ring
    rw [heq]
    have hp : 0 ≤ A^2*P^5/T^2 := by positivity
    nlinarith only [hp]
  exact finite_closed_window_incompatible P Q Z (5*B*T^2) (3*T/(4*A*P^3))
    (1/4000) hP hZ (by positivity) (by positivity) (by norm_num) (by norm_num)
    hlo hhi (by convert hform using 1 <;> ring) hlow hupp

/-- The V-window exclusion for an actual ordered D(1) sextuple.
Nonvanishing, integrality, root signs and root-size estimates are all
derived inside the theorem. -/
theorem IsD1Tuple.four_anchor_V_window
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hP : 1000 ≤ ‖phi (a 4 : K)‖)
    (hTP : 4*‖phi (a 3 : K)‖ ≤ ‖phi (a 4 : K)‖)
    (hQ : 4*‖phi (a 4 : K)‖ ≤ ‖phi (a 5 : K)‖)
    (hsize : 32*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖*‖phi (a 3 : K)‖/
      ‖phi (a 0 : K)‖^3 ≤ ‖phi (a 4 : K)‖^2) :
    ‖phi (a 5 : K)‖ < 101*‖phi (a 1 : K)‖^2*‖phi (a 3 : K)‖^4/
        ‖phi (a 4 : K)‖ ∨
      (2/5 : ℝ)*‖phi (a 0 : K)‖^2*‖phi (a 4 : K)‖^5/
        ‖phi (a 3 : K)‖^2 < ‖phi (a 5 : K)‖ := by
  classical
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let Tup : Finset (𝓞 K) := Finset.univ.image a
  have hmem (i : Fin 6) : a i ∈ Tup :=
    Finset.mem_image.mpr ⟨i,Finset.mem_univ i,rfl⟩
  have hTup : IsD1 Tup := by
    constructor
    · intro x hx
      obtain ⟨i,_,rfl⟩ := Finset.mem_image.mp hx
      exact ha.2.1 i
    · intro x hx y hy hxy
      obtain ⟨i,_,rfl⟩ := Finset.mem_image.mp hx
      obtain ⟨j,_,rfl⟩ := Finset.mem_image.mp hy
      exact ha.2.2 i j (fun hij => hxy (congrArg a hij))
  let b : Fin 4 → 𝓞 K := fun i => a (![0,1,2,3] i)
  have hb : Function.Injective b :=
    ha.1.comp (by decide : Function.Injective (![0,1,2,3] : Fin 4 → Fin 6))
  have hbmon : Monotone (fun i => ‖f (b i)‖) := by
    intro i j hij
    apply hmon
    fin_cases i <;> fin_cases j <;> norm_num at hij ⊢
  let p := f (a 4)
  let q := f (a 5)
  let eta : ℂ := (p*q)^(1/2 : ℂ)
  have heta : eta^2 = p*q := coherent_cpow_half_sq (p*q)
  have hp : 0 < ‖p‖ := by change 0 < ‖f (a 4)‖; linarith only [hP]
  have hq : 0 < ‖q‖ := hp.trans_le (hmon (by decide : (4 : Fin 6) ≤ 5))
  have hpq : 4000 ≤ ‖p‖*‖q‖ := by
    have hh := mul_le_mul_of_nonneg_left hQ hp.le
    nlinarith only [hP,hh,sq_nonneg (‖p‖-1000)]
  have hform := full_ring_four_anchor_three_separated_inequality hK phi hTup
    (hmem 4) (hmem 5) (ha.1.ne (by decide)) b hb (fun i => hmem _)
    (by intro i; exact ha.1.ne (by fin_cases i <;> decide))
    (by intro i; exact ha.1.ne (by fin_cases i <;> decide))
    hbmon hP hTP hQ hsize eta heta
  let z := coherentTerminalRoot p q eta
  have hz : z^2 = p*q+1 := coherent_analytic_terminal_root_sq p q eta
    (norm_pos_iff.mp hp) (norm_pos_iff.mp hq) heta
  have hrel := finite_tuple_root_relative_norm p q z hz hpq
  have hZ : 0 < ‖z‖ := by
    have hh := hrel.1
    have hn := norm_nonneg z
    nlinarith only [hh,hpq,hn]
  have hnorm (i : Fin 6) : 0 < ‖f (a i)‖ := by
    have hh := one_le_norm_integer hK phi (ha.2.1 i)
    change 1 ≤ ‖f (a i)‖ at hh
    linarith only [hh]
  exact four_anchor_V_window_scalar ‖f (a 0)‖ ‖f (a 1)‖ ‖f (a 3)‖
    ‖p‖ ‖q‖ ‖z‖ (hnorm 0) (hnorm 1) (hnorm 3) hp hZ hrel.1 hrel.2 hform

end D1Bound5
