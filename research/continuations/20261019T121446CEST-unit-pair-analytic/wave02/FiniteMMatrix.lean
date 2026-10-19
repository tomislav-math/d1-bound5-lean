import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum

namespace D1Bound5

/-- An integer factored monomial in the ordinary three-anchor order-two
residue matrix. Exponents are stored explicitly so the height certificate
can be checked over a finite list of natural numbers. -/
structure FiniteMTerm where
  coeff : ℤ
  ap : ℕ
  bp : ℕ
  sp : ℕ
  abp : ℕ
  asp : ℕ
  bsp : ℕ
  vp : ℕ
  deriving DecidableEq

def finiteMTermEval {R : Type*} [CommRing R] (t : FiniteMTerm)
    (a b s v : R) : R :=
  (t.coeff : R)*a^t.ap*b^t.bp*s^t.sp*(a-b)^t.abp*(a-s)^t.asp*(b-s)^t.bsp*v^t.vp

/-- The exact finite Taylor residue terms after both the manuscript's row
factors and the three root-column anchor factors have been removed. -/
def finiteMTerms : Fin 4 → Fin 4 → List FiniteMTerm :=
  ![![[⟨48, 0, 0, 2, 3, 3, 3, 2⟩,
      ⟨64, 0, 1, 1, 3, 3, 3, 2⟩,
      ⟨48, 0, 2, 0, 3, 3, 3, 2⟩,
      ⟨64, 1, 0, 1, 3, 3, 3, 2⟩,
      ⟨64, 1, 1, 0, 3, 3, 3, 2⟩,
      ⟨48, 2, 0, 0, 3, 3, 3, 2⟩,
      ⟨80, 0, 0, 1, 3, 3, 3, 1⟩,
      ⟨80, 0, 1, 0, 3, 3, 3, 1⟩,
      ⟨80, 1, 0, 0, 3, 3, 3, 1⟩,
      ⟨30, 0, 0, 0, 3, 3, 3, 0⟩],
    [⟨32, 3, 0, 1, 1, 0, 3, 2⟩,
      ⟨32, 3, 1, 0, 0, 1, 3, 2⟩,
      ⟨40, 3, 0, 0, 1, 1, 3, 1⟩,
      ⟨-48, 3, 0, 0, 1, 1, 3, 2⟩],
    [⟨32, 0, 3, 1, 1, 3, 0, 2⟩,
      ⟨40, 0, 3, 0, 1, 3, 1, 1⟩,
      ⟨-32, 1, 3, 0, 0, 3, 1, 2⟩,
      ⟨-48, 0, 3, 0, 1, 3, 1, 2⟩],
    [⟨40, 0, 0, 3, 3, 1, 1, 1⟩,
      ⟨-32, 0, 1, 3, 3, 1, 0, 2⟩,
      ⟨-32, 1, 0, 3, 3, 0, 1, 2⟩,
      ⟨-48, 0, 0, 3, 3, 1, 1, 2⟩]],
  ![[⟨-32, 0, 0, 1, 4, 4, 3, 2⟩,
      ⟨-32, 0, 1, 0, 4, 4, 3, 2⟩,
      ⟨-48, 1, 0, 0, 4, 4, 3, 2⟩,
      ⟨-40, 0, 0, 0, 4, 4, 3, 1⟩],
    [⟨48, 2, 0, 2, 2, 0, 3, 2⟩,
      ⟨64, 2, 1, 1, 1, 1, 3, 2⟩,
      ⟨48, 2, 2, 0, 0, 2, 3, 2⟩,
      ⟨80, 2, 0, 1, 2, 1, 3, 1⟩,
      ⟨80, 2, 1, 0, 1, 2, 3, 1⟩,
      ⟨30, 2, 0, 0, 2, 2, 3, 0⟩,
      ⟨-64, 2, 0, 1, 2, 1, 3, 2⟩,
      ⟨-64, 2, 1, 0, 1, 2, 3, 2⟩,
      ⟨-80, 2, 0, 0, 2, 2, 3, 1⟩,
      ⟨48, 2, 0, 0, 2, 2, 3, 2⟩],
    [⟨32, 0, 3, 1, 1, 4, 0, 2⟩,
      ⟨40, 0, 3, 0, 1, 4, 1, 1⟩,
      ⟨-48, 1, 3, 0, 0, 4, 1, 2⟩,
      ⟨-32, 0, 3, 0, 1, 4, 1, 2⟩],
    [⟨40, 0, 0, 3, 4, 1, 1, 1⟩,
      ⟨-32, 0, 1, 3, 4, 1, 0, 2⟩,
      ⟨-48, 1, 0, 3, 4, 0, 1, 2⟩,
      ⟨-32, 0, 0, 3, 4, 1, 1, 2⟩]],
  ![[⟨-32, 0, 0, 1, 4, 3, 4, 2⟩,
      ⟨-48, 0, 1, 0, 4, 3, 4, 2⟩,
      ⟨-32, 1, 0, 0, 4, 3, 4, 2⟩,
      ⟨-40, 0, 0, 0, 4, 3, 4, 1⟩],
    [⟨-32, 3, 0, 1, 1, 0, 4, 2⟩,
      ⟨-48, 3, 1, 0, 0, 1, 4, 2⟩,
      ⟨-40, 3, 0, 0, 1, 1, 4, 1⟩,
      ⟨32, 3, 0, 0, 1, 1, 4, 2⟩],
    [⟨48, 0, 2, 2, 2, 3, 0, 2⟩,
      ⟨80, 0, 2, 1, 2, 3, 1, 1⟩,
      ⟨30, 0, 2, 0, 2, 3, 2, 0⟩,
      ⟨-64, 1, 2, 1, 1, 3, 1, 2⟩,
      ⟨-80, 1, 2, 0, 1, 3, 2, 1⟩,
      ⟨48, 2, 2, 0, 0, 3, 2, 2⟩,
      ⟨-64, 0, 2, 1, 2, 3, 1, 2⟩,
      ⟨-80, 0, 2, 0, 2, 3, 2, 1⟩,
      ⟨64, 1, 2, 0, 1, 3, 2, 2⟩,
      ⟨48, 0, 2, 0, 2, 3, 2, 2⟩],
    [⟨40, 0, 0, 3, 4, 1, 1, 1⟩,
      ⟨-48, 0, 1, 3, 4, 1, 0, 2⟩,
      ⟨-32, 1, 0, 3, 4, 0, 1, 2⟩,
      ⟨-32, 0, 0, 3, 4, 1, 1, 2⟩]],
  ![[⟨-48, 0, 0, 1, 3, 4, 4, 2⟩,
      ⟨-32, 0, 1, 0, 3, 4, 4, 2⟩,
      ⟨-32, 1, 0, 0, 3, 4, 4, 2⟩,
      ⟨-40, 0, 0, 0, 3, 4, 4, 1⟩],
    [⟨-48, 3, 0, 1, 1, 0, 4, 2⟩,
      ⟨-32, 3, 1, 0, 0, 1, 4, 2⟩,
      ⟨-40, 3, 0, 0, 1, 1, 4, 1⟩,
      ⟨32, 3, 0, 0, 1, 1, 4, 2⟩],
    [⟨-48, 0, 3, 1, 1, 4, 0, 2⟩,
      ⟨-40, 0, 3, 0, 1, 4, 1, 1⟩,
      ⟨32, 1, 3, 0, 0, 4, 1, 2⟩,
      ⟨32, 0, 3, 0, 1, 4, 1, 2⟩],
    [⟨30, 0, 0, 2, 3, 2, 2, 0⟩,
      ⟨-80, 0, 1, 2, 3, 2, 1, 1⟩,
      ⟨48, 0, 2, 2, 3, 2, 0, 2⟩,
      ⟨-80, 1, 0, 2, 3, 1, 2, 1⟩,
      ⟨64, 1, 1, 2, 3, 1, 1, 2⟩,
      ⟨48, 2, 0, 2, 3, 0, 2, 2⟩,
      ⟨-80, 0, 0, 2, 3, 2, 2, 1⟩,
      ⟨64, 0, 1, 2, 3, 2, 1, 2⟩,
      ⟨64, 1, 0, 2, 3, 1, 2, 2⟩,
      ⟨48, 0, 0, 2, 3, 2, 2, 2⟩]]]

def finiteMRowFactor {R : Type*} [CommRing R] (a b s : R) : Fin 4 → R :=
  ![(a-b)*(a-s)*(b-s), a*(b-s), b*(a-s), s*(a-b)]

def finiteMDividedMatrix {R : Type*} [CommRing R] (a b s c : R) :
    Matrix (Fin 4) (Fin 4) R :=
  Matrix.of (fun i j => ((finiteMTerms i j).map
    (fun t => finiteMTermEval t a b s (![c,a*c+1,b*c+1,s*c+1] j))).sum)

def finiteMMatrix {R : Type*} [CommRing R] (a b s c : R) :
    Matrix (Fin 4) (Fin 4) R :=
  finiteMDividedMatrix a b s c * Matrix.diagonal ![1,a,b,s]

/-- Integer coefficient weight using |a-b|≤2B, |a-s|,|b-s|≤2S,
and |u*c+1|≤2SC. -/
def finiteMTermWeight (t : FiniteMTerm) : ℕ :=
  t.coeff.natAbs * 2^(t.abp+t.asp+t.bsp+t.vp)

def finiteMTermAdmissible (t : FiniteMTerm) : Prop :=
  t.sp+t.asp+t.bsp+t.vp ≤ 8 ∧
  t.ap+t.bp+t.sp+t.abp+t.asp+t.bsp+t.vp ≤ 11 ∧ t.vp ≤ 2

instance (t : FiniteMTerm) : Decidable (finiteMTermAdmissible t) := by
  unfold finiteMTermAdmissible
  infer_instance

/-- Every root-column monomial has the required anchor and terminal weights. -/
theorem finiteMTerms_admissible (i : Fin 4) (j : Fin 3) :
    ∀ t ∈ finiteMTerms i j.succ, finiteMTermAdmissible t := by
  fin_cases i <;> fin_cases j <;> decide

/-- The complete finite row certificate; it requires no norm or analytic
assumption. In row zero the exact sum is38400, in the other rows169728. -/
theorem finiteMTerms_weight (i : Fin 4) :
    (∑ j : Fin 3, ((finiteMTerms i j.succ).map finiteMTermWeight).sum) ≤ 169728 := by
  fin_cases i <;> decide

@[simp] theorem map_finiteMTermEval {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (t : FiniteMTerm) (a b s v : R) :
    f (finiteMTermEval t a b s v) = finiteMTermEval t (f a) (f b) (f s) (f v) := by
  simp [finiteMTermEval]

@[simp] theorem map_finiteMDividedMatrix {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (a b s c : R) (i j : Fin 4) :
    f (finiteMDividedMatrix a b s c i j) =
      finiteMDividedMatrix (f a) (f b) (f s) (f c) i j := by
  have hv : f (![c,a*c+1,b*c+1,s*c+1] j) =
      ![f c,f a*f c+1,f b*f c+1,f s*f c+1] j := by
    fin_cases j <;> simp
  simp only [finiteMDividedMatrix, Matrix.of_apply, map_list_sum,
    List.map_map, Function.comp_def, map_finiteMTermEval, hv]


end D1Bound5
