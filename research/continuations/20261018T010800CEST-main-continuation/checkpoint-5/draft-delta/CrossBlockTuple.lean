import D1Bound5.CrossBlockGrowth

open scoped BigOperators NumberField
open Module

namespace D1Bound5

/-- Simultaneous signs for an arbitrary rectangular three-by-three block.
All chosen entries stay in the original ring and retain the exact square
relations. No symmetry condition is imposed or needed. -/
theorem exists_crossBlock_signed_scaled_error
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a b : Fin 3 → R) (M : Fin 3 → Fin 3 → R)
    (hroot : ∀ i j, (M i j)^2 = a i*b j+1)
    (hlarge : ∀ i j, 9 ≤ ‖f (a i)*f (b j)‖) :
    ∃ (u v : Fin 3 → ℂ) (S : Fin 3 → Fin 3 → R),
      (∀ i, (u i)^2 = f (a i)) ∧
      (∀ j, (v j)^2 = f (b j)) ∧
      (∀ i j, (S i j)^2 = a i*b j+1) ∧
      (∀ i j, ‖(f (a i)*f (b j))*(u i*f (S i j)*v j)-
        (f (a i)*f (b j))^2-(1/2 : ℂ)*(f (a i)*f (b j))‖ < (2/15 : ℝ)) := by
  classical
  have hura (i : Fin 3) : ∃ z : ℂ, z^2 = f (a i) :=
    IsAlgClosed.exists_pow_nat_eq (f (a i)) (by decide : 0 < 2)
  have hur b' : ∃ z : ℂ, z^2 = f (b b') :=
    IsAlgClosed.exists_pow_nat_eq (f (b b')) (by decide : 0 < 2)
  choose u hu using hura
  choose v hv using hur
  have hex (i j : Fin 3) : ∃ s : R, s^2 = a i*b j+1 ∧
      SignedEntryGood f (a i) (b j) (u i) (v j) s := by
    rcases signed_entry_good_or_neg f (a i) (b j) (M i j) (u i) (v j)
      (hu i) (hv j) (hroot i j) (hlarge i j) with hg | hg
    · exact ⟨M i j, hroot i j, hg⟩
    · exact ⟨-M i j, by simpa only [neg_sq] using hroot i j, hg⟩
  choose S hS hgood using hex
  refine ⟨u, v, S, hu, hv, hS, ?_⟩
  intro i j
  exact signed_entry_crossBlock_scaled_error f (a i) (b j) (S i j)
    (u i) (v j) (hu i) (hv j) (hS i j) (hgood i j)

/-- Squared modulus of the cross-block determinant after the two scaling
steps. Stating the identity with squares avoids real square-root choices. -/
theorem crossBlock_scaled_det_norm_sq
    {R : Type*} [CommRing R] (f : R →+* ℂ)
    (a b : Fin 3 → R) (u v : Fin 3 → ℂ)
    (S : Fin 3 → Fin 3 → R)
    (hu : ∀ i, (u i)^2 = f (a i)) (hv : ∀ j, (v j)^2 = f (b j)) :
    ‖Matrix.det (Matrix.of (fun i j => (f (a i)*u i)*f (S i j)*(f (b j)*v j)))‖^2 =
      ((‖f (a 0)‖*‖f (b 0)‖)*(‖f (a 1)‖*‖f (b 1)‖)*
        (‖f (a 2)‖*‖f (b 2)‖))^3*‖f (Matrix.det (Matrix.of S))‖^2 := by
  let T : Fin 3 → Fin 3 → ℂ :=
    fun i j => (f (a i)*u i)*f (S i j)*(f (b j)*v j)
  have hT : Matrix.of T = Matrix.diagonal (fun i => f (a i)*u i) * (Matrix.map (Matrix.of S) f) *
      Matrix.diagonal (fun j => f (b j)*v j) := by
    ext i j
    simp only [T, Matrix.mul_diagonal, Matrix.diagonal_mul, Matrix.map_apply, Matrix.of_apply]
  have hmap := RingHom.map_det f (Matrix.of S)
  change f (Matrix.det (Matrix.of S)) = Matrix.det (Matrix.map (Matrix.of S) f) at hmap
  have hdet : (Matrix.det (Matrix.of T)) = (∏ i, f (a i)*u i)*f (Matrix.det (Matrix.of S))*(∏ j, f (b j)*v j) := by
    rw [hT, Matrix.det_mul, Matrix.det_mul, Matrix.det_diagonal, Matrix.det_diagonal, ← hmap]
  have hleft : (∏ i, f (a i)*u i)^2 = (∏ i, f (a i))^3 := by
    rw [← Finset.prod_pow, ← Finset.prod_pow]
    apply Finset.prod_congr rfl
    intro i _
    rw [mul_pow, hu i]
    ring
  have hright : (∏ j, f (b j)*v j)^2 = (∏ j, f (b j))^3 := by
    rw [← Finset.prod_pow, ← Finset.prod_pow]
    apply Finset.prod_congr rfl
    intro j _
    rw [mul_pow, hv j]
    ring
  have hsquare : (Matrix.det (Matrix.of T))^2 = ((∏ i, f (a i))*(∏ j, f (b j)))^3*(f (Matrix.det (Matrix.of S)))^2 := by
    rw [hdet]
    calc
      _ = (∏ i, f (a i)*u i)^2*(∏ j, f (b j)*v j)^2*(f (Matrix.det (Matrix.of S)))^2 := by ring
      _ = ((∏ i, f (a i))*(∏ j, f (b j)))^3*(f (Matrix.det (Matrix.of S)))^2 := by
        rw [hleft, hright]
        ring
  have hnorm := congrArg norm hsquare
  simp only [norm_pow, norm_mul, norm_prod] at hnorm
  change ‖(Matrix.det (Matrix.of T))‖^2 = _
  rw [hnorm]
  simp [Fin.prod_univ_succ]
  <;> ring

/-- Quantitative cross-block growth over any characteristic-zero domain
whose nonzero elements have complex modulus at least one. The following
full-ring corollary supplies this arithmetic property unconditionally. -/
theorem crossBlock_growth
    {R : Type*} [CommRing R] [IsDomain R] [CharZero R]
    (f : R →+* ℂ) (hdiscrete : ∀ x : R, x ≠ 0 → 1 ≤ ‖f x‖)
    (a b : Fin 3 → R) (M : Fin 3 → Fin 3 → R)
    (ha : Function.Injective a) (hb : Function.Injective b)
    (hroot : ∀ i j, (M i j)^2 = a i*b j+1)
    (hmonA : Monotone (fun i => ‖f (a i)‖))
    (hmonB : Monotone (fun i => ‖f (b i)‖))
    (hlarge : 9 ≤ ‖f (a 0)‖*‖f (b 0)‖) :
    (‖f (a 0)‖*‖f (b 0)‖)^3*(‖f (a 1)‖*‖f (b 1)‖)/7 <
      ‖f (a 2)‖*‖f (b 2)‖ := by
  have hlargeij (i j : Fin 3) : 9 ≤ ‖f (a i)*f (b j)‖ := by
    rw [norm_mul]
    exact hlarge.trans (mul_le_mul (hmonA (by omega : 0 ≤ i))
      (hmonB (by omega : 0 ≤ j)) (norm_nonneg _) (norm_nonneg _))
  obtain ⟨u, v, S, hu, hv, hS, herr⟩ :=
    exists_crossBlock_signed_scaled_error f a b M hroot hlargeij
  let T : Fin 3 → Fin 3 → ℂ :=
    fun i j => (f (a i)*u i)*f (S i j)*(f (b j)*v j)
  let E : Fin 3 → Fin 3 → ℂ := fun i j =>
    T i j-(f (a i)*f (b j))^2-(1/2 : ℂ)*(f (a i)*f (b j))
  have hE (i j : Fin 3) : ‖E i j‖ ≤ (2/15 : ℝ) := by
    have hrewrite : E i j = (f (a i)*f (b j))*(u i*f (S i j)*v j)-
        (f (a i)*f (b j))^2-(1/2 : ℂ)*(f (a i)*f (b j)) := by
      dsimp [E, T]
      ring
    rw [hrewrite]
    exact (herr i j).le
  have hTform : T = fun i j =>
      (f (a i)*f (b j))^2+(1/2 : ℂ)*(f (a i)*f (b j))+E i j := by
    ext i j
    dsimp only [E]
    ring
  have hWi (i : Fin 3) : 9 ≤ ‖f (a i)‖*‖f (b i)‖ := by
    simpa only [norm_mul] using hlargeij i i
  have hupper : ‖(Matrix.det (Matrix.of T))‖ <
      (5/2 : ℝ)*(‖f (a 2)‖*‖f (b 2)‖)^2*(‖f (a 1)‖*‖f (b 1)‖) := by
    rw [hTform]
    exact crossBlock_ordered_error_det_upper
      (fun i => f (a i)) (fun i => f (b i)) E hmonA hmonB hE (hWi 1) (hWi 2)
  have hnorm : 1 ≤ ‖f (Matrix.det (Matrix.of S))‖ :=
    hdiscrete (Matrix.det (Matrix.of S)) (crossBlock_rootMatrix_det_ne_zero a b (Matrix.of S) ha hb hS)
  have hnormsq : 1 ≤ ‖f (Matrix.det (Matrix.of S))‖^2 := by nlinarith only [hnorm]
  have hlower : ((‖f (a 0)‖*‖f (b 0)‖)*(‖f (a 1)‖*‖f (b 1)‖)*
      (‖f (a 2)‖*‖f (b 2)‖))^3 ≤ ‖(Matrix.det (Matrix.of T))‖^2 := by
    rw [crossBlock_scaled_det_norm_sq f a b u v S hu hv]
    exact le_mul_of_one_le_right (by positivity) hnormsq
  exact crossBlock_growth_of_scaled_determinant
    (‖f (a 0)‖*‖f (b 0)‖) (‖f (a 1)‖*‖f (b 1)‖)
    (‖f (a 2)‖*‖f (b 2)‖) ‖(Matrix.det (Matrix.of T))‖
    (hWi 0) (hWi 1) (hWi 2) (norm_nonneg _) hlower hupper

/-- The complete cross-block growth lemma for the full integer ring of an
arbitrary imaginary quadratic field. -/
theorem full_ring_crossBlock_growth
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a b : Fin 3 → 𝓞 K) (M : Fin 3 → Fin 3 → 𝓞 K)
    (ha : Function.Injective a) (hb : Function.Injective b)
    (hroot : ∀ i j, (M i j)^2 = a i*b j+1)
    (hmonA : Monotone (fun i => ‖phi (a i : K)‖))
    (hmonB : Monotone (fun i => ‖phi (b i : K)‖))
    (hlarge : 9 ≤ ‖phi (a 0 : K)‖*‖phi (b 0 : K)‖) :
    (‖phi (a 0 : K)‖*‖phi (b 0 : K)‖)^3*
        (‖phi (a 1 : K)‖*‖phi (b 1 : K)‖)/7 <
      ‖phi (a 2 : K)‖*‖phi (b 2 : K)‖ := by
  exact crossBlock_growth (phi.comp (algebraMap (𝓞 K) K))
    (fun x hx => one_le_norm_integer hK phi hx)
    a b M ha hb hroot hmonA hmonB hlarge

/-- The manuscript's cross-block inequality for any two disjoint triples
inside an actual D(1)-tuple. Only the stated separate order and initial
size hypotheses remain. -/
theorem IsD1Tuple.crossBlock_growth
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {n : ℕ} (t : Fin n → 𝓞 K) (ht : IsD1Tuple t)
    (p q : Fin 3 ↪ Fin n) (hpq : ∀ i j, p i ≠ q j)
    (hmonA : Monotone (fun i => ‖phi (t (p i) : K)‖))
    (hmonB : Monotone (fun i => ‖phi (t (q i) : K)‖))
    (hlarge : 9 ≤ ‖phi (t (p 0) : K)‖*‖phi (t (q 0) : K)‖) :
    (‖phi (t (p 0) : K)‖*‖phi (t (q 0) : K)‖)^3*
        (‖phi (t (p 1) : K)‖*‖phi (t (q 1) : K)‖)/7 <
      ‖phi (t (p 2) : K)‖*‖phi (t (q 2) : K)‖ := by
  classical
  have hex (i j : Fin 3) : ∃ r : 𝓞 K, r^2 = t (p i)*t (q j)+1 := by
    simpa only [pow_two] using ht.2.2 (p i) (q j) (hpq i j)
  choose M hM using hex
  exact full_ring_crossBlock_growth hK phi (fun i => t (p i)) (fun j => t (q j))
    M (ht.1.comp p.injective) (ht.1.comp q.injective) hM hmonA hmonB hlarge

end D1Bound5
