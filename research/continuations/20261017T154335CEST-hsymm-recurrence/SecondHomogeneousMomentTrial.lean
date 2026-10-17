import Mathlib.RingTheory.Polynomial.Vieta
import exploration.CompleteHomogeneousMomentsTrial
import exploration.InterpolationNodalRecurrenceTrial

open Polynomial Finset

namespace D1Bound5

/-- The coefficient two steps below the leading term of the nodal polynomial
is the second elementary symmetric polynomial of its interpolation nodes. -/
theorem nodal_coefficient_two_below_top
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F) (hs : 2 ≤ s.card) :
    (Lagrange.nodal s a).coeff (s.card - 2) =
      (s.val.map a).esymm 2 := by
  have hcoeff :=
    Multiset.prod_X_sub_C_coeff (s.val.map a)
      (k := s.card - 2) (by simp)
  have hcard : (s.val.map a).card = s.card := by simp
  have hsub : s.card - (s.card - 2) = 2 := by omega
  simpa only [hcard, hsub, neg_one_sq, one_mul,
    Lagrange.nodal_eq, Finset.prod_map_val, Multiset.map_map, Function.comp_def] using hcoeff

/-- The next Lagrange moment after h1 is the second complete homogeneous
symmetric value h2 = e1^2 - e2, for every finite collection of
at least two pairwise distinct nodes. -/
theorem lagrange_power_moment_second_hsymm
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (hinj : Set.InjOn a s) (hs : 2 ≤ s.card) :
    (∑ i ∈ s, (a i) ^ (s.card + 1) /
      (∏ t ∈ s.erase i, (a i - a t))) =
      (∑ i ∈ s, a i) ^ 2 - (s.val.map a).esymm 2 := by
  let L : ℕ → F := fun n =>
    ∑ i ∈ s, (a i) ^ n / (∏ t ∈ s.erase i, (a i - a t))
  let Q : F[X] := Lagrange.nodal s a
  have hlow : ∀ j ∈ Finset.range (s.card - 2), L (1 + j) = 0 := by
    intro j hj
    have hj' : j < s.card - 2 := Finset.mem_range.mp hj
    have hn : 1 + j < s.card := by omega
    have hne : 1 + j ≠ s.card - 1 := by omega
    have h := lagrange_power_moment_low s a hinj (1 + j) hn
    simpa only [L, hne, if_false] using h
  have htop : L (1 + (s.card - 2)) = 1 := by
    have hn : 1 + (s.card - 2) = s.card - 1 := by omega
    rw [hn]
    have h := lagrange_power_moment_low s a hinj (s.card - 1) (by omega)
    simpa only [L, if_true] using h
  have hnext : L (1 + (s.card - 1)) = ∑ i ∈ s, a i := by
    have hn : 1 + (s.card - 1) = s.card := by omega
    rw [hn]
    exact lagrange_power_moment_first_hsymm s a hinj (by omega)
  have hq1 : Q.coeff (s.card - 1) = -(∑ i ∈ s, a i) := by
    simpa only [Q, Lagrange.nodal_eq] using
      (Polynomial.prod_X_sub_C_coeff_card_pred s a (by omega))
  have hq2 : Q.coeff (s.card - 2) = (s.val.map a).esymm 2 := by
    exact nodal_coefficient_two_below_top s a hs
  have hsum : (∑ j ∈ Finset.range s.card, Q.coeff j * L (1 + j)) =
      Q.coeff (s.card - 2) * L (1 + (s.card - 2)) +
        Q.coeff (s.card - 1) * L (1 + (s.card - 1)) := by
    have hcard : (s.card - 2 + 1 + 1) = s.card := by omega
    calc
      _ = ∑ j ∈ Finset.range (s.card - 2 + 1 + 1), Q.coeff j * L (1 + j) := by
        rw [hcard]
      _ = _ := by
        rw [Finset.sum_range_succ, Finset.sum_range_succ]
        have hz : (∑ j ∈ Finset.range (s.card - 2), Q.coeff j * L (1 + j)) = 0 := by
          apply Finset.sum_eq_zero
          intro j hj
          rw [hlow j hj, mul_zero]
        rw [hz, zero_add]
        have hpred : s.card - 2 + 1 = s.card - 1 := by omega
        rw [hpred]
  have hr := lagrange_power_moment_step s a 1
  change (∑ j ∈ Finset.range s.card, Q.coeff j * L (1+j)) + L (1 + s.card) = 0 at hr
  rw [hsum, htop, hnext, hq1, hq2, mul_one] at hr
  change L (s.card + 1) = _
  have hn : 1 + s.card = s.card + 1 := by omega
  rw [hn] at hr
  have heq : L (s.card + 1) =
      -((s.val.map a).esymm 2 +
        (-(∑ i ∈ s, a i)) * (∑ i ∈ s, a i)) :=
    eq_neg_of_add_eq_zero_right hr
  calc
    L (s.card + 1) = _ := heq
    _ = _ := by ring

/-- Exact third reciprocal-power Lagrange sum, expressing the first
nontrivial higher reciprocal interpolation term in terms of the
second complete homogeneous symmetric value of reciprocal nodes. -/
theorem reciprocal_anchor_third_power_hsymm
    {F ι : Type*} [Field F] [DecidableEq ι]
    (s : Finset ι) (a : ι → F)
    (ha : ∀ i ∈ s, a i ≠ 0)
    (hinj : Set.InjOn a s) (hs : 2 ≤ s.card) :
    (∑ i ∈ s, ((a i)⁻¹) ^ 3 /
      (∏ t ∈ s.erase i, (a i - a t))) =
      ((-1 : F) ^ (s.card - 1) * (∏ i ∈ s, a i)⁻¹) *
        ((∑ i ∈ s, (a i)⁻¹) ^ 2 -
          (s.val.map (fun i => (a i)⁻¹)).esymm 2) := by
  have hinv : Set.InjOn (fun i => (a i)⁻¹) s := by
    intro i hi j hj hij
    apply hinj hi hj
    simpa only [inv_inv] using congrArg Inv.inv hij
  have htransfer := reciprocal_anchor_sum_transfer s a ha 2
  have hpow : 2 + s.card - 1 = s.card + 1 := by omega
  rw [hpow] at htransfer
  rw [lagrange_power_moment_second_hsymm s (fun i => (a i)⁻¹) hinv hs] at htransfer
  simpa only [Nat.reduceAdd] using htransfer

end D1Bound5

#check @D1Bound5.nodal_coefficient_two_below_top
#check @D1Bound5.lagrange_power_moment_second_hsymm
#check @D1Bound5.reciprocal_anchor_third_power_hsymm
#print axioms D1Bound5.nodal_coefficient_two_below_top
#print axioms D1Bound5.lagrange_power_moment_second_hsymm
#print axioms D1Bound5.reciprocal_anchor_third_power_hsymm
