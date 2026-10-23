import D1Bound5.CoherentRetainedMixedGap

namespace D1Bound5

/-- The first retained power gap separates the fourth anchor from the
first terminal by the factor needed in the direct-four estimate. -/
theorem coherent_retained_mixed_first_terminal_large
    (A B S T C : ℝ) (hA : 1 ≤ A) (hB : 3 ≤ B) (hS : 0 < S)
    (hBS : B ≤ S) (hST : S ≤ T)
    (hfront : 2*A*B*S < T) (hgap : A^2*T^5/S^2 < C) :
    16*B*S*T < C := by
  have hA0 : 0 < A := by linarith only [hA]
  have hB0 : 0 < B := by linarith only [hB]
  have hT : 0 < T := hS.trans_le hST
  have hBT : B ≤ T := hBS.trans hST
  have hAB : 3 ≤ A*B := by
    nlinarith only [hA,hB,mul_nonneg (sub_nonneg.mpr hA) (sub_nonneg.mpr hB)]
  have h2S : 6*S < T := by
    have hh := mul_le_mul_of_nonneg_right hAB hS.le
    nlinarith only [hh,hfront,hS]
  have hT2 : 36*S^2 ≤ T^2 := by
    have hh := mul_pos (sub_pos.mpr h2S) (show 0 < T+6*S by positivity)
    nlinarith only [hh]
  have hsmall : 16*B*S*T ≤ 16*T^3 := by
    calc
      16*B*S*T ≤ 16*T*T*T := by gcongr
      _ = _ := by ring
  have hA2 : (1 : ℝ) ≤ A^2 := by nlinarith only [hA,sq_nonneg (A-1)]
  have hmiddle : 16*T^3 < 36*A^2*T^3 := by
    have hh := mul_pos (show 0 < 36*A^2-16 by linarith only [hA2]) (pow_pos hT 3)
    nlinarith only [hh]
  have hlarge : 36*A^2*T^3 ≤ A^2*T^5/S^2 := by
    apply (le_div_iff₀ (pow_pos hS 2)).2
    have hh := mul_le_mul_of_nonneg_left hT2 (by positivity : 0 ≤ A^2*T^3)
    nlinarith only [hh]
  exact (hsmall.trans_lt (hmiddle.trans_le hlarge)).trans hgap

/-- The repeated retained power gap supplies the direct-four separation
and excludes the zero-form upper window. -/
theorem coherent_retained_mixed_four_terminal_sizes
    (A B S T C D : ℝ) (hA : 1 ≤ A) (hB : 3 ≤ B)
    (hS : 0 < S) (hT : 0 < T) (hST : S ≤ T) (hSC : S ≤ C)
    (hC1000 : 1000 < C) (hC : 16*B*S*T < C)
    (hD : A^2*C^5/S^2 < D) :
    1000*C < D ∧ 17*A*B*S*T*C^3 < D := by
  have hA0 : 0 < A := by linarith only [hA]
  have hB0 : 0 < B := by linarith only [hB]
  have hC0 : 0 < C := by linarith only [hC1000]
  have hA2 : (1 : ℝ) ≤ A^2 := by nlinarith only [hA,sq_nonneg (A-1)]
  constructor
  · have hC2 : (1000 : ℝ) < C^2 := by nlinarith only [hC1000,sq_nonneg (C-1000)]
    have hstart : 1000*C < C^3 := by
      have hh := mul_lt_mul_of_pos_right hC2 hC0
      nlinarith only [hh]
    have hfinish : C^3 ≤ A^2*C^5/S^2 := by
      apply (le_div_iff₀ (pow_pos hS 2)).2
      have hs : S^2 ≤ C^2 := by gcongr
      have hmul := mul_le_mul_of_nonneg_left hs (pow_nonneg hC0.le 3)
      have ha := mul_le_mul_of_nonneg_right hA2 (pow_nonneg hC0.le 5)
      nlinarith only [hmul,ha]
    exact (hstart.trans_le hfinish).trans hD
  · have hAB : 3 ≤ A*B := by
      nlinarith only [hA,hB,mul_nonneg (sub_nonneg.mpr hA) (sub_nonneg.mpr hB)]
    have hcoef : 17*A*B < 256*A^2*B^2 := by
      have hh := mul_pos (show 0 < A*B by positivity)
        (show 0 < 256*A*B-17 by linarith only [hAB])
      nlinarith only [hh]
    have hC2 : (16*B*S*T)^2 < C^2 := by gcongr
    have hC2' := mul_lt_mul_of_pos_left hC2 (pow_pos hA0 2)
    have hcoef' := mul_lt_mul_of_pos_right hcoef (by positivity : 0 < S^2*T^2)
    have hST' : 17*A*B*S^3*T ≤ 17*A*B*S^2*T^2 := by
      have hh := mul_le_mul_of_nonneg_left hST (by positivity : 0 ≤ 17*A*B*S^2*T)
      nlinarith only [hh]
    have hbase : 17*A*B*S*T < A^2*C^2/S^2 := by
      apply (lt_div_iff₀ (pow_pos hS 2)).2
      nlinarith only [hC2',hcoef',hST']
    have hh := mul_lt_mul_of_pos_right hbase (pow_pos hC0 3)
    have heq : (A^2*C^2/S^2)*C^3 = A^2*C^5/S^2 := by ring
    rw [heq] at hh
    exact hh.trans hD

/-- The mixed retained power gap with AT≥48 supplies the common large
terminal hypotheses for the approximation constructions. -/
theorem coherent_retained_mixed_common_sizes
    (A S T C : ℝ) (hA : 1 ≤ A) (hS3 : 3 ≤ S) (hST : S ≤ T)
    (hAT48 : 48 ≤ A*T) (hgap : A^2*T^5/S^2 < C) :
    1000 < C ∧ 200*S < C ∧ 4*T < C := by
  have hS : 0 < S := by linarith only [hS3]
  have hT : 0 < T := hS.trans_le hST
  have hbase : A^2*T^3 ≤ A^2*T^5/S^2 := by
    apply (le_div_iff₀ (pow_pos hS 2)).2
    have hs : S^2 ≤ T^2 := by gcongr
    have hh := mul_le_mul_of_nonneg_left hs (by positivity : 0 ≤ A^2*T^3)
    nlinarith only [hh]
  have hT3 : A^2*T^3 < C := hbase.trans_lt hgap
  have hAT2 : (2304 : ℝ) ≤ A^2*T^2 := by nlinarith only [hAT48,sq_nonneg (A*T-48)]
  have hmul := mul_le_mul_of_nonneg_right hAT2 hT.le
  refine ⟨?_,?_,?_⟩
  · nlinarith only [hS3,hST,hmul,hT3]
  · nlinarith only [hST,hS,hmul,hT3]
  · nlinarith only [hT,hmul,hT3]

end D1Bound5

#print axioms D1Bound5.coherent_retained_mixed_first_terminal_large
#print axioms D1Bound5.coherent_retained_mixed_four_terminal_sizes
#print axioms D1Bound5.coherent_retained_mixed_common_sizes
