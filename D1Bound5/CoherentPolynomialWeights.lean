import D1Bound5.CoherentAnalyticInterpolation
import Mathlib.Data.Fin.VecNotation

open Finset

namespace D1Bound5

def coherentVandermonde2 {R : Type*} [CommRing R] (a : Fin 2 → R) : R :=
  a 0 - a 1

def coherentVandermonde3 {R : Type*} [CommRing R] (a : Fin 3 → R) : R :=
  (a 0 - a 1) * (a 0 - a 2) * (a 1 - a 2)

def coherentVandermonde4 {R : Type*} [CommRing R] (a : Fin 4 → R) : R :=
  (a 0 - a 1) * (a 0 - a 2) * (a 0 - a 3) *
    (a 1 - a 2) * (a 1 - a 3) * (a 2 - a 3)

/-- The integral polynomial weights for two anchors. -/
def coherentWeights2 {R : Type*} [CommRing R] (_a : Fin 2 → R) : Fin 2 → R :=
  ![1, -1]

/-- The integral polynomial weights for three anchors. -/
def coherentWeights3 {R : Type*} [CommRing R] (a : Fin 3 → R) : Fin 3 → R :=
  ![a 0 * (a 1 - a 2), -a 1 * (a 0 - a 2), a 2 * (a 0 - a 1)]

/-- The integral polynomial weights for four anchors. -/
def coherentWeights4 {R : Type*} [CommRing R] (a : Fin 4 → R) : Fin 4 → R :=
  ![(a 0)^2 * (a 1 - a 2) * (a 1 - a 3) * (a 2 - a 3),
    -(a 1)^2 * (a 0 - a 2) * (a 0 - a 3) * (a 2 - a 3),
    (a 2)^2 * (a 0 - a 1) * (a 0 - a 3) * (a 1 - a 3),
    -(a 3)^2 * (a 0 - a 1) * (a 0 - a 2) * (a 1 - a 2)]

theorem coherentWeights2_eq_quotient
    {F : Type*} [Field F] (a : Fin 2 → F) (hinj : Function.Injective a)
    (i : Fin 2) :
    coherentWeights2 a i = coherentVandermonde2 a * (a i) ^ (2 - 2) /
      (∏ j ∈ Finset.univ.erase i, (a i - a j)) := by
  have h01 : a 0 - a 1 ≠ 0 := sub_ne_zero.mpr (hinj.ne (by decide))
  have h10 : a 1 - a 0 ≠ 0 := sub_ne_zero.mpr (hinj.ne (by decide))
  have he0 : (Finset.univ : Finset (Fin 2)).erase 0 = {1} := by decide
  have he1 : (Finset.univ : Finset (Fin 2)).erase 1 = {0} := by decide
  fin_cases i <;>
    simp [coherentWeights2, coherentVandermonde2, he0, he1] <;>
    field_simp [h01, h10] <;> ring

theorem coherentWeights3_eq_quotient
    {F : Type*} [Field F] (a : Fin 3 → F) (hinj : Function.Injective a)
    (i : Fin 3) :
    coherentWeights3 a i = coherentVandermonde3 a * (a i) ^ (3 - 2) /
      (∏ j ∈ Finset.univ.erase i, (a i - a j)) := by
  have hne (i j : Fin 3) (hij : i ≠ j) : a i - a j ≠ 0 :=
    sub_ne_zero.mpr (hinj.ne hij)
  have h01 := hne 0 1 (by decide)
  have h02 := hne 0 2 (by decide)
  have h10 := hne 1 0 (by decide)
  have h12 := hne 1 2 (by decide)
  have h20 := hne 2 0 (by decide)
  have h21 := hne 2 1 (by decide)
  have he0 : (Finset.univ : Finset (Fin 3)).erase 0 = {1, 2} := by decide
  have he1 : (Finset.univ : Finset (Fin 3)).erase 1 = {0, 2} := by decide
  have he2 : (Finset.univ : Finset (Fin 3)).erase 2 = {0, 1} := by decide
  fin_cases i <;>
    simp [coherentWeights3, coherentVandermonde3, he0, he1, he2] <;>
    field_simp [h01, h02, h10, h12, h20, h21] <;> ring

theorem coherentWeights4_eq_quotient
    {F : Type*} [Field F] (a : Fin 4 → F) (hinj : Function.Injective a)
    (i : Fin 4) :
    coherentWeights4 a i = coherentVandermonde4 a * (a i) ^ (4 - 2) /
      (∏ j ∈ Finset.univ.erase i, (a i - a j)) := by
  have hne (i j : Fin 4) (hij : i ≠ j) : a i - a j ≠ 0 :=
    sub_ne_zero.mpr (hinj.ne hij)
  have h01 := hne 0 1 (by decide)
  have h02 := hne 0 2 (by decide)
  have h03 := hne 0 3 (by decide)
  have h10 := hne 1 0 (by decide)
  have h12 := hne 1 2 (by decide)
  have h13 := hne 1 3 (by decide)
  have h20 := hne 2 0 (by decide)
  have h21 := hne 2 1 (by decide)
  have h23 := hne 2 3 (by decide)
  have h30 := hne 3 0 (by decide)
  have h31 := hne 3 1 (by decide)
  have h32 := hne 3 2 (by decide)
  have he0 : (Finset.univ : Finset (Fin 4)).erase 0 = {1, 2, 3} := by decide
  have he1 : (Finset.univ : Finset (Fin 4)).erase 1 = {0, 2, 3} := by decide
  have he2 : (Finset.univ : Finset (Fin 4)).erase 2 = {0, 1, 3} := by decide
  have he3 : (Finset.univ : Finset (Fin 4)).erase 3 = {0, 1, 2} := by decide
  fin_cases i <;>
    simp [coherentWeights4, coherentVandermonde4, he0, he1, he2, he3] <;>
    field_simp [h01, h02, h03, h10, h12, h13, h20, h21, h23, h30, h31, h32] <;> ring

/-- Polynomial weights commute with every ring homomorphism. -/
theorem map_coherentWeights2
    {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (a : Fin 2 → R) (i : Fin 2) :
    f (coherentWeights2 a i) = coherentWeights2 (fun j => f (a j)) i := by
  fin_cases i <;> simp [coherentWeights2]

theorem map_coherentWeights3
    {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (a : Fin 3 → R) (i : Fin 3) :
    f (coherentWeights3 a i) = coherentWeights3 (fun j => f (a j)) i := by
  fin_cases i <;> simp [coherentWeights3]

theorem map_coherentWeights4
    {R S : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (a : Fin 4 → R) (i : Fin 4) :
    f (coherentWeights4 a i) = coherentWeights4 (fun j => f (a j)) i := by
  fin_cases i <;> simp [coherentWeights4]

/-- Exact coefficient identity in the target field, now with the
numerator and weight explicitly lifted from the source ring. -/
theorem map_coherentWeights2_eq_quotient
    {R F : Type*} [CommRing R] [Field F]
    (f : R →+* F) (a : Fin 2 → R)
    (hinj : Function.Injective (fun i => f (a i))) (i : Fin 2) :
    f (coherentWeights2 a i) = f (coherentVandermonde2 a) * (f (a i)) ^ (2 - 2) /
      (∏ j ∈ Finset.univ.erase i, (f (a i) - f (a j))) := by
  rw [map_coherentWeights2]
  simpa only [coherentVandermonde2, map_sub] using
    coherentWeights2_eq_quotient (fun j => f (a j)) hinj i

theorem map_coherentWeights3_eq_quotient
    {R F : Type*} [CommRing R] [Field F]
    (f : R →+* F) (a : Fin 3 → R)
    (hinj : Function.Injective (fun i => f (a i))) (i : Fin 3) :
    f (coherentWeights3 a i) = f (coherentVandermonde3 a) * (f (a i)) ^ (3 - 2) /
      (∏ j ∈ Finset.univ.erase i, (f (a i) - f (a j))) := by
  rw [map_coherentWeights3]
  simpa only [coherentVandermonde3, map_sub, map_mul] using
    coherentWeights3_eq_quotient (fun j => f (a j)) hinj i

theorem map_coherentWeights4_eq_quotient
    {R F : Type*} [CommRing R] [Field F]
    (f : R →+* F) (a : Fin 4 → R)
    (hinj : Function.Injective (fun i => f (a i))) (i : Fin 4) :
    f (coherentWeights4 a i) = f (coherentVandermonde4 a) * (f (a i)) ^ (4 - 2) /
      (∏ j ∈ Finset.univ.erase i, (f (a i) - f (a j))) := by
  rw [map_coherentWeights4]
  simpa only [coherentVandermonde4, map_sub, map_mul] using
    coherentWeights4_eq_quotient (fun j => f (a j)) hinj i

end D1Bound5

