import D1Bound5.RationalCutoffHeights
import D1Bound5.CoherentFixedCutoffNorms

open scoped NumberField

namespace D1Bound5

theorem rationalCutoff_a0 : oneSmallCutoffRow_56.a0 = 1 := by decide +kernel
theorem rationalCutoff_dab : oneSmallCutoffRow_56.dab = 4 := by decide +kernel
theorem rationalCutoff_das : oneSmallCutoffRow_56.das = 49 := by decide +kernel
theorem rationalCutoff_dbs : oneSmallCutoffRow_56.dbs = 25 := by decide +kernel

/-- The complete retained-start norm packet for the universal rational
triple. Only the common sign is needed; integer anchors are fixed by conjugation. -/
theorem rationalCutoff_triple_norms
    {K : Type*} [Field K] [NumberField K] (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (sgn : Bool)
    (h0 : a 0 = if sgn then -1 else 1)
    (h1 : a 1 = if sgn then -3 else 3)
    (h2 : a 2 = if sgn then -8 else 8) :
    ‖phi (a 0 : K)‖^2 = (oneSmallCutoffRow_56.a0 : ℝ) ∧
    ‖phi (a 1 : K)‖^2 = (oneSmallCutoffRow_56.b0 : ℝ) ∧
    ‖phi (a 2 : K)‖^2 = (oneSmallCutoffRow_56.s0 : ℝ) ∧
    ‖phi (a 0 : K)-phi (a 1 : K)‖^2 = (oneSmallCutoffRow_56.dab : ℝ) ∧
    ‖phi (a 0 : K)-phi (a 2 : K)‖^2 = (oneSmallCutoffRow_56.das : ℝ) ∧
    ‖phi (a 1 : K)-phi (a 2 : K)‖^2 = (oneSmallCutoffRow_56.dbs : ℝ) := by
  rw [h0,h1,h2,rationalCutoff_a0,rationalCutoff_b0,rationalCutoff_s0,
    rationalCutoff_dab,rationalCutoff_das,rationalCutoff_dbs]
  cases sgn <;> norm_num

end D1Bound5
