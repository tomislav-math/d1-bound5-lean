import D1Bound5.TailAnalytic
import D1Bound5.IrregularGrowth

open scoped NumberField
open Module

namespace D1Bound5

/-- The analytic regular-tail contradiction. The only arithmetic input
is that each nonzero ring element has complex modulus at least one. -/
theorem no_regular_large_tail_core {R : Type*} [CommRing R] [Nontrivial R]
    (f : R →+* ℂ) (hn : ∀ s : R, s ≠ 0 → 1 ≤ ‖f s‖)
    (a b c d r u0 v0 w0 : R)
    (hr : r^2 = b*c+1) (hu0 : u0^2 = a*b+1)
    (hv0 : v0^2 = a*c+1) (hw0 : w0^2 = a*d+1)
    (hd : d = b+c+2*r)
    (hA : 1 ≤ ‖f a‖) (hB : 3 ≤ ‖f b‖) (hC : 4 ≤ ‖f c‖)
    (hAB : ‖f a‖ ≤ ‖f b‖) (hCD : ‖f c‖ ≤ ‖f d‖) : False := by
  have hrC : (f r)^2 = f b*f c+1 := by
    simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hr
  obtain ⟨beta,gamma,hbeta,hgamma,hrclose⟩ :=
    exists_aligned_square_roots (f b) (f c) (f r) hrC hB hC
  obtain ⟨alpha,halpha⟩ := IsAlgClosed.exists_pow_nat_eq (f a) (by decide : 0 < 2)
  let x := ‖alpha‖
  let y := ‖beta‖
  let z := ‖gamma‖
  let er := ‖f r-beta*gamma‖
  let p := beta+gamma
  let P := ‖p‖
  have haN : x^2 = ‖f a‖ := by dsimp only [x]; rw [← norm_pow,halpha]
  have hbN : y^2 = ‖f b‖ := by dsimp only [y]; rw [← norm_pow,hbeta]
  have hcN : z^2 = ‖f c‖ := by dsimp only [z]; rw [← norm_pow,hgamma]
  have hx : 1 ≤ x := by nlinarith [norm_nonneg alpha]
  have hy : (12/7 : ℝ) ≤ y := by nlinarith [norm_nonneg beta]
  have hz : 2 ≤ z := by nlinarith [norm_nonneg gamma]
  have hxy : x ≤ y := by nlinarith [norm_nonneg alpha,norm_nonneg beta]
  have hx0 : 0 < x := by linarith
  have hy0 : 0 < y := by linarith
  have hz0 : 0 < z := by linarith
  have her : 0 ≤ er := norm_nonneg _
  have hP : 0 ≤ P := norm_nonneg _
  have ha0 : alpha ≠ 0 := norm_pos_iff.mp hx0
  have hb0 : beta ≠ 0 := norm_pos_iff.mp hy0
  have hc0 : gamma ≠ 0 := norm_pos_iff.mp hz0
  change (39/20 : ℝ)*y*z*er < 1 at hrclose
  have hdimage : f d = p^2+2*(f r-beta*gamma) := by
    simp only [hd,map_add,map_mul,map_ofNat]
    rw [← hbeta,← hgamma]
    dsimp only [p]
    ring
  have hdnorm : ‖f d‖ ≤ P^2+2*er := by
    rw [hdimage]
    have h := norm_add_le (p^2) (2*(f r-beta*gamma))
    simpa only [norm_pow,norm_mul,Complex.norm_two] using h
  have horder : z^2 ≤ P^2+2*er := by linarith
  have hPbounds := tail_sum_root_bounds x y z P er hx hy hz hP her hrclose horder
  have hP0 : 0 < P := by nlinarith [hPbounds.1]
  have hp0 : p ≠ 0 := norm_pos_iff.mp hP0
  have hx2 : 1 ≤ x^2 := by linarith
  have hy2 : 3 ≤ y^2 := by linarith
  have hz2 : 4 ≤ z^2 := by linarith
  have hABprod : 3 ≤ x^2*y^2 := by
    nlinarith only [hx2,hy2,mul_nonneg (sub_nonneg.mpr hx2) (sub_nonneg.mpr hy2)]
  have hACprod : 4 ≤ x^2*z^2 := by
    nlinarith only [hx2,hz2,mul_nonneg (sub_nonneg.mpr hx2) (sub_nonneg.mpr hz2)]
  have hUerror : (f u0)^2-(alpha*beta)^2 = 1 := by
    rw [← map_pow,hu0,map_add,map_mul,map_one,mul_pow,halpha,hbeta]
    ring
  have hUgap : 1 < (1-(4/5 : ℝ)^2)*‖alpha*beta‖^2 := by
    rw [norm_mul,mul_pow]
    change 1 < (1-(4/5 : ℝ)^2)*(x^2*y^2)
    nlinarith only [hABprod]
  obtain ⟨u,hu2,huclose⟩ := exists_ring_sign_root_perturbation f u0 (alpha*beta)
    (4/5) 1 (mul_ne_zero ha0 hb0) (by norm_num) (by norm_num)
    (by rw [hUerror,norm_one]) hUgap
  have hVerror : (f v0)^2-(alpha*gamma)^2 = 1 := by
    rw [← map_pow,hv0,map_add,map_mul,map_one,mul_pow,halpha,hgamma]
    ring
  have hVgap : 1 < (1-(6/7 : ℝ)^2)*‖alpha*gamma‖^2 := by
    rw [norm_mul,mul_pow]
    change 1 < (1-(6/7 : ℝ)^2)*(x^2*z^2)
    nlinarith only [hACprod]
  obtain ⟨v,hv2,hvclose⟩ := exists_ring_sign_root_perturbation f v0 (alpha*gamma)
    (6/7) 1 (mul_ne_zero ha0 hc0) (by norm_num) (by norm_num)
    (by rw [hVerror,norm_one]) hVgap
  let E := 1+2*x^2*er
  have hE : 0 < E := by dsimp only [E]; positivity
  have hWerror : (f w0)^2-(alpha*p)^2 = 1+2*(f a)*(f r-beta*gamma) := by
    rw [← map_pow,hw0,map_add,map_mul,map_one,mul_pow,halpha,hdimage]
    ring
  have hWerr : ‖(f w0)^2-(alpha*p)^2‖ ≤ E := by
    rw [hWerror]
    have h := norm_add_le (1 : ℂ) (2*(f a)*(f r-beta*gamma))
    simp only [norm_one,norm_mul,Complex.norm_two] at h
    simpa only [E,haN] using h
  have hWgap : E < (1-(4/5 : ℝ)^2)*‖alpha*p‖^2 := by
    norm_num only [norm_mul]
    exact hPbounds.2
  obtain ⟨w,hw2,hwclose⟩ := exists_ring_sign_root_perturbation f w0 (alpha*p)
    (4/5) E (mul_ne_zero ha0 hp0) (by norm_num) hE hWerr hWgap
  let eu := ‖f u-alpha*beta‖
  let ev := ‖f v-alpha*gamma‖
  let ew := ‖f w-alpha*p‖
  norm_num only [norm_mul] at huclose hvclose hwclose
  have huB : (9/5 : ℝ)*x*y*eu < 1 := by
    dsimp only [x,y,eu]
    nlinarith only [huclose]
  have hvB : (13/7 : ℝ)*x*z*ev < 1 := by
    dsimp only [x,z,ev]
    nlinarith only [hvclose]
  have hwB : (216/125 : ℝ)*x*z*ew < 1+2*x^2*er := by
    have h := mul_le_mul_of_nonneg_right hPbounds.1.le
      (show 0 ≤ (9/5 : ℝ)*x*ew by dsimp only [ew]; positivity)
    dsimp only [E] at hwclose
    dsimp only [x,P,ew,E] at h ⊢
    nlinarith only [h,hwclose]
  have herrsum : eu+ev+ew < 1 := tail_error_sum_lt_one x y z er eu ev ew hx hy hz hxy
    her (norm_nonneg _) (norm_nonneg _) (norm_nonneg _) hrclose huB hvB hwB
  have htriangle : ‖f (u+v-w)‖ ≤ eu+ev+ew := by
    have hid : f (u+v-w) = (f u-alpha*beta)+(f v-alpha*gamma)-(f w-alpha*p) := by
      simp only [map_add,map_sub]
      dsimp only [p]
      ring
    rw [hid]
    have h1 := norm_sub_le ((f u-alpha*beta)+(f v-alpha*gamma)) (f w-alpha*p)
    have h2 := norm_add_le (f u-alpha*beta) (f v-alpha*gamma)
    dsimp only [eu,ev,ew]
    linarith only [h1,h2]
  have hL : u+v-w = 0 := by
    by_contra h
    have hlow := hn (u+v-w) h
    linarith
  have hwuv : w = u+v := by linear_combination -hL
  have hwEq : (u+v)^2 = a*(b+c+2*r)+1 := by
    rw [← hwuv,← hd]
    exact hw2.trans hw0
  have huEq := hu2.trans hu0
  have hvEq := hv2.trans hv0
  have htwo : 2*(a*r-u*v) = 1 := by
    linear_combination huEq+hvEq-hwEq
  have hnonzero : a*r-u*v ≠ 0 := by
    intro hzero
    rw [hzero,mul_zero] at htwo
    exact zero_ne_one htwo
  have hnormTwo : 2*‖f (a*r-u*v)‖ = 1 := by
    have h := congrArg (fun s : R => ‖f s‖) htwo
    simpa only [map_mul,map_ofNat,map_one,norm_mul,Complex.norm_two,norm_one] using h
  have hlow := hn (a*r-u*v) hnonzero
  linarith

/-- The C>=4 branch of lem:tail-irregular in the full ring of integers
of every imaginary quadratic field. No root is assumed to be nonzero. -/
theorem tail_irregular_of_four_le {K : Type*} [Field K] [NumberField K]
    [NumberField.IsTotallyComplex K] (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a b c d : 𝓞 K) (ha : a ≠ 0)
    (hab : ∃ u : 𝓞 K, u^2 = a*b+1) (hac : ∃ v : 𝓞 K, v^2 = a*c+1)
    (had : ∃ w : 𝓞 K, w^2 = a*d+1) (hbc : ∃ r : 𝓞 K, r^2 = b*c+1)
    (hAB : ‖phi (a : K)‖ ≤ ‖phi (b : K)‖) (hB : 3 ≤ ‖phi (b : K)‖)
    (hC : 4 ≤ ‖phi (c : K)‖) (hCD : ‖phi (c : K)‖ ≤ ‖phi (d : K)‖) :
    regularDefect b c d ≠ 0 := by
  intro hreg
  obtain ⟨u,hu⟩ := hab
  obtain ⟨v,hv⟩ := hac
  obtain ⟨w,hw⟩ := had
  obtain ⟨r,hr⟩ := hbc
  have hp : (d-b-c-2*r)*(d-b-c+2*r) = 0 := by
    unfold regularDefect at hreg
    linear_combination hreg-4*hr
  let f := phi.comp (algebraMap (𝓞 K) K)
  have hn (s : 𝓞 K) (hs : s ≠ 0) : 1 ≤ ‖f s‖ := one_le_norm_integer hK phi hs
  rcases mul_eq_zero.mp hp with h | h
  · have hd : d = b+c+2*r := by linear_combination h
    exact no_regular_large_tail_core f hn a b c d r u v w hr hu hv hw hd
      (hn a ha) hB hC hAB hCD
  · have hd : d = b+c+2*(-r) := by linear_combination h
    have hr' : (-r)^2 = b*c+1 := by simpa only [neg_sq] using hr
    exact no_regular_large_tail_core f hn a b c d (-r) u v w hr' hu hv hw hd
      (hn a ha) hB hC hAB hCD


/-- The large-C tail lemma and its growth consequence for an actual
ordered D(1) quadruple. Monotonicity allows equal moduli. -/
theorem IsD1Tuple.tail_irregular_and_growth_of_four_le
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 4 → 𝓞 K) (ht : IsD1Tuple t)
    (hmon : Monotone (fun i => ‖phi (t i : K)‖))
    (hB : 3 ≤ ‖phi (t 1 : K)‖) (hC : 4 ≤ ‖phi (t 2 : K)‖) :
    regularDefect (t 1) (t 2) (t 3) ≠ 0 ∧
      2*‖phi (t 1 : K)‖*‖phi (t 2 : K)‖ < ‖phi (t 3 : K)‖ := by
  have roots (i j : Fin 4) (hij : i ≠ j) :
      ∃ r : 𝓞 K, r^2 = t i*t j+1 := by
    simpa only [pow_two] using ht.2.2 i j hij
  have hirr := tail_irregular_of_four_le hK phi (t 0) (t 1) (t 2) (t 3)
    (ht.2.1 0) (roots 0 1 (by decide)) (roots 0 2 (by decide))
    (roots 0 3 (by decide)) (roots 1 2 (by decide))
    (hmon (by decide : (0 : Fin 4) ≤ 1)) hB hC
    (hmon (by decide : (2 : Fin 4) ≤ 3))
  obtain ⟨r,hr⟩ := roots 1 2 (by decide)
  obtain ⟨s,hs⟩ := roots 1 3 (by decide)
  obtain ⟨v,hv⟩ := roots 2 3 (by decide)
  exact ⟨hirr,irregular_growth hK phi (t 1) (t 2) (t 3) r s v hr hs hv hirr
    hB (hmon (by decide : (1 : Fin 4) ≤ 2))
    (hmon (by decide : (2 : Fin 4) ≤ 3))⟩

end D1Bound5
