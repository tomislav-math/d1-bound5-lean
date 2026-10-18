import D1Bound5.FirstPairRetainedScalar
import D1Bound5.FirstPairGeometry
import D1Bound5.FirstPairGeometryData
import D1Bound5.FrontierFifteenTuple
import D1Bound5.CoherentRetainedFrontierStart

open scoped NumberField
open Module

namespace D1Bound5

/-- The actual S≥15 retained packet. Only the squared norms of the
normalized first pair are used, so rational pairs are valid over every
imaginary quadratic full integer ring without a coordinate equivalence. -/
theorem IsD1Tuple.first_pair_retained_packet_of_norms
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (a : Fin 6 → 𝓞 K) (ha : IsD1Tuple a)
    (hmon : Monotone (fun i => ‖phi (a i : K)‖))
    (r : FirstPairGeometryRow) (hv : r.Valid)
    (hAsq : ‖phi (a 0 : K)‖^2 = (r.a0 : ℝ))
    (hBsq : ‖phi (a 1 : K)‖^2 = (r.b0 : ℝ))
    (hdsq : ‖phi (a 0 : K)-phi (a 1 : K)‖^2 = (r.dab : ℝ))
    (hS15 : 15 ≤ ‖phi (a 2 : K)‖) :
    let B := ‖phi (a 1 : K)‖
    let S := ‖phi (a 2 : K)‖
    let T := ‖phi (a 3 : K)‖
    let C := ‖phi (a 4 : K)‖
    let D := ‖phi (a 5 : K)‖
    (7/4 : ℝ)*T^5/S^2 < C ∧
    (r.G : ℝ)*B^5*S^3 < C ∧
    (r.rho : ℝ)*((3535/409600 : ℝ)*firstPairPhi (phi (a 1 : K)) (phi (a 2 : K)))*B^5*S^3 < C ∧
    C^7/(S^2*T^4) < D ∧
    1000 < C ∧ 200*S < C ∧ 4*T < C ∧ 2*B*S < T := by
  classical
  let f : 𝓞 K →+* ℂ := phi.comp (algebraMap (𝓞 K) K)
  let A := ‖f (a 0)‖
  let B := ‖f (a 1)‖
  let S := ‖f (a 2)‖
  let T := ‖f (a 3)‖
  let C := ‖f (a 4)‖
  let D := ‖f (a 5)‖
  let v : Fin 3 → ℂ := fun i => f (a (![0,1,2] i))
  let R := ‖coherentVandermonde3 v‖/(B*S^2)
  let Phi := firstPairPhi (f (a 1)) (f (a 2))
  change A^2 = (r.a0 : ℝ) at hAsq
  change B^2 = (r.b0 : ℝ) at hBsq
  change 15 ≤ S at hS15
  obtain ⟨haNorm,hbNorm,hdNorm,hA1pos,hA1sq,hB0pos,hB0sq,hB1pos,hB1sq,
    hd1pos,hd1sq,hq,hQ0,hsep,hKcoef,hG,hH,hF0,hrho,hrest⟩ := hv
  have hA1 : 1 ≤ A := one_le_norm_integer hK phi (ha.2.1 0)
  have hA : 0 < A := by linarith only [hA1]
  have hAB : A ≤ B := hmon (by decide : (0 : Fin 6) ≤ 1)
  have hBS : B ≤ S := hmon (by decide : (1 : Fin 6) ≤ 2)
  have hST : S ≤ T := hmon (by decide : (2 : Fin 6) ≤ 3)
  have hB : 0 < B := hA.trans_le hAB
  have hS : 0 < S := hB.trans_le hBS
  have hT : 0 < T := hS.trans_le hST
  have hA2 : A^2 ≤ 2 := by
    rw [hAsq]
    rcases haNorm with hh | hh <;> exact_mod_cast (show r.a0 ≤ 2 by linarith only [hh])
  have hA3 : A < 3 := by nlinarith only [hA2,hA]
  have hB3 : 3 ≤ B := by
    have hh : (9 : ℝ) ≤ B^2 := by rw [hBsq]; exact_mod_cast hbNorm
    nlinarith only [hh,hB]
  let i4 : Fin 4 → Fin 6 := ![0,1,2,3]
  let i5 : Fin 5 → Fin 6 := ![0,1,2,3,4]
  have hi4 : Function.Injective i4 := by decide
  have hi5 : Function.Injective i5 := by decide
  have hm4 : Monotone i4 := by decide
  have hm5 : Monotone i5 := by decide
  have ht4 : IsD1Tuple (fun i => a (i4 i)) :=
    ⟨ha.1.comp hi4,fun i => ha.2.1 _,fun i j hij => ha.2.2 _ _ (hi4.ne hij)⟩
  have ht5 : IsD1Tuple (fun i => a (i5 i)) :=
    ⟨ha.1.comp hi5,fun i => ha.2.1 _,fun i j hij => ha.2.2 _ _ (hi5.ne hij)⟩
  have hfront : (59/20 : ℝ)*A*B*S < T :=
    IsD1Tuple.frontier_fifteen_growth hK phi (fun i => a (i4 i)) ht4 (hmon.comp hm4) hA3 hB3 hS15
  have hfront2 : 2*A*B*S < T := by
    have hh : 0 < A*B*S := by positivity
    nlinarith only [hfront,hh]
  have hfrontBS : 2*B*S < T := by
    have hh := mul_le_mul_of_nonneg_right hA1 (by positivity : 0 ≤ 2*B*S)
    nlinarith only [hh,hfront2]
  have hBST : 45 ≤ B*S := by
    calc
      (45 : ℝ) = 3*15 := by norm_num
      _ ≤ B*S := by gcongr
  have hAT : 32 ≤ A*T := by
    have hh := mul_le_mul_of_nonneg_right hA1 hT.le
    nlinarith only [hh,hfrontBS,hBST]
  have hstart := IsD1Tuple.retained_start_of_frontier hK phi a ha hmon hB3 hfront2 hAT
  change A^2*T^5/S^2 < C ∧ A^2*C^5/S^2 < D ∧ A^2*C^7/(S^2*T^4) < D ∧
    1000 < C ∧ 200*S < C ∧ 4*T < C ∧ 16*B*S*T < C ∧ 1000*C < D at hstart
  have hretRaw := (IsD1Tuple.retained_gap_of_frontier hK phi (fun i => a (i5 i)) ht5
    (hmon.comp hm5) hB3 hfront2 32 (1/10) (179/10) (Or.inl ⟨rfl,rfl,rfl⟩) hAT).1
  have hret : (9999/100 : ℝ)*A^2*(1/R-(51051/400000 : ℝ)/(A^2*B^2))^2*(T^5/S^2) < C := by
    convert hretRaw using 1 <;> dsimp [R,v,coherentVandermonde3,i5,A,B,S,T,C,f] <;> ring
  have hf : Function.Injective f := by
    intro x y h
    apply NumberField.RingOfIntegers.ext
    exact phi.injective h
  have hvi : Function.Injective v :=
    hf.comp (ha.1.comp (by decide : Function.Injective (![0,1,2] : Fin 3 → Fin 6)))
  have hR : 0 < R := (coherent_three_vandermonde_ratio_bounds v hvi hA hAB hBS).1
  have hA1r : 0 < (r.A1 : ℝ) := by exact_mod_cast hA1pos
  have hB1r : 0 < (r.B1 : ℝ) := by exact_mod_cast hB1pos
  have hd1r : 0 < (r.d1 : ℝ) := by exact_mod_cast hd1pos
  have hAupper : A ≤ (r.A1 : ℝ) := by
    apply (sq_le_sq₀ hA.le hA1r.le).mp
    rw [hAsq]
    exact_mod_cast hA1sq
  have hBupper : B ≤ (r.B1 : ℝ) := by
    apply (sq_le_sq₀ hB.le hB1r.le).mp
    rw [hBsq]
    exact_mod_cast hB1sq
  have hdupper : ‖f (a 0)-f (a 1)‖/B ≤ (r.d1 : ℝ) := by
    apply (sq_le_sq₀ (by positivity) hd1r.le).mp
    rw [div_pow,hdsq,hBsq]
    exact_mod_cast hd1sq
  have hgeom := first_pair_geometry_bounds (f (a 0)) (f (a 1)) (f (a 2))
    (r.A1 : ℝ) (r.B1 : ℝ) (r.d1 : ℝ) (norm_pos_iff.mp hB) hBS hS15 hAupper hBupper hdupper
  have hvEq : v = ![f (a 0),f (a 1),f (a 2)] := by
    funext i
    fin_cases i <;> rfl
  rw [←hvEq] at hgeom
  have hRQ : R ≤ (r.Q0 : ℝ) := by
    have hh := hgeom.1
    change R ≤ _ at hh
    simp only [FirstPairGeometryRow.Q0]
    push_cast
    exact hh
  have hRF : R^2*Phi ≤ (r.F0 : ℝ) := by
    have hh := hgeom.2
    change R^2*Phi ≤ _ at hh
    rw [hdsq,hBsq] at hh
    simp only [FirstPairGeometryRow.F0]
    push_cast
    exact hh
  have hPhi : 0 ≤ Phi := by dsimp [Phi,firstPairPhi]; positivity
  have hF : 0 < (r.F0 : ℝ) := by exact_mod_cast hF0
  have hsepr : (51051/400000 : ℝ)/B^2 < 1/(r.Q0 : ℝ) := by
    rw [hBsq]
    exact_mod_cast hsep
  have hs := first_pair_retained_scalar A B S T C R (r.Q0 : ℝ) (r.F0 : ℝ) Phi
    hA1 hB hS hT hR hRQ hF hPhi hsepr hfront hRF hret
  have hKeq : (r.K : ℝ) = (9999/100 : ℝ)*A^2*(1/(r.Q0 : ℝ)-(51051/400000 : ℝ)/B^2)^2 := by
    simp only [FirstPairGeometryRow.K]
    push_cast
    rw [hAsq,hBsq]
  have hGeq : (r.G : ℝ) = (r.K : ℝ)*(59/20 : ℝ)^5 := by
    simp only [FirstPairGeometryRow.G]
    push_cast
    <;> rfl
  have hHeq : (r.H : ℝ) = (9999/100 : ℝ)*A^2*(59/20 : ℝ)^5*
      (1-(51051/400000 : ℝ)*(r.Q0 : ℝ)/B^2)^2 := by
    simp only [FirstPairGeometryRow.H]
    push_cast
    rw [hAsq,hBsq]
  have hrhoeq : (r.rho : ℝ)*(3535/409600 : ℝ) = (r.H : ℝ)/(r.F0 : ℝ) := by
    simp only [FirstPairGeometryRow.rho]
    push_cast
    field_simp [hF.ne']
    <;> ring
  have hKgap : (r.K : ℝ)*T^5/S^2 < C := by rw [hKeq]; exact hs.1
  have hKgtr : (7/4 : ℝ) < (r.K : ℝ) := by exact_mod_cast hKcoef
  have hKg : (7/4 : ℝ)*T^5/S^2 < C := by
    have hh := mul_lt_mul_of_pos_right hKgtr (by positivity : 0 < T^5/S^2)
    have hh' : (7/4 : ℝ)*T^5/S^2 < (r.K : ℝ)*T^5/S^2 := by
      convert hh using 1 <;> ring
    exact hh'.trans hKgap
  have hGgap : (r.G : ℝ)*B^5*S^3 < C := by
    rw [hGeq,hKeq]
    exact hs.2.1
  have hRhogap : (r.rho : ℝ)*((3535/409600 : ℝ)*Phi)*B^5*S^3 < C := by
    have hh := hs.2.2
    rw [←hHeq] at hh
    rw [←hrhoeq] at hh
    convert hh using 1 <;> ring
  have hC : 0 < C := by linarith only [hstart.2.2.2.1]
  have hDstart : C^7/(S^2*T^4) < D := by
    apply lt_of_le_of_lt _ hstart.2.2.1
    have hA2one : 1 ≤ A^2 := by nlinarith only [hA1]
    apply div_le_div_of_nonneg_right _ (by positivity)
    simpa only [one_mul] using mul_le_mul_of_nonneg_right hA2one (pow_nonneg hC.le 7)
  exact ⟨hKg,hGgap,hRhogap,hDstart,hstart.2.2.2.1,hstart.2.2.2.2.1,hstart.2.2.2.2.2.1,hfrontBS⟩

end D1Bound5

#print axioms D1Bound5.IsD1Tuple.first_pair_retained_packet_of_norms
