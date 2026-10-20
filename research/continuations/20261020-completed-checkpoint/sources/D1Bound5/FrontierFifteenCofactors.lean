import D1Bound5.FrontierMixedCofactors
import D1Bound5.FrontierFifteenRootError

open Matrix

namespace D1Bound5

theorem frontier_three_envelope_product (x y z : ℂ) (a b c : ℝ)
    (ha : 1/2 ≤ a) (hb : 1/2 ≤ b) (hc : 1/2 ≤ c)
    (hx : ‖x-(1/2 : ℂ)‖ ≤ a-1/2)
    (hy : ‖y-(1/2 : ℂ)‖ ≤ b-1/2)
    (hz : ‖z-(1/2 : ℂ)‖ ≤ c-1/2) :
    ‖x*y*z‖ ≤ a*b*c ∧ ‖x*y*z-(1/8 : ℂ)‖ ≤ a*b*c-1/8 := by
  have ha0 : 0 ≤ a := by linarith only [ha]
  have hb0 : 0 ≤ b := by linarith only [hb]
  have hc0 : 0 ≤ c := by linarith only [hc]
  have hnx : ‖x‖ ≤ a := by
    have hh := norm_add_le (x-(1/2 : ℂ)) (1/2 : ℂ)
    norm_num at hh
    linarith only [hh,hx]
  have hny : ‖y‖ ≤ b := by
    have hh := norm_add_le (y-(1/2 : ℂ)) (1/2 : ℂ)
    norm_num at hh
    linarith only [hh,hy]
  have hnz : ‖z‖ ≤ c := by
    have hh := norm_add_le (z-(1/2 : ℂ)) (1/2 : ℂ)
    norm_num at hh
    linarith only [hh,hz]
  constructor
  · simp only [norm_mul]
    gcongr
  · have hid : x*y*z-(1/8 : ℂ) =
        (x-1/2)*y*z+(1/2 : ℂ)*(y-1/2)*z+(1/4 : ℂ)*(z-1/2) := by ring
    rw [hid]
    calc
      _ ≤ ‖(x-1/2)*y*z+(1/2 : ℂ)*(y-1/2)*z‖+‖(1/4 : ℂ)*(z-1/2)‖ := norm_add_le _ _
      _ ≤ ‖(x-1/2)*y*z‖+‖(1/2 : ℂ)*(y-1/2)*z‖+‖(1/4 : ℂ)*(z-1/2)‖ :=
        add_le_add (norm_add_le _ _) le_rfl
      _ = ‖x-1/2‖*‖y‖*‖z‖+(1/2 : ℝ)*‖y-1/2‖*‖z‖+(1/4 : ℝ)*‖z-1/2‖ := by
        norm_num [norm_mul]
      _ ≤ (a-1/2)*b*c+(1/2 : ℝ)*(b-1/2)*c+(1/4 : ℝ)*(c-1/2) := by gcongr
      _ = a*b*c-1/8 := by ring

theorem frontier_three_variable_cofactor (p q r : ℂ) (P Q R : ℝ)
    (hp : ‖p-(1/8 : ℂ)‖ ≤ P-1/8)
    (hq : ‖q-(1/8 : ℂ)‖ ≤ Q-1/8)
    (hr : ‖r-(1/8 : ℂ)‖ ≤ R-1/8) : ‖p-q-r‖ ≤ P+Q+R-1/4 := by
  have hid : p-q-r = (p-1/8)-(q-1/8)-(r-1/8)-(1/8 : ℂ) := by ring
  rw [hid]
  have h1 := norm_sub_le ((p-1/8)-(q-1/8)-(r-1/8)) (1/8 : ℂ)
  have h2 := norm_sub_le ((p-1/8)-(q-1/8)) (r-1/8)
  have h3 := norm_sub_le (p-(1/8 : ℂ)) (q-1/8)
  have h18 : ‖(1/8 : ℂ)‖ = (1/8 : ℝ) := by norm_num
  rw [h18] at h1
  linarith only [h1,h2,h3,hp,hq,hr]

/-- Rounded rational entrywise bounds still retain enough margin for
59/20. Rounding avoids propagating large cubic rational coefficients. -/
noncomputable def frontierFifteenG : Matrix (Fin 4) (Fin 4) ℝ :=
  !![252/1000,142/1000,142/1000,144/1000;
     142/1000,256/1000,143/1000,148/1000;
     142/1000,143/1000,277/1000,181/1000;
     144/1000,148/1000,181/1000,282/1000]

theorem frontier_fifteen_six_bounds (x y z u v w : ℂ)
    (hx : ‖x-(1/2 : ℂ)‖ ≤ (5506/10000 : ℝ)-1/2)
    (hy : ‖y-(1/2 : ℂ)‖ ≤ (5087/10000 : ℝ)-1/2)
    (hz : ‖z-(1/2 : ℂ)‖ ≤ (5014/10000 : ℝ)-1/2)
    (hu : ‖u-(1/2 : ℂ)‖ ≤ (5029/10000 : ℝ)-1/2)
    (hv : ‖v-(1/2 : ℂ)‖ ≤ (5005/10000 : ℝ)-1/2)
    (hw : ‖w-(1/2 : ℂ)‖ ≤ (5001/10000 : ℝ)-1/2) :
    let F : Matrix (Fin 4) (Fin 4) ℂ := !![0,x,y,z; x,0,u,v; y,u,0,w; z,v,w,0]
    ‖F.det‖ ≤ 1 ∧ ∀ i j, ‖F.adjugate i j‖ ≤ frontierFifteenG i j := by
  let F : Matrix (Fin 4) (Fin 4) ℂ := !![0,x,y,z; x,0,u,v; y,u,0,w; z,v,w,0]
  change ‖F.det‖ ≤ 1 ∧ ∀ i j, ‖F.adjugate i j‖ ≤ frontierFifteenG i j
  constructor
  · have hh := (frontier_mixed_six_bounds x y z u v w (551/1000) (551/1000)
      (by norm_num) le_rfl
      (by linarith only [hx]) (by linarith only [hy]) (by linarith only [hz])
      (by linarith only [hu]) (by linarith only [hv]) (by linarith only [hw])).1
    exact hh.trans (by norm_num)
  · have hAdj : F.adjugate =
      !![2*u*v*w, w^2*x-w*z*u-w*y*v, v^2*y-v*z*u-v*x*w, u^2*z-u*y*v-u*x*w;
         w^2*x-w*z*u-w*y*v, 2*y*z*w, z^2*u-z*y*v-z*x*w, y^2*v-y*x*w-y*z*u;
         v^2*y-v*z*u-v*x*w, z^2*u-z*y*v-z*x*w, 2*x*z*v, x^2*w-x*y*v-x*z*u;
         u^2*z-u*y*v-u*x*w, y^2*v-y*x*w-y*z*u, x^2*w-x*y*v-x*z*u, 2*x*y*u] :=
      symmetricFour_adjugate_formula x y z u v w
    have h00 : ‖2*u*v*w‖ ≤ (252/1000 : ℝ) := by
      have hh := (frontier_three_envelope_product u v w (5029/10000) (5005/10000) (5001/10000) (by norm_num) (by norm_num) (by norm_num) hu hv hw).1
      calc
        _ = 2*‖u*v*w‖ := by norm_num [norm_mul,mul_assoc]
        _ ≤ 2*((5029/10000 : ℝ)*(5005/10000 : ℝ)*(5001/10000 : ℝ)) := mul_le_mul_of_nonneg_left hh (by norm_num)
        _ ≤ _ := by norm_num
    have h11 : ‖2*y*z*w‖ ≤ (256/1000 : ℝ) := by
      have hh := (frontier_three_envelope_product y z w (5087/10000) (5014/10000) (5001/10000) (by norm_num) (by norm_num) (by norm_num) hy hz hw).1
      calc
        _ = 2*‖y*z*w‖ := by norm_num [norm_mul,mul_assoc]
        _ ≤ 2*((5087/10000 : ℝ)*(5014/10000 : ℝ)*(5001/10000 : ℝ)) := mul_le_mul_of_nonneg_left hh (by norm_num)
        _ ≤ _ := by norm_num
    have h22 : ‖2*x*z*v‖ ≤ (277/1000 : ℝ) := by
      have hh := (frontier_three_envelope_product x z v (5506/10000) (5014/10000) (5005/10000) (by norm_num) (by norm_num) (by norm_num) hx hz hv).1
      calc
        _ = 2*‖x*z*v‖ := by norm_num [norm_mul,mul_assoc]
        _ ≤ 2*((5506/10000 : ℝ)*(5014/10000 : ℝ)*(5005/10000 : ℝ)) := mul_le_mul_of_nonneg_left hh (by norm_num)
        _ ≤ _ := by norm_num
    have h33 : ‖2*x*y*u‖ ≤ (282/1000 : ℝ) := by
      have hh := (frontier_three_envelope_product x y u (5506/10000) (5087/10000) (5029/10000) (by norm_num) (by norm_num) (by norm_num) hx hy hu).1
      calc
        _ = 2*‖x*y*u‖ := by norm_num [norm_mul,mul_assoc]
        _ ≤ 2*((5506/10000 : ℝ)*(5087/10000 : ℝ)*(5029/10000 : ℝ)) := mul_le_mul_of_nonneg_left hh (by norm_num)
        _ ≤ _ := by norm_num
    have h01 : ‖w^2*x-w*z*u-w*y*v‖ ≤ (142/1000 : ℝ) := by
      have hh1 : ‖w^2*x-(1/8 : ℂ)‖ ≤ (5001/10000 : ℝ)*(5001/10000 : ℝ)*(5506/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product w w x (5001/10000) (5001/10000) (5506/10000) (by norm_num) (by norm_num) (by norm_num) hw hw hx).2
      have hh2 : ‖w*z*u-(1/8 : ℂ)‖ ≤ (5001/10000 : ℝ)*(5014/10000 : ℝ)*(5029/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product w z u (5001/10000) (5014/10000) (5029/10000) (by norm_num) (by norm_num) (by norm_num) hw hz hu).2
      have hh3 : ‖w*y*v-(1/8 : ℂ)‖ ≤ (5001/10000 : ℝ)*(5087/10000 : ℝ)*(5005/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product w y v (5001/10000) (5087/10000) (5005/10000) (by norm_num) (by norm_num) (by norm_num) hw hy hv).2
      have hh := frontier_three_variable_cofactor (w^2*x) (w*z*u) (w*y*v)
        ((5001/10000 : ℝ)*(5001/10000 : ℝ)*(5506/10000 : ℝ)) ((5001/10000 : ℝ)*(5014/10000 : ℝ)*(5029/10000 : ℝ)) ((5001/10000 : ℝ)*(5087/10000 : ℝ)*(5005/10000 : ℝ)) hh1 hh2 hh3
      exact hh.trans (by norm_num)
    have h02 : ‖v^2*y-v*z*u-v*x*w‖ ≤ (142/1000 : ℝ) := by
      have hh1 : ‖v^2*y-(1/8 : ℂ)‖ ≤ (5005/10000 : ℝ)*(5005/10000 : ℝ)*(5087/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product v v y (5005/10000) (5005/10000) (5087/10000) (by norm_num) (by norm_num) (by norm_num) hv hv hy).2
      have hh2 : ‖v*z*u-(1/8 : ℂ)‖ ≤ (5005/10000 : ℝ)*(5014/10000 : ℝ)*(5029/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product v z u (5005/10000) (5014/10000) (5029/10000) (by norm_num) (by norm_num) (by norm_num) hv hz hu).2
      have hh3 : ‖v*x*w-(1/8 : ℂ)‖ ≤ (5005/10000 : ℝ)*(5506/10000 : ℝ)*(5001/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product v x w (5005/10000) (5506/10000) (5001/10000) (by norm_num) (by norm_num) (by norm_num) hv hx hw).2
      have hh := frontier_three_variable_cofactor (v^2*y) (v*z*u) (v*x*w)
        ((5005/10000 : ℝ)*(5005/10000 : ℝ)*(5087/10000 : ℝ)) ((5005/10000 : ℝ)*(5014/10000 : ℝ)*(5029/10000 : ℝ)) ((5005/10000 : ℝ)*(5506/10000 : ℝ)*(5001/10000 : ℝ)) hh1 hh2 hh3
      exact hh.trans (by norm_num)
    have h03 : ‖u^2*z-u*y*v-u*x*w‖ ≤ (144/1000 : ℝ) := by
      have hh1 : ‖u^2*z-(1/8 : ℂ)‖ ≤ (5029/10000 : ℝ)*(5029/10000 : ℝ)*(5014/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product u u z (5029/10000) (5029/10000) (5014/10000) (by norm_num) (by norm_num) (by norm_num) hu hu hz).2
      have hh2 : ‖u*y*v-(1/8 : ℂ)‖ ≤ (5029/10000 : ℝ)*(5087/10000 : ℝ)*(5005/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product u y v (5029/10000) (5087/10000) (5005/10000) (by norm_num) (by norm_num) (by norm_num) hu hy hv).2
      have hh3 : ‖u*x*w-(1/8 : ℂ)‖ ≤ (5029/10000 : ℝ)*(5506/10000 : ℝ)*(5001/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product u x w (5029/10000) (5506/10000) (5001/10000) (by norm_num) (by norm_num) (by norm_num) hu hx hw).2
      have hh := frontier_three_variable_cofactor (u^2*z) (u*y*v) (u*x*w)
        ((5029/10000 : ℝ)*(5029/10000 : ℝ)*(5014/10000 : ℝ)) ((5029/10000 : ℝ)*(5087/10000 : ℝ)*(5005/10000 : ℝ)) ((5029/10000 : ℝ)*(5506/10000 : ℝ)*(5001/10000 : ℝ)) hh1 hh2 hh3
      exact hh.trans (by norm_num)
    have h12 : ‖z^2*u-z*y*v-z*x*w‖ ≤ (143/1000 : ℝ) := by
      have hh1 : ‖z^2*u-(1/8 : ℂ)‖ ≤ (5014/10000 : ℝ)*(5014/10000 : ℝ)*(5029/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product z z u (5014/10000) (5014/10000) (5029/10000) (by norm_num) (by norm_num) (by norm_num) hz hz hu).2
      have hh2 : ‖z*y*v-(1/8 : ℂ)‖ ≤ (5014/10000 : ℝ)*(5087/10000 : ℝ)*(5005/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product z y v (5014/10000) (5087/10000) (5005/10000) (by norm_num) (by norm_num) (by norm_num) hz hy hv).2
      have hh3 : ‖z*x*w-(1/8 : ℂ)‖ ≤ (5014/10000 : ℝ)*(5506/10000 : ℝ)*(5001/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product z x w (5014/10000) (5506/10000) (5001/10000) (by norm_num) (by norm_num) (by norm_num) hz hx hw).2
      have hh := frontier_three_variable_cofactor (z^2*u) (z*y*v) (z*x*w)
        ((5014/10000 : ℝ)*(5014/10000 : ℝ)*(5029/10000 : ℝ)) ((5014/10000 : ℝ)*(5087/10000 : ℝ)*(5005/10000 : ℝ)) ((5014/10000 : ℝ)*(5506/10000 : ℝ)*(5001/10000 : ℝ)) hh1 hh2 hh3
      exact hh.trans (by norm_num)
    have h13 : ‖y^2*v-y*x*w-y*z*u‖ ≤ (148/1000 : ℝ) := by
      have hh1 : ‖y^2*v-(1/8 : ℂ)‖ ≤ (5087/10000 : ℝ)*(5087/10000 : ℝ)*(5005/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product y y v (5087/10000) (5087/10000) (5005/10000) (by norm_num) (by norm_num) (by norm_num) hy hy hv).2
      have hh2 : ‖y*x*w-(1/8 : ℂ)‖ ≤ (5087/10000 : ℝ)*(5506/10000 : ℝ)*(5001/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product y x w (5087/10000) (5506/10000) (5001/10000) (by norm_num) (by norm_num) (by norm_num) hy hx hw).2
      have hh3 : ‖y*z*u-(1/8 : ℂ)‖ ≤ (5087/10000 : ℝ)*(5014/10000 : ℝ)*(5029/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product y z u (5087/10000) (5014/10000) (5029/10000) (by norm_num) (by norm_num) (by norm_num) hy hz hu).2
      have hh := frontier_three_variable_cofactor (y^2*v) (y*x*w) (y*z*u)
        ((5087/10000 : ℝ)*(5087/10000 : ℝ)*(5005/10000 : ℝ)) ((5087/10000 : ℝ)*(5506/10000 : ℝ)*(5001/10000 : ℝ)) ((5087/10000 : ℝ)*(5014/10000 : ℝ)*(5029/10000 : ℝ)) hh1 hh2 hh3
      exact hh.trans (by norm_num)
    have h23 : ‖x^2*w-x*y*v-x*z*u‖ ≤ (181/1000 : ℝ) := by
      have hh1 : ‖x^2*w-(1/8 : ℂ)‖ ≤ (5506/10000 : ℝ)*(5506/10000 : ℝ)*(5001/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product x x w (5506/10000) (5506/10000) (5001/10000) (by norm_num) (by norm_num) (by norm_num) hx hx hw).2
      have hh2 : ‖x*y*v-(1/8 : ℂ)‖ ≤ (5506/10000 : ℝ)*(5087/10000 : ℝ)*(5005/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product x y v (5506/10000) (5087/10000) (5005/10000) (by norm_num) (by norm_num) (by norm_num) hx hy hv).2
      have hh3 : ‖x*z*u-(1/8 : ℂ)‖ ≤ (5506/10000 : ℝ)*(5014/10000 : ℝ)*(5029/10000 : ℝ)-1/8 := by
        simpa only [pow_two] using (frontier_three_envelope_product x z u (5506/10000) (5014/10000) (5029/10000) (by norm_num) (by norm_num) (by norm_num) hx hz hu).2
      have hh := frontier_three_variable_cofactor (x^2*w) (x*y*v) (x*z*u)
        ((5506/10000 : ℝ)*(5506/10000 : ℝ)*(5001/10000 : ℝ)) ((5506/10000 : ℝ)*(5087/10000 : ℝ)*(5005/10000 : ℝ)) ((5506/10000 : ℝ)*(5014/10000 : ℝ)*(5029/10000 : ℝ)) hh1 hh2 hh3
      exact hh.trans (by norm_num)
    intro i j
    rw [hAdj]
    fin_cases i <;> fin_cases j
    all_goals first
      | simpa [frontierFifteenG] using h00
      | simpa [frontierFifteenG] using h11
      | simpa [frontierFifteenG] using h22
      | simpa [frontierFifteenG] using h33
      | simpa [frontierFifteenG] using h01
      | simpa [frontierFifteenG] using h02
      | simpa [frontierFifteenG] using h03
      | simpa [frontierFifteenG] using h12
      | simpa [frontierFifteenG] using h13
      | simpa [frontierFifteenG] using h23

end D1Bound5
