from pathlib import Path
base=Path('/workspace/scratch/40edb97fa4c0')
s='''import D1Bound5.FirstPairGeometryNumeric
import D1Bound5.FirstPairFixedTransfer
import D1Bound5.FirstPairRelabeledN3
import D1Bound5.FirstPairRetainedPacket
import D1Bound5.CommonIntervalOverlaps
import D1Bound5.CoherentFixedCutoffQ
import D1Bound5.OneSmallN2FixedInterval
import D1Bound5.OneSmallN3AbFixedInterval
import D1Bound5.OneSmallA3FixedInterval
import D1Bound5.OneSmallA4FixedInterval
import D1Bound5.OneSmallA5FixedInterval
import D1Bound5.FiniteMInterval
import D1Bound5.FinitePAdaptiveInterval

open Finset
open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

/-- Every actual normalized nonrational first-pair row has S<15.
The geometric packet, all family bounds, the fifteen overlaps and the
infinite ordinary tail are supplied internally by proved theorems. -/
theorem IsD1Tuple.first_pair_third_lt_fifteen_of_fixed
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (g : FirstPairGeometryRow) (hg : g ∈ firstPairGeometryRows)
    (r : OneSmallCutoffRow) (hr : r ∈ oneSmallCutoffRows)
    (hmatch : FirstPairGeometryMatches g r)
    (e : QuadInt r.triple.tau r.triple.nu ≃+* 𝓞 K)
    (sgn conj : Bool)
    (h0 : smallExtensionSymmetry sgn conj (e.symm (a 0)) = r.triple.anchorA)
    (h1 : smallExtensionSymmetry sgn conj (e.symm (a 1)) = r.triple.anchorB) :
    ‖phi (a 2 : K)‖ < 15 := by
  classical
  by_contra hn
  have hS15 := le_of_not_gt hn
  let A := ‖phi (a 0 : K)‖
  let B := ‖phi (a 1 : K)‖
  let S := ‖phi (a 2 : K)‖
  let T := ‖phi (a 3 : K)‖
  let C := ‖phi (a 4 : K)‖
  let D := ‖phi (a 5 : K)‖
  let Rbs : ℝ := (3535/409600)*firstPairPhi (phi (a 1 : K)) (phi (a 2 : K))
  have hAB : A ≤ B := hmon (by decide : (0 : Fin 6) ≤ 1)
  have hBS : B ≤ S := hmon (by decide : (1 : Fin 6) ≤ 2)
  have hST : S ≤ T := hmon (by decide : (2 : Fin 6) ≤ 3)
  have hCD : C ≤ D := hmon (by decide : (4 : Fin 6) ≤ 5)
  have hA1 : 1 ≤ A := one_le_norm_integer hK phi (ha.2.1 0)
  have hA : 0 < A := by linarith only [hA1]
  have hB : 0 < B := hA.trans_le hAB
  have hS : 0 < S := hB.trans_le hBS
  have hT : 0 < T := hS.trans_le hST
  have hv := firstPairGeometryRows_valid g hg
  obtain ⟨ha0,hb0,hd0⟩ := FirstPairGeometryMatches.pair_invariants g r hmatch
  obtain ⟨hAsq,hBsq,hdsq,_⟩ := oneSmall_fixed_pair_geometry phi r hr e sgn conj (a 0) (a 1) h0 h1
  rw [←ha0] at hAsq
  rw [←hb0] at hBsq
  rw [←hd0] at hdsq
  have hret := IsD1Tuple.first_pair_retained_packet_of_norms hK phi a ha hmon
    g hv hAsq hBsq hdsq hS15
  change (7/4 : ℝ)*T^5/S^2<C ∧ (g.G : ℝ)*B^5*S^3<C ∧
    (g.rho : ℝ)*Rbs*B^5*S^3<C ∧ C^7/(S^2*T^4)<D ∧
    1000<C ∧ 200*S<C ∧ 4*T<C ∧ 2*B*S<T at hret
  obtain ⟨hgap0,hgap,hgapbs,hstart,hC1000,hC200S,hC4T,hfront⟩ := hret
  have hC : 0 < C := by linarith only [hC1000]
  have hC200B : 200*B ≤ C := (by gcongr : 200*B ≤ 200*S).trans hC200S.le
  have hC4S : 4*S ≤ C := (by gcongr : 4*S ≤ 4*T).trans hC4T.le
  have hC4B : 4*B < C := by linarith only [hC200B,hB]
  have hAC : 1000 ≤ A*C := by
    have hh := mul_le_mul_of_nonneg_right hA1 hC.le
    linarith only [hh,hC1000]
  obtain ⟨haN,hbN,hdN,hA1p,hA1sq,hB0p,hB0sq,hB1p,hB1sq,hd1p,hd1sq,hq,hQ,hm,hK0,
    hG,hH,hF,hrho,hR2,hRn,hR3,hR4,hR5,hRp,hM2,hMn,hM3,hM4,hM5,hqs,htail⟩ := hv
'''
for v in ['G','rho','R2','Rn','R3','R4','R5','Rp','M2','Mn','M3','M4','M5','B0','A1']:
    old={'B0':'hB0p','A1':'hA1p'}.get(v,'h'+v)
    s+=f'  have hp{v} : (0 : ℝ) < (g.{v} : ℝ) := by exact_mod_cast {old}\n'
s+='''  have hsep : phi (a 1 : K)-phi (a 2 : K) ≠ 0 := by
    intro hh
    have he := phi.injective (sub_eq_zero.mp hh)
    exact (ha.1.ne (by decide : (1 : Fin 6) ≠ 2)) (Subtype.ext he)
  have hRbs : 0 < Rbs := by
    have hh : 0 < (‖phi (a 1 : K)-phi (a 2 : K)‖/S)^6 :=
      pow_pos (div_pos (norm_pos_iff.mpr hsep) hS) 6
    have hp : 0 < firstPairPhi (phi (a 1 : K)) (phi (a 2 : K)) :=
      hh.trans_le (le_max_left _ _)
    dsimp [Rbs]
    positivity
  have hnum := firstPairGeometry_common_overlap_bounds g hv B S hB hBsq hS15
  obtain ⟨hoStart,hoQN2,hoN2P,hoPN3,hoPA3,hoA3M,hoMN3,hoN3A4,hoN3bs,
    hoBsA4,hoA4O4,hoO4A5,hoA5O5,hoO5O6,hoRate⟩ :=
    common_interval_window_overlaps 1 B S T C g.G g.rho (7/4)
      g.M2 g.Mn g.M3 g.M4 g.M5 4143 g.R2 g.Rn g.R3 g.R4 g.R5 Rbs g.Rp
      (by norm_num) hB hS hBS hpG hprho (by norm_num)
      hpM2 hpMn hpM3 hpM4 hpM5 (by norm_num)
      hpR2 hpRn hpR3 hpR4 hpR5 hRbs hpRp hfront
      (by simpa only [one_pow,mul_one] using hgap0)
      (by simpa only [one_pow,one_mul,mul_assoc] using hgap)
      (by simpa only [one_pow,one_mul,mul_assoc] using hgapbs) hnum
  obtain ⟨hR2eq,hRneq,hR3eq,hR4eq,hR5eq⟩ :=
    FirstPairGeometryMatches.residual_rates g r hmatch
  obtain ⟨_,_,_,_,hM2eq,hMneq,hM3eq,hM4eq,hM5eq⟩ := hmatch
  let Tup : Finset (𝓞 K) := Finset.univ.image a
  have hmem (i : Fin 6) : a i ∈ Tup := Finset.mem_image.mpr ⟨i,Finset.mem_univ i,rfl⟩
  have hTup : IsD1 Tup := by
    constructor
    · intro x hx
      obtain ⟨i,_,rfl⟩ := Finset.mem_image.mp hx
      exact ha.2.1 i
    · intro x hx y hy hxy
      obtain ⟨i,_,rfl⟩ := Finset.mem_image.mp hx
      obtain ⟨j,_,rfl⟩ := Finset.mem_image.mp hy
      exact ha.2.2 i j (fun hij => hxy (congrArg a hij))
'''
for name,win,m,rn,endpoint in [('N2','N2','M2','R2','finiteN2'),('N3','N3','Mn','Rn','finiteN3Ab'),('A3','A3','M3','R3','finiteA3'),('A4','A4','M4','R4','finiteA4'),('A5','A5','M5','R5','finiteA5')]:
    s+=f'''  have h{name} : ¬ ((commonWindow{win} 1 B C g.{m} g.{rn}).1 ≤ D ∧
      D ≤ (commonWindow{win} 1 B C g.{m} g.{rn}).2) := by
    rintro ⟨hl,hu⟩
    simp only [commonWindow{win},one_pow,one_mul,h{m}eq,h{rn}eq] at hl hu
    exact full_ring_{endpoint}_fixed_interval_excluded hK phi hTup (a 0) (a 1) (a 4) (a 5)
      (hmem 0) (hmem 1) (hmem 4) (hmem 5)
      (ha.1.ne (by decide)) (ha.1.ne (by decide)) (ha.1.ne (by decide))
      (ha.1.ne (by decide)) (ha.1.ne (by decide)) (ha.1.ne (by decide))
      hAB hC1000.le hC200B hCD r hr e sgn conj h0 h1 hl hu
'''
s+='''  have hN3bs : ¬ ((commonWindowN3 B S C 4143 Rbs).1 ≤ D ∧
      D ≤ (commonWindowN3 B S C 4143 Rbs).2) := by
    rintro ⟨hl,hu⟩
    exact full_ring_finiteN3_phi_interval_excluded hK phi hTup (a 1) (a 2) (a 4) (a 5)
      (hmem 1) (hmem 2) (hmem 4) (hmem 5)
      (ha.1.ne (by decide)) (ha.1.ne (by decide)) (ha.1.ne (by decide))
      (ha.1.ne (by decide)) (ha.1.ne (by decide)) (ha.1.ne (by decide))
      hBS hC1000.le hC200S.le hCD hl hu
  let i3 : Fin 3 → Fin 6 := ![0,1,2]
  let b3 : Fin 3 → 𝓞 K := fun i => a (i3 i)
  have hi3 : Function.Injective i3 := by decide
  have hb3 : Function.Injective b3 := ha.1.comp hi3
  have hm3 : Monotone i3 := by decide
  have hM : ¬ ((allLargeWindowM 1 B S C).1 ≤ D ∧ D ≤ (allLargeWindowM 1 B S C).2) := by
    rintro ⟨hl,hu⟩
    have hu' : D ≤ A^6*C^11/(4*(3920/81 : ℝ)^2*B^4*S^10*(1+1/4000 : ℝ)) := by
      apply hu.trans
      simp only [allLargeWindowM,one_pow,one_mul]
      gcongr
    exact full_ring_finiteM_closed_interval_excluded hK phi hTup b3 (a 4) (a 5)
      (fun j => hmem (i3 j)) (hmem 4) (hmem 5) hb3
      (fun j => ha.1.ne (by fin_cases j <;> decide))
      (fun j => ha.1.ne (by fin_cases j <;> decide))
      (ha.1.ne (by decide : (4 : Fin 6) ≠ 5)) (hmon.comp hm3) hC4S hCD hAC hl hu'
  have hq1 : 1 ≤ (g.q : ℝ) := by exact_mod_cast (show (1 : ℚ) ≤ g.q by linarith only [hq])
  have hqAB : (g.q : ℝ)*A ≤ B := by
    have hAA : A ≤ (g.A1 : ℝ) := by
      have hh : A^2 ≤ (g.A1 : ℝ)^2 := by rw [hAsq]; exact_mod_cast hA1sq
      nlinarith only [hh,hA,hpA1]
    have hBB : (g.B0 : ℝ) ≤ B := by
      have hh : (g.B0 : ℝ)^2 ≤ B^2 := by rw [hBsq]; exact_mod_cast hB0sq
      nlinarith only [hh,hB,hpB0]
    calc
      (g.q : ℝ)*A ≤ (g.q : ℝ)*(g.A1 : ℝ) := by gcongr
      _ = (g.B0 : ℝ) := by
        simp only [FirstPairGeometryRow.q]
        push_cast
        field_simp [hpA1.ne']
      _ ≤ B := hBB
  have hRpEq : finitePAdaptiveRate (1/(g.q : ℝ)) = (g.Rp : ℝ) := by
    simp only [finitePAdaptiveRate,FirstPairGeometryRow.Rp]
    push_cast
    <;> ring
  have hP : ¬ ((commonWindowP 1 B S C g.Rp).1 ≤ D ∧ D ≤ (commonWindowP 1 B S C g.Rp).2) := by
    rintro ⟨hl,hu⟩
    have hu' : D ≤ A^6*C^9/(4*(finitePAdaptiveRate (1/(g.q : ℝ)))^2*S^4*(1+1/4000 : ℝ)) := by
      rw [hRpEq]
      apply hu.trans
      simp only [commonWindowP,one_pow,one_mul]
      gcongr
    exact full_ring_finiteP_adaptive_closed_interval_excluded hK phi hTup b3 (a 4) (a 5)
      (fun j => hmem (i3 j)) (hmem 4) (hmem 5) hb3
      (fun j => ha.1.ne (by fin_cases j <;> decide))
      (fun j => ha.1.ne (by fin_cases j <;> decide))
      (ha.1.ne (by decide : (4 : Fin 6) ≠ 5)) (hmon.comp hm3) hC200S.le hCD hAC
      (g.q : ℝ) hq1 hqAB hl hu'
  let iAB : Fin 4 → Fin 6 := ![0,1,4,5]
  let tAB : Fin 4 → 𝓞 K := fun i => a (iAB i)
  have hiAB : Function.Injective iAB := by decide
  have htAB : IsD1Tuple tAB :=
    ⟨ha.1.comp hiAB,fun j => ha.2.1 _,fun j k hjk => ha.2.2 _ _ (hiAB.ne hjk)⟩
  have hOU (k : ℕ) : ordinaryWindowUpper 1 B C k ≤ ordinaryWindowUpper A B C k := by
    unfold ordinaryWindowUpper
    gcongr
  have hQupper : (allLargeWindowQ 1 T C).2 < D := by
    have hlo : (allLargeWindowQ 1 T C).1 ≤ D := by
      apply le_of_lt
      apply hoStart.trans
      simpa only [one_pow,one_mul] using hstart
    exact IsD1Tuple.finiteQ_upper_of_lower hK phi a ha hmon hC1000.le hC4T.le hlo
  have hN2upper := window_upper_lt_of_excluded _ D hN2 (hoQN2.trans hQupper).le
  have hPupper := window_upper_lt_of_excluded _ D hP (hoN2P.trans hN2upper).le
  have hN3upper : (commonWindowN3 1 B C g.Mn g.Rn).2 < D := by
    rcases le_total (B^2) S with h | h
    · exact window_upper_lt_of_excluded _ D hN3 ((hoPN3 h).trans hPupper).le
    · have hA3upper := window_upper_lt_of_excluded _ D hA3 (hoPA3.trans hPupper).le
      have hMupper := window_upper_lt_of_excluded _ D hM ((hoA3M h).trans hA3upper).le
      exact window_upper_lt_of_excluded _ D hN3 (hoMN3.trans hMupper).le
  have hA4upper : (commonWindowA4 1 B C g.M4 g.R4).2 < D := by
    rcases le_total (B^3) S with h | h
    · exact window_upper_lt_of_excluded _ D hA4 ((hoN3A4 h).trans hN3upper).le
    · have hBsupper := window_upper_lt_of_excluded _ D hN3bs ((hoN3bs h).trans hN3upper).le
      exact window_upper_lt_of_excluded _ D hA4 (hoBsA4.trans hBsupper).le
  have hO4lower : ordinaryWindowLower B C 4 ≤ D := (hoA4O4.trans hA4upper).le
  have hO4upper : ordinaryWindowUpper 1 B C 4 < D := by
    apply lt_of_not_ge
    intro h
    exact IsD1Tuple.ordinary_closed_interval_excluded hK phi tAB htAB hAB hAC hC4B hCD
      4 (by norm_num) hO4lower (h.trans (hOU 4))
  have hA5upper := window_upper_lt_of_excluded _ D hA5 (hoO4A5.trans hO4upper).le
  have hO5lower : ordinaryWindowLower B C 5 ≤ D := (hoA5O5.trans hA5upper).le
  have hrate : 42*B^3*C < 2*A*C^2/(5*B) := by
    apply hoRate.trans_le
    gcongr
  exact IsD1Tuple.ordinary_tail_incompatible hK phi tAB htAB hAB hAC hC4B hCD
    hrate (hoO5O6.le.trans (hOU 5)) hO5lower

end D1Bound5
'''
(base/'first_pair_next/FirstPairFifteenExclusion.lean').write_text(s)
