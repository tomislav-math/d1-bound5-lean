import D1Bound5.FiniteA4Matrix
import D1Bound5.FiniteHomogeneousTwo

namespace D1Bound5

def finiteA4Coeff0 : Fin 3 → Fin 2 → Fin 6 → ℤ :=
  ![![![0,0,1848,792,-88,8],![-8,88,-792,-1848,0,0]],![![0,1155,2772,594,-44,3],![8,-264,-2376,-1848,0,0]],![![0,0,-1848,-2376,-264,8],![3,-44,594,2772,1155,0]]]

def finiteA4Coeff1 : Fin 3 → Fin 2 → Fin 7 → ℤ :=
  ![![![0,0,0,14520,-5544,1448,-184],![184,-1448,5544,-14520,0,0,0]],![![0,0,12936,6336,-1584,256,-24],![-40,600,-3960,-14520,0,0,0]],![![0,0,0,-14520,-3960,600,-40],![-24,256,-1584,6336,12936,0,0]]]

def finiteA4Coeff2 : Fin 3 → Fin 2 → Fin 8 → ℤ :=
  ![![![0,0,0,0,38016,-33984,13440,-2112],![2112,-13440,33984,-38016,0,0,0,0]],![![0,0,0,44352,-25344,10080,-2496,288],![336,-3168,13968,-38016,0,0,0,0]],![![0,0,0,0,-38016,13968,-3168,336],![288,-2496,10080,-25344,44352,0,0,0]]]

def finiteA4Coeff3 : Fin 3 → Fin 2 → Fin 9 → ℤ :=
  ![![![0,0,0,0,0,40704,-50688,24704,-4480],![4480,-24704,50688,-40704,0,0,0,0,0]],![![0,0,0,0,59136,-73728,44928,-14336,1920],![1664,-11712,32832,-40704,0,0,0,0,0]],![![0,0,0,0,0,-40704,32832,-11712,1664],![1920,-14336,44928,-73728,59136,0,0,0,0]]]

def finiteA4Coeff4 : Fin 3 → Fin 2 → Fin 10 → ℤ :=
  ![![![0,0,0,0,0,0,15360,-23040,12800,-2560],![2560,-12800,23040,-15360,0,0,0,0,0,0]],![![0,0,0,0,0,26880,-46080,34560,-12800,1920],![1280,-7680,17280,-15360,0,0,0,0,0,0]],![![0,0,0,0,0,0,-15360,17280,-7680,1280],![1920,-12800,34560,-46080,26880,0,0,0,0,0]]]

def finiteA4RootCoeff {R : Type*} [CommRing R] (x y : R) (i : Fin 3) (j : Fin 2) : Fin 5 → R :=
  ![finiteHomogeneousTwo 5 (finiteA4Coeff0 i j) x y,finiteHomogeneousTwo 6 (finiteA4Coeff1 i j) x y,finiteHomogeneousTwo 7 (finiteA4Coeff2 i j) x y,finiteHomogeneousTwo 8 (finiteA4Coeff3 i j) x y,finiteHomogeneousTwo 9 (finiteA4Coeff4 i j) x y]

theorem finiteA4_root_coeff_decomposition {R : Type*} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![finiteA4Left x y c i,finiteA4Right x y c i] j =
      ∑ ell : Fin 5, finiteA4RootCoeff x y i j ell*c^(ell : ℕ) := by
  fin_cases i <;> fin_cases j
  all_goals
    norm_num [finiteA4Left,finiteA4Right,finiteA4RootCoeff,
      finiteA4Coeff0,finiteA4Coeff1,finiteA4Coeff2,finiteA4Coeff3,finiteA4Coeff4,finiteHomogeneousTwo,Fin.sum_univ_succ]
    <;> ring

def finiteA4CoefficientSums : Fin 3 → Fin 5 → ℤ :=
  ![![5472,43392,175104,241152,107520],![9064,40256,138048,280960,163840],![9064,40256,138048,280960,163840]]

theorem finiteA4_coefficient_sums_0 (i : Fin 3) :
    (∑ r, |(finiteA4Coeff0 i 0 r : ℝ)|)+
      (∑ r, |(finiteA4Coeff0 i 1 r : ℝ)|) = finiteA4CoefficientSums i 0 := by
  fin_cases i <;> norm_num [finiteA4Coeff0,finiteA4CoefficientSums,Fin.sum_univ_succ]

theorem finiteA4_coefficient_sums_1 (i : Fin 3) :
    (∑ r, |(finiteA4Coeff1 i 0 r : ℝ)|)+
      (∑ r, |(finiteA4Coeff1 i 1 r : ℝ)|) = finiteA4CoefficientSums i 1 := by
  fin_cases i <;> norm_num [finiteA4Coeff1,finiteA4CoefficientSums,Fin.sum_univ_succ]

theorem finiteA4_coefficient_sums_2 (i : Fin 3) :
    (∑ r, |(finiteA4Coeff2 i 0 r : ℝ)|)+
      (∑ r, |(finiteA4Coeff2 i 1 r : ℝ)|) = finiteA4CoefficientSums i 2 := by
  fin_cases i <;> norm_num [finiteA4Coeff2,finiteA4CoefficientSums,Fin.sum_univ_succ]

theorem finiteA4_coefficient_sums_3 (i : Fin 3) :
    (∑ r, |(finiteA4Coeff3 i 0 r : ℝ)|)+
      (∑ r, |(finiteA4Coeff3 i 1 r : ℝ)|) = finiteA4CoefficientSums i 3 := by
  fin_cases i <;> norm_num [finiteA4Coeff3,finiteA4CoefficientSums,Fin.sum_univ_succ]

theorem finiteA4_coefficient_sums_4 (i : Fin 3) :
    (∑ r, |(finiteA4Coeff4 i 0 r : ℝ)|)+
      (∑ r, |(finiteA4Coeff4 i 1 r : ℝ)|) = finiteA4CoefficientSums i 4 := by
  fin_cases i <;> norm_num [finiteA4Coeff4,finiteA4CoefficientSums,Fin.sum_univ_succ]

end D1Bound5
