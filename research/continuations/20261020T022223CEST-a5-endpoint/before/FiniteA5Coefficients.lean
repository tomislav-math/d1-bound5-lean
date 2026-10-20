import D1Bound5.FiniteA5Matrix
import D1Bound5.FiniteHomogeneousTwo

namespace D1Bound5

def finiteA5Coeff0 : Fin 3 → Fin 2 → Fin 8 → ℤ :=
  ![![![0,0,0,-12870,-5720,780,-120,10],![-10,120,-780,5720,12870,0,0,0]],![![0,0,-9009,-19305,-4290,390,-45,3],![6,-120,2340,17160,12870,0,0,0]],![![0,0,0,12870,17160,2340,-120,6],![3,-45,390,-4290,-19305,-9009,0,0]]]

def finiteA5Coeff1 : Fin 3 → Fin 2 → Fin 9 → ℤ :=
  ![![![0,0,0,0,-127270,51480,-17220,3800,-390],![390,-3800,17220,-51480,127270,0,0,0,0]],![![0,0,0,-115830,-57200,14300,-3000,490,-40],![-58,808,-6780,40040,127270,0,0,0,0]],![![0,0,0,0,127270,40040,-6780,808,-58],![-40,490,-3000,14300,-57200,-115830,0,0,0]]]

def finiteA5Coeff2 : Fin 3 → Fin 2 → Fin 10 → ℤ :=
  ![![![0,0,0,0,0,-457600,453200,-231120,63920,-7600],![7600,-63920,231120,-453200,457600,0,0,0,0,0]],![![0,0,0,0,-514800,286000,-127600,41520,-8480,800],![896,-9824,51648,-177760,457600,0,0,0,0,0]],![![0,0,0,0,0,457600,-177760,51648,-9824,896],![800,-8480,41520,-127600,286000,-514800,0,0,0,0]]]

def finiteA5Coeff3 : Fin 3 → Fin 2 → Fin 11 → ℤ :=
  ![![![0,0,0,0,0,0,-765600,1085920,-693120,223200,-29600],![29600,-223200,693120,-1085920,765600,0,0,0,0,0,0]],![![0,0,0,0,0,-1029600,1320000,-913440,382080,-91200,9600],![8640,-79872,318816,-690624,765600,0,0,0,0,0,0]],![![0,0,0,0,0,0,765600,-690624,318816,-79872,8640],![9600,-91200,382080,-913440,1320000,-1029600,0,0,0,0,0]]]

def finiteA5Coeff4 : Fin 3 → Fin 2 → Fin 12 → ℤ :=
  ![![![0,0,0,0,0,0,0,-605440,1056000,-779520,279680,-40320],![40320,-279680,779520,-1056000,605440,0,0,0,0,0,0,0]],![![0,0,0,0,0,0,-950400,1724800,-1492480,729600,-195200,22400],![16640,-135680,457728,-782848,605440,0,0,0,0,0,0,0]],![![0,0,0,0,0,0,0,605440,-782848,457728,-135680,16640],![22400,-195200,729600,-1492480,1724800,-950400,0,0,0,0,0,0]]]

def finiteA5Coeff5 : Fin 3 → Fin 2 → Fin 13 → ℤ :=
  ![![![0,0,0,0,0,0,0,0,-183040,366080,-299520,116480,-17920],![17920,-116480,299520,-366080,183040,0,0,0,0,0,0,0,0]],![![0,0,0,0,0,0,0,-329472,732160,-732160,399360,-116480,14336],![8960,-66560,199680,-292864,183040,0,0,0,0,0,0,0,0]],![![0,0,0,0,0,0,0,0,183040,-292864,199680,-66560,8960],![14336,-116480,399360,-732160,732160,-329472,0,0,0,0,0,0,0]]]

def finiteA5RootCoeff {R : Type*} [CommRing R] (x y : R) (i : Fin 3) (j : Fin 2) : Fin 6 → R :=
  ![finiteHomogeneousTwo 7 (finiteA5Coeff0 i j) x y,finiteHomogeneousTwo 8 (finiteA5Coeff1 i j) x y,finiteHomogeneousTwo 9 (finiteA5Coeff2 i j) x y,finiteHomogeneousTwo 10 (finiteA5Coeff3 i j) x y,finiteHomogeneousTwo 11 (finiteA5Coeff4 i j) x y,finiteHomogeneousTwo 12 (finiteA5Coeff5 i j) x y]

@[simp] private theorem finiteA5_sixth_coordinate {α : Type*}
    (a0 a1 a2 a3 a4 a5 : α) :
    (![a0,a1,a2,a3,a4,a5] : Fin 6 → α) 5 = a5 := rfl

private theorem finiteA5_root_coeff_00 {R : Type*} [CommRing R]
    (x y c : R) :
    ![finiteA5Left x y c 0,finiteA5Right x y c 0] 0 =
      ∑ ell : Fin 6, finiteA5RootCoeff x y 0 0 ell*c^(ell : ℕ) := by
  norm_num [finiteA5Left,finiteA5Right,finiteA5RootCoeff,
    finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,
    finiteHomogeneousTwo,Fin.sum_univ_succ]
  <;> ring

private theorem finiteA5_root_coeff_01 {R : Type*} [CommRing R]
    (x y c : R) :
    ![finiteA5Left x y c 0,finiteA5Right x y c 0] 1 =
      ∑ ell : Fin 6, finiteA5RootCoeff x y 0 1 ell*c^(ell : ℕ) := by
  norm_num [finiteA5Left,finiteA5Right,finiteA5RootCoeff,
    finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,
    finiteHomogeneousTwo,Fin.sum_univ_succ]
  <;> ring

private theorem finiteA5_root_coeff_10 {R : Type*} [CommRing R]
    (x y c : R) :
    ![finiteA5Left x y c 1,finiteA5Right x y c 1] 0 =
      ∑ ell : Fin 6, finiteA5RootCoeff x y 1 0 ell*c^(ell : ℕ) := by
  norm_num [finiteA5Left,finiteA5Right,finiteA5RootCoeff,
    finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,
    finiteHomogeneousTwo,Fin.sum_univ_succ]
  <;> ring

private theorem finiteA5_root_coeff_11 {R : Type*} [CommRing R]
    (x y c : R) :
    ![finiteA5Left x y c 1,finiteA5Right x y c 1] 1 =
      ∑ ell : Fin 6, finiteA5RootCoeff x y 1 1 ell*c^(ell : ℕ) := by
  norm_num [finiteA5Left,finiteA5Right,finiteA5RootCoeff,
    finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,
    finiteHomogeneousTwo,Fin.sum_univ_succ]
  <;> ring

private theorem finiteA5_root_coeff_20 {R : Type*} [CommRing R]
    (x y c : R) :
    ![finiteA5Left x y c 2,finiteA5Right x y c 2] 0 =
      ∑ ell : Fin 6, finiteA5RootCoeff x y 2 0 ell*c^(ell : ℕ) := by
  norm_num [finiteA5Left,finiteA5Right,finiteA5RootCoeff,
    finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,
    finiteHomogeneousTwo,Fin.sum_univ_succ]
  <;> ring

private theorem finiteA5_root_coeff_21 {R : Type*} [CommRing R]
    (x y c : R) :
    ![finiteA5Left x y c 2,finiteA5Right x y c 2] 1 =
      ∑ ell : Fin 6, finiteA5RootCoeff x y 2 1 ell*c^(ell : ℕ) := by
  norm_num [finiteA5Left,finiteA5Right,finiteA5RootCoeff,
    finiteA5Coeff0,finiteA5Coeff1,finiteA5Coeff2,finiteA5Coeff3,finiteA5Coeff4,finiteA5Coeff5,
    finiteHomogeneousTwo,Fin.sum_univ_succ]
  <;> ring

theorem finiteA5_root_coeff_decomposition {R : Type*} [CommRing R]
    (x y c : R) (i : Fin 3) (j : Fin 2) :
    ![finiteA5Left x y c i,finiteA5Right x y c i] j =
      ∑ ell : Fin 6, finiteA5RootCoeff x y i j ell*c^(ell : ℕ) := by
  have hi : i = 0 ∨ i = 1 ∨ i = 2 := by omega
  have hj : j = 0 ∨ j = 1 := by omega
  rcases hi with rfl | rfl | rfl <;> rcases hj with rfl | rfl
  · exact finiteA5_root_coeff_00 x y c
  · exact finiteA5_root_coeff_01 x y c
  · exact finiteA5_root_coeff_10 x y c
  · exact finiteA5_root_coeff_11 x y c
  · exact finiteA5_root_coeff_20 x y c
  · exact finiteA5_root_coeff_21 x y c


def finiteA5CoefficientSums : Fin 3 → Fin 6 → ℤ :=
  ![![39000,400320,2426880,5594880,5521920,1966080],![65538,365816,1676928,5609472,7113216,3075072],![65538,365816,1676928,5609472,7113216,3075072]]

theorem finiteA5_coefficient_sums_0 (i : Fin 3) :
    (∑ r, |(finiteA5Coeff0 i 0 r : ℝ)|)+
      (∑ r, |(finiteA5Coeff0 i 1 r : ℝ)|) = finiteA5CoefficientSums i 0 := by
  fin_cases i <;> norm_num [finiteA5Coeff0,finiteA5CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]

theorem finiteA5_coefficient_sums_1 (i : Fin 3) :
    (∑ r, |(finiteA5Coeff1 i 0 r : ℝ)|)+
      (∑ r, |(finiteA5Coeff1 i 1 r : ℝ)|) = finiteA5CoefficientSums i 1 := by
  fin_cases i <;> norm_num [finiteA5Coeff1,finiteA5CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]

theorem finiteA5_coefficient_sums_2 (i : Fin 3) :
    (∑ r, |(finiteA5Coeff2 i 0 r : ℝ)|)+
      (∑ r, |(finiteA5Coeff2 i 1 r : ℝ)|) = finiteA5CoefficientSums i 2 := by
  fin_cases i <;> norm_num [finiteA5Coeff2,finiteA5CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]

theorem finiteA5_coefficient_sums_3 (i : Fin 3) :
    (∑ r, |(finiteA5Coeff3 i 0 r : ℝ)|)+
      (∑ r, |(finiteA5Coeff3 i 1 r : ℝ)|) = finiteA5CoefficientSums i 3 := by
  fin_cases i <;> norm_num [finiteA5Coeff3,finiteA5CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]

theorem finiteA5_coefficient_sums_4 (i : Fin 3) :
    (∑ r, |(finiteA5Coeff4 i 0 r : ℝ)|)+
      (∑ r, |(finiteA5Coeff4 i 1 r : ℝ)|) = finiteA5CoefficientSums i 4 := by
  fin_cases i <;> norm_num [finiteA5Coeff4,finiteA5CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]

theorem finiteA5_coefficient_sums_5 (i : Fin 3) :
    (∑ r, |(finiteA5Coeff5 i 0 r : ℝ)|)+
      (∑ r, |(finiteA5Coeff5 i 1 r : ℝ)|) = finiteA5CoefficientSums i 5 := by
  fin_cases i <;> norm_num [finiteA5Coeff5,finiteA5CoefficientSums,Fin.sum_univ_succ, Matrix.cons_val_two, Matrix.cons_val_three, Matrix.cons_val_four, Matrix.cons_val_succ', Matrix.head_cons, Matrix.tail_cons]

end D1Bound5
