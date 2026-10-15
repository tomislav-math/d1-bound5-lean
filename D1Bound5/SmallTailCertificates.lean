import D1Bound5.Coordinates
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic.NormNum

namespace D1Bound5

/-- Exhaustive modular obstruction for both coordinate equations of a square. -/
def NoSquareResidues (m : ℕ) (tau nu u v : ℤ) : Prop :=
  ∀ x y : ZMod m,
    x*x-(nu : ZMod m)*y*y ≠ (u : ZMod m) ∨
    2*x*y+(tau : ZMod m)*y*y ≠ (v : ZMod m)

/-- Soundness: every integral square reduces to a solution of both modular
equations. Thus a checked obstruction excludes every root, with no cutoff. -/
theorem not_square_of_residues (m : ℕ) (tau nu u v : ℤ)
    (h : NoSquareResidues m tau nu u v) :
    ¬ ∃ r : QuadInt tau nu, r*r = ⟨u,v⟩ := by
  rintro ⟨r, hr⟩
  have hre : r.re*r.re-nu*r.im*r.im = u := by
    have he := congrArg (fun z : QuadInt tau nu => z.re) hr
    simpa only [QuadraticAlgebra.re_mul, neg_mul, sub_eq_add_neg] using he
  have him : 2*r.re*r.im+tau*r.im*r.im = v := by
    calc
      _ = r.re*r.im+r.im*r.re+tau*r.im*r.im := by ring
      _ = v := congrArg (fun z : QuadInt tau nu => z.im) hr
  rcases h (r.re : ZMod m) (r.im : ZMod m) with hreal | himag
  · apply hreal
    simpa only [Int.cast_sub, Int.cast_mul] using
      congrArg (fun x : ℤ => (x : ZMod m)) hre
  · apply himag
    simpa only [Int.cast_add, Int.cast_mul, Int.cast_ofNat] using
      congrArg (fun x : ℤ => (x : ZMod m)) him

/-- Terminal row 1 of lem:tail-irregular, q=2, final value 1+4*omega. -/
theorem small_tail_q2_first : ¬ ∃ r : QuadInt 0 2, r*r = ⟨1,4⟩ :=
  not_square_of_residues 3 0 2 1 4 (by unfold NoSquareResidues; decide)

/-- Terminal row 2, q=2, final value -10+4*omega. -/
theorem small_tail_q2_second : ¬ ∃ r : QuadInt 0 2, r*r = ⟨-10,4⟩ :=
  not_square_of_residues 5 0 2 (-10) 4 (by unfold NoSquareResidues; decide)

/-- Terminal row 3, q=3, half-integral basis tau=1, nu=1. -/
theorem small_tail_q3 : ¬ ∃ r : QuadInt 1 1, r*r = ⟨22,0⟩ :=
  not_square_of_residues 4 1 1 22 0 (by unfold NoSquareResidues; decide)

/-- Terminal row 4, q=6. -/
theorem small_tail_q6 : ¬ ∃ r : QuadInt 0 6, r*r = ⟨-27,0⟩ :=
  not_square_of_residues 5 0 6 (-27) 0 (by unfold NoSquareResidues; decide)

/-- Terminal row 5, q=11, half-integral basis tau=1, nu=3. -/
theorem small_tail_q11 : ¬ ∃ r : QuadInt 1 3, r*r = ⟨-14,0⟩ :=
  not_square_of_residues 4 1 3 (-14) 0 (by unfold NoSquareResidues; decide)

/-- Terminal row 6, q=35, half-integral basis tau=1, nu=9. -/
theorem small_tail_q35 : ¬ ∃ r : QuadInt 1 9, r*r = ⟨-38,0⟩ :=
  not_square_of_residues 4 1 9 (-38) 0 (by unfold NoSquareResidues; decide)

end D1Bound5
