import D1Bound5.CoherentFixedCutoffGap
import D1Bound5.OneSmallCutoffReal
import D1Bound5.FiniteQInterval

open Finset
open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- The actual finite Q interval forces an ordered full-ring sextuple
past its upper endpoint as soon as it has passed the lower endpoint.
The lower anchor radius is one, obtained from integrality. -/
theorem IsD1Tuple.finiteQ_upper_of_lower
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hC : 1000 ≤ ‖phi (a 4 : K)‖)
    (hCT : 4*‖phi (a 3 : K)‖ ≤ ‖phi (a 4 : K)‖)
    (hleft : 4*55^2*‖phi (a 3 : K)‖^6*‖phi (a 4 : K)‖^3/(1-1/4000 : ℝ) ≤
      ‖phi (a 5 : K)‖) :
    ‖phi (a 4 : K)‖^7/(9*‖phi (a 3 : K)‖^2*(1+1/4000 : ℝ)) <
      ‖phi (a 5 : K)‖ := by
  classical
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
  let b : Fin 4 → 𝓞 K := fun i => a (Fin.castAdd 2 i)
  have hcast : Function.Injective (Fin.castAdd 2 : Fin 4 → Fin 6) := by
    intro i j hij
    apply Fin.ext
    exact congrArg (fun k : Fin 6 => k.val) hij
  have hbc (i : Fin 4) : b i ≠ a 4 := by
    apply ha.1.ne
    apply Fin.ne_of_val_ne
    have hi := i.isLt
    change i.val ≠ 4
    omega
  have hbd (i : Fin 4) : b i ≠ a 5 := by
    apply ha.1.ne
    apply Fin.ne_of_val_ne
    have hi := i.isLt
    change i.val ≠ 5
    omega
  have hlow (i : Fin 4) : (1 : ℝ) ≤ ‖phi (b i : K)‖ :=
    one_le_norm_integer hK phi (ha.2.1 (Fin.castAdd 2 i))
  have hhigh (i : Fin 4) : ‖phi (b i : K)‖ ≤ ‖phi (a 3 : K)‖ := by
    apply hmon
    change i.val ≤ 3
    omega
  by_contra hn
  have hright := le_of_not_gt hn
  exact full_ring_finiteQ_closed_interval_excluded hK phi hTup b (a 4) (a 5)
    (fun i => hmem (Fin.castAdd 2 i)) (hmem 4) (hmem 5)
    (ha.1.comp hcast) hbc hbd (ha.1.ne (by decide)) 1 ‖phi (a 3 : K)‖
    (by norm_num) hlow hhigh hCT (hmon (by decide))
    (by simpa only [one_mul] using hC) hleft
    (by simpa only [one_pow,one_mul] using hright)

/-- An actual normalized fixed-triple sextuple above its printed cutoff
already lies strictly above the upper Q endpoint. This joins the exact
rational cutoff table, retained growth and the actual Q polynomials. -/
theorem IsD1Tuple.fixed_cutoff_above_Q
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (r : OneSmallCutoffRow) (hr : r ∈ oneSmallCutoffRows)
    (e : QuadInt r.triple.tau r.triple.nu ≃+* 𝓞 K)
    (sgn conj : Bool)
    (h0 : smallExtensionSymmetry sgn conj (e.symm (a 0)) = r.triple.anchorA)
    (h1 : smallExtensionSymmetry sgn conj (e.symm (a 1)) = r.triple.anchorB)
    (h2 : smallExtensionSymmetry sgn conj (e.symm (a 2)) = r.triple.anchorS)
    (hlarge : (r.triple.cutoff : ℝ) ≤ ‖phi (a 3 : K)‖^2) :
    ‖phi (a 4 : K)‖^7/(9*‖phi (a 3 : K)‖^2*(1+1/4000 : ℝ)) <
      ‖phi (a 5 : K)‖ := by
  let A := ‖phi (a 0 : K)‖
  let S := ‖phi (a 2 : K)‖
  let T := ‖phi (a 3 : K)‖
  let C := ‖phi (a 4 : K)‖
  let D := ‖phi (a 5 : K)‖
  have hA : 1 ≤ A := one_le_norm_integer hK phi (ha.2.1 0)
  have hS : 0 < S := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1)
    (one_le_norm_integer hK phi (ha.2.1 2))
  have hT : 0 < T := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1)
    (one_le_norm_integer hK phi (ha.2.1 3))
  have hC : 0 < C := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1)
    (one_le_norm_integer hK phi (ha.2.1 4))
  have hv := oneSmallCutoffRows_valid r hr
  have hSsq : S^2 = (r.s0 : ℝ) := by
    have hn : ‖phi (a 2 : K)‖^2 =
        ((smallExtensionSymmetry sgn conj (e.symm (a 2))).norm : ℝ) := by
      simpa only [smallExtensionSymmetry_norm,RingEquiv.apply_symm_apply] using
        norm_sq_full_ring_equiv e phi (e.symm (a 2))
    rw [h2] at hn
    simpa [S,OneSmallCutoffRow.s0] using hn
  have hover := r.start_overlap_real hv S T hS hSsq hlarge
  have hg := IsD1Tuple.fixed_cutoff_retained_gap hK phi a ha hmon r hr e sgn conj h0 h1 h2 hlarge
  have hstart : C^7/(S^2*T^4) < D := by
    have hA2 : 1 ≤ A^2 := by nlinarith only [hA]
    calc
      _ ≤ A^2*C^7/(S^2*T^4) := by gcongr
      _ < D := hg.2.2.1
  have hcoefpos : 0 < (r.retainedCoefficient : ℝ) := by
    obtain ⟨_,_,_,_,_,_,_,_,_,_,_,_,hK,_⟩ := hv
    have hh : (1 : ℝ) < (r.retainedCoefficient : ℝ) := by exact_mod_cast hK
    linarith only [hh]
  have hleft := fixed_cutoff_start_above_Q (r.retainedCoefficient : ℝ) S T C D
    hcoefpos hS hT hC hg.1 hstart hover
  exact IsD1Tuple.finiteQ_upper_of_lower hK phi a ha hmon
    hg.2.2.2.1.le hg.2.2.2.2.2.1.le hleft.le

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.finiteQ_upper_of_lower
#print axioms D1Bound5.IsD1Tuple.fixed_cutoff_above_Q
