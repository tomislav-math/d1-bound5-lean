import D1Bound5.RootErrorMagnitude
import D1Bound5.TupleRootMatrixBridge

namespace D1Bound5

/-- A rational first-order margin yields any certified near-half
envelope. This permits a separate sharp constant for each of six edges. -/
theorem exists_root_error_rational_envelope (x t : ℂ) (m c k : ℝ)
    (hm : 0 < m) (hc : 0 ≤ c) (hk : 1/2 < k)
    (hgap : 1 < (1-c^2)*m)
    (hprecision : 1 ≤ 2*m*(1+c)^2*(k-1/2))
    (hx : m ≤ ‖x‖) (ht : t^2 = x*(x+1)) :
    ∃ v : ℂ, (v = t ∨ v = -t) ∧ ‖v-x-(1/2 : ℂ)‖ ≤ k-1/2 := by
  have hcoef : 0 ≤ 1-c^2 := by
    by_contra hbad
    have hh := mul_nonpos_of_nonpos_of_nonneg (le_of_lt (lt_of_not_ge hbad)) hm.le
    nlinarith only [hgap,hh]
  have hgap' : 1 < (1-c^2)*‖x‖ :=
    hgap.trans_le (mul_le_mul_of_nonneg_left hx hcoef)
  obtain ⟨v,hv,_,hhalf⟩ := exists_root_error_control x t c hc (hm.trans_le hx) hgap' ht
  refine ⟨v,hv,?_⟩
  have hE : 0 ≤ ‖v-x-(1/2 : ℂ)‖ := norm_nonneg _
  have hscale := mul_nonneg
    (mul_nonneg (sub_nonneg.mpr hx) (sq_nonneg (1+c))) hE
  by_contra hbad
  have hdiff := mul_nonneg
    (sub_nonneg.mpr (le_of_lt (lt_of_not_ge hbad)))
    (show 0 ≤ 2*m*(1+c)^2 by positivity)
  nlinarith only [hhalf,hprecision,hscale,hdiff]

/-- Select the sign inside the original ring while retaining its exact
square equation. The source root is allowed to be zero. -/
theorem exists_integral_root_rational_envelope
    {R : Type*} [CommRing R] (f : R →+* ℂ) (a b r : R) (u v : ℂ)
    (hu : u^2 = f a) (hv : v^2 = f b) (hr : r^2 = a*b+1)
    (m c k : ℝ) (hm : 0 < m) (hc : 0 ≤ c) (hk : 1/2 < k)
    (hgap : 1 < (1-c^2)*m) (hprecision : 1 ≤ 2*m*(1+c)^2*(k-1/2))
    (hab : m ≤ ‖f a*f b‖) :
    ∃ q : R, q^2 = a*b+1 ∧ ‖u*f q*v-f a*f b-(1/2 : ℂ)‖ ≤ k-1/2 := by
  have hrC : (f r)^2 = f a*f b+1 := by
    simpa only [map_pow,map_mul,map_add,map_one] using congrArg f hr
  have ht : (u*f r*v)^2 = (f a*f b)*(f a*f b+1) := by
    rw [mul_pow,mul_pow,hu,hv,hrC]
    ring
  obtain ⟨t,htsign,hbound⟩ := exists_root_error_rational_envelope
    (f a*f b) (u*f r*v) m c k hm hc hk hgap hprecision hab ht
  rcases htsign with rfl | rfl
  · exact ⟨r,hr,hbound⟩
  · refine ⟨-r,by simpa only [neg_sq] using hr,?_⟩
    simpa only [map_neg,mul_neg,neg_mul] using hbound

noncomputable def frontierFifteenK : Matrix (Fin 4) (Fin 4) ℝ :=
  !![0,5506/10000,5087/10000,5014/10000;
     5506/10000,0,5029/10000,5005/10000;
     5087/10000,5029/10000,0,5001/10000;
     5014/10000,5005/10000,5001/10000,0]

noncomputable def frontierFifteenMin : Matrix (Fin 4) (Fin 4) ℝ :=
  !![0,3,15,90; 3,0,45,270; 15,45,0,1350; 90,270,1350,0]

/-- The six manuscript near-half constants are realized simultaneously
by one symmetric integral root matrix. -/
theorem exists_frontier_fifteen_root_matrix
    {R : Type*} [CommRing R] (f : R →+* ℂ) (a : Fin 4 → R) (u : Fin 4 → ℂ)
    (hu : ∀ i, (u i)^2 = f (a i))
    (hr : ∀ i j, i ≠ j → ∃ r : R, r^2 = a i*a j+1)
    (hlarge : ∀ i j, i ≠ j → frontierFifteenMin i j ≤ ‖f (a i)*f (a j)‖) :
    ∃ S : Matrix (Fin 4) (Fin 4) R,
      (∀ i, S i i = a i) ∧ (∀ i j, S i j = S j i) ∧
      (∀ i j, i ≠ j → (S i j)^2 = a i*a j+1) ∧
      (∀ i j, i ≠ j →
        ‖u i*f (S i j)*u j-f (a i)*f (a j)-(1/2 : ℂ)‖ ≤ frontierFifteenK i j-1/2) := by
  obtain ⟨r01,hr01⟩ := hr 0 1 (by decide)
  obtain ⟨r02,hr02⟩ := hr 0 2 (by decide)
  obtain ⟨r03,hr03⟩ := hr 0 3 (by decide)
  obtain ⟨r12,hr12⟩ := hr 1 2 (by decide)
  obtain ⟨r13,hr13⟩ := hr 1 3 (by decide)
  obtain ⟨r23,hr23⟩ := hr 2 3 (by decide)
  obtain ⟨q01,hq01,he01⟩ := exists_integral_root_rational_envelope f (a 0) (a 1) r01
    (u 0) (u 1) (hu 0) (hu 1) hr01 3 (40/49) (5506/10000)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by simpa [frontierFifteenMin] using hlarge 0 1 (by decide))
  obtain ⟨q02,hq02,he02⟩ := exists_integral_root_rational_envelope f (a 0) (a 2) r02
    (u 0) (u 2) (hu 0) (hu 2) hr02 15 (24/25) (5087/10000)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by simpa [frontierFifteenMin] using hlarge 0 2 (by decide))
  obtain ⟨q03,hq03,he03⟩ := exists_integral_root_rational_envelope f (a 0) (a 3) r03
    (u 0) (u 3) (hu 0) (hu 3) hr03 90 (993/1000) (5014/10000)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by simpa [frontierFifteenMin] using hlarge 0 3 (by decide))
  obtain ⟨q12,hq12,he12⟩ := exists_integral_root_rational_envelope f (a 1) (a 2) r12
    (u 1) (u 2) (hu 1) (hu 2) hr12 45 (49/50) (5029/10000)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by simpa [frontierFifteenMin] using hlarge 1 2 (by decide))
  obtain ⟨q13,hq13,he13⟩ := exists_integral_root_rational_envelope f (a 1) (a 3) r13
    (u 1) (u 3) (hu 1) (hu 3) hr13 270 (99/100) (5005/10000)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by simpa [frontierFifteenMin] using hlarge 1 3 (by decide))
  obtain ⟨q23,hq23,he23⟩ := exists_integral_root_rational_envelope f (a 2) (a 3) r23
    (u 2) (u 3) (hu 2) (hu 3) hr23 1350 (99/100) (5001/10000)
    (by norm_num) (by norm_num) (by norm_num) (by norm_num) (by norm_num)
    (by simpa [frontierFifteenMin] using hlarge 2 3 (by decide))
  let S : Matrix (Fin 4) (Fin 4) R :=
    !![a 0,q01,q02,q03; q01,a 1,q12,q13; q02,q12,a 2,q23; q03,q13,q23,a 3]
  refine ⟨S,?_,?_,?_,?_⟩
  · intro i; fin_cases i <;> simp [S]
  · intro i j; fin_cases i <;> fin_cases j <;> simp [S]
  · intro i j hij
    fin_cases i <;> fin_cases j <;> try contradiction
    all_goals first
      | simpa [S,mul_comm] using hq01
      | simpa [S,mul_comm] using hq02
      | simpa [S,mul_comm] using hq03
      | simpa [S,mul_comm] using hq12
      | simpa [S,mul_comm] using hq13
      | simpa [S,mul_comm] using hq23
  · intro i j hij
    fin_cases i <;> fin_cases j <;> try contradiction
    all_goals first
      | simpa [S,frontierFifteenK,mul_comm,mul_left_comm,mul_assoc] using he01
      | simpa [S,frontierFifteenK,mul_comm,mul_left_comm,mul_assoc] using he02
      | simpa [S,frontierFifteenK,mul_comm,mul_left_comm,mul_assoc] using he03
      | simpa [S,frontierFifteenK,mul_comm,mul_left_comm,mul_assoc] using he12
      | simpa [S,frontierFifteenK,mul_comm,mul_left_comm,mul_assoc] using he13
      | simpa [S,frontierFifteenK,mul_comm,mul_left_comm,mul_assoc] using he23

end D1Bound5
