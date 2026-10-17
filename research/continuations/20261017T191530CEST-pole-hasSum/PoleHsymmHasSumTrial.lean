import D1Bound5.PoleHomogeneousTail
import D1Bound5.HsymmSummability
import D1Bound5.WeightedPoleLimit

open Filter Finset

namespace D1Bound5

/-- The finite rational interpolation identity converges to the infinite
complete-homogeneous series. All nodes are nonzero and pairwise distinct,
but no positivity, real-node, or square-root hypotheses are imposed.
The explicit majorant supplies summability of the series. -/
theorem reciprocal_pole_hsymm_hasSum_of_majorant
    {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (a : ι → ℂ)
    (hs : s.Nonempty) (hinj : Set.InjOn a s)
    (ha : ∀ i ∈ s, a i ≠ 0)
    (z : ℂ) (hsmall : ∀ i ∈ s, ‖z‖ < ‖a i‖)
    (ρ : ℝ) (hρ0 : 0 ≤ ρ)
    (hρ : ∀ i : s, ‖(a i)⁻¹‖ ≤ ρ)
    (hradius : ρ * ‖z‖ < 1) :
    HasSum
      (fun k : ℕ =>
        z ^ k * (((-1 : ℂ) ^ (s.card - 1) * (∏ i ∈ s, a i)⁻¹) *
          MvPolynomial.aeval (fun i : s => (a i)⁻¹)
            (MvPolynomial.hsymm s ℂ k)))
      (∑ i ∈ s,
        (∏ j ∈ s.erase i, (a i - a j))⁻¹ / (a i - z)) := by
  letI : Nonempty s := ⟨⟨hs.choose, hs.choose_spec⟩⟩
  let w : ι → ℂ := fun i =>
    (∏ j ∈ s.erase i, (a i - a j))⁻¹
  let c : ℂ := (-1 : ℂ) ^ (s.card - 1) * (∏ i ∈ s, a i)⁻¹
  let H : ℕ → ℂ := fun k =>
    MvPolynomial.aeval (fun i : s => (a i)⁻¹)
      (MvPolynomial.hsymm s ℂ k)
  let f : ℕ → ℂ := fun k => z ^ k * (c * H k)
  let lhs : ℂ := ∑ i ∈ s, w i / (a i - z)
  let remainder : ℕ → ℂ := fun n =>
    z ^ n * ∑ i ∈ s, w i / ((a i) ^ n * (a i - z))
  have haz : ∀ i ∈ s, a i ≠ z := by
    intro i hi heq
    have hh : ‖z‖ < ‖z‖ := by
      simpa only [heq] using hsmall i hi
    exact (lt_irrefl (‖z‖)) hh
  have hfinite (n : ℕ) :
      lhs = (∑ k ∈ Finset.range n, f k) + remainder n := by
    simpa only [lhs, f, c, H, remainder, w] using
      (reciprocal_pole_hsymm_finite_tail s a hs hinj ha z haz n)
  have htail : Tendsto remainder atTop (nhds (0 : ℂ)) :=
    weighted_poles_tail_tendsto_zero s a w z hsmall
  have hpart (n : ℕ) :
      (∑ k ∈ Finset.range n, f k) = lhs - remainder n := by
    have hh := hfinite n
    apply (eq_sub_iff_add_eq).2
    exact hh.symm
  have hconverge : Tendsto (fun n : ℕ => ∑ k ∈ Finset.range n, f k)
      atTop (nhds lhs) := by
    have hdiff : Tendsto (fun n : ℕ => lhs - remainder n)
        atTop (nhds lhs) := by
      simpa using (tendsto_const_nhds.sub htail)
    convert hdiff using 1
    funext n
    exact hpart n
  have hH : Summable (fun k : ℕ => z ^ k * H k) :=
    hsymm_aeval_complex_summable
      (fun i : s => (a i)⁻¹) z ρ hρ0 hρ hradius
  have hf : Summable f := by
    have hcf : Summable (fun k : ℕ => c * (z ^ k * H k)) :=
      hH.mul_left c
    have heq : f = (fun k : ℕ => c * (z ^ k * H k)) := by
      funext k
      dsimp [f]
      ring
    rw [heq]
    exact hcf
  exact (hf.hasSum_iff_tendsto_nat).2 hconverge

end D1Bound5

#check @D1Bound5.reciprocal_pole_hsymm_hasSum_of_majorant
#print axioms D1Bound5.reciprocal_pole_hsymm_hasSum_of_majorant
