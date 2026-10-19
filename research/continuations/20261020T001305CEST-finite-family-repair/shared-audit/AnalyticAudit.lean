import D1Bound5.UnequalPoleResidual
import D1Bound5.FiniteUnequalEntry
import D1Bound5.FinitePolynomialHeight
import D1Bound5.FiniteChooseFive
import Lean.Elab.Command
import Lean.Util.CollectAxioms
open Lean Elab Command
open Module
set_option maxRecDepth 32768
run_cmd do
  let names : List Name := [
    `D1Bound5.unequalPolePolynomial,
    `D1Bound5.unequalPolePolynomial_residual_hasSum,
    `D1Bound5.unequalPolePolynomial_residual_coeff,
    `D1Bound5.unequalPolePolynomial_residual_coeff_zero,
    `D1Bound5.unequalPolePolynomial_residual_tail_hasSum,
    `D1Bound5.unequalPolePolynomial_residual_norm_le,
    `D1Bound5.finiteUnequalOrders,
    `D1Bound5.finiteUnequalOrders_add_one,
    `D1Bound5.finiteUnequalOrders_le,
    `D1Bound5.finiteUnequalOrders_total,
    `D1Bound5.finiteUnequalOtherPoles_zero,
    `D1Bound5.finiteUnequalOtherPoles_one,
    `D1Bound5.finiteUnequalOtherPoles_two,
    `D1Bound5.finiteUnequalClearedEntry,
    `D1Bound5.finiteUnequalClearedEntry_eq_scaled_residue,
    `D1Bound5.finiteUnequal_residual_scale,
    `D1Bound5.finiteUnequalClearedEntry_residual_norm_le,
    `D1Bound5.finitePolynomial_norm_le,
    `D1Bound5.finitePolynomial_two_columns_norm_le,
    `D1Bound5.finitePolynomial_power_majorization,
    `D1Bound5.finitePolynomial_height_scalar,
    `D1Bound5.finiteA_choose_two,
    `D1Bound5.finiteA_choose_three,
    `D1Bound5.finiteA_choose_four,
    `D1Bound5.finiteA_choose_five]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.unequalPolePolynomial
#check @D1Bound5.unequalPolePolynomial_residual_hasSum
#check @D1Bound5.unequalPolePolynomial_residual_coeff
#check @D1Bound5.unequalPolePolynomial_residual_coeff_zero
#check @D1Bound5.unequalPolePolynomial_residual_tail_hasSum
#check @D1Bound5.unequalPolePolynomial_residual_norm_le
#check @D1Bound5.finiteUnequalOrders
#check @D1Bound5.finiteUnequalOrders_add_one
#check @D1Bound5.finiteUnequalOrders_le
#check @D1Bound5.finiteUnequalOrders_total
#check @D1Bound5.finiteUnequalOtherPoles_zero
#check @D1Bound5.finiteUnequalOtherPoles_one
#check @D1Bound5.finiteUnequalOtherPoles_two
#check @D1Bound5.finiteUnequalClearedEntry
#check @D1Bound5.finiteUnequalClearedEntry_eq_scaled_residue
#check @D1Bound5.finiteUnequal_residual_scale
#check @D1Bound5.finiteUnequalClearedEntry_residual_norm_le
#check @D1Bound5.finitePolynomial_norm_le
#check @D1Bound5.finitePolynomial_two_columns_norm_le
#check @D1Bound5.finitePolynomial_power_majorization
#check @D1Bound5.finitePolynomial_height_scalar
#check @D1Bound5.finiteA_choose_two
#check @D1Bound5.finiteA_choose_three
#check @D1Bound5.finiteA_choose_four
#check @D1Bound5.finiteA_choose_five

open Finset Polynomial
namespace D1Bound5
section
variable {I : Type*} [Fintype I] [DecidableEq I]

example
    (a : I → ℂ) (e : I → ℕ) (k : ℕ) (ν x : ℂ)
    (hx : ∀ j, ‖a j*x‖ < 1) :
    HasSum (fun r : ℕ => PowerSeries.coeff r
      (∑ j, (unequalPolePolynomial a e k ν j : PowerSeries ℂ)*
        PowerSeries.rescale (a j) (PowerSeries.binomialSeries ℂ ν))*x^r)
      (∑ j, (unequalPolePolynomial a e k ν j).eval x*(1+a j*x)^ν) := by
  exact unequalPolePolynomial_residual_hasSum a e k ν x hx

example
    {F : Type*} [Field F] [CharZero F]
    (a : I → F) (e : I → ℕ) (k : ℕ) (he : ∀ j, e j ≤ k)
    (ν : F) (r : ℕ) :
    PowerSeries.coeff r
      (∑ j, (unequalPolePolynomial a e k ν j : PowerSeries F)*
        PowerSeries.rescale (a j) (PowerSeries.binomialSeries F ν)) =
      Ring.choose ((k : F)+ν) r *
        ∑ j, bennettLocalResidue a e (Polynomial.X^r) j := by
  exact unequalPolePolynomial_residual_coeff a e k he ν r

example
    {F : Type*} [Field F] [CharZero F]
    (a : I → F) (ha : Function.Injective a) (e : I → ℕ)
    (k : ℕ) (he : ∀ j, e j ≤ k) (ν : F)
    (r : ℕ) (hr : r < (∑ j, (e j+1))-1) :
    PowerSeries.coeff r
      (∑ j, (unequalPolePolynomial a e k ν j : PowerSeries F)*
        PowerSeries.rescale (a j) (PowerSeries.binomialSeries F ν)) = 0 := by
  exact unequalPolePolynomial_residual_coeff_zero a ha e k he ν r hr

example
    (a : I → ℂ) (ha : Function.Injective a) (e : I → ℕ)
    (k : ℕ) (he : ∀ j, e j ≤ k) (ν x : ℂ)
    (hx : ∀ j, ‖a j*x‖ < 1) :
    HasSum (fun t : ℕ =>
      (Ring.choose ((k : ℂ)+ν) ((∑ j,(e j+1))-1+t) *
        ∑ j, bennettLocalResidue a e
          (Polynomial.X^((∑ j,(e j+1))-1+t)) j)*
            x^((∑ j,(e j+1))-1+t))
      (∑ j, (unequalPolePolynomial a e k ν j).eval x*(1+a j*x)^ν) := by
  exact unequalPolePolynomial_residual_tail_hasSum a ha e k he ν x hx

example
    (a : I → ℂ) (ha : Function.Injective a) (e : I → ℕ)
    (q : I) (k : ℕ) (he : ∀ j, e j ≤ k) (ν ρ : ℝ) (x : ℂ)
    (hs : (k : ℝ)+ν < ((∑ j,(e j+1))-1 : ℕ))
    (hρ0 : 0 ≤ ρ) (hρ : ∀ j, ‖a j‖ ≤ ρ) (hradius : ρ*‖x‖ < 1) :
    ‖∑ j, (unequalPolePolynomial a e k (ν : ℂ) j).eval x*
      (1+a j*x)^(ν : ℂ)‖ ≤
      |Ring.choose ((k : ℝ)+ν) ((∑ j,(e j+1))-1)| *
        ‖x‖^((∑ j,(e j+1))-1) /
          (1-ρ*‖x‖)^((((∑ j,(e j+1))-1 : ℕ) : ℝ)-((k : ℝ)+ν)) := by
  exact unequalPolePolynomial_residual_norm_le a ha e q k he ν ρ x hs hρ0 hρ hradius

end

section
variable {F : Type*} [Field F] [CharZero F]

example (k m : ℕ) (hk : 1 ≤ k) (hm : 1 ≤ m)
    (i j : Fin 3) : finiteUnequalOrders k m i j+1 = ![m,k,k] j+(if i=j then 1 else 0) := by
  exact finiteUnequalOrders_add_one k m hk hm i j

example (k m : ℕ) (hmk : m ≤ k) (i j : Fin 3) :
    finiteUnequalOrders k m i j ≤ k := by
  exact finiteUnequalOrders_le k m hmk i j

example (k m : ℕ) (hk : 1 ≤ k) (hm : 1 ≤ m) (i : Fin 3) :
    (∑ j, (finiteUnequalOrders k m i j+1)) = m+2*k+1 := by
  exact finiteUnequalOrders_total k m hk hm i

example (x y : F) (k m : ℕ)
    (hk : 1 ≤ k) (hm : 1 ≤ m) (i : Fin 3) :
    bennettLocalReciprocal (bennettTwoNodes x y) (finiteUnequalOrders k m i) 0 =
      bennettPoleSeries (-y) (k+if i=1 then 1 else 0)*
        bennettPoleSeries (-x) (k+if i=2 then 1 else 0) := by
  exact finiteUnequalOtherPoles_zero x y k m hk hm i

example (x y : F) (k m : ℕ)
    (hk : 1 ≤ k) (hm : 1 ≤ m) (i : Fin 3) :
    bennettLocalReciprocal (bennettTwoNodes x y) (finiteUnequalOrders k m i) 1 =
      bennettPoleSeries y (m+if i=0 then 1 else 0)*
        bennettPoleSeries (y-x) (k+if i=2 then 1 else 0) := by
  exact finiteUnequalOtherPoles_one x y k m hk hm i

example (x y : F) (k m : ℕ)
    (hk : 1 ≤ k) (hm : 1 ≤ m) (i : Fin 3) :
    bennettLocalReciprocal (bennettTwoNodes x y) (finiteUnequalOrders k m i) 2 =
      bennettPoleSeries x (m+if i=0 then 1 else 0)*
        bennettPoleSeries (x-y) (k+if i=1 then 1 else 0) := by
  exact finiteUnequalOtherPoles_two x y k m hk hm i

example (x y c : F)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0)
    (k m : ℕ) (hmk : m ≤ k) (i j : Fin 3) :
    finiteUnequalClearedEntry x y c k m i j =
      (4^k*x^m*y^m*(x-y)^(2*k)*(x*y*c)^k)*
        (unequalPolePolynomial (bennettTwoNodes x y) (finiteUnequalOrders k m i)
          k (1/2 : F) j).eval (x*y*c)⁻¹ := by
  exact finiteUnequalClearedEntry_eq_scaled_residue x y c hx hy hc k m hmk i j

example (X Y C delta : ℝ)
    (hX : X ≠ 0) (hY : Y ≠ 0) (hC : C ≠ 0) (k m : ℕ) :
    (4^k*X^m*Y^m*delta^(2*k)*(X*Y*C)^k)*((X*Y*C)⁻¹)^(m+2*k) =
      4^k*delta^(2*k)/(X^k*Y^k*C^(m+k)) := by
  exact finiteUnequal_residual_scale X Y C delta hX hY hC k m

example
    (x y c : ℂ) (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1 < ‖x‖*‖c‖)
    (k m : ℕ) (hk : 1 ≤ k) (hm : 1 ≤ m) (hmk : m ≤ k)
    (hs : (k : ℝ)+1/2 < (m+2*k : ℕ)) (i : Fin 3) :
    ‖∑ j, finiteUnequalClearedEntry x y c k m i j*
        (1+bennettTwoNodes x y j*(x*y*c)⁻¹)^(1/2 : ℂ)‖ ≤
      (4^k*‖x-y‖^(2*k)/(‖x‖^k*‖y‖^k*‖c‖^(m+k)))*
        |Ring.choose ((k : ℝ)+1/2) (m+2*k)| /
          (1-1/(‖x‖*‖c‖))^(((m+2*k : ℕ) : ℝ)-((k : ℝ)+1/2)) := by
  exact finiteUnequalClearedEntry_residual_norm_le x y c hx hy hc hxy hXY hXC k m hk hm hmk hs i

end

section


example (k : ℕ) (a : Fin (k+1) → ℂ) (c : ℂ) :
    ‖∑ ell, a ell*c^(ell : ℕ)‖ ≤ ∑ ell, ‖a ell‖*‖c‖^(ell : ℕ) := by
  exact finitePolynomial_norm_le k a c

example (k d0 : ℕ)
    (p : Fin 2 → Fin (k+1) → ℂ) (v : Fin (k+1) → ℝ) (c : ℂ) (Y : ℝ)
    (hcoeff : ∀ ell, ‖p 0 ell‖+‖p 1 ell‖ ≤ v ell*Y^(d0+(ell : ℕ))) :
    ‖∑ ell, p 0 ell*c^(ell : ℕ)‖+‖∑ ell, p 1 ell*c^(ell : ℕ)‖ ≤
      Y^d0*∑ ell, v ell*(Y*‖c‖)^(ell : ℕ) := by
  exact finitePolynomial_two_columns_norm_le k d0 p v c Y hcoeff

example (T : ℝ) (hT : 1000 ≤ T)
    (k ell : ℕ) (hell : ell ≤ k) : T^ell ≤ T^k/(1000 : ℝ)^(k-ell) := by
  exact finitePolynomial_power_majorization T hT k ell hell

example (k : ℕ) (v : Fin (k+1) → ℝ)
    (hv : ∀ ell, 0 ≤ v ell) (M T : ℝ) (hT : 1000 ≤ T)
    (hslack : (101/100 : ℝ)*(∑ ell, v ell/(1000 : ℝ)^(k-(ell : ℕ))) < M) :
    (101/100 : ℝ)*(∑ ell, v ell*T^(ell : ℕ)) < M*T^k := by
  exact finitePolynomial_height_scalar k v hv M T hT hslack

end

section
variable {F : Type*} [Field F] [CharZero F]

example (r : F) : Ring.choose r 2 = r*(r-1)/2 := by
  exact finiteA_choose_two r

example (r : F) : Ring.choose r 3 = r*(r-1)*(r-2)/6 := by
  exact finiteA_choose_three r

example (r : F) : Ring.choose r 4 = r*(r-1)*(r-2)*(r-3)/24 := by
  exact finiteA_choose_four r

example (r : F) : Ring.choose r 5 = r*(r-1)*(r-2)*(r-3)*(r-4)/120 := by
  exact finiteA_choose_five r

end

end D1Bound5
