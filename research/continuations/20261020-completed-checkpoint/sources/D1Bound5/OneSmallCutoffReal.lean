import Mathlib.Data.Real.Basic
import D1Bound5.OneSmallCutoffArithmetic

namespace D1Bound5

/-- Every strict rational overlap at the cutoff remains strict for all
larger real squared fourth moduli. -/
theorem OneSmallCutoffRow.overlaps_at_real (r : OneSmallCutoffRow)
    (hv : r.Valid) (x : ℝ) (hx : (r.triple.cutoff : ℝ) ≤ x)
    (e : ℚ × ℕ) (he : e ∈ r.overlaps) :
    1 < (e.1 : ℝ)*x^e.2 := by
  obtain ⟨hcut,hAN,hB,hBS,hq,hqle,hq1,hD,hphi,hp6,hp5,hsep,hK,
    hM2,hMn,hM3,hM4,hM5,hMbs,hover,htail⟩ := hv
  have hn : (0 : ℝ) < r.triple.cutoff := by
    have hn' : (1024 : ℝ) ≤ r.triple.cutoff := by exact_mod_cast hcut
    linarith only [hn']
  have hseed : 1 < (e.1 : ℝ)*(r.triple.cutoff : ℝ)^e.2 := by
    exact_mod_cast hover e he
  have hc : 0 < (e.1 : ℝ) := by
    by_contra hh
    have hnonpos := mul_nonpos_of_nonpos_of_nonneg
      (le_of_not_gt hh) (pow_nonneg hn.le e.2)
    linarith only [hseed,hnonpos]
  have hp : (r.triple.cutoff : ℝ)^e.2 ≤ x^e.2 := by gcongr
  exact hseed.trans_le (mul_le_mul_of_nonneg_left hp hc.le)

/-- The first table inequality is exactly the strict overlap of the
retained direct-four start with the finite Q interval. -/
theorem OneSmallCutoffRow.start_overlap_real (r : OneSmallCutoffRow)
    (hv : r.Valid) (S T : ℝ) (hS : 0 < S)
    (hSsq : S^2 = (r.s0 : ℝ))
    (hlarge : (r.triple.cutoff : ℝ) ≤ T^2) :
    1 < (1-1/4000 : ℝ)*(r.retainedCoefficient : ℝ)^4*T^10/(12100*S^10) := by
  have h := r.overlaps_at_real hv (T^2) hlarge
    (((1-1/4000)*r.retainedCoefficient^4/(12100*r.s0^5)),5)
    (by simp [OneSmallCutoffRow.overlaps])
  change 1 < (((1-1/4000)*r.retainedCoefficient^4/(12100*r.s0^5) : ℚ) : ℝ)*
    (T^2)^5 at h
  push_cast at h
  rw [←hSsq] at h
  convert h using 1 <;> ring

/-- Scalar conversion of the first overlap, retaining every strict
inequality. The two growth premises are precisely the actual retained
bounds already proved for fixed triples. -/
theorem fixed_cutoff_start_above_Q (K S T C D : ℝ)
    (hK : 0 < K) (hS : 0 < S) (hT : 0 < T) (hC : 0 < C)
    (hgap : K*T^5/S^2 < C) (hstart : C^7/(S^2*T^4) < D)
    (hover : 1 < (1-1/4000 : ℝ)*K^4*T^10/(12100*S^10)) :
    4*55^2*T^6*C^3/(1-1/4000 : ℝ) < D := by
  have hc : K*T^5 < C*S^2 := (div_lt_iff₀ (pow_pos hS 2)).mp hgap
  have hc4 : (K*T^5)^4 < (C*S^2)^4 := by gcongr
  have hp : K^4*T^20 < C^4*S^8 := by convert hc4 using 1 <;> ring
  have he : 0 < (1-1/4000 : ℝ) := by norm_num
  have hn : 12100*S^10 < (1-1/4000 : ℝ)*K^4*T^10 := by
    have h := (lt_div_iff₀ (by positivity : (0 : ℝ) < 12100*S^10)).mp hover
    simpa only [one_mul] using h
  have hprod : (12100*S^10)*T^10 < (1-1/4000 : ℝ)*(C^4*S^8) := by
    calc
      _ < ((1-1/4000 : ℝ)*K^4*T^10)*T^10 :=
        mul_lt_mul_of_pos_right hn (pow_pos hT 10)
      _ = (1-1/4000 : ℝ)*(K^4*T^20) := by ring
      _ < _ := mul_lt_mul_of_pos_left hp he
  have hC4 : 12100*S^2*T^10 < (1-1/4000 : ℝ)*C^4 := by
    apply (mul_lt_mul_iff_of_pos_right (pow_pos hS 8)).mp
    calc
      (12100*S^2*T^10)*S^8 = (12100*S^10)*T^10 := by ring
      _ < (1-1/4000 : ℝ)*(C^4*S^8) := hprod
      _ = ((1-1/4000 : ℝ)*C^4)*S^8 := by ring
  have hlower : 4*55^2*T^6*C^3/(1-1/4000 : ℝ) < C^7/(S^2*T^4) := by
    apply (div_lt_div_iff₀ he (by positivity : 0 < S^2*T^4)).mpr
    have hh := mul_lt_mul_of_pos_right hC4 (pow_pos hC 3)
    convert hh using 1 <;> ring
  exact hlower.trans hstart

end D1Bound5

#print axioms D1Bound5.OneSmallCutoffRow.overlaps_at_real
#print axioms D1Bound5.OneSmallCutoffRow.start_overlap_real
#print axioms D1Bound5.fixed_cutoff_start_above_Q
