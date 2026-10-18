import D1Bound5.FiniteA3Matrix
import D1Bound5.FiniteHomogeneousTwo

namespace D1Bound5

def finiteA3Coeff0 : Fin 3 → Fin 2 → Fin 4 → ℤ :=
  ![![![0,-70,-28,2],![-2,28,70,0]],![![-35,-105,-21,1],![6,84,70,0]],![![0,70,84,6],![1,-21,-105,-35]]]

def finiteA3Coeff1 : Fin 3 → Fin 2 → Fin 5 → ℤ :=
  ![![![0,0,-406,140,-22],![22,-140,406,0,0]],![![0,-350,-168,42,-4],![-10,84,406,0,0]],![![0,0,406,84,-10],![-4,42,-168,-350,0]]]

def finiteA3Coeff2 : Fin 3 → Fin 2 → Fin 6 → ℤ :=
  ![![![0,0,0,-672,504,-120],![120,-504,672,0,0,0]],![![0,0,-840,504,-168,24],![32,-224,672,0,0,0]],![![0,0,0,672,-224,32],![24,-168,504,-840,0,0]]]

def finiteA3Coeff3 : Fin 3 → Fin 2 → Fin 7 → ℤ :=
  ![![![0,0,0,0,-336,336,-96],![96,-336,336,0,0,0,0]],![![0,0,0,-560,672,-336,64],![48,-224,336,0,0,0,0]],![![0,0,0,0,336,-224,48],![64,-336,672,-560,0,0,0]]]

def finiteA3RootCoeff {R : Type*} [CommRing R] (x y : R) (i : Fin 3) (j : Fin 2) : Fin 4 → R :=
  ![finiteHomogeneousTwo 3 (finiteA3Coeff0 i j) x y,finiteHomogeneousTwo 4 (finiteA3Coeff1 i j) x y,finiteHomogeneousTwo 5 (finiteA3Coeff2 i j) x y,finiteHomogeneousTwo 6 (finiteA3Coeff3 i j) x y]

theorem finiteA3_root_coeff_decomposition {R : Type*} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![finiteA3Left x y c i,finiteA3Right x y c i] j =
      ∑ ell : Fin 4, finiteA3RootCoeff x y i j ell*c^(ell : ℕ) := by
  fin_cases i <;> fin_cases j
  all_goals
    norm_num [finiteA3Left,finiteA3Right,finiteA3RootCoeff,
      finiteA3Coeff0,finiteA3Coeff1,finiteA3Coeff2,finiteA3Coeff3,finiteHomogeneousTwo,Fin.sum_univ_succ]
    <;> ring

def finiteA3CoefficientSums : Fin 3 → Fin 4 → ℤ :=
  ![![200,1136,2592,1536],![322,1064,2464,2240],![322,1064,2464,2240]]

theorem finiteA3_coefficient_sums_0 (i : Fin 3) :
    (∑ r, |(finiteA3Coeff0 i 0 r : ℝ)|)+
      (∑ r, |(finiteA3Coeff0 i 1 r : ℝ)|) = finiteA3CoefficientSums i 0 := by
  fin_cases i <;> norm_num [finiteA3Coeff0,finiteA3CoefficientSums,Fin.sum_univ_succ]

theorem finiteA3_coefficient_sums_1 (i : Fin 3) :
    (∑ r, |(finiteA3Coeff1 i 0 r : ℝ)|)+
      (∑ r, |(finiteA3Coeff1 i 1 r : ℝ)|) = finiteA3CoefficientSums i 1 := by
  fin_cases i <;> norm_num [finiteA3Coeff1,finiteA3CoefficientSums,Fin.sum_univ_succ]

theorem finiteA3_coefficient_sums_2 (i : Fin 3) :
    (∑ r, |(finiteA3Coeff2 i 0 r : ℝ)|)+
      (∑ r, |(finiteA3Coeff2 i 1 r : ℝ)|) = finiteA3CoefficientSums i 2 := by
  fin_cases i <;> norm_num [finiteA3Coeff2,finiteA3CoefficientSums,Fin.sum_univ_succ]

theorem finiteA3_coefficient_sums_3 (i : Fin 3) :
    (∑ r, |(finiteA3Coeff3 i 0 r : ℝ)|)+
      (∑ r, |(finiteA3Coeff3 i 1 r : ℝ)|) = finiteA3CoefficientSums i 3 := by
  fin_cases i <;> norm_num [finiteA3Coeff3,finiteA3CoefficientSums,Fin.sum_univ_succ]

end D1Bound5
