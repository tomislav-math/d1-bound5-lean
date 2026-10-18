import D1Bound5.OrdinaryHeightEnvelope
import D1Bound5.BennettRootTransfer

open scoped NumberField
open Module

namespace D1Bound5

/-- A terminal square root supplies the height comparison and is
automatically nonzero in the ordered large-entry regime. -/
theorem complex_terminal_root_height (c d z : ℂ)
    (hC : 2 ≤ ‖c‖) (hCD : ‖c‖ ≤ ‖d‖) (hz : z^2 = c*d+1) :
    1 ≤ ‖z‖ ∧ ‖c‖*‖d‖ < 2*‖z‖^2 := by
  have hD : 2 ≤ ‖d‖ := hC.trans hCD
  have hCD4 : 4 ≤ ‖c‖*‖d‖ := by
    have hp := mul_nonneg (sub_nonneg.mpr hC) (sub_nonneg.mpr hD)
    nlinarith only [hp,hC,hD]
  have hZ : ‖c‖*‖d‖ ≤ ‖z‖^2+1 := by
    have hid : c*d = z^2-1 := by rw [hz]; ring
    have hh := norm_sub_le (z^2) (1 : ℂ)
    rw [← hid,norm_mul] at hh
    simpa only [norm_pow,norm_one] using hh
  constructor
  · by_contra hbad
    have hp := mul_nonneg (sub_nonneg.mpr (le_of_lt (lt_of_not_ge hbad)))
      (show 0 ≤ 1+‖z‖ by positivity)
    nlinarith only [hZ,hCD4,hp]
  · nlinarith only [hZ,hCD4]

/-- The manuscript ordinary height envelope for an actual ordered
D(1)-quadruple. The all-order analytic estimate is obtained internally
from the constructed integral Bennett matrix and the tuple's roots. -/
theorem IsD1Tuple.ordinary_height_envelope
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 4 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (hAC : 1000 ≤ ‖phi (a 0 : K)‖*‖phi (a 2 : K)‖)
    (hC : 4*‖phi (a 1 : K)‖ < ‖phi (a 2 : K)‖)
    (h r u : ℝ)
    (hHlog : ordinaryLog10 (42*‖phi (a 1 : K)‖^3*‖phi (a 2 : K)‖) <
      ordinaryLog10 ‖phi (a 2 : K)‖+h)
    (hRlog : 2*ordinaryLog10 ‖phi (a 2 : K)‖+r <
      ordinaryLog10 (bennettTwoResidualRate ‖phi (a 0 : K)‖ ‖phi (a 1 : K)‖
        ‖phi (a 2 : K)‖ ‖phi (a 0 : K)-phi (a 1 : K)‖))
    (hUlog : ordinaryLog10 (253*‖phi (a 1 : K)‖^2) < u)
    (hxt : h-r < ordinaryLog10 ‖phi (a 2 : K)‖)
    (hx2 : 0 < 2*ordinaryLog10 ‖phi (a 2 : K)‖+r) :
    ordinaryLog10 ‖phi (a 3 : K)‖ < 7*ordinaryLog10 ‖phi (a 2 : K)‖+
      (4*u+8*h-4*r)+(2*u*r+(4*u+8*h-4*r)*(h-r))/
        (ordinaryLog10 ‖phi (a 2 : K)‖-(h-r))+(2/5 : ℝ) := by
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  have hA1 : 1 ≤ ‖f (a 0)‖ := one_le_norm_integer hK phi (ha.2.1 0)
  have hB1 : 1 ≤ ‖f (a 1)‖ := one_le_norm_integer hK phi (ha.2.1 1)
  have hD1 : 1 ≤ ‖f (a 3)‖ := one_le_norm_integer hK phi (ha.2.1 3)
  have hA0 : 0 < ‖f (a 0)‖ := by linarith only [hA1]
  have hB0 : 0 < ‖f (a 1)‖ := by linarith only [hB1]
  have hD0 : 0 < ‖f (a 3)‖ := by linarith only [hD1]
  have hC2 : 2 ≤ ‖f (a 2)‖ := by linarith only [hC,hB1]
  have hC1 : 1 < ‖f (a 2)‖ := by linarith only [hC2]
  have hdelta1 : 1 ≤ ‖f (a 0)-f (a 1)‖ := by
    have hh := one_le_norm_integer hK phi
      (sub_ne_zero.mpr (ha.1.ne (by decide : (0 : Fin 4) ≠ 1)))
    change 1 ≤ ‖f (a 0-a 1)‖ at hh
    simpa only [map_sub] using hh
  have hdelta : 0 < ‖f (a 0)-f (a 1)‖ := by linarith only [hdelta1]
  have hrate := bennettTwoResidualRate_pos ‖f (a 0)‖ ‖f (a 1)‖ ‖f (a 2)‖
    ‖f (a 0)-f (a 1)‖ hA0 hB0 hdelta (by linarith only [hAC])
  obtain ⟨rA,hrA⟩ := ha.2.2 0 2 (by decide)
  obtain ⟨rB,hrB⟩ := ha.2.2 1 2 (by decide)
  obtain ⟨vA,hvA⟩ := ha.2.2 0 3 (by decide)
  obtain ⟨vB,hvB⟩ := ha.2.2 1 3 (by decide)
  obtain ⟨z,hz⟩ := ha.2.2 2 3 (by decide)
  have hzC : (f z)^2 = f (a 2)*f (a 3)+1 := by
    simpa only [pow_two,map_mul,map_add,map_one] using congrArg f hz
  obtain ⟨hZ,hprod⟩ := complex_terminal_root_height (f (a 2)) (f (a 3)) (f z)
    hC2 (hmon (by decide : (2 : Fin 4) ≤ 3)) hzC
  apply ordinary_height_envelope_from_orders ‖f (a 1)‖ ‖f (a 2)‖ ‖f (a 3)‖ ‖f z‖
    (bennettTwoResidualRate ‖f (a 0)‖ ‖f (a 1)‖ ‖f (a 2)‖ ‖f (a 0)-f (a 1)‖)
    h r u hB1 hC1 hD0 hZ hrate hprod hHlog hRlog hUlog hxt hx2
  intro k hk
  exact full_ring_bennett_two_integer_k hK phi (a 0) (a 1) (a 2) (a 3)
    rA rB vA vB z (ha.2.1 0) (ha.2.1 1) (ha.2.1 2) (ha.2.1 3)
    (ha.1.ne (by decide : (0 : Fin 4) ≠ 1))
    (by simpa only [pow_two] using hrA) (by simpa only [pow_two] using hrB)
    (by simpa only [pow_two] using hvA) (by simpa only [pow_two] using hvB)
    (by simpa only [pow_two] using hz) (hmon (by decide : (0 : Fin 4) ≤ 1))
    hAC hC k hk

end D1Bound5
