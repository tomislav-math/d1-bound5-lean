from pathlib import Path
imports=['FiniteN2RationalHeight','FiniteN3RationalHeight','FiniteA3RationalHeight','FiniteA4RationalHeight','FiniteA5RationalHeight','OneSmallN3AbFixedArithmetic','OneSmallN3BsFixedArithmetic','OneSmallA3FixedArithmetic','OneSmallA4FixedArithmetic','OneSmallA5FixedArithmetic']
out=''.join('import D1Bound5.'+m+'\n' for m in imports)+'''
open scoped NumberField

namespace D1Bound5
open QuadInt

/-- These are integer equalities in the table's coefficient model only;
no equivalence of that model with the ambient number field is used. -/
theorem rationalCutoff_anchorA :
    oneSmallCutoffRow_56.triple.anchorA = (1 : QuadInt 0 1) := by decide +kernel
theorem rationalCutoff_anchorB :
    oneSmallCutoffRow_56.triple.anchorB = (3 : QuadInt 0 1) := by decide +kernel
theorem rationalCutoff_anchorS :
    oneSmallCutoffRow_56.triple.anchorS = (8 : QuadInt 0 1) := by decide +kernel
theorem rationalCutoff_b0 : oneSmallCutoffRow_56.b0 = 9 := by decide +kernel
theorem rationalCutoff_s0 : oneSmallCutoffRow_56.s0 = 64 := by decide +kernel
theorem rationalCutoff_mem : oneSmallCutoffRow_56 ∈ oneSmallCutoffRows := by decide +kernel

/-- Exact embedding geometry of the simultaneous signed rational pair. -/
theorem rationalCutoff_pair_geometry
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (sgn : Bool) (x y : 𝓞 K)
    (hx : x = if sgn then -1 else 1)
    (hy : y = if sgn then -3 else 3) :
    ‖phi (x : K)‖ = 1 ∧ ‖phi (y : K)‖ = 3 ∧
      ‖phi (x : K)-phi (y : K)‖ = 2 := by
  rw [hx,hy]
  cases sgn <;> norm_num

theorem rationalCutoff_bs_geometry
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (sgn : Bool) (b s : 𝓞 K)
    (hb : b = if sgn then -3 else 3)
    (hs : s = if sgn then -8 else 8) :
    ‖phi (b : K)‖ = 3 ∧ ‖phi (s : K)‖ = 8 ∧
      ‖phi (b : K)-phi (s : K)‖ = 5 := by
  rw [hb,hs]
  cases sgn <;> norm_num

'''
configs=[('N2','N2','M2',4,2,'finiteN2FixedPolynomial',3,'1','3','anchorA','anchorB'),('N3Ab','N3','Mn',7,3,'finiteN3FixedPolynomial',4,'1','3','anchorA','anchorB'),('N3Bs','N3','Mbs',7,3,'finiteN3FixedPolynomial',4,'3','8','anchorB','anchorS'),('A3','A3','M3',6,3,'finiteA3RootCoeff',4,'1','3','anchorA','anchorB'),('A4','A4','M4',9,4,'finiteA4RootCoeff',5,'1','3','anchorA','anchorB'),('A5','A5','M5',12,5,'finiteA5RootCoeff',6,'1','3','anchorA','anchorB')]
for label,fam,M,bpow,cpow,coef,sz,X,Y,anchorX,anchorY in configs:
 out+=f'''/-- Actual {label} height at the signed rational pair, valid in every
number field. The coefficient certificate is checked before transfer. -/
theorem finite{label}_rational_height
    {{K : Type*}} [Field K] [NumberField K] (phi : K →+* ℂ)
    (sgn : Bool) (x y c : 𝓞 K)
    (hx : x = if sgn then -{X} else {X})
    (hy : y = if sgn then -{Y} else {Y})
    (hC : 1000 ≤ ‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖) (i : Fin 3) :
    (101/100 : ℝ)*(‖finite{fam}Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
      ‖finite{fam}Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
      (oneSmallCutoffRow_56.{M} : ℝ)*‖phi (y : K)‖^{bpow}*‖phi (c : K)‖^{cpow} := by
  have hY : ‖phi (y : K)‖ = {Y} := by
    rw [hy]
    cases sgn <;> norm_num
  have hy0 : phi (y : K) ≠ 0 := norm_pos_iff.mp (by rw [hY]; norm_num)
  have hnorm (i : Fin 3) (j : Fin 2) (ell : Fin {sz}) :
      ‖{coef} (phi (x : K)) (phi (y : K)) i j ell‖^2 =
        (({coef} oneSmallCutoffRow_56.triple.{anchorX}
          oneSmallCutoffRow_56.triple.{anchorY} i j ell).norm : ℝ) := by
    rw [rationalCutoff_{anchorX},rationalCutoff_{anchorY}]
    exact {coef}_rational_norm_sq phi 0 1 {X} {Y} sgn x y hx hy i j ell
'''
 if fam=='N2':
  out+='''  have hYsq : ‖phi (y : K)‖^2 = (oneSmallCutoffRow_56.b0 : ℝ) := by
    rw [hY,rationalCutoff_b0]
    norm_num
  exact finiteN2_fixed_height_of_norm_sq oneSmallCutoffRow_56 rationalCutoff_mem
    (phi (x : K)) (phi (y : K)) (phi (c : K)) hYsq hnorm hy0 hC hCY i

'''
 else:
  out+=f'''  have hYsq : ‖phi (y : K)‖^2 =
      (oneSmallCutoffRow_56.triple.{anchorY}.norm : ℝ) := by
    change ‖phi (y : K)‖^2 = (oneSmallCutoffRow_56.{'b0' if Y=='3' else 's0'} : ℝ)
    rw [hY,rationalCutoff_{'b0' if Y=='3' else 's0'}]
    norm_num
  exact finite{fam}_fixed_height_of_norm_sq oneSmallCutoffRow_56.triple.{anchorX}
    oneSmallCutoffRow_56.triple.{anchorY} oneSmallCutoffRow_56.{M}
    finite{label}CutoffWeights_56 finite{label}CutoffWeights_56_valid
    (phi (x : K)) (phi (y : K)) (phi (c : K)) hYsq hnorm hy0 hC hCY i

'''
out+='end D1Bound5\n'
Path('rational_pair_next/RationalCutoffHeights.lean').write_text(out)
