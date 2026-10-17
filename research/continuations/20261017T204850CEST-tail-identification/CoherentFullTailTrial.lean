import D1Bound5.CoherentWeightedRemainder

namespace D1Bound5

/-- A summable positive-degree weighted homogeneous tail determines the entire
series, and its constant term is precisely the degree-zero coefficient. -/
theorem coherent_full_tail_split
    {ι : Type*} [Fintype ι] [DecidableEq ι] [Nonempty ι]
    (a : ι → ℂ) (f : ℕ → ℂ) (m : ℕ)
    (hrest : Summable (fun j : ℕ => f (m + (j + 1)) *
       MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ (j + 1)))) :
    Summable (fun j : ℕ => f (m + j) *
       MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ j)) ∧
    (∑' j : ℕ, f (m + j) *
       MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ j)) =
      f m + ∑' j : ℕ, f (m + (j + 1)) *
       MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ (j + 1)) := by
  let u : ℕ → ℂ := fun j => f (m + j) *
    MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ j)
  have hshift : Summable (fun j : ℕ => u (j + 1)) := by
    simpa only [u, Nat.add_assoc] using hrest
  have hwhole : Summable u :=
    (summable_nat_add_iff (f := u) 1).mp hshift
  refine ⟨?_, ?_⟩
  · simpa only [u] using hwhole
  · have hsplit := hwhole.tsum_eq_zero_add
    simpa [u, Nat.add_assoc] using hsplit

/-- The norm of the actual full weighted homogeneous sum minus its constant
coefficient is bounded by the already proved positive-degree tail majorant.
The coefficient envelope remains an explicit hypothesis here. -/
theorem coherent_full_tail_sub_constant_norm_le
    {ι : Type*} [Fintype ι] [DecidableEq ι] [Nonempty ι]
    (a : ι → ℂ) (f : ℕ → ℂ) (m : ℕ) (C ρ t : ℝ)
    (hC : 0 ≤ C) (hρ0 : 0 ≤ ρ) (ht0 : 0 ≤ t)
    (hρ : ∀ i, ‖a i‖ ≤ ρ) (hradius : ρ * t < 1)
    (hf : ∀ j : ℕ, ‖f (m + (j + 1))‖ ≤ C * t ^ (m + (j + 1))) :
    ‖(∑' j : ℕ, f (m + j) *
       MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ j)) - f m‖ ≤
      C * t ^ m * (1 / (1 - ρ * t) ^ Fintype.card ι - 1) := by
  obtain ⟨hrest, hbound⟩ :=
    coherent_weighted_remainder_summable_and_norm_le a f m C ρ t
      hC hρ0 ht0 hρ hradius hf
  obtain ⟨_, hsplit⟩ := coherent_full_tail_split a f m hrest
  have hident :
      (∑' j : ℕ, f (m + j) *
         MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ j)) - f m =
        ∑' j : ℕ, f (m + (j + 1)) *
         MvPolynomial.aeval a (MvPolynomial.hsymm ι ℂ (j + 1)) := by
    rw [hsplit]
    ring
  rw [hident]
  exact hbound

end D1Bound5

#check @D1Bound5.coherent_full_tail_split
#check @D1Bound5.coherent_full_tail_sub_constant_norm_le
#print axioms D1Bound5.coherent_full_tail_split
#print axioms D1Bound5.coherent_full_tail_sub_constant_norm_le
