import D1Bound5.Coordinates
import Mathlib.Data.Int.Sqrt
import Mathlib.Data.Int.Interval
import Mathlib.Data.Finset.Prod

namespace D1Bound5.QuadInt

variable {tau nu : ℤ}

/-- A squared integer bound implies the corresponding exact integer
square-root bound; no floating-point approximation is used. -/
theorem abs_le_int_sqrt_of_sq_le {a n : ℤ} (h : a^2 ≤ n) : |a| ≤ Int.sqrt n := by
  have hn : 0 ≤ n := (sq_nonneg a).trans h
  have hc : (a.natAbs : ℤ)^2 ≤ (n.toNat : ℤ) := by
    simpa only [Int.natCast_natAbs, sq_abs, Int.toNat_of_nonneg hn] using h
  have hnat : a.natAbs^2 ≤ n.toNat := by exact_mod_cast hc
  rw [← Int.natCast_natAbs, Int.sqrt]
  exact_mod_cast (Nat.le_sqrt'.mpr hnat)

/-- Enumerate the closed norm disk using doubled-real and imaginary integer
coordinates. The square-root rectangle is a finite superset; the exact
norm and parity filters select the disk. It includes zero and anchors. -/
def disk (tau nu M : ℤ) : Finset (QuadInt tau nu) :=
  let r := Int.sqrt (4*M)
  (((Finset.Icc (-r) r).product (Finset.Icc (-r) r)).filter
    (fun p : ℤ × ℤ => p.1 % 2 = (tau*p.2) % 2 ∧
      p.1^2+discriminant tau nu*p.2^2 ≤ 4*M)).image
    (fun p => (⟨(p.1-tau*p.2)/2,p.2⟩ : QuadInt tau nu))

/-- Exact completeness and soundness of disk enumeration. This is valid
for every integer cutoff, including an empty negative-cutoff disk. -/
theorem mem_disk_iff (hd : 0 < discriminant tau nu) (M : ℤ) (z : QuadInt tau nu) :
    z ∈ disk tau nu M ↔ z.norm ≤ M := by
  constructor
  · intro hz
    unfold disk at hz
    obtain ⟨⟨e,f⟩, hp, rfl⟩ := Finset.mem_image.mp hz
    obtain ⟨_, hpar, hbound⟩ := Finset.mem_filter.mp hp
    dsimp only at hpar hbound
    have he : 2*((e-tau*f)/2)+tau*f = e := by omega
    have hN := four_norm (⟨(e-tau*f)/2,f⟩ : QuadInt tau nu)
    change 4*(⟨(e-tau*f)/2,f⟩ : QuadInt tau nu).norm =
      (2*((e-tau*f)/2)+tau*f)^2+discriminant tau nu*f^2 at hN
    rw [he] at hN
    change (⟨(e-tau*f)/2,f⟩ : QuadInt tau nu).norm ≤ M
    omega
  · intro hz
    let e := 2*z.re+tau*z.im
    have hsum : e^2+discriminant tau nu*z.im^2 ≤ 4*M := by
      have hN := four_norm z
      change 4*z.norm = e^2+discriminant tau nu*z.im^2 at hN
      omega
    have he : e^2 ≤ 4*M := by
      have hpos := mul_nonneg hd.le (sq_nonneg z.im)
      nlinarith only [hsum, hpos]
    have hf : z.im^2 ≤ 4*M := by
      have hmul := mul_le_mul_of_nonneg_right (show 1 ≤ discriminant tau nu by omega)
        (sq_nonneg z.im)
      nlinarith only [hsum, hmul, sq_nonneg e]
    have heb := abs_le.mp (abs_le_int_sqrt_of_sq_le he)
    have hfb := abs_le.mp (abs_le_int_sqrt_of_sq_le hf)
    unfold disk
    apply Finset.mem_image.mpr
    refine ⟨(e,z.im), ?_, ?_⟩
    · apply Finset.mem_filter.mpr
      refine ⟨Finset.mem_product.mpr ⟨Finset.mem_Icc.mpr heb, Finset.mem_Icc.mpr hfb⟩, ?_, hsum⟩
      dsimp only [e]
      omega
    · apply QuadraticAlgebra.ext
      · change (e-tau*z.im)/2 = z.re
        dsimp only [e]
        omega
      · rfl

/-- The finite disk contains exactly seven elements in the Eisenstein
integer norm-one case: zero and the six units. -/
theorem eisenstein_unit_disk_card : (disk 1 1 1).card = 7 := by decide +kernel

/-- Regression for the norm-zero boundary. -/
theorem zero_disk : disk 1 1 0 = {0} := by decide +kernel

end D1Bound5.QuadInt
