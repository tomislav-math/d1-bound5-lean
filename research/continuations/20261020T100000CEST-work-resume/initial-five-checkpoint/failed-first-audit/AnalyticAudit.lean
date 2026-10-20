import D1Bound5.FinitePRatioMonomial
import D1Bound5.CoherentRetainedMixedFourSizes
import D1Bound5.SmallPairClassificationCheck
import D1Bound5.OneSmallFiniteCheck
import D1Bound5.OneThreeEight
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open scoped NumberField
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [
    `D1Bound5.finiteP_ratio_monomial_bound,
    `D1Bound5.coherent_retained_mixed_first_terminal_large,
    `D1Bound5.coherent_retained_mixed_four_terminal_sizes,
    `D1Bound5.coherent_retained_mixed_common_sizes,
    `D1Bound5.pairCoordinates,
    `D1Bound5.smallPairClassifiedBool,
    `D1Bound5.smallPairClassified_of_explicit_list,
    `D1Bound5.first_pair_root_norm_le_eight,
    `D1Bound5.one_small_fourth_root_norm_le,
    `D1Bound5.firstPairCoordinates,
    `D1Bound5.FirstPairNorms,
    `D1Bound5.firstPairClassifiedBool,
    `D1Bound5.firstPairClassified_of_checked,
    `D1Bound5.oneSmallThirdCoveredBool,
    `D1Bound5.oneSmallThirdCovered_of_checked,
    `D1Bound5.oneSmallFourthGrowthBool,
    `D1Bound5.oneSmallFourthGrowth_of_checked,
    `D1Bound5.integer_one_three_third_eq_eight,
    `D1Bound5.IsD1.one_three_small_third_eq_eight,
    `D1Bound5.one_three_eight_cutoff_contradiction]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.finiteP_ratio_monomial_bound
#check @D1Bound5.coherent_retained_mixed_first_terminal_large
#check @D1Bound5.coherent_retained_mixed_four_terminal_sizes
#check @D1Bound5.coherent_retained_mixed_common_sizes
#check @D1Bound5.pairCoordinates
#check @D1Bound5.smallPairClassifiedBool
#check @D1Bound5.smallPairClassified_of_explicit_list
#check @D1Bound5.first_pair_root_norm_le_eight
#check @D1Bound5.one_small_fourth_root_norm_le
#check @D1Bound5.firstPairCoordinates
#check @D1Bound5.FirstPairNorms
#check @D1Bound5.firstPairClassifiedBool
#check @D1Bound5.firstPairClassified_of_checked
#check @D1Bound5.oneSmallThirdCoveredBool
#check @D1Bound5.oneSmallThirdCovered_of_checked
#check @D1Bound5.oneSmallFourthGrowthBool
#check @D1Bound5.oneSmallFourthGrowth_of_checked
#check @D1Bound5.integer_one_three_third_eq_eight
#check @D1Bound5.IsD1.one_three_small_third_eq_eight
#check @D1Bound5.one_three_eight_cutoff_contradiction

open Finset Polynomial
namespace D1Bound5
section


example (A B S : ℝ)
    (hA : 1 ≤ A) (hAB : A ≤ B) (hBS : B ≤ S)
    (r : Fin 3) (i j l m t e : ℕ)
    (htotal : i+j+l+t ≤ m+2)
    (he : e+j+l = if r=0 then 2 else m+2)
    (hl : r ≠ 2 → l ≤ 2) :
    A^i*B^j*S^l/(![A,B,S] r)^m ≤ (S^2/A^t)*(A/B)^e := by
  exact finiteP_ratio_monomial_bound A B S hA hAB hBS r i j l m t e htotal he hl

end

section


example
    (A B S T C : ℝ) (hA : 1 ≤ A) (hB : 3 ≤ B) (hS : 0 < S)
    (hBS : B ≤ S) (hST : S ≤ T)
    (hfront : 2*A*B*S < T) (hgap : A^2*T^5/S^2 < C) :
    16*B*S*T < C := by
  exact coherent_retained_mixed_first_terminal_large A B S T C hA hB hS hBS hST hfront hgap

example
    (A B S T C D : ℝ) (hA : 1 ≤ A) (hB : 3 ≤ B)
    (hS : 0 < S) (hT : 0 < T) (hST : S ≤ T) (hSC : S ≤ C)
    (hC1000 : 1000 < C) (hC : 16*B*S*T < C)
    (hD : A^2*C^5/S^2 < D) :
    1000*C < D ∧ 17*A*B*S*T*C^3 < D := by
  exact coherent_retained_mixed_four_terminal_sizes A B S T C D hA hB hS hT hST hSC hC1000 hC hD

example
    (A S T C : ℝ) (hA : 1 ≤ A) (hS3 : 3 ≤ S) (hST : S ≤ T)
    (hAT48 : 48 ≤ A*T) (hgap : A^2*T^5/S^2 < C) :
    1000 < C ∧ 200*S < C ∧ 4*T < C := by
  exact coherent_retained_mixed_common_sizes A S T C hA hS3 hST hAT48 hgap

end

section


example {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (xs : List (QuadInt tau nu))
    (rows : List (Finset (ℤ × ℤ)))
    (cover : ∀ z ∈ disk tau nu 8, z ∈ xs)
    (checked : smallPairClassifiedBool xs rows = true)
    (a b : QuadInt tau nu) (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b)
    (hroot : ∃ r, r*r = a*b+1) (hnondeg : a*b+1 ≠ 0)
    (hNa : a.norm ≤ 8) (hNb : b.norm ≤ 8) : pairCoordinates a b ∈ rows := by
  exact smallPairClassified_of_explicit_list hd xs rows cover checked a b ha hb hab hroot hnondeg hNa hNb

end

section


example {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b q : QuadInt tau nu)
    (hab : a.norm*b.norm ≤ 63) (hq : q*q = a*b+1) : q.norm ≤ 8 := by
  exact first_pair_root_norm_le_eight hd a b q hab hq

example {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a z q : QuadInt tau nu)
    (ha : a.norm ≤ 2) (hz : z.norm ≤ 21270) (hq : q*q = a*z+1) :
    q.norm ≤ 300 := by
  exact one_small_fourth_root_norm_le hd a z q ha hz hq

example {tau nu : ℤ}
    (hd : 0 < discriminant tau nu)
    (small roots : List (QuadInt tau nu))
    (rows : List ((ℤ × ℤ) × (ℤ × ℤ)))
    (hsmall : ∀ a ∈ disk tau nu 8, a ∈ small)
    (hroots : ∀ q ∈ disk tau nu 8, q ∈ roots)
    (hcheck : firstPairClassifiedBool small roots rows = true)
    (a b : QuadInt tau nu) (hnorm : FirstPairNorms a b)
    (hroot : ∃ q, q*q = a*b+1) :
    (a = 1 ∧ b = 3) ∨ (a = -1 ∧ b = -3) ∨ firstPairCoordinates a b ∈ rows := by
  exact firstPairClassified_of_checked hd small roots rows hsmall hroots hcheck a b hnorm hroot

example {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b : QuadInt tau nu)
    (diskEntries allowed : List (QuadInt tau nu))
    (hcover : ∀ s ∈ disk tau nu 224, s ∈ diskEntries)
    (hcheck : oneSmallThirdCoveredBool a b diskEntries allowed = true)
    (s : QuadInt tau nu) (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) : s ∈ allowed := by
  exact oneSmallThirdCovered_of_checked hd a b diskEntries allowed hcover hcheck s hbound horder ha hb hpair

example {tau nu : ℤ}
    (hd : 0 < discriminant tau nu) (a b s : QuadInt tau nu)
    (ha : a ≠ 0) (hNa : a.norm ≤ 2) (cutoff : ℤ) (hcutoff : cutoff ≤ 21270)
    (roots : List (QuadInt tau nu))
    (hcover : ∀ q ∈ disk tau nu 300, q ∈ roots)
    (hcheck : oneSmallFourthGrowthBool a b s cutoff roots = true)
    (z : QuadInt tau nu) (hz : z.norm < cutoff)
    (hza : ∃ q, q*q = a*z+1) (hzb : ∃ q, q*q = b*z+1)
    (hzs : ∃ q, q*q = s*z+1) : z.norm ≤ 4*b.norm*s.norm := by
  exact oneSmallFourthGrowth_of_checked hd a b s ha hNa cutoff hcutoff roots hcover hcheck z hz hza hzb hzs

end

section


example (s r : ℤ)
    (hlo : 3 < s) (hhi : s < 15) (hr : r*r = s+1) : s = 8 := by
  exact integer_one_three_third_eq_eight s r hlo hhi hr

example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {A : Finset (𝓞 K)} (hA : IsD1 A)
    (h1 : (1 : 𝓞 K) ∈ A) (h3 : (3 : 𝓞 K) ∈ A) (hcard : 4 < A.card)
    (z : 𝓞 K) (hz : z ∈ A) (hz1 : z ≠ 1) (hz3 : z ≠ 3)
    (hlo : 9 ≤ ‖phi (z : K)‖^2) (hhi : ‖phi (z : K)‖^2 < 225) : z = 8 := by
  exact IsD1.one_three_small_third_eq_eight hK phi hA h1 h3 hcard z hz hz1 hz3 hlo hhi

example (T : ℝ)
    (hcutoff : T^2 < 1024) (hgrowth : 48 < T) : False := by
  exact one_three_eight_cutoff_contradiction T hcutoff hgrowth

end

end D1Bound5
