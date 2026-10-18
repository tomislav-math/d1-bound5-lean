from pathlib import Path
src=Path('all_large_next/AllLargeForcedPWindow.lean').read_text()
# Preserve the reviewed interval ordering while replace every family with its region specialization.
setup=src[src.index('  classical\n'):src.index('  have hB : 3 ≤ B')]
setup=setup.replace('  change (allLargeWindowP A B S C).1 ≤ D ∧ D ≤ (allLargeWindowP A B S C).2\n','')
setup=setup.replace('allLarge_subtuple','fiveRegion_subtuple')
body='''  have hA1 : 1 ≤ A := one_le_norm_integer hK phi (ha.2.1 0)
  have hc := fiveRegion_case_bounds r A B (norm_nonneg _) hN8 hcase
  have hB : 3 ≤ B := hc.2.2.2.1
  have hS : 3 ≤ S := hB.trans hBS
  have hA0 : 0 < A := by linarith only [hA1]
  have hB0 : 0 < B := by linarith only [hB]
  have hS0 : 0 < S := by linarith only [hS]
  have hT0 : 0 < T := hS0.trans_le hST
  have hB1 : 1 ≤ B := by linarith only [hB]
  have hS1 : 1 ≤ S := by linarith only [hS]
  have hret := IsD1Tuple.small_norm_retained_start hK phi a ha hmon hN8 hB
    (fiveRegion_case_disjunction r A B hcase)
  change A^2*T^5/S^2 < C ∧ A^2*C^5/S^2 < D ∧ A^2*C^7/(S^2*T^4) < D ∧
    1000 < C ∧ 200*S < C ∧ 4*T < C ∧ 16*B*S*T < C ∧ 1000*C < D at hret
  rcases hret with ⟨hCgap,hDgap,hDstart,hC1000,hC200S',hC4T',hC16,hD1000⟩
  let Rbs : ℝ := (3535/409600)*phasePhi (phi (a 1 : K)) (phi (a 2 : K))
  have hgapBoth := IsD1Tuple.five_region_retained_gaps hK phi b5 hb5 (hmon.comp hm5) r hN8 hcase
  have hgap : fiveRegionGap r*(A^7*B^5*S^3) < C := hgapBoth.1
  have hgapbs : (fiveRegionCoupledGap r*Rbs)*(A^7*B^5*S^3) < C := hgapBoth.2
  have hfront : 2*A*B*S < T :=
    (IsD1Tuple.small_norm_retained_parameters hK phi b4 hb4 (hmon.comp hm4)
      hN8 hB (fiveRegion_case_disjunction r A B hcase)).1
  have hTBS : 2*B*S < T := by
    have hh := mul_le_mul_of_nonneg_right hA1 (show 0 ≤ 2*B*S by positivity)
    nlinarith only [hh,hfront]
  have hC0 : 0 < C := by linarith only [hC1000]
  have hC200S : 200*S ≤ C := hC200S'.le
  have hC200B : 200*B ≤ C := (by gcongr : 200*B ≤ 200*S).trans hC200S
  have hC4T : 4*T ≤ C := hC4T'.le
  have hC4S : 4*S ≤ C := (by gcongr : 4*S ≤ 4*T).trans hC4T
  have hC4B : 4*B < C := by linarith only [hC200B,hB0]
  have hAC : 1000 ≤ A*C := by
    have hh := mul_le_mul_of_nonneg_right hA1 hC0.le
    linarith only [hh,hC1000]
  have hBC : 1000 ≤ B*C := hAC.trans (mul_le_mul_of_nonneg_right hAB hC0.le)
'''
body+=src[src.index('  let Tup :'):src.index('  have hN2 :')]
# actual family intervals
for f in ['N2','N3','A3','A4','A5']:
 w=f'(commonWindow{f} A B C (fiveRegion{f}Height r) (fiveRegion{f}Residual r))'
 body+=f'''  have h{f} : ¬ ({w}.1 ≤ D ∧ D ≤ {w}.2) := by
    rintro ⟨hl,hu⟩
    exact full_ring_finite{f}_five_region_interval_excluded hK phi hTup (a 0) (a 1) (a 4) (a 5)
      (hmem 0) (hmem 1) (hmem 4) (hmem 5)
      (ha.1.ne (by decide)) (ha.1.ne (by decide)) (ha.1.ne (by decide))
      (ha.1.ne (by decide)) (ha.1.ne (by decide)) (ha.1.ne (by decide))
      hAB hC1000.le hC200B hCD r hc.2.2.2.2.2 hl hu
'''
body+='''  have hN3bs : ¬ ((commonWindowN3 B S C 4143 Rbs).1 ≤ D ∧ D ≤ (commonWindowN3 B S C 4143 Rbs).2) := by
    rintro ⟨hl,hu⟩
    exact full_ring_finiteN3_phi_interval_excluded hK phi hTup (a 1) (a 2) (a 4) (a 5)
      (hmem 1) (hmem 2) (hmem 4) (hmem 5)
      (ha.1.ne (by decide)) (ha.1.ne (by decide)) (ha.1.ne (by decide))
      (ha.1.ne (by decide)) (ha.1.ne (by decide)) (ha.1.ne (by decide))
      hBS hC1000.le hC200S hCD hl hu
  have hP : ¬ ((commonWindowP A B S C (fiveRegionPResidual r)).1 ≤ D ∧
      D ≤ (commonWindowP A B S C (fiveRegionPResidual r)).2) := by
    rintro ⟨hl,hu⟩
    exact full_ring_finiteP_five_region_interval_excluded hK phi hTup b3 (a 4) (a 5)
      (fun j => hmem (i3 j)) (hmem 4) (hmem 5) hb3.1
      (fun j => ha.1.ne (by fin_cases j <;> decide))
      (fun j => ha.1.ne (by fin_cases j <;> decide))
      (ha.1.ne (by decide : (4 : Fin 6) ≠ 5)) (hmon.comp hm3) hC200S hCD hAC
      r hc.2.2.2.2.1 hl hu
'''
body+=src[src.index('  have hM :'):src.index('  rcases all_large_window_overlaps')]
for name in ['Gap','CoupledGap','N2Height','N3Height','A3Height','A4Height','A5Height','N2Residual','N3Residual','A3Residual','A4Residual','A5Residual','PResidual']:
 body+=f'''  have hp{name} : 0 < fiveRegion{name} r := by
    fin_cases r <;> norm_num [fiveRegion{name},fiveRegionAnchorRatio]
'''
body+='''  have hRbs : 0 < Rbs := by
    have hsep : phi (a 1 : K)-phi (a 2 : K) ≠ 0 := by
      intro hh
      apply ha.1.ne (by decide : (1 : Fin 6) ≠ 2)
      apply NumberField.RingOfIntegers.ext
      exact phi.injective (sub_eq_zero.mp hh)
    have hd : 0 < ‖phi (a 1 : K)-phi (a 2 : K)‖ := norm_pos_iff.mpr hsep
    have hPhi : 0 < phasePhi (phi (a 1 : K)) (phi (a 2 : K)) := by
      apply lt_of_lt_of_le (pow_pos (div_pos hd hS0) 6)
      exact le_max_left _ _
    dsimp [Rbs]
    positivity
  have hnum := fiveRegion_common_overlap_bounds r A B S hc.1 hc.2.2.1 hBS
  rcases common_interval_window_overlaps A B S T C
      (fiveRegionGap r) (fiveRegionCoupledGap r) 1
      (fiveRegionN2Height r) (fiveRegionN3Height r) (fiveRegionA3Height r)
      (fiveRegionA4Height r) (fiveRegionA5Height r) 4143
      (fiveRegionN2Residual r) (fiveRegionN3Residual r) (fiveRegionA3Residual r)
      (fiveRegionA4Residual r) (fiveRegionA5Residual r) Rbs (fiveRegionPResidual r)
      hA0 hB0 hS0 hBS hpGap hpCoupledGap (by norm_num)
      hpN2Height hpN3Height hpA3Height hpA4Height hpA5Height (by norm_num)
      hpN2Residual hpN3Residual hpA3Residual hpA4Residual hpA5Residual hRbs hpPResidual
      hTBS (by simpa only [one_mul] using hCgap) hgap hgapbs hnum with
    ⟨hoStart,hoQN2,hoN2P,hoPN3,hoPA3,hoA3M,hoMN3,hoN3A4,hoN3bs,hoBsA4,
      hoA4O4,hoO4A5,hoA5O5,hoO5O6,hoRate⟩
'''
tail=src[src.index('  have hQlower :'):src.index('\nend D1Bound5')]
tail=tail.replace('  refine ⟨hPlower,?_⟩\n  by_contra hnot\n  have hPupper : (allLargeWindowP A B S C).2 < D := lt_of_not_ge hnot', '  have hPupper : (allLargeWindowP A B S C).2 < D := window_upper_lt_of_excluded _ D hP hPlower')
for f in ['N2','N3','A3','A4','A5']:
 tail=tail.replace(f'(allLargeWindow{f} A B C)',f'(commonWindow{f} A B C (fiveRegion{f}Height r) (fiveRegion{f}Residual r))')
tail=tail.replace('(allLargeWindowP A B S C)','(commonWindowP A B S C (fiveRegionPResidual r))')
body+=tail
header='''import D1Bound5.FiveRegionTupleGap
import D1Bound5.FiveRegionOverlapBounds
import D1Bound5.CommonIntervalOverlaps
import D1Bound5.FiveRegionN2Interval
import D1Bound5.FiveRegionN3Interval
import D1Bound5.FiveRegionA3Interval
import D1Bound5.FiveRegionA4Interval
import D1Bound5.FiveRegionA5Interval
import D1Bound5.FiveRegionPInterval
import D1Bound5.FirstPairRelabeledN3
import D1Bound5.CoherentRetainedMixedStart
import D1Bound5.FiniteQInterval
import D1Bound5.FiniteMInterval

open Finset
open scoped NumberField
open Module

noncomputable section

namespace D1Bound5

private theorem fiveRegion_subtuple
    {R : Type*} [CommRing R] {m n : ℕ} (a : Fin n → R) (ha : IsD1Tuple a)
    (i : Fin m → Fin n) (hi : Function.Injective i) : IsD1Tuple (fun j => a (i j)) :=
  ⟨ha.1.comp hi, fun j => ha.2.1 (i j), fun j k hjk => ha.2.2 (i j) (i k) (hi.ne hjk)⟩

/-- Every unbounded first-pair region is impossible for an actual
ordered sextuple. All coefficient heights, residual rates, retained
gaps, phase bounds, finite windows, and the infinite tail are supplied
by their proved constructions; no interval certificate is assumed. -/
theorem IsD1Tuple.five_region_impossible
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (r : Fin 5) (hN8 : ‖phi (a 0 : K)‖^2 ≤ 8)
    (hcase : FiveRegionCase r ‖phi (a 0 : K)‖ ‖phi (a 1 : K)‖) : False := by
'''
Path('five_regions_next/FiveRegionImpossible.lean').write_text(header+setup+body+'\nend D1Bound5\n')
