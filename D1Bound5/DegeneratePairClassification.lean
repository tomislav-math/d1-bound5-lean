import D1Bound5.SmallPairLargeDiscriminant

namespace D1Bound5
open QuadInt

/-- The ordered rational unit pair, with either orientation allowed. -/
def RationalUnitPair {R : Type*} [Ring R] (a b : R) : Prop :=
  (a = -1 ∧ b = 1) ∨ (a = 1 ∧ b = -1)

/-- Product minus one forces both positive integral norms to be one. -/
theorem product_neg_one_norms {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b : QuadInt tau nu)
    (hprod : a*b+1=0) : a.norm=1 ∧ b.norm=1 := by
  have hp : a*b = -1 := eq_neg_iff_add_eq_zero.mpr hprod
  have hn : a.norm*b.norm=1 := by
    have hh := congrArg QuadraticAlgebra.norm hp
    simpa only [map_mul,QuadraticAlgebra.norm_neg,
      QuadraticAlgebra.norm_one] using hh
  have ha0 := QuadInt.norm_nonneg hd a
  have hb0 := QuadInt.norm_nonneg hd b
  have ha : 1 ≤ a.norm := by
    by_contra h
    have hz : a.norm=0 := by omega
    rw [hz] at hn
    norm_num at hn
  have hb : 1 ≤ b.norm := by
    by_contra h
    have hz : b.norm=0 := by omega
    rw [hz] at hn
    norm_num at hn
  have hm := mul_nonneg (show 0 ≤ a.norm-1 by omega) (show 0 ≤ b.norm-1 by omega)
  constructor <;> nlinarith only [hn,ha,hb,hm]

private theorem gaussian_degenerate_checked :
    ∀ a ∈ disk 0 1 1, ∀ b ∈ disk 0 1 1,
      a ≠ b → a*b+1=0 → RationalUnitPair a b := by
  unfold RationalUnitPair
  decide +kernel

/-- Distinct Gaussian units with product minus one are exactly {-1,1}.
The apparent Gaussian alternatives ±i would repeat the same entry. -/
theorem gaussian_degenerate_pair (a b : QuadInt 0 1) (hne : a ≠ b)
    (hprod : a*b+1=0) : RationalUnitPair a b := by
  obtain ⟨ha,hb⟩ := product_neg_one_norms (by decide) a b hprod
  exact gaussian_degenerate_checked a ((mem_disk_iff (by decide) 1 a).2 ha.le)
    b ((mem_disk_iff (by decide) 1 b).2 hb.le) hne hprod

/-- The only possible nonrational distinct product-minus-one pair lies
in the Eisenstein model. No smallness hypothesis is needed. -/
theorem degenerate_pair_model {tau nu : ℤ}
    (htau : tau=0 ∨ tau=1) (hd : 0 < discriminant tau nu)
    (a b : QuadInt tau nu) (hne : a ≠ b) (hprod : a*b+1=0) :
    RationalUnitPair a b ∨ (tau=1 ∧ nu=1) := by
  obtain ⟨ha,hb⟩ := product_neg_one_norms hd a b hprod
  by_cases hia : a.im=0
  · by_cases hib : b.im=0
    · left
      have hra : a.re^2=1 := by simpa [norm_formula,hia] using ha
      have hfac : (a.re-1)*(a.re+1)=0 := by nlinarith only [hra]
      have hsign : a.re=1 ∨ a.re=-1 := by
        rcases mul_eq_zero.mp hfac with h | h
        · left; omega
        · right; omega
      rcases hsign with h | h
      · have he : a=1 := by apply QuadraticAlgebra.ext <;> simp [h,hia,QuadraticAlgebra.re_one,QuadraticAlgebra.im_one]
        right
        refine ⟨he,?_⟩
        rw [he,one_mul] at hprod
        exact eq_neg_iff_add_eq_zero.mpr hprod
      · have he : a=-1 := by apply QuadraticAlgebra.ext <;> simp [h,hia,QuadraticAlgebra.re_one,QuadraticAlgebra.im_one]
        left
        refine ⟨he,?_⟩
        rw [he,neg_one_mul] at hprod
        linear_combination -hprod
    · have hcut := discriminant_le_four_bound hd hb.le hib
      rcases htau with rfl | rfl
      · have hnu : nu=1 := by simp only [discriminant] at hd hcut; omega
        subst nu
        exact Or.inl (gaussian_degenerate_pair a b hne hprod)
      · have hnu : nu=1 := by simp only [discriminant] at hd hcut; omega
        exact Or.inr ⟨rfl,hnu⟩
  · have hcut := discriminant_le_four_bound hd ha.le hia
    rcases htau with rfl | rfl
    · have hnu : nu=1 := by simp only [discriminant] at hd hcut; omega
      subst nu
      exact Or.inl (gaussian_degenerate_pair a b hne hprod)
    · have hnu : nu=1 := by simp only [discriminant] at hd hcut; omega
      exact Or.inr ⟨rfl,hnu⟩

/-- Both orientations of the exceptional Eisenstein pair. -/
def EisensteinCanonicalPair (a b : QuadInt 1 1) : Prop :=
  (a=⟨0,-1⟩ ∧ b=⟨1,-1⟩) ∨ (a=⟨1,-1⟩ ∧ b=⟨0,-1⟩)

private theorem eisenstein_degenerate_checked :
    ∀ a ∈ disk 1 1 1, ∀ b ∈ disk 1 1 1,
      a ≠ b → a*b+1=0 → RationalUnitPair a b ∨
        EisensteinCanonicalPair a b ∨ EisensteinCanonicalPair (-a) (-b) := by
  unfold RationalUnitPair EisensteinCanonicalPair
  decide +kernel

theorem eisenstein_degenerate_pair (a b : QuadInt 1 1) (hne : a ≠ b)
    (hprod : a*b+1=0) : RationalUnitPair a b ∨
      EisensteinCanonicalPair a b ∨ EisensteinCanonicalPair (-a) (-b) := by
  obtain ⟨ha,hb⟩ := product_neg_one_norms (by decide) a b hprod
  exact eisenstein_degenerate_checked a ((mem_disk_iff (by decide) 1 a).2 ha.le)
    b ((mem_disk_iff (by decide) 1 b).2 hb.le) hne hprod

end D1Bound5
