from pathlib import Path
configs=[('A3','M3','R3',12,7,9,6,'707/40960',1,3,2),('A4','M4','R4',18,9,13,8,'6363/409600',1,3,2),('A5','M5','R5',24,11,17,10,'9999/2621440',1,3,2),('N3Ab','Mn','Rn',14,7,11,6,'3535/409600',1,3,2),('N3Bs','Mbs','Rbs',14,7,11,6,'3535/409600',3,8,5)]
imports=['RationalCutoffHeights','FiniteA3FixedInterval','FiniteA4FixedInterval','FiniteA5FixedInterval','FiniteN3FixedInterval','FiniteN3ExactInterval']
out=''.join('import D1Bound5.'+m+'\n' for m in imports)+'''
open scoped NumberField
open Module

namespace D1Bound5

'''
for fam,M,R,bp,clo,chi,rp,alpha,X,Y,delta in configs:
 upperprefix='‖phi (x : K)‖^8*' if fam=='N3Bs' else ''
 out+=f'''/-- The actual {fam} window for signed rational anchors. It requires no
coordinate-ring equivalence for the ambient quadratic field. -/
theorem full_ring_finite{fam}_rational_interval_excluded
    {{K : Type*}} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {{S : Finset (𝓞 K)}} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hC1000 : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (sgn : Bool) (hx : x = if sgn then -{X} else {X})
    (hy : y = if sgn then -{Y} else {Y})
    (hleft : 4*(oneSmallCutoffRow_56.{M} : ℝ)^2*‖phi (y : K)‖^{bp}*‖phi (c : K)‖^{clo}/
      (1-1/4000 : ℝ) ≤ ‖phi (d : K)‖)
    (hright : ‖phi (d : K)‖ ≤ {upperprefix}‖phi (c : K)‖^{chi}/
      (4*(oneSmallCutoffRow_56.{R} : ℝ)^2*‖phi (y : K)‖^{rp}*(1+1/4000 : ℝ))) : False := by
  obtain ⟨hX,hY,hdist⟩ := rationalCutoff_{'bs' if fam=='N3Bs' else 'pair'}_geometry phi sgn x y hx hy
  have hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖ := by rw [hX,hY]; norm_num
  have hM : 0 < (oneSmallCutoffRow_56.{M} : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.{M} by decide +kernel)
  have hRpos : 0 < (oneSmallCutoffRow_56.{R} : ℝ) := by
    exact_mod_cast (show (0 : ℚ) < oneSmallCutoffRow_56.{R} by decide +kernel)
  have hheight := finite{fam}_rational_height phi sgn x y c hx hy hC1000 hCY
'''
 if fam.startswith('A'):
  out+=f'''  have hdelta : ‖phi (x : K)‖ ≤ ‖phi (x : K)-phi (y : K)‖ := by
    rw [hX,hdist]
    norm_num
  have hR : ({alpha} : ℝ)*‖phi (x : K)-phi (y : K)‖^{rp} ≤
      (oneSmallCutoffRow_56.{R} : ℝ)*‖phi (y : K)‖^{rp} := by
    rw [hdist,hY]
    exact_mod_cast (show ({alpha} : ℚ)*{delta}^{rp} ≤ oneSmallCutoffRow_56.{R}*{Y}^{rp} by decide +kernel)
  exact full_ring_finite{fam}_fixed_interval_of_bounds hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hC1000 hCY hCD
    (oneSmallCutoffRow_56.{M} : ℝ) (oneSmallCutoffRow_56.{R} : ℝ)
    hM hRpos hheight hdelta hR hleft hright

'''
 else:
  out+=f'''  have hR : ({alpha} : ℝ)*max (‖phi (x : K)-phi (y : K)‖^6)
      (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^5) ≤
        (oneSmallCutoffRow_56.{R} : ℝ)*‖phi (y : K)‖^6 := by
    rw [hdist,hX,hY]
    exact_mod_cast (show ({alpha} : ℚ)*max ({delta}^6) ({X}*{delta}^5) ≤
      oneSmallCutoffRow_56.{R}*{Y}^6 by decide +kernel)
  exact full_ring_finiteN3_{'exact' if fam=='N3Bs' else 'fixed'}_interval_of_bounds hK phi hS x y c d
    hxS hyS hcS hdS hxy hxc hyc hxd hyd hcd hXY hC1000 hCY hCD
    (oneSmallCutoffRow_56.{M} : ℝ) (oneSmallCutoffRow_56.{R} : ℝ)
    hM hRpos hheight hR hleft hright

'''
out+='end D1Bound5\n'
Path('rational_pair_next/RationalCutoffIntervals.lean').write_text(out)
