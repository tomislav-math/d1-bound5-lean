from pathlib import Path
base=Path('.')
configs=[('A3','finite_a_next/FiniteA3FixedHeight.lean','finiteA3RootCoeff',4,6,3),('A4','finite_a_next/FiniteA4FixedHeight.lean','finiteA4RootCoeff',5,9,4),('A5','finite_a_next/FiniteA5FixedHeight.lean','finiteA5RootCoeff',6,12,5),('N3','one_small_analytic_next/FiniteN3FixedHeight.lean','finiteN3FixedPolynomial',4,7,3)]
for fam,source,coef,size,bpow,cpow in configs:
 text=Path(source).read_text()
 old=text[text.index('theorem finite'+fam+'_fixed_height'):text.index('\nend D1Bound5')]
 body=old[old.index(' := by\n')+len(' := by\n'):]
 body=body.replace('  let X := phi (x : K)\n  let Y := phi (y : K)\n  let Z := phi (c : K)\n','')
 body=body.replace('  have hC0 : 0 < C := by change 0 < ‖phi (c : K)‖; linarith only [hC]','  have hC0 : 0 < C := by dsimp [C]; linarith only [hC]')
 start=body.index('  have hBsq :')
 end=body.index('  obtain ⟨hw,hsq,hrow⟩ := hbound',start)
 body=body[:start]+body[end:]
 body=body.replace(f'    have hn := {coef}_norm_sq phi e sgn conj x y i j ell\n    rw [hx,hy] at hn', '    have hn := hnorm i j ell')
 header=f'''import D1Bound5.Finite{fam}FixedHeight
import D1Bound5.FiniteRationalCoefficientNorm

open scoped NumberField

namespace D1Bound5
open QuadInt

/-- Exact coefficient norm identities suffice for height transfer; no
identification of the ambient field with a coordinate ring is needed. -/
theorem finite{fam}_fixed_height_of_norm_sq {{tau nu : ℤ}}
    (a b : QuadInt tau nu) (M : ℚ)
    (w : Fin 3 → Fin 2 → Fin {size} → ℚ) (hbound : Finite{fam}FixedBound a b M w)
    (X Y Z : ℂ) (hBsq : ‖Y‖^2 = (b.norm : ℝ))
    (hnorm : ∀ i j ell, ‖{coef} X Y i j ell‖^2 =
      (({coef} a b i j ell).norm : ℝ))
    (hy0 : Y ≠ 0) (hC : 1000 ≤ ‖Z‖) (hCB : 200*‖Y‖ ≤ ‖Z‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finite{fam}Left X Y Z i‖+‖finite{fam}Right X Y Z i‖) <
      (M : ℝ)*‖Y‖^{bpow}*‖Z‖^{cpow} := by
'''
 norm=f'''
/-- Signed integer anchors have the certified coefficient norms in every
number field. Conjugation fixes the integer anchors automatically. -/
theorem {coef}_rational_norm_sq
    {{K : Type*}} [Field K] [NumberField K] (phi : K →+* ℂ)
    (tau nu : ℤ) (X Y : ℤ) (sgn : Bool) (x y : 𝓞 K)
    (hx : x = if sgn then -(X : 𝓞 K) else (X : 𝓞 K))
    (hy : y = if sgn then -(Y : 𝓞 K) else (Y : 𝓞 K))
    (i : Fin 3) (j : Fin 2) (ell : Fin {size}) :
    ‖{coef} (phi (x : K)) (phi (y : K)) i j ell‖^2 =
      (({coef} (X : QuadInt tau nu) (Y : QuadInt tau nu) i j ell).norm : ℝ) := by
  fin_cases ell
  all_goals
    simp only [{coef}, Matrix.cons_val_zero, Matrix.cons_val_succ]
    exact full_ring_finiteFixedHomogeneous_rational_norm_sq phi tau nu _ _ X Y sgn x y hx hy

end D1Bound5
'''
 Path('rational_pair_next/Finite'+fam+'RationalHeight.lean').write_text(header+body+norm)
# N2 is table-bound, but the transfer step can still expose pure norm data.
text=Path('one_small_analytic_next/OneSmallN2FixedHeight.lean').read_text()
old=text[text.index('theorem finiteN2_fixed_height'):text.index('\nend D1Bound5')]
body=old[old.index(' := by\n')+len(' := by\n'):]
body=body.replace('  let X := phi (x : K)\n  let Y := phi (y : K)\n  let Z := phi (c : K)\n','')
body=body.replace('  have hC0 : 0 < C := by change 0 < ‖phi (c : K)‖; linarith only [hC]','  have hC0 : 0 < C := by dsimp [C]; linarith only [hC]')
start=body.index('  have hBsq :');end=body.index('  obtain ⟨w,hw,hsq,hrow⟩',start)
body=body[:start]+body[end:]
body=body.replace('    have hn := finiteN2FixedPolynomial_norm_sq phi e sgn conj x y i j ell\n    rw [hx,hy] at hn','    have hn := hnorm i j ell')
head='''import D1Bound5.OneSmallN2FixedHeight
import D1Bound5.FiniteRationalCoefficientNorm

open scoped NumberField

namespace D1Bound5
open QuadInt

/-- N2 height transfer from actual squared coefficient norms. -/
theorem finiteN2_fixed_height_of_norm_sq
    (r : OneSmallCutoffRow) (hr : r ∈ oneSmallCutoffRows)
    (X Y Z : ℂ) (hBsq : ‖Y‖^2 = (r.b0 : ℝ))
    (hnorm : ∀ i j ell, ‖finiteN2FixedPolynomial X Y i j ell‖^2 =
      ((finiteN2FixedPolynomial r.triple.anchorA r.triple.anchorB i j ell).norm : ℝ))
    (hy0 : Y ≠ 0) (hC : 1000 ≤ ‖Z‖) (hCB : 200*‖Y‖ ≤ ‖Z‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finiteN2Left X Y Z i‖+‖finiteN2Right X Y Z i‖) <
      (r.M2 : ℝ)*‖Y‖^4*‖Z‖^2 := by
'''
norm='''
theorem finiteN2FixedPolynomial_rational_norm_sq
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (tau nu : ℤ) (X Y : ℤ) (sgn : Bool) (x y : 𝓞 K)
    (hx : x = if sgn then -(X : 𝓞 K) else (X : 𝓞 K))
    (hy : y = if sgn then -(Y : 𝓞 K) else (Y : 𝓞 K))
    (i : Fin 3) (j : Fin 2) (ell : Fin 3) :
    ‖finiteN2FixedPolynomial (phi (x : K)) (phi (y : K)) i j ell‖^2 =
      ((finiteN2FixedPolynomial (X : QuadInt tau nu) (Y : QuadInt tau nu) i j ell).norm : ℝ) := by
  fin_cases ell
  all_goals
    simp only [finiteN2FixedPolynomial, Matrix.cons_val_zero, Matrix.cons_val_succ]
    exact full_ring_finiteFixedHomogeneous_rational_norm_sq phi tau nu _ _ X Y sgn x y hx hy

end D1Bound5
'''
Path('rational_pair_next/FiniteN2RationalHeight.lean').write_text(head+body+norm)
