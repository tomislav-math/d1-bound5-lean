import D1Bound5.SquareTest
import D1Bound5.DiskEnumeration
import D1Bound5.DescentAlgebra

namespace D1Bound5
open QuadInt

/-- Common extensions retain zero and anchor coincidences. -/
def PairExtension {tau nu : ℤ} (a b z : QuadInt tau nu) : Prop :=
  (∃ r, r*r = a*z+1) ∧ (∃ s, s*s = b*z+1)

/-- The norm parallelogram identity gives a division-free root bound. -/
theorem quadInt_norm_add_le_twice {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (x y : QuadInt tau nu) :
    (x+y).norm ≤ 2*x.norm+2*y.norm := by
  have hn := norm_nonneg hd (x-y)
  have hi : (x+y).norm+(x-y).norm = 2*x.norm+2*y.norm := by
    simp only [norm_formula, QuadraticAlgebra.re_add, QuadraticAlgebra.im_add,
      QuadraticAlgebra.re_sub, QuadraticAlgebra.im_sub]
    ring
  omega

/-- Every root needed for the radius-33 seed search has norm at most 132.
This deliberately loose bound keeps the finite search small and uniform. -/
theorem pair_seed_root_norm_le {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a z q : QuadInt tau nu)
    (ha : a.norm ≤ 8) (hz : z.norm ≤ 1089) (hq : q*q = a*z+1) :
    q.norm ≤ 132 := by
  have hq0 := norm_nonneg hd q
  have hz0 := norm_nonneg hd z
  have hsum := quadInt_norm_add_le_twice hd (a*z) 1
  have hsq : q.norm*q.norm = (a*z+1).norm := by
    rw [← map_mul, hq]
  have hone : (1 : QuadInt tau nu).norm = 1 := by norm_num [norm_formula]
  rw [map_mul, hone] at hsum
  have hprod : a.norm*z.norm ≤ 8*1089 := mul_le_mul ha hz hz0 (by norm_num)
  nlinarith

/-- Exact quotient (q²−1)/a computed by multiplying by the conjugate of a.
The candidate is subsequently checked, so divisibility is never assumed. -/
def pairSeedCandidate {tau nu : ℤ} (a q : QuadInt tau nu) : QuadInt tau nu :=
  let w := q*q-1
  ⟨((a.re+tau*a.im)*w.re+nu*a.im*w.im)/a.norm,
    (a.re*w.im-a.im*w.re)/a.norm⟩

/-- Every actual extension is reconstructed from either chosen square root. -/
theorem pairSeedCandidate_eq {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a z q : QuadInt tau nu)
    (ha : a ≠ 0) (hq : q*q = a*z+1) : pairSeedCandidate a q = z := by
  have hn : a.norm ≠ 0 := fun h => ha ((norm_eq_zero_iff hd a).1 h)
  have hw : q*q-1 = a*z := by rw [hq]; ring
  have hre : (a.re+tau*a.im)*(a*z).re+nu*a.im*(a*z).im = a.norm*z.re := by
    simp only [norm_formula, QuadraticAlgebra.re_mul, QuadraticAlgebra.im_mul]
    ring
  have him : a.re*(a*z).im-a.im*(a*z).re = a.norm*z.im := by
    simp only [norm_formula, QuadraticAlgebra.re_mul, QuadraticAlgebra.im_mul]
    ring
  unfold pairSeedCandidate
  dsimp only
  rw [hw, hre, him]
  apply QuadraticAlgebra.ext <;> simp only [Int.mul_ediv_cancel_left _ hn]

/-- A finite root search checks all radius-33 seeds, including zero. -/
def pairSeedsCoveredBool {tau nu : ℤ} (a b : QuadInt tau nu)
    (roots vertices : List (QuadInt tau nu)) : Bool :=
  roots.all fun q =>
    let z := pairSeedCandidate a q
    if decide (q*q = a*z+1 ∧ z.norm ≤ 1089) then
      if hasSquareRoot (b*z+1) then decide (z ∈ vertices) else true
    else true

/-- Mathematical soundness of the root-based finite seed certificate. -/
theorem pairSeedsCovered_of_checked {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b : QuadInt tau nu)
    (ha : a ≠ 0) (hNa : a.norm ≤ 8)
    (roots vertices : List (QuadInt tau nu))
    (hcover : ∀ q ∈ disk tau nu 132, q ∈ roots)
    (hcheck : pairSeedsCoveredBool a b roots vertices = true)
    (z : QuadInt tau nu) (hz : PairExtension a b z) (hNz : z.norm ≤ 1089) :
    z ∈ vertices := by
  obtain ⟨⟨q, hq⟩, hs⟩ := hz
  have hNq := pair_seed_root_norm_le hd a z q hNa hNz hq
  have hmem := hcover q ((mem_disk_iff hd 132 q).2 hNq)
  have hc := List.all_eq_true.mp hcheck q hmem
  have heq := pairSeedCandidate_eq hd a z q ha hq
  have hb := (hasSquareRoot_iff hd _).2 hs
  simpa [heq, hq, hNz, hb] using hc

/-- Positive-definite quadratic coordinates have no zero divisors. -/
theorem quadInt_mul_eq_zero {tau nu : ℤ} (hd : 0 < discriminant tau nu)
    {x y : QuadInt tau nu} (h : x*y = 0) : x = 0 ∨ y = 0 := by
  have hn : x.norm*y.norm = 0 := by
    have hn := congrArg (fun z : QuadInt tau nu => z.norm) h
    simpa using hn
  rcases mul_eq_zero.mp hn with hx | hy
  · exact Or.inl ((norm_eq_zero_iff hd x).1 hx)
  · exact Or.inr ((norm_eq_zero_iff hd y).1 hy)

/-- Any actual root differs from the canonical one by sign, including zero. -/
theorem quadInt_root_eq_or_neg {tau nu : ℤ} (hd : 0 < discriminant tau nu)
    (z r : QuadInt tau nu) (hr : r*r = z) :
    r = rootCandidate z ∨ r = -rootCandidate z := by
  have hc := rootCandidate_complete hd ⟨r, hr⟩
  have hf : (r-rootCandidate z)*(r+rootCandidate z) = 0 := by
    linear_combination hr-hc
  rcases quadInt_mul_eq_zero hd hf with h | h
  · exact Or.inl (sub_eq_zero.mp h)
  · exact Or.inr (eq_neg_of_add_eq_zero_left h)

/-- The two canonical neighbors generate both root-sign choices. -/
def pairMutationPlus {tau nu : ℤ} (a b z : QuadInt tau nu) : QuadInt tau nu :=
  mutate a b z (rootCandidate (a*b+1))
    (rootCandidate (a*z+1)) (rootCandidate (b*z+1))

def pairMutationMinus {tau nu : ℤ} (a b z : QuadInt tau nu) : QuadInt tau nu :=
  mutate a b z (rootCandidate (a*b+1))
    (rootCandidate (a*z+1)) (-rootCandidate (b*z+1))

/-- Arbitrary actual root choices give one of the two deterministic neighbors. -/
theorem mutate_eq_canonical {tau nu : ℤ} (hd : 0 < discriminant tau nu)
    (a b z r0 r s : QuadInt tau nu)
    (h0 : r0*r0 = a*b+1) (hr : r*r = a*z+1) (hs : s*s = b*z+1) :
    mutate a b z r0 r s = pairMutationPlus a b z ∨
    mutate a b z r0 r s = pairMutationMinus a b z := by
  rcases quadInt_root_eq_or_neg hd _ r0 h0 with h0 | h0 <;>
    rcases quadInt_root_eq_or_neg hd _ r hr with hr | hr <;>
    rcases quadInt_root_eq_or_neg hd _ s hs with hs | hs
  all_goals rw [h0, hr, hs]
  all_goals unfold pairMutationPlus pairMutationMinus mutate
  all_goals first | left; ring | right; ring

/-- Every mutation edge can be reversed using one of the two canonical
neighbors of its target, regardless of the original root signs. -/
theorem mutate_reverse_canonical {tau nu : ℤ} (hd : 0 < discriminant tau nu)
    (a b z r0 r s : QuadInt tau nu)
    (h0 : r0*r0 = a*b+1) (hr : r*r = a*z+1) (hs : s*s = b*z+1) :
    z = pairMutationPlus a b (mutate a b z r0 r s) ∨
    z = pairMutationMinus a b (mutate a b z r0 r s) := by
  have h0' : r0^2 = a*b+1 := by simpa only [pow_two] using h0
  have hr' : r^2 = a*z+1 := by simpa only [pow_two] using hr
  have hs' : s^2 = b*z+1 := by simpa only [pow_two] using hs
  have hroots := mutate_roots a b z r0 r s h0' hr' hs'
  have hp : (r0*r+a*s)*(r0*r+a*s) = a*mutate a b z r0 r s+1 := by
    simpa only [pow_two] using hroots.1
  have hq : (-(b*r+r0*s))*(-(b*r+r0*s)) = b*mutate a b z r0 r s+1 := by
    simpa only [neg_mul_neg, pow_two] using hroots.2
  have hrev : mutate a b (mutate a b z r0 r s) r0
      (r0*r+a*s) (-(b*r+r0*s)) = z := by
    have h := mutate_reverse a b z r0 r s h0' hr' hs'
    unfold mutate at h ⊢
    linear_combination h
  have hcases := mutate_eq_canonical hd a b (mutate a b z r0 r s)
    r0 (r0*r+a*s) (-(b*r+r0*s)) h0 hp hq
  rwa [hrev] at hcases

/-- A bounded closed list is checked at its own vertices, not by enumerating
the surrounding potentially enormous disk. -/
def pairClosureBool {tau nu : ℤ} (a b : QuadInt tau nu) (bound : ℤ)
    (vertices : List (QuadInt tau nu)) : Bool :=
  vertices.all fun z =>
    (if decide ((pairMutationPlus a b z).norm ≤ bound) then
      decide (pairMutationPlus a b z ∈ vertices) else true) &&
    (if decide ((pairMutationMinus a b z).norm ≤ bound) then
      decide (pairMutationMinus a b z ∈ vertices) else true)

theorem pairClosure_of_checked {tau nu : ℤ} (a b : QuadInt tau nu) (bound : ℤ)
    (vertices : List (QuadInt tau nu)) (hcheck : pairClosureBool a b bound vertices = true)
    {z w : QuadInt tau nu} (hz : z ∈ vertices)
    (hw : w = pairMutationPlus a b z ∨ w = pairMutationMinus a b z)
    (hbound : w.norm ≤ bound) : w ∈ vertices := by
  have hc := List.all_eq_true.mp hcheck z hz
  have hc' := Bool.and_eq_true.mp hc
  rcases hw with rfl | rfl
  · simpa [hbound] using hc'.1
  · simpa [hbound] using hc'.2

/-- Filter a certified pair-extension list by the third anchor. -/
def tripleExtensionFilterBool {tau nu : ℤ} (a b c : QuadInt tau nu)
    (vertices allowed : List (QuadInt tau nu)) : Bool :=
  vertices.all fun z =>
    if decide (z ≠ 0 ∧ z ≠ a ∧ z ≠ b ∧ z ≠ c) then
      if hasSquareRoot (c*z+1) then decide (z ∈ allowed) else true
    else true

theorem tripleExtensionFilter_of_checked {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b c : QuadInt tau nu)
    (vertices allowed : List (QuadInt tau nu))
    (hcheck : tripleExtensionFilterBool a b c vertices allowed = true)
    {z : QuadInt tau nu} (hz : z ∈ vertices)
    (h0 : z ≠ 0) (ha : z ≠ a) (hb : z ≠ b) (hc : z ≠ c)
    (hs : ∃ r, r*r = c*z+1) : z ∈ allowed := by
  have h := List.all_eq_true.mp hcheck z hz
  have hs' := (hasSquareRoot_iff hd _).2 hs
  simpa [h0, ha, hb, hc, hs'] using h

end D1Bound5
