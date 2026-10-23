import D1Bound5.CoherentRetainedMixedFourSizes
import D1Bound5.CoherentRetainedFrontierTuple
import D1Bound5.CoherentDirectFour
import D1Bound5.RetainedMixedFourScalar

open Finset
open scoped NumberField
open Module

namespace D1Bound5

/-- The mixed retained power gap with AT≥32 supplies the common large
terminal hypotheses for the approximation constructions. -/
theorem coherent_retained_h32_common_sizes
    (A S T C : ℝ) (hA : 1 ≤ A) (hS3 : 3 ≤ S) (hST : S ≤ T)
    (hAT32 : 32 ≤ A*T) (hgap : A^2*T^5/S^2 < C) :
    1000 < C ∧ 200*S < C ∧ 4*T < C := by
  have hS : 0 < S := by linarith only [hS3]
  have hT : 0 < T := hS.trans_le hST
  have hbase : A^2*T^3 ≤ A^2*T^5/S^2 := by
    apply (le_div_iff₀ (pow_pos hS 2)).2
    have hs : S^2 ≤ T^2 := by gcongr
    have hh := mul_le_mul_of_nonneg_left hs (by positivity : 0 ≤ A^2*T^3)
    nlinarith only [hh]
  have hT3 : A^2*T^3 < C := hbase.trans_lt hgap
  have hAT2 : (1024 : ℝ) ≤ A^2*T^2 := by nlinarith only [hAT32,sq_nonneg (A*T-32)]
  have hmul := mul_le_mul_of_nonneg_right hAT2 hT.le
  refine ⟨?_,?_,?_⟩
  · nlinarith only [hS3,hST,hmul,hT3]
  · nlinarith only [hST,hS,hmul,hT3]
  · nlinarith only [hT,hmul,hT3]


private theorem coherent_retained_frontier_subtuple
    {R : Type*} [CommRing R] {m n : ℕ} (a : Fin n → R) (ha : IsD1Tuple a)
    (i : Fin m → Fin n) (hi : Function.Injective i) : IsD1Tuple (fun j => a (i j)) :=
  ⟨ha.1.comp hi, fun j => ha.2.1 (i j), fun j k hjk => ha.2.2 (i j) (i k) (hi.ne hjk)⟩

/-- The retained start estimates for an actual ordered sextuple in the
general H32 frontier regime.  The four-anchor form is proved nonzero using
its actual zero window and the repeated five-entry power gap, then its
full-ring integral lower bound supplies the final seventh-power gap. -/
theorem IsD1Tuple.retained_start_of_frontier
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hB : 3 ≤ ‖phi (a 1 : K)‖)
    (hfrontier : 2*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖ < ‖phi (a 3 : K)‖)
    (hAT32 : 32 ≤ ‖phi (a 0 : K)‖*‖phi (a 3 : K)‖) :
    let A := ‖phi (a 0 : K)‖
    let B := ‖phi (a 1 : K)‖
    let S := ‖phi (a 2 : K)‖
    let T := ‖phi (a 3 : K)‖
    let C := ‖phi (a 4 : K)‖
    let D := ‖phi (a 5 : K)‖
    A^2*T^5/S^2 < C ∧ A^2*C^5/S^2 < D ∧ A^2*C^7/(S^2*T^4) < D ∧
      1000 < C ∧ 200*S < C ∧ 4*T < C ∧ 16*B*S*T < C ∧ 1000*C < D := by
  classical
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f (a 0)‖
  let B := ‖f (a 1)‖
  let S := ‖f (a 2)‖
  let T := ‖f (a 3)‖
  let C := ‖f (a 4)‖
  let D := ‖f (a 5)‖
  let i4 : Fin 4 → Fin 6 := ![0,1,2,3]
  let i5 : Fin 5 → Fin 6 := ![0,1,2,3,4]
  let j5 : Fin 5 → Fin 6 := ![0,1,2,4,5]
  let b : Fin 4 → 𝓞 K := fun i => a (i4 i)
  let v : Fin 4 → ℂ := fun i => f (b i)
  have hi4 : Function.Injective i4 := by decide
  have hi5 : Function.Injective i5 := by decide
  have hj5 : Function.Injective j5 := by decide
  have hmi4 : Monotone i4 := by decide
  have hmi5 : Monotone i5 := by decide
  have hmj5 : Monotone j5 := by decide
  have hb := coherent_retained_frontier_subtuple a ha i4 hi4
  have hfirst := coherent_retained_frontier_subtuple a ha i5 hi5
  have hsecond := coherent_retained_frontier_subtuple a ha j5 hj5
  have hA : 1 ≤ A := one_le_norm_integer hK phi (ha.2.1 0)
  have hAB : A ≤ B := hmon (by decide : (0 : Fin 6) ≤ 1)
  have hBS : B ≤ S := hmon (by decide : (1 : Fin 6) ≤ 2)
  have hST : S ≤ T := hmon (by decide : (2 : Fin 6) ≤ 3)
  have hTC : T ≤ C := hmon (by decide : (3 : Fin 6) ≤ 4)
  have hCD : C ≤ D := hmon (by decide : (4 : Fin 6) ≤ 5)
  have hB3 : 3 ≤ B := hB
  have hS3 : 3 ≤ S := hB3.trans hBS
  have hA0 : 0 < A := by linarith only [hA]
  have hB0 : 0 < B := by linarith only [hB3]
  have hS0 : 0 < S := by linarith only [hS3]
  have hT0 : 0 < T := hS0.trans_le hST
  have hpos : 0 < A*B*S := by positivity
  have hfront : 2*A*B*S < T := hfrontier
  have hAC32 : 32 ≤ A*C := hAT32.trans (mul_le_mul_of_nonneg_left hTC hA0.le)
  have hrow : CoherentRetainedRow 32 (1/10) (179/10) := Or.inl ⟨rfl,rfl,rfl⟩
  have hCdata := IsD1Tuple.retained_gap_of_frontier hK phi (fun i => a (i5 i)) hfirst
    (hmon.comp hmi5) hB hfront 32 (1/10) (179/10) hrow hAT32
  have hDdata := IsD1Tuple.retained_gap_of_frontier hK phi (fun i => a (j5 i)) hsecond
    (hmon.comp hmj5) hB (hfront.trans_le hTC) 32 (1/10) (179/10) hrow hAC32
  have hCgap : A^2*T^5/S^2 < C := hCdata.2
  have hDgap : A^2*C^5/S^2 < D := hDdata.2
  have hcommon := coherent_retained_h32_common_sizes A S T C hA hS3 hST hAT32 hCgap
  have hC1000 : 1000 < C := hcommon.1
  have hC0 : 0 < C := by linarith only [hC1000]
  have hD0 : 0 < D := hC0.trans_le hCD
  have hC16 := coherent_retained_mixed_first_terminal_large A B S T C
    hA hB3 hS0 hBS hST hfront hCgap
  have hterminal := coherent_retained_mixed_four_terminal_sizes A B S T C D
    hA hB3 hS0 hT0 hST (hST.trans hTC) hC1000 hC16 hDgap
  let eta : ℂ := (f (a 4)*f (a 5))^(1/2 : ℂ)
  let Z := ‖coherentTerminalRoot (f (a 4)) (f (a 5)) eta‖
  let L := coherentQuotientForm v (coherentVandermonde4 v) (f (a 4)) (f (a 5)) eta
  have heta : eta^2 = f (a 4)*f (a 5) := coherent_cpow_half_sq _
  have hf : Function.Injective f := by
    intro x y hxy
    apply NumberField.RingOfIntegers.ext
    exact phi.injective hxy
  have hv : Function.Injective v := hf.comp hb.1
  have hforms := coherent_direct_four v hv (f (a 4)) (f (a 5)) eta
    (by change 1 ≤ A; linarith only [hA]) hAB hBS hST hTC hC1000.le hterminal.1.le heta
  have hnonzero : L ≠ 0 := by
    intro hz
    have hh : D < 17*A*B*S*T*C^3 := (hforms.2 hz).2
    exact lt_asymm hh hterminal.2
  let Tup : Finset (𝓞 K) := Finset.univ.image a
  have hmem (i : Fin 6) : a i ∈ Tup :=
    Finset.mem_image.mpr ⟨i, Finset.mem_univ i, rfl⟩
  have hTup : IsD1 Tup := by
    constructor
    · intro x hx
      obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hx
      exact ha.2.1 i
    · intro x hx y hy hxy
      obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hx
      obtain ⟨j, _, rfl⟩ := Finset.mem_image.mp hy
      exact ha.2.2 i j (fun hij => hxy (congrArg a hij))
  have hbm (i : Fin 4) : b i ∈ Tup := hmem (i4 i)
  have hbp (i : Fin 4) : b i ≠ a 4 := ha.1.ne (by fin_cases i <;> decide)
  have hbq (i : Fin 4) : b i ≠ a 5 := ha.1.ne (by fin_cases i <;> decide)
  have hdelta : phi ((coherentVandermonde4 b : 𝓞 K) : K) = coherentVandermonde4 v := by
    change f (coherentVandermonde4 b) = coherentVandermonde4 v
    simp [coherentVandermonde4,v]
  have hnonzero' : coherentQuotientForm (fun i => phi (b i : K))
      (phi ((coherentVandermonde4 b : 𝓞 K) : K)) (phi (a 4 : K)) (phi (a 5 : K)) eta ≠ 0 := by
    rw [hdelta]
    exact hnonzero
  have hlow := full_ring_coherent_four_one_le_norm hK phi hTup
    (hmem 4) (hmem 5) (ha.1.ne (by decide)) b hb.1 hbm hbp hbq eta heta hnonzero'
  rw [hdelta] at hlow
  have hPQ : 4000 < C*D := by
    have hh := mul_le_mul_of_nonneg_left hCD hC0.le
    nlinarith only [hh,hC1000,sq_nonneg (C-1000)]
  have hroots := coherent_terminal_root_norm_sq_bounds (f (a 4)) (f (a 5)) eta
    (norm_pos_iff.mp hC0) (norm_pos_iff.mp hD0) heta hPQ
  have hZ : 0 < Z := by
    have hz0 : 0 ≤ Z := norm_nonneg _
    have hh : 0 < (3999/4000 : ℝ)*C*D := by positivity
    nlinarith only [hz0,hh,hroots.1]
  have hupper : ‖L‖ < 13*B*S^2*T^3/Z+(49/50 : ℝ)*S*T^2*Z/(A*C^4) := by
    calc
      ‖L‖ < 13*B*S^2*T^3/Z+49*S*T^2*Z/(50*A*C^4) := hforms.1
      _ = _ := by ring
  have hfinal := retained_mixed_four_start_scalar_gap A B S T C D Z ‖L‖
    hA hB3 hS0 hT0 (hST.trans hTC) hTC hC1000 hZ hC16 hDgap
    hroots.1 hroots.2 hlow hupper
  exact ⟨hCgap,hDgap,hfinal,hC1000,hcommon.2.1,hcommon.2.2,hC16,hterminal.1⟩

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.retained_start_of_frontier

#print axioms D1Bound5.coherent_retained_h32_common_sizes
