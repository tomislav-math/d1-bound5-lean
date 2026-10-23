import D1Bound5.CoherentRetainedFrontierStart
import D1Bound5.OneSmallFullRingFinite
import D1Bound5.OneSmallRowMetadata
import D1Bound5.TailIrregular

open Finset
open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- In every one of the 56 actual normalized fixed-triple rows, a fourth
norm at or above its printed cutoff supplies the precise H32 frontier
inputs. Norm-one rows use actual tail irregularity; norm-two rows use
the verified strict cutoff metadata. -/
theorem oneSmallRow_full_ring_retained_parameters
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 4 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K)
    (sgn conj : Bool) (cutoff : ℤ)
    (hrow : OneSmallRowMembership
      (smallExtensionSymmetry sgn conj (e.symm (a 0)))
      (smallExtensionSymmetry sgn conj (e.symm (a 1)))
      (smallExtensionSymmetry sgn conj (e.symm (a 2))) cutoff)
    (hlarge : (cutoff : ℝ) ≤ ‖phi (a 3 : K)‖^2) :
    3 ≤ ‖phi (a 1 : K)‖ ∧
      2*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖ < ‖phi (a 3 : K)‖ ∧
      32 ≤ ‖phi (a 0 : K)‖*‖phi (a 3 : K)‖ := by
  classical
  let F : 𝓞 K → QuadInt tau nu := fun w => smallExtensionSymmetry sgn conj (e.symm w)
  let r : OneSmallTripleRow :=
    ⟨tau,nu,((F (a 0)).re,(F (a 0)).im),((F (a 1)).re,(F (a 1)).im),
      ((F (a 2)).re,(F (a 2)).im),cutoff⟩
  have hr : r ∈ oneSmallFixedRows := hrow
  obtain ⟨hcut,hAN,hBN,hcut2⟩ := oneSmallFixedRows_metadata r hr
  have hnorm (i : Fin 4) : ‖phi (a i : K)‖^2 = ((F (a i)).norm : ℝ) := by
    simpa only [F,smallExtensionSymmetry_norm,RingEquiv.apply_symm_apply] using
      norm_sq_full_ring_equiv e phi (e.symm (a i))
  change 1024 ≤ cutoff at hcut
  change (F (a 0)).norm = 1 ∨ (F (a 0)).norm = 2 at hAN
  change 9 ≤ (F (a 1)).norm at hBN
  change (F (a 0)).norm = 2 →
    4*(F (a 0)).norm*(F (a 1)).norm*(F (a 2)).norm < cutoff at hcut2
  have hBsq : (9 : ℝ) ≤ ‖phi (a 1 : K)‖^2 := by
    rw [hnorm 1]
    exact_mod_cast hBN
  have hB : 3 ≤ ‖phi (a 1 : K)‖ :=
    (sq_le_sq₀ (by norm_num) (norm_nonneg _)).mp (by simpa only [show (3 : ℝ)^2 = 9 by norm_num] using hBsq)
  have hcutReal : (1024 : ℝ) ≤ cutoff := by exact_mod_cast hcut
  have hT : 32 ≤ ‖phi (a 3 : K)‖ :=
    (sq_le_sq₀ (by norm_num) (norm_nonneg _)).mp (by simpa only [show (32 : ℝ)^2 = 1024 by norm_num] using hcutReal.trans hlarge)
  have hA : 1 ≤ ‖phi (a 0 : K)‖ := one_le_norm_integer hK phi (ha.2.1 0)
  have hAT : 32 ≤ ‖phi (a 0 : K)‖*‖phi (a 3 : K)‖ := by
    have hh := mul_le_mul hA hT (by norm_num : (0 : ℝ) ≤ 32) (norm_nonneg _)
    simpa only [one_mul] using hh
  refine ⟨hB,?_,hAT⟩
  rcases hAN with hN | hN
  · have hAsq : ‖phi (a 0 : K)‖^2 = 1 := by
      rw [hnorm 0]
      exact_mod_cast hN
    have hAeq : ‖phi (a 0 : K)‖ = 1 := by nlinarith only [hAsq,hA]
    have ht := (IsD1Tuple.tail_irregular_and_growth hK phi a ha hmon hB).2
    simpa only [hAeq,mul_one] using ht
  · have hbound : 4*‖phi (a 0 : K)‖^2*‖phi (a 1 : K)‖^2*‖phi (a 2 : K)‖^2 <
        (cutoff : ℝ) := by
      rw [hnorm 0,hnorm 1,hnorm 2]
      exact_mod_cast hcut2 hN
    have hsq : (2*‖phi (a 0 : K)‖*‖phi (a 1 : K)‖*‖phi (a 2 : K)‖)^2 <
        ‖phi (a 3 : K)‖^2 := by nlinarith only [hbound,hlarge]
    exact (sq_lt_sq₀ (by positivity) (norm_nonneg _)).mp hsq

/-- The actual fixed-triple cutoff supplies every retained-start and
large-terminal hypothesis needed by its approximation interval chain.
This does not assume or assert any forbidden-interval exclusion. -/
theorem IsD1Tuple.one_small_row_retained_start
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K)
    (sgn conj : Bool) (cutoff : ℤ)
    (hrow : OneSmallRowMembership
      (smallExtensionSymmetry sgn conj (e.symm (a 0)))
      (smallExtensionSymmetry sgn conj (e.symm (a 1)))
      (smallExtensionSymmetry sgn conj (e.symm (a 2))) cutoff)
    (hlarge : (cutoff : ℝ) ≤ ‖phi (a 3 : K)‖^2) :
    let A := ‖phi (a 0 : K)‖
    let B := ‖phi (a 1 : K)‖
    let S := ‖phi (a 2 : K)‖
    let T := ‖phi (a 3 : K)‖
    let C := ‖phi (a 4 : K)‖
    let D := ‖phi (a 5 : K)‖
    A^2*T^5/S^2 < C ∧ A^2*C^5/S^2 < D ∧ A^2*C^7/(S^2*T^4) < D ∧
      1000 < C ∧ 200*S < C ∧ 4*T < C ∧ 16*B*S*T < C ∧ 1000*C < D := by
  let b : Fin 4 → 𝓞 K := fun i => a (Fin.castAdd 2 i)
  have hcast : Function.Injective (Fin.castAdd 2 : Fin 4 → Fin 6) := by
    intro i j hij
    apply Fin.ext
    exact congrArg (fun k : Fin 6 => k.val) hij
  have hb : IsD1Tuple b := by
    refine ⟨ha.1.comp hcast,?_,?_⟩
    · intro i
      exact ha.2.1 (Fin.castAdd 2 i)
    · intro i j hij
      exact ha.2.2 (Fin.castAdd 2 i) (Fin.castAdd 2 j) (hcast.ne hij)
  have hbmon : Monotone (fun i => ‖phi (b i : K)‖) := by
    intro i j hij
    exact hmon hij
  have hp := oneSmallRow_full_ring_retained_parameters hK phi b hb hbmon e sgn conj cutoff hrow hlarge
  exact IsD1Tuple.retained_start_of_frontier hK phi a ha hmon hp.1 hp.2.1 hp.2.2

end D1Bound5

#print axioms D1Bound5.oneSmallRow_full_ring_retained_parameters
#print axioms D1Bound5.IsD1Tuple.one_small_row_retained_start
