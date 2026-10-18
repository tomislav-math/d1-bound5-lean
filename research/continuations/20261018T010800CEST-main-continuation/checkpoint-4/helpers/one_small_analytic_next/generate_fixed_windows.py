from pathlib import Path
b=Path(__file__).parent
head='''import D1Bound5.OneSmallCutoffReal
import D1Bound5.AllLargeWindows

namespace D1Bound5

noncomputable def fixedWindowN2 (r : OneSmallCutoffRow) (B C : ℝ) : ℝ × ℝ :=
  (4*(r.M2 : ℝ)^2*B^8*C^5/(1-1/4000 : ℝ), C^7/(4*(r.R2 : ℝ)^2*B^4*(1+1/4000 : ℝ)))
noncomputable def fixedWindowP (r : OneSmallCutoffRow) (B S C : ℝ) : ℝ × ℝ :=
  (4*2400^2*(max (B*S^3) (B^3*S^2))^2*C^5/(1-1/4000 : ℝ),
    C^9/(4*(r.Rp : ℝ)^2*S^4*(1+1/4000 : ℝ)))
noncomputable def fixedWindowA3 (r : OneSmallCutoffRow) (B C : ℝ) : ℝ × ℝ :=
  (4*(r.M3 : ℝ)^2*B^12*C^7/(1-1/4000 : ℝ), C^9/(4*(r.R3 : ℝ)^2*B^6*(1+1/4000 : ℝ)))
noncomputable def fixedWindowN3 (r : OneSmallCutoffRow) (B C : ℝ) : ℝ × ℝ :=
  (4*(r.Mn : ℝ)^2*B^14*C^7/(1-1/4000 : ℝ), C^11/(4*(r.Rn : ℝ)^2*B^6*(1+1/4000 : ℝ)))
noncomputable def fixedWindowN3bs (r : OneSmallCutoffRow) (B S C : ℝ) : ℝ × ℝ :=
  (4*(r.Mbs : ℝ)^2*S^14*C^7/(1-1/4000 : ℝ),
    B^8*C^11/(4*(r.Rbs : ℝ)^2*S^6*(1+1/4000 : ℝ)))
noncomputable def fixedWindowA4 (r : OneSmallCutoffRow) (B C : ℝ) : ℝ × ℝ :=
  (4*(r.M4 : ℝ)^2*B^18*C^9/(1-1/4000 : ℝ), C^13/(4*(r.R4 : ℝ)^2*B^8*(1+1/4000 : ℝ)))
noncomputable def fixedWindowA5 (r : OneSmallCutoffRow) (B C : ℝ) : ℝ × ℝ :=
  (4*(r.M5 : ℝ)^2*B^24*C^11/(1-1/4000 : ℝ), C^17/(4*(r.R5 : ℝ)^2*B^10*(1+1/4000 : ℝ)))

/-- Positivity of the explicit residual constants is a separate exact
rational certificate; this makes no assertion about an analytic form. -/
theorem oneSmallCutoffRows_residuals_pos : ∀ r ∈ oneSmallCutoffRows,
    0 < r.R2 ∧ 0 < r.Rn ∧ 0 < r.R3 ∧ 0 < r.R4 ∧ 0 < r.R5 ∧ 0 < r.Rbs ∧ 0 < r.Rp := by
  decide +kernel

/-- Every adjacent fixed-table window overlaps for all fourth moduli at
or beyond its certified cutoff. The actual analytic exclusions are supplied
separately when this scalar theorem is applied to a tuple. -/
theorem fixed_cutoff_window_overlaps (r : OneSmallCutoffRow) (hr : r ∈ oneSmallCutoffRows)
    (B S T C : ℝ) (hB : 0 < B) (hS : 0 < S) (hT : 0 < T)
    (hBsq : B^2 = (r.b0 : ℝ)) (hSsq : S^2 = (r.s0 : ℝ))
    (hlarge : (r.triple.cutoff : ℝ) ≤ T^2)
    (hgap : (r.retainedCoefficient : ℝ)*T^5/S^2 < C) :
    (fixedWindowN2 r B C).1 < (allLargeWindowQ 1 T C).2 ∧
    (fixedWindowP r B S C).1 < (fixedWindowN2 r B C).2 ∧
    (fixedWindowA3 r B C).1 < (fixedWindowP r B S C).2 ∧
    (allLargeWindowM 1 B S C).1 < (fixedWindowA3 r B C).2 ∧
    (fixedWindowN3 r B C).1 < (allLargeWindowM 1 B S C).2 ∧
    (fixedWindowN3bs r B S C).1 < (fixedWindowN3 r B C).2 ∧
    (fixedWindowA4 r B C).1 < (fixedWindowN3bs r B S C).2 ∧
    ordinaryWindowLower B C 4 < (fixedWindowA4 r B C).2 ∧
    (fixedWindowA5 r B C).1 < ordinaryWindowUpper 1 B C 4 ∧
    ordinaryWindowLower B C 5 < (fixedWindowA5 r B C).2 ∧
    ordinaryWindowLower B C 6 < ordinaryWindowUpper 1 B C 5 ∧
    42*B^3*C < 2*C^2/(5*B) := by
  have hv := oneSmallCutoffRows_valid r hr
  obtain ⟨_,_,_,_,_,_,_,_,_,_,_,_,hK,hM2,hMn,hM3,hM4,hM5,hMbs,_,htail⟩ := hv
  obtain ⟨hR2,hRn,hR3,hR4,hR5,hRbs,hRp⟩ := oneSmallCutoffRows_residuals_pos r hr
  have hKpos : 0 < (r.retainedCoefficient : ℝ) := by exact_mod_cast (show (0 : ℚ) < r.retainedCoefficient from lt_trans (by norm_num) hK)
  have hM2pos : 0 < (r.M2 : ℝ) := by exact_mod_cast hM2
  have hMnpos : 0 < (r.Mn : ℝ) := by exact_mod_cast hMn
  have hM3pos : 0 < (r.M3 : ℝ) := by exact_mod_cast hM3
  have hM4pos : 0 < (r.M4 : ℝ) := by exact_mod_cast hM4
  have hM5pos : 0 < (r.M5 : ℝ) := by exact_mod_cast hM5
  have hMbspos : 0 < (r.Mbs : ℝ) := by exact_mod_cast hMbs
  have hR2pos : 0 < (r.R2 : ℝ) := by exact_mod_cast hR2
  have hRnpos : 0 < (r.Rn : ℝ) := by exact_mod_cast hRn
  have hR3pos : 0 < (r.R3 : ℝ) := by exact_mod_cast hR3
  have hR4pos : 0 < (r.R4 : ℝ) := by exact_mod_cast hR4
  have hR5pos : 0 < (r.R5 : ℝ) := by exact_mod_cast hR5
  have hRbspos : 0 < (r.Rbs : ℝ) := by exact_mod_cast hRbs
  have hRppos : 0 < (r.Rp : ℝ) := by exact_mod_cast hRp
  have hC : 0 < C := (by positivity : 0 < (r.retainedCoefficient : ℝ)*T^5/S^2).trans hgap
'''
# row, coefficient expression over Q, power, actual ratio expression over R
rows=[
(1,'r.retainedCoefficient^2/(36*r.M2^2*r.b0^4*r.s0^2*(4001/3999))',4,'C^2/(36*(r.M2 : ℝ)^2*B^8*T^2*(4001/3999 : ℝ))'),
(2,'r.retainedCoefficient^2/(16*r.R2^2*2400^2*r.b0^3*r.s0^5*(4001/3999))',5,'C^2/(16*(r.R2 : ℝ)^2*2400^2*B^6*S^6*(4001/3999 : ℝ))'),
(3,'r.retainedCoefficient^2/(16*r.R2^2*2400^2*r.b0^5*r.s0^4*(4001/3999))',5,'C^2/(16*(r.R2 : ℝ)^2*2400^2*B^10*S^4*(4001/3999 : ℝ))'),
(4,'r.retainedCoefficient^2/(16*r.Rp^2*r.M3^2*r.b0^6*r.s0^4*(4001/3999))',5,'C^2/(16*(r.Rp : ℝ)^2*(r.M3 : ℝ)^2*B^12*S^4*(4001/3999 : ℝ))'),
(5,'r.retainedCoefficient^4/(16*r.R3^2*((8/9)*608^2)^2*r.b0^6*r.s0^12*(4001/3999))',10,'C^4/(16*(r.R3 : ℝ)^2*((8/9 : ℝ)*608^2)^2*B^12*S^16*(4001/3999 : ℝ))'),
(6,'r.retainedCoefficient^4/(16*(3920/81)^2*r.Mn^2*r.b0^9*r.s0^9*(4001/3999))',10,'C^4/(16*(3920/81 : ℝ)^2*(r.Mn : ℝ)^2*B^18*S^10*(4001/3999 : ℝ))'),
(7,'r.retainedCoefficient^4/(16*r.Rn^2*r.Mbs^2*r.b0^3*r.s0^11*(4001/3999))',10,'C^4/(16*(r.Rn : ℝ)^2*(r.Mbs : ℝ)^2*B^6*S^14*(4001/3999 : ℝ))'),
(8,'r.retainedCoefficient^2/(16*r.Rbs^2*r.M4^2*r.b0^5*r.s0^5*(4001/3999))',5,'C^2/(16*(r.Rbs : ℝ)^2*(r.M4 : ℝ)^2*B^10*S^6*(4001/3999 : ℝ))'),
(9,'r.retainedCoefficient^4/(144*r.R4^2*42^8*r.b0^15*r.s0^4*(4001/3999))',10,'C^4/(144*(r.R4 : ℝ)^2*42^8*B^30*(4001/3999 : ℝ))'),
(10,'(2/5)^8*r.retainedCoefficient^4/(4*r.M5^2*r.b0^16*r.s0^4*(4001/3999))',10,'(2/5 : ℝ)^8*C^4/(4*(r.M5 : ℝ)^2*B^32*(4001/3999 : ℝ))'),
(11,'r.retainedCoefficient^6/(144*r.R5^2*42^10*r.b0^19*r.s0^6*(4001/3999))',15,'C^6/(144*(r.R5 : ℝ)^2*42^10*B^38*(4001/3999 : ℝ))'),
(12,'(2/5)^10*r.retainedCoefficient^6/(36*42^12*r.b0^22*r.s0^6*(4001/3999))',15,'(2/5 : ℝ)^10*C^6/(36*42^12*B^44*(4001/3999 : ℝ))'),
]
s=head
for n,coef,p,ratio in rows:
 base=ratio.replace('C^','((r.retainedCoefficient : ℝ)*T^5/S^2)^')
 s+=f'''  have hr{n} : 1 < {ratio} := by
    have hh := r.overlaps_at_real hv (T^2) hlarge
      (({coef} : ℚ),{p}) (by simp [OneSmallCutoffRow.overlaps])
    have hbase : 1 < {base} := by
      push_cast at hh
      rw [←hBsq,←hSsq] at hh
      convert hh using 1 <;> field_simp [hB.ne',hS.ne',hT.ne',hM2pos.ne',hMnpos.ne',hM3pos.ne',hM4pos.ne',hM5pos.ne',hMbspos.ne',hR2pos.ne',hRnpos.ne',hR3pos.ne',hR4pos.ne',hR5pos.ne',hRbspos.ne',hRppos.ne'] <;> ring
    apply hbase.trans_le
    gcongr <;> first | exact hgap.le | positivity
'''
s+='''  have hrate : 42*B^3*C < 2*C^2/(5*B) := by
    have hn : 0 < (r.triple.cutoff : ℝ) := by
      have hh : (1024 : ℝ) ≤ r.triple.cutoff := by exact_mod_cast hv.1
      linarith only [hh]
    change 1 < r.retainedCoefficient^2*(r.triple.cutoff : ℚ)^5/(105^2*r.b0^4*r.s0^2) at htail
    have hs : 1 < (r.retainedCoefficient : ℝ)^2*(r.triple.cutoff : ℝ)^5/
        (105^2*(r.b0 : ℝ)^4*(r.s0 : ℝ)^2) := by
      exact_mod_cast htail
    rw [←hBsq,←hSsq] at hs
    have hp : (r.triple.cutoff : ℝ)^5 ≤ (T^2)^5 := by gcongr
    have hs' : 1 < (r.retainedCoefficient : ℝ)^2*T^10/(105^2*B^8*S^4) := by
      calc
        (1 : ℝ) < (r.retainedCoefficient : ℝ)^2*(r.triple.cutoff : ℝ)^5/
            (105^2*(B^2)^4*(S^2)^2) := hs
        _ ≤ (r.retainedCoefficient : ℝ)^2*(T^2)^5/(105^2*(B^2)^4*(S^2)^2) := by gcongr
        _ = _ := by ring
    have hs'' : (105*B^4*S^2)^2 < ((r.retainedCoefficient : ℝ)*T^5)^2 := by
      have hh := (lt_div_iff₀ (by positivity : (0 : ℝ) < 105^2*B^8*S^4)).mp hs'
      nlinarith only [hh]
    have hlin : 105*B^4*S^2 < (r.retainedCoefficient : ℝ)*T^5 :=
      (sq_lt_sq₀ (by positivity) (by positivity)).mp hs''
    have hsmall : 105*B^4 < (r.retainedCoefficient : ℝ)*T^5/S^2 :=
      (lt_div_iff₀ (pow_pos hS 2)).mpr hlin
    have hc : 105*B^4 < C := hsmall.trans hgap
    apply (lt_div_iff₀ (by positivity : 0 < 5*B)).mpr
    have hm := mul_lt_mul_of_pos_right hc (by positivity : 0 < 2*C)
    nlinarith only [hm]
  have heq (l u q : ℝ) (hl : 0 < l) (h : u/l=q) (hq : 1 < q) : l<u :=
    window_overlap_of_ratio l u q hl h hq
  refine ⟨?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,?_,hrate⟩
'''
windows=[
('fixedWindowN2 r B C','allLargeWindowQ 1 T C',1),
None,
('fixedWindowA3 r B C','fixedWindowP r B S C',4),
('allLargeWindowM 1 B S C','fixedWindowA3 r B C',5),
('fixedWindowN3 r B C','allLargeWindowM 1 B S C',6),
('fixedWindowN3bs r B S C','fixedWindowN3 r B C',7),
('fixedWindowA4 r B C','fixedWindowN3bs r B S C',8),
('ordinaryWindowLower B C 4','fixedWindowA4 r B C',9),
('fixedWindowA5 r B C','ordinaryWindowUpper 1 B C 4',10),
('ordinaryWindowLower B C 5','fixedWindowA5 r B C',11),
('ordinaryWindowLower B C 6','ordinaryWindowUpper 1 B C 5',12),
]
all_defs='fixedWindowN2,fixedWindowP,fixedWindowA3,fixedWindowN3,fixedWindowN3bs,fixedWindowA4,fixedWindowA5,allLargeWindowQ,allLargeWindowM,ordinaryWindowLower,ordinaryWindowUpper'
nonzeros="hB.ne',hS.ne',hT.ne',hC.ne',hM2pos.ne',hMnpos.ne',hM3pos.ne',hM4pos.ne',hM5pos.ne',hMbspos.ne',hR2pos.ne',hRnpos.ne',hR3pos.ne',hR4pos.ne',hR5pos.ne',hRbspos.ne',hRppos.ne'"
for w in windows:
 if w is None:
  s+=f'''  · by_cases hm : B*S^3 ≤ B^3*S^2
    · apply heq _ _ _ (by simp only [{all_defs}]; positivity) _ hr3
      simp only [{all_defs},max_eq_right hm]
      field_simp [{nonzeros}]
      <;> ring
    · have hm' : B^3*S^2 ≤ B*S^3 := (le_of_not_ge hm)
      apply heq _ _ _ (by simp only [{all_defs}]; positivity) _ hr2
      simp only [{all_defs},max_eq_left hm']
      field_simp [{nonzeros}]
      <;> ring
'''
 else:
  l,u,n=w
  s+=f'''  · apply heq _ _ _ (by simp only [{all_defs}]; positivity) _ hr{n}
    simp only [{all_defs}]
    field_simp [{nonzeros}]
    <;> ring
'''
s+='\nend D1Bound5\n'
(b/'OneSmallFixedWindows.lean').write_text(s)
