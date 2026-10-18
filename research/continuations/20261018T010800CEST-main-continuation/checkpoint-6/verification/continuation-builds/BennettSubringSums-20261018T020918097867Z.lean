import D1Bound5.BennettBinomialIntegrality

open Finset

namespace D1Bound5

/-- A finite sum of multiples whose quotients lie in a fixed subring has a
quotient in that same subring. The divisor itself need not belong to it. -/
theorem bennett_sum_divisible_in_subring
    {F T : Type*} [CommRing F] (S : Subring F) (s : Finset T)
    (x : T → F) (d : F)
    (h : ∀ t ∈ s, ∃ q ∈ S, x t = d * q) :
    ∃ q ∈ S, ∑ t ∈ s, x t = d * q := by
  classical
  revert h
  induction s using Finset.induction_on with
  | empty =>
      intro h
      exact ⟨0, S.zero_mem, by simp⟩
  | @insert t s hts ih =>
      intro h
      obtain ⟨q, hq, hx⟩ := h t (Finset.mem_insert_self t s)
      obtain ⟨r, hr, hs⟩ := ih (fun u hu ↦ h u (Finset.mem_insert_of_mem hu))
      refine ⟨q + r, S.add_mem hq hr, ?_⟩
      rw [Finset.sum_insert hts, hx, hs, mul_add]

/-- The three binomial factors in the two-node Taylor expansion are integral
after the uniform order-k power of four is included. Every integer is in S. -/
theorem bennett_two_taylor_scalar_mem
    {F : Type*} [Field F] [CharZero F] (S : Subring F)
    (k h p q u v : ℕ) (hh : h ≤ k) :
    (((4 : F) ^ k * Ring.choose ((k : F) + 1 / 2) h) *
      Ring.choose (-(p : F)) u * Ring.choose (-(q : F)) v) ∈ S := by
  obtain ⟨z, hz⟩ := bennett_shifted_half_choose_uniform_is_integer (F := F) k h k hh
  obtain ⟨zp, hp⟩ := bennett_negative_choose_is_integer (F := F) p u
  obtain ⟨zq, hq⟩ := bennett_negative_choose_is_integer (F := F) q v
  rw [hz, hp, hq]
  exact S.mul_mem (S.mul_mem (S.intCast_mem z) (S.intCast_mem zp)) (S.intCast_mem zq)

end D1Bound5
