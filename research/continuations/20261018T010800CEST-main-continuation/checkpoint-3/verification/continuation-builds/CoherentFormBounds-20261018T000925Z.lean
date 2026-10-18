import D1Bound5.CoherentQuotientForms
import D1Bound5.CoherentNearOne

open Finset

namespace D1Bound5

/-- The complete homogeneous remainder for the actual reciprocal
terminal parameters.  The finite-subtype indexing matches the proved
Lagrange interpolation theorem exactly. -/
noncomputable def coherentRemainder {m : ℕ} (a : Fin m → ℂ) (p q : ℂ) : ℂ :=
  ∑' j : ℕ, halfBinomialWeightedCoeff p⁻¹ q⁻¹ (m + j) *
    MvPolynomial.aeval (fun i : (Finset.univ : Finset (Fin m)) => (a i)⁻¹)
      (MvPolynomial.hsymm (Finset.univ : Finset (Fin m)) ℂ j)

/-- The normalized exact identity for the actual manuscript form,
including the precise coherent branch choices and all quotient weights. -/
theorem coherentQuotientForm_normalized_eq
    {m : ℕ} (a : Fin m → ℂ) (hm : 2 ≤ m)
    (ha : ∀ i, a i ≠ 0) (hinj : Function.Injective a)
    (Delta p q eta : ℂ) (hDelta : Delta ≠ 0) (heta : eta ≠ 0)
    (hp : ∀ i, ‖p⁻¹ * (a i)⁻¹‖ < 1)
    (hq : ∀ i, ‖q⁻¹ * (a i)⁻¹‖ < 1) :
    coherentQuotientForm a Delta p q eta / (Delta * eta) =
      1 - ((1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ)) +
        ((-1 : ℂ) ^ (m - 1) * (∏ i, a i)⁻¹) * coherentRemainder a p q := by
  let g : Fin m → ℂ := fun i =>
    ((1 + p⁻¹ * (a i)⁻¹) ^ (1 / 2 : ℂ)) *
      ((1 + q⁻¹ * (a i)⁻¹) ^ (1 / 2 : ℂ))
  have hs : (Finset.univ : Finset (Fin m)).Nonempty :=
    ⟨⟨0, by omega⟩, Finset.mem_univ _⟩
  have hnorm : coherentQuotientForm a Delta p q eta / (Delta * eta) =
      (∑ i, ((a i) ^ (m - 1) /
        (∏ j ∈ Finset.univ.erase i, (a i - a j))) * g i) -
        ((1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ)) := by
    simpa only [coherentQuotientForm, coherentTerminalRoot, coherentAnchorRoot,
      Finset.card_univ, Fintype.card_fin, g, mul_assoc] using
      coherent_interpolation_normalization Finset.univ a g
        ((1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ)) Delta eta
        (by simpa using hm) hDelta heta
  have h := coherent_half_binomial_exact Finset.univ a hs
    (fun i _ => ha i) hinj.injOn p⁻¹ q⁻¹ (fun i _ => hp i) (fun i _ => hq i)
  have hsum : (∑ i, ((a i) ^ (m - 1) /
        (∏ j ∈ Finset.univ.erase i, (a i - a j))) * g i) =
      1 + ((-1 : ℂ) ^ (m - 1) * (∏ i, a i)⁻¹) * coherentRemainder a p q := by
    simpa only [Finset.card_univ, Fintype.card_fin, coherentRemainder, g] using h.2
  rw [hnorm, hsum]
  ring

/-- The manuscript tail estimate applied directly to the remainder in
the actual coherent form. -/
theorem coherentRemainder_norm_sub_le
    {m : ℕ} (a : Fin m → ℂ) (hm : 2 ≤ m) (p q : ℂ) (A P : ℝ)
    (hA : 0 < A) (hP : 0 < P) (ha : ∀ i, A ≤ ‖a i‖)
    (hp : ‖p⁻¹‖ ≤ 1 / P) (hq : ‖q⁻¹‖ ≤ 1 / P) (hAP : 1 < A * P) :
    ‖coherentRemainder a p q - halfBinomialWeightedCoeff p⁻¹ q⁻¹ m‖ ≤
      (4 * |halfBinomialCoeff (m + 1)|) / P ^ m *
        (1 / (1 - 1 / (A * P)) ^ m - 1) := by
  have hs : (Finset.univ : Finset (Fin m)).Nonempty :=
    ⟨⟨0, by omega⟩, Finset.mem_univ _⟩
  have h := coherent_half_binomial_manuscript_tail_norm_le Finset.univ a hs
    p⁻¹ q⁻¹ A P hA hP (fun i _ => ha i) hp hq hAP
  simpa only [Finset.card_univ, Fintype.card_fin, coherentRemainder] using h.2

/-- An explicit upper bound for the actual coherent form, derived from
its exact analytic identity and the proved coefficient remainder.  This
is the common input for the numerical two-, three-, and four-anchor
estimates; no bound on an unspecified analytic remainder is assumed. -/
theorem coherentQuotientForm_norm_le
    {m : ℕ} (a : Fin m → ℂ) (hm : 2 ≤ m) (hinj : Function.Injective a)
    (Delta p q eta : ℂ) (hDelta : Delta ≠ 0) (heta : eta ≠ 0)
    (A P : ℝ) (hA : 0 < A) (hP : 0 < P) (ha : ∀ i, A ≤ ‖a i‖)
    (hp : ‖p⁻¹‖ ≤ 1 / P) (hq : ‖q⁻¹‖ ≤ 1 / P) (hAP : 1 < A * P) :
    ‖coherentQuotientForm a Delta p q eta‖ ≤ ‖Delta‖ * ‖eta‖ *
      (‖1 - ((1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ))‖ +
        (‖halfBinomialWeightedCoeff p⁻¹ q⁻¹ m‖ +
          (4 * |halfBinomialCoeff (m + 1)|) / P ^ m *
            (1 / (1 - 1 / (A * P)) ^ m - 1)) / (∏ i, ‖a i‖)) := by
  let E : ℝ := (4 * |halfBinomialCoeff (m + 1)|) / P ^ m *
    (1 / (1 - 1 / (A * P)) ^ m - 1)
  let c : ℂ := (-1 : ℂ) ^ (m - 1) * (∏ i, a i)⁻¹
  have han : ∀ i, a i ≠ 0 := by
    intro i
    exact norm_pos_iff.mp (hA.trans_le (ha i))
  have hxp : ∀ i, ‖p⁻¹ * (a i)⁻¹‖ < 1 := by
    intro i
    exact coherent_half_binomial_manuscript_anchor_radius Finset.univ a p⁻¹ A P
      hA hP (fun j _ => ha j) hp hAP i (Finset.mem_univ i)
  have hxq : ∀ i, ‖q⁻¹ * (a i)⁻¹‖ < 1 := by
    intro i
    exact coherent_half_binomial_manuscript_anchor_radius Finset.univ a q⁻¹ A P
      hA hP (fun j _ => ha j) hq hAP i (Finset.mem_univ i)
  have hexact := coherentQuotientForm_normalized_eq a hm han hinj
    Delta p q eta hDelta heta hxp hxq
  have hmul : coherentQuotientForm a Delta p q eta = (Delta * eta) *
      (1 - ((1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ)) + c * coherentRemainder a p q) := by
    have h := (div_eq_iff (mul_ne_zero hDelta heta)).mp hexact
    calc
      coherentQuotientForm a Delta p q eta =
        (1 - ((1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ)) + c * coherentRemainder a p q) *
          (Delta * eta) := h
      _ = _ := mul_comm _ _
  have htail : ‖coherentRemainder a p q - halfBinomialWeightedCoeff p⁻¹ q⁻¹ m‖ ≤ E :=
    coherentRemainder_norm_sub_le a hm p q A P hA hP ha hp hq hAP
  have hF : ‖coherentRemainder a p q‖ ≤ ‖halfBinomialWeightedCoeff p⁻¹ q⁻¹ m‖ + E := by
    have h := norm_add_le (coherentRemainder a p q - halfBinomialWeightedCoeff p⁻¹ q⁻¹ m)
      (halfBinomialWeightedCoeff p⁻¹ q⁻¹ m)
    rw [sub_add_cancel] at h
    linarith
  have hc : ‖c‖ = (∏ i, ‖a i‖)⁻¹ := by
    simp [c, norm_mul, norm_pow, norm_inv, norm_prod]
  have hprod0 : 0 ≤ ∏ i, ‖a i‖ := Finset.prod_nonneg (fun i _ => norm_nonneg _)
  rw [hmul, norm_mul, norm_mul]
  apply mul_le_mul_of_nonneg_left _ (by positivity : 0 ≤ ‖Delta‖ * ‖eta‖)
  calc
    ‖1 - ((1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ)) + c * coherentRemainder a p q‖ ≤
      ‖1 - ((1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ))‖ + ‖c * coherentRemainder a p q‖ :=
        norm_add_le _ _
    _ = ‖1 - ((1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ))‖ +
        (∏ i, ‖a i‖)⁻¹ * ‖coherentRemainder a p q‖ := by rw [norm_mul, hc]
    _ ≤ ‖1 - ((1 + p⁻¹ * q⁻¹) ^ (1 / 2 : ℂ))‖ +
        (∏ i, ‖a i‖)⁻¹ * (‖halfBinomialWeightedCoeff p⁻¹ q⁻¹ m‖ + E) :=
      add_le_add le_rfl (mul_le_mul_of_nonneg_left hF (inv_nonneg.mpr hprod0))
    _ = _ := by dsimp only [E]; ring

end D1Bound5

