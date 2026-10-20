import D1Bound5.FrontierCubicErrors
import D1Bound5.FiniteN3RefinedResidual
import D1Bound5.FiniteN2HeightRefinement
import D1Bound5.FiniteN3HeightRefinement
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 32768
run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.frontier_cubic_product_bounds,
    `D1Bound5.frontier_three_cubic_cofactor,
    `D1Bound5.frontier_quartic_polynomial,
    `D1Bound5.finiteN3_residual_norm_lt_max,
    `D1Bound5.finiteN3_residual_norm_lt_refined,
    `D1Bound5.finiteN2RowForm_norm_lt_refined,
    `D1Bound5.full_ring_finiteN2_inequalities_of_height,
    `D1Bound5.finiteN3RowForm_norm_lt_refined,
    `D1Bound5.full_ring_finiteN3_integer_refined,
    `D1Bound5.full_ring_finiteN3_inequality_of_height]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"
#check @_root_.D1Bound5.frontier_cubic_product_bounds
#check @_root_.D1Bound5.frontier_three_cubic_cofactor
#check @_root_.D1Bound5.frontier_quartic_polynomial
#check @_root_.D1Bound5.finiteN3_residual_norm_lt_max
#check @_root_.D1Bound5.finiteN3_residual_norm_lt_refined
#check @_root_.D1Bound5.finiteN2RowForm_norm_lt_refined
#check @_root_.D1Bound5.full_ring_finiteN2_inequalities_of_height
#check @_root_.D1Bound5.finiteN3RowForm_norm_lt_refined
#check @_root_.D1Bound5.full_ring_finiteN3_integer_refined
#check @_root_.D1Bound5.full_ring_finiteN3_inequality_of_height

section
namespace D1Bound5
set_option autoImplicit false
example (x y z : ℂ) (k l : ℝ)
    (hk : (1/2 : ℝ) ≤ k) (hl : (1/2 : ℝ) ≤ l)
    (hx : ‖x-(1/2 : ℂ)‖ ≤ k-1/2)
    (hy : ‖y-(1/2 : ℂ)‖ ≤ k-1/2)
    (hz : ‖z-(1/2 : ℂ)‖ ≤ l-1/2) :
    ‖x*y*z‖ ≤ k^2*l ∧ ‖x*y*z-(1/8 : ℂ)‖ ≤ k^2*l-1/8 := by
  exact _root_.D1Bound5.frontier_cubic_product_bounds (x := x) (y := y) (z := z) (k := k) (l := l) (hk := hk) (hl := hl) (hx := hx) (hy := hy) (hz := hz)
end
end

section
namespace D1Bound5
set_option autoImplicit false
example (p q r : ℂ) (K : ℝ)
    (hp : ‖p-(1/8 : ℂ)‖ ≤ K-1/8)
    (hq : ‖q-(1/8 : ℂ)‖ ≤ K-1/8)
    (hr : ‖r-(1/8 : ℂ)‖ ≤ K-1/8) :
    ‖p-q-r‖ ≤ 3*K-1/4 := by
  exact _root_.D1Bound5.frontier_three_cubic_cofactor (p := p) (q := q) (r := r) (K := K) (hp := hp) (hq := hq) (hr := hr)
end
end

section
namespace D1Bound5
set_option autoImplicit false
example (P Q R : ℂ) (L : ℝ) (hL : 0 ≤ L)
    (hP : ‖P‖ ≤ L) (hQ : ‖Q‖ ≤ L) (hR : ‖R‖ ≤ L) :
    ‖P^2+Q^2+R^2-2*(P*Q+P*R+Q*R)‖ ≤ 9*L^2 := by
  exact _root_.D1Bound5.frontier_quartic_polynomial (P := P) (Q := Q) (R := R) (L := L) (hL := hL) (hP := hP) (hQ := hQ) (hR := hR)
end
end

section
namespace D1Bound5
set_option autoImplicit false
example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖) (i : Fin 3) :
    ‖finiteN3Residual x y c i‖ <
      (3535/409600 : ℝ)*max (‖x-y‖^6) (‖x‖*‖x-y‖^5)/
        (‖x‖^4*‖y‖^3*‖c‖^6) := by
  exact _root_.D1Bound5.finiteN3_residual_norm_lt_max (x := x) (y := y) (c := c) (hx := hx) (hy := hy) (hc := hc) (hxy := hxy) (hXY := hXY) (hXC := hXC) (i := i)
end
end

section
namespace D1Bound5
set_option autoImplicit false
example (x y c : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖)
    (R : ℝ)
    (hdistance : (3535/409600 : ℝ)*max (‖x-y‖^6) (‖x‖*‖x-y‖^5) ≤
      R*‖y‖^6) (i : Fin 3) :
    ‖finiteN3Residual x y c i‖ < R*‖y‖^3/(‖x‖^4*‖c‖^6) := by
  exact _root_.D1Bound5.finiteN3_residual_norm_lt_refined (x := x) (y := y) (c := c) (hx := hx) (hy := hy) (hc := hc) (hxy := hxy) (hXY := hXY) (hXC := hXC) (R := R) (hdistance := hdistance) (i := i)
end
end

section
open scoped NumberField
open Module
namespace D1Bound5
set_option autoImplicit false
example
    (x y c z sX sY : ℂ) (hx : x ≠ 0) (hy : y ≠ 0) (hz : z ≠ 0)
    (i : Fin 3) (M : ℝ)
    (hheightScaled : (101/100 : ℝ)*(‖finiteN2Left x y c i‖+‖finiteN2Right x y c i‖) <
      M*‖y‖^4*‖c‖^2)
    (herr : ∀ j : Fin 2,
      ‖(1+1/(![x,y] j*c))^(1/2 : ℂ)-![sX,sY] j/(![x,y] j*z)‖ ≤
        (101/100 : ℝ)*‖c‖/(‖![x,y] j‖*‖z‖^2))
    (R : ℝ) (hres : ‖finiteN2Residual x y c i‖ < R) :
    ‖finiteN2RowForm x y c z sX sY i‖ <
      M*‖y‖^4*‖c‖^3/‖z‖+R*‖z‖ := by
  exact _root_.D1Bound5.finiteN2RowForm_norm_lt_refined (x := x) (y := y) (c := c) (z := z) (sX := sX) (sY := sY) (hx := hx) (hy := hy) (hz := hz) (i := i) (M := M) (hheightScaled := hheightScaled) (herr := herr) (R := R) (hres := hres)
end
end

section
open scoped NumberField
open Module
namespace D1Bound5
set_option autoImplicit false
example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hXC : 1000 ≤ ‖phi (x : K)‖*‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖)
    (M : ℝ)
    (hheight : ∀ i : Fin 3,
      (101/100 : ℝ)*(‖finiteN2Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
        ‖finiteN2Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
          M*‖phi (y : K)‖^4*‖phi (c : K)‖^2) :
    ∃ z : 𝓞 K, z^2 = c*d+1 ∧
      (1 < M*‖phi (y : K)‖^4*‖phi (c : K)‖^3/‖phi (z : K)‖ +
        (5/4 : ℝ)*‖phi (y : K)‖^2*‖phi (z : K)‖ /
          (‖phi (x : K)‖^3*‖phi (c : K)‖^4)) ∧
      (1 < M*‖phi (y : K)‖^4*‖phi (c : K)‖^3/‖phi (z : K)‖ +
        (101/2560 : ℝ)*max (‖phi (x : K)-phi (y : K)‖^4)
          (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^3)*‖phi (z : K)‖ /
            (‖phi (x : K)‖^3*‖phi (y : K)‖^2*‖phi (c : K)‖^4)) := by
  exact _root_.D1Bound5.full_ring_finiteN2_inequalities_of_height (hK := hK) (phi := phi) (hS := hS) (x := x) (y := y) (c := c) (d := d) (hxS := hxS) (hyS := hyS) (hcS := hcS) (hdS := hdS) (hxy := hxy) (hxc := hxc) (hyc := hyc) (hxd := hxd) (hyd := hyd) (hcd := hcd) (hXY := hXY) (hXC := hXC) (hCY := hCY) (hCD := hCD) (M := M) (hheight := hheight)
end
end

section
open scoped NumberField
open Module
namespace D1Bound5
set_option autoImplicit false
example (x y c z sX sY : ℂ)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hz : z ≠ 0) (hxy : x ≠ y)
    (hXY : ‖x‖ ≤ ‖y‖) (hXC : 1000 ≤ ‖x‖*‖c‖)
    (herrorX : ‖(1+1/(x*c))^(1/2 : ℂ)-sX/(x*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖x‖*‖z‖^2))
    (herrorY : ‖(1+1/(y*c))^(1/2 : ℂ)-sY/(y*z)‖ <
      (101/100 : ℝ)*‖c‖/(‖y‖*‖z‖^2))
    (M Rbound : ℝ)
    (hheightBound : ∀ i : Fin 3,
      (101/100 : ℝ)*(‖finiteN3Left x y c i‖+‖finiteN3Right x y c i‖) <
        M*‖y‖^7*‖c‖^3)
    (hdistance : (3535/409600 : ℝ)*max (‖x-y‖^6) (‖x‖*‖x-y‖^5) ≤ Rbound*‖y‖^6)
    (i : Fin 3) :
    ‖finiteN3RowForm x y c z sX sY i‖ <
      M*‖y‖^7*‖c‖^4/‖z‖ + Rbound*‖y‖^3*‖z‖/(‖x‖^4*‖c‖^6) := by
  exact _root_.D1Bound5.finiteN3RowForm_norm_lt_refined (x := x) (y := y) (c := c) (z := z) (sX := sX) (sY := sY) (hx := hx) (hy := hy) (hc := hc) (hz := hz) (hxy := hxy) (hXY := hXY) (hXC := hXC) (herrorX := herrorX) (herrorY := herrorY) (M := M) (Rbound := Rbound) (hheightBound := hheightBound) (hdistance := hdistance) (i := i)
end
end

section
open scoped NumberField
open Module
namespace D1Bound5
set_option autoImplicit false
example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (x y c d rX rY vX vY z : 𝓞 K)
    (hx : x ≠ 0) (hy : y ≠ 0) (hc : c ≠ 0) (hd : d ≠ 0) (hxy : x ≠ y)
    (hrX : rX^2=x*c+1) (hrY : rY^2=y*c+1)
    (hvX : vX^2=x*d+1) (hvY : vY^2=y*d+1) (hzsq : z^2=c*d+1)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hXC : 1000 ≤ ‖phi (x : K)‖*‖phi (c : K)‖)
    (hC : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (M Rbound : ℝ)
    (hheightBound : ∀ i : Fin 3,
      (101/100 : ℝ)*(‖finiteN3Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
        ‖finiteN3Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
          M*‖phi (y : K)‖^7*‖phi (c : K)‖^3)
    (hdistance : (3535/409600 : ℝ)*max (‖phi (x : K)-phi (y : K)‖^6)
      (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^5) ≤ Rbound*‖phi (y : K)‖^6) :
    1 < M*‖phi (y : K)‖^7*‖phi (c : K)‖^4/‖phi (z : K)‖ +
      Rbound*‖phi (y : K)‖^3*‖phi (z : K)‖/
        (‖phi (x : K)‖^4*‖phi (c : K)‖^6) := by
  exact _root_.D1Bound5.full_ring_finiteN3_integer_refined (hK := hK) (phi := phi) (x := x) (y := y) (c := c) (d := d) (rX := rX) (rY := rY) (vX := vX) (vY := vY) (z := z) (hx := hx) (hy := hy) (hc := hc) (hd := hd) (hxy := hxy) (hrX := hrX) (hrY := hrY) (hvX := hvX) (hvY := hvY) (hzsq := hzsq) (hXY := hXY) (hXC := hXC) (hC := hC) (M := M) (Rbound := Rbound) (hheightBound := hheightBound) (hdistance := hdistance)
end
end

section
open scoped NumberField
open Module
namespace D1Bound5
set_option autoImplicit false
example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {S : Finset (𝓞 K)} (hS : IsD1 S) (x y c d : 𝓞 K)
    (hxS : x ∈ S) (hyS : y ∈ S) (hcS : c ∈ S) (hdS : d ∈ S)
    (hxy : x ≠ y) (hxc : x ≠ c) (hyc : y ≠ c)
    (hxd : x ≠ d) (hyd : y ≠ d) (hcd : c ≠ d)
    (hXY : ‖phi (x : K)‖ ≤ ‖phi (y : K)‖)
    (hXC : 1000 ≤ ‖phi (x : K)‖*‖phi (c : K)‖)
    (hCY : 200*‖phi (y : K)‖ ≤ ‖phi (c : K)‖)
    (M R : ℝ)
    (hheight : ∀ i : Fin 3,
      (101/100 : ℝ)*(‖finiteN3Left (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖+
        ‖finiteN3Right (phi (x : K)) (phi (y : K)) (phi (c : K)) i‖) <
          M*‖phi (y : K)‖^7*‖phi (c : K)‖^3)
    (hR : (3535/409600 : ℝ)*max (‖phi (x : K)-phi (y : K)‖^6)
      (‖phi (x : K)‖*‖phi (x : K)-phi (y : K)‖^5) ≤ R*‖phi (y : K)‖^6) :
    ∃ z : 𝓞 K, z^2=c*d+1 ∧
      1 < M*‖phi (y : K)‖^7*‖phi (c : K)‖^4/‖phi (z : K)‖+
        R*‖phi (y : K)‖^3*‖phi (z : K)‖/(‖phi (x : K)‖^4*‖phi (c : K)‖^6) := by
  exact _root_.D1Bound5.full_ring_finiteN3_inequality_of_height (hK := hK) (phi := phi) (hS := hS) (x := x) (y := y) (c := c) (d := d) (hxS := hxS) (hyS := hyS) (hcS := hcS) (hdS := hdS) (hxy := hxy) (hxc := hxc) (hyc := hyc) (hxd := hxd) (hyd := hyd) (hcd := hcd) (hXY := hXY) (hXC := hXC) (hCY := hCY) (M := M) (R := R) (hheight := hheight) (hR := hR)
end
end
