import D1Bound5.MixedRootMatrixSigns

namespace D1Bound5

/-- A uniform sign choice for |x|>=5 gives the variable frontier error
1/(7|x|). The rational margin32/225<1/7 avoids analytic square roots. -/
theorem exists_frontier_root_error (x t : ℂ)
    (hx : 5 ≤ ‖x‖) (ht : t^2 = x*(x+1)) :
    ∃ v : ℂ, (v = t ∨ v = -t) ∧
      ‖(v-x)-(1/2 : ℂ)‖ ≤ 1/(7*‖x‖) := by
  have hx0 : 0 < ‖x‖ := by linarith only [hx]
  have hgap : 1 < (1-(7/8 : ℝ)^2)*‖x‖ := by nlinarith only [hx]
  obtain ⟨v,hv,_,hhalf⟩ := exists_root_error_control x t (7/8)
    (by norm_num) hx0 hgap ht
  refine ⟨v,hv,le_of_lt ?_⟩
  apply (lt_div_iff₀ (by positivity : 0 < 7*‖x‖)).mpr
  nlinarith only [hhalf]

/-- The exact, variable near-half condition used in the frontier proof. -/
def FrontierSignedEntryGood {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a b : R) (u v : ℂ) (r : R) : Prop :=
  ‖u*f r*v-f a*f b-(1/2 : ℂ)‖ ≤ 1/(7*‖f a*f b‖)

private theorem frontierSignedEntryGood_swap {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a b r : R) (u v : ℂ)
    (h : FrontierSignedEntryGood f a b u v r) :
    FrontierSignedEntryGood f b a v u r := by
  unfold FrontierSignedEntryGood at h ⊢
  simpa only [mul_comm, mul_left_comm, mul_assoc] using h

private theorem frontierSignedEntryGood_or_neg {R : Type*} [CommRing R]
    (f : R →+* ℂ) (a b r : R) (u v : ℂ)
    (hu : u^2 = f a) (hv : v^2 = f b) (hr : r^2 = a*b+1)
    (hab : 5 ≤ ‖f a*f b‖) :
    FrontierSignedEntryGood f a b u v r ∨
      FrontierSignedEntryGood f a b u v (-r) := by
  have hrC : (f r)^2 = f a*f b+1 := by
    simpa only [map_pow, map_mul, map_add, map_one] using congrArg f hr
  have ht : (u*f r*v)^2 = (f a*f b)*(f a*f b+1) := by
    rw [mul_pow, mul_pow, hu, hv, hrC]
    ring
  obtain ⟨q,hq,hbound⟩ := exists_frontier_root_error (f a*f b) (u*f r*v) hab ht
  rcases hq with hq | hq
  · exact Or.inl (by simpa only [FrontierSignedEntryGood, hq] using hbound)
  · right
    have heq : u*f (-r)*v = q := by rw [hq, map_neg]; ring
    simpa only [FrontierSignedEntryGood, heq] using hbound

/-- All six frontier signs can be selected in the same original ring,
with symmetry and exact root equations retained. -/
theorem exists_frontier_symmetric_root_matrix
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a : Fin 4 → R) (u : Fin 4 → ℂ) (M : Matrix (Fin 4) (Fin 4) R)
    (hu : ∀ i, (u i)^2 = f (a i))
    (hd : ∀ i, M i i = a i) (hsym : ∀ i j, M i j = M j i)
    (hr : ∀ i j, i ≠ j → (M i j)^2 = a i*a j+1)
    (hlarge : ∀ i j, i ≠ j → 5 ≤ ‖f (a i)*f (a j)‖) :
    ∃ S : Matrix (Fin 4) (Fin 4) R,
      (∀ i, S i i = a i) ∧ (∀ i j, S i j = S j i) ∧
      (∀ i j, i ≠ j → (S i j)^2 = a i*a j+1) ∧
      (∀ i j, i ≠ j → FrontierSignedEntryGood f (a i) (a j) (u i) (u j) (S i j)) := by
  classical
  let q (i j : Fin 4) : R :=
    if FrontierSignedEntryGood f (a i) (a j) (u i) (u j) (M i j) then M i j else -M i j
  have hqsign (i j : Fin 4) : q i j = M i j ∨ q i j = -M i j := by
    dsimp [q]
    split_ifs
    · exact Or.inl rfl
    · exact Or.inr rfl
  have hqgood (i j : Fin 4) (hij : i ≠ j) :
      FrontierSignedEntryGood f (a i) (a j) (u i) (u j) (q i j) := by
    dsimp [q]
    split_ifs with h
    · exact h
    · rcases frontierSignedEntryGood_or_neg f (a i) (a j) (M i j) (u i) (u j)
        (hu i) (hu j) (hr i j hij) (hlarge i j hij) with hp | hn
      · exact (h hp).elim
      · exact hn
  let S (i j : Fin 4) : R := if i = j then a i else q (min i j) (max i j)
  have hSdiag (i : Fin 4) : S i i = a i := by simp [S]
  have hSsym (i j : Fin 4) : S i j = S j i := by
    by_cases hij : i = j
    · subst j; rfl
    · simp [S, hij, Ne.symm hij, min_comm, max_comm]
  have hSsign (i j : Fin 4) (hij : i ≠ j) : S i j = M i j ∨ S i j = -M i j := by
    rcases lt_or_gt_of_ne hij with hlt | hgt
    · simpa [S, hij, min_eq_left hlt.le, max_eq_right hlt.le] using hqsign i j
    · simpa [S, hij, min_eq_right hgt.le, max_eq_left hgt.le, hsym j i] using hqsign j i
  refine ⟨S,hSdiag,hSsym,?_,?_⟩
  · intro i j hij
    rcases hSsign i j hij with h | h
    · rw [h]; exact hr i j hij
    · rw [h]; simpa only [neg_sq] using hr i j hij
  · intro i j hij
    rcases lt_or_gt_of_ne hij with hlt | hgt
    · simpa [S, hij, min_eq_left hlt.le, max_eq_right hlt.le] using hqgood i j hij
    · have h := frontierSignedEntryGood_swap f (a j) (a i) (q j i) (u j) (u i)
        (hqgood j i hij.symm)
      simpa [S, hij, min_eq_right hgt.le, max_eq_left hgt.le] using h

end D1Bound5
