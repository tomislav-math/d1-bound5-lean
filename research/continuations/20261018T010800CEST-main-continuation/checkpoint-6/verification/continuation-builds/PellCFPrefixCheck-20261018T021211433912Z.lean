import D1Bound5.PellConvergentCompleteness

namespace D1Bound5

/-- All seven fields are integers. `pp,qq` are the preceding convergent;
`p,q` are the current one. No real arithmetic occurs in the certificate. -/
structure PellCFState where
  m : ℤ
  Q : ℤ
  a : ℤ
  pp : ℤ
  p : ℤ
  qq : ℤ
  q : ℤ
  deriving DecidableEq, Repr

def pellCFInit (a0 : ℤ) : PellCFState := ⟨0,1,a0,1,a0,0,1⟩

def pellCFStep (d a0 : ℤ) (s : PellCFState) : PellCFState :=
  let m := s.Q*s.a-s.m
  let Q := (d-m^2)/s.Q
  let a := (a0+m)/Q
  ⟨m,Q,a,s.p,a*s.p+s.pp,s.q,a*s.q+s.qq⟩

def pellCFAt (d a0 : ℤ) : PellCFState → ℕ → PellCFState
  | s,0 => s
  | s,n+1 => pellCFAt d a0 (pellCFStep d a0 s) n

def pellCFTrace (d a0 : ℤ) : PellCFState → ℕ → List PellCFState
  | s,0 => [s]
  | s,n+1 => s :: pellCFTrace d a0 (pellCFStep d a0 s) n

def PellCFStateGood (a0 : ℤ) (s : PellCFState) : Prop :=
  0 < s.Q ∧ s.a*s.Q ≤ a0+s.m ∧ a0+s.m < (s.a+1)*s.Q

def PellCFTransitionGood (d a0 : ℤ) (s : PellCFState) : Prop :=
  s.Q*(pellCFStep d a0 s).Q = d-(pellCFStep d a0 s).m^2

instance (a0 : ℤ) (s : PellCFState) : Decidable (PellCFStateGood a0 s) :=
  inferInstanceAs (Decidable (_ ∧ _ ∧ _))

instance (d a0 : ℤ) (s : PellCFState) : Decidable (PellCFTransitionGood d a0 s) :=
  inferInstanceAs (Decidable (_ = _))

def pellCFCheckFrom (d a0 : ℤ) : PellCFState → ℕ → Bool
  | s,0 => decide (PellCFStateGood a0 s)
  | s,n+1 => decide (PellCFStateGood a0 s ∧ PellCFTransitionGood d a0 s) &&
      pellCFCheckFrom d a0 (pellCFStep d a0 s) n

def pellCFPrefixCheck (d a0 : ℤ) (N : ℕ) : Bool :=
  decide (0 ≤ a0 ∧ a0^2 < d ∧ d < (a0+1)^2) &&
    pellCFCheckFrom d a0 (pellCFInit a0) N

/-- The actual finite output, computed rather than postulated. -/
def pellCFSolutions (d a0 X : ℤ) (N : ℕ) : List (ℤ × ℤ) :=
  (pellCFTrace d a0 (pellCFInit a0) N).filterMap fun s =>
    if 0 < s.p ∧ 0 < s.q ∧ s.p ≤ X ∧ s.p^2-d*s.q^2=2
      then some (s.p,s.q) else none

theorem pellCFAt_succ (d a0 : ℤ) (s : PellCFState) (n : ℕ) :
    pellCFAt d a0 s (n+1) = pellCFStep d a0 (pellCFAt d a0 s n) := by
  induction n generalizing s with
  | zero => rfl
  | succ n ih => simpa only [pellCFAt] using ih (pellCFStep d a0 s)

theorem pellCFAt_mem_trace (d a0 : ℤ) (s : PellCFState) {n N : ℕ} (hn : n ≤ N) :
    pellCFAt d a0 s n ∈ pellCFTrace d a0 s N := by
  induction N generalizing s n with
  | zero => have hn0 : n=0 := by omega; simp [hn0,pellCFAt,pellCFTrace]
  | succ N ih =>
      cases n with
      | zero => simp [pellCFAt,pellCFTrace]
      | succ n =>
          exact List.mem_cons_of_mem _ (ih (pellCFStep d a0 s) (by omega))

theorem pellCFCheckFrom_sound (d a0 : ℤ) (s : PellCFState) (N : ℕ)
    (h : pellCFCheckFrom d a0 s N = true) :
    (∀ i ≤ N, PellCFStateGood a0 (pellCFAt d a0 s i)) ∧
    (∀ i < N, PellCFTransitionGood d a0 (pellCFAt d a0 s i)) := by
  induction N generalizing s with
  | zero =>
      have hs : PellCFStateGood a0 s := by simpa only [pellCFCheckFrom,decide_eq_true_eq] using h
      exact ⟨fun i hi => by have : i=0 := by omega; simpa [this,pellCFAt] using hs,
        fun i hi => by omega⟩
  | succ N ih =>
      have hh : (PellCFStateGood a0 s ∧ PellCFTransitionGood d a0 s) ∧
          pellCFCheckFrom d a0 (pellCFStep d a0 s) N = true := by
        simpa only [pellCFCheckFrom,Bool.and_eq_true,decide_eq_true_eq] using h
      obtain ⟨hg,ht⟩ := ih (pellCFStep d a0 s) hh.2
      constructor
      · intro i hi
        cases i with
        | zero => exact hh.1.1
        | succ i => exact hg i (by omega)
      · intro i hi
        cases i with
        | zero => exact hh.1.2
        | succ i => exact ht i (by omega)

noncomputable def pellRealTail (x : ℝ) : ℕ → ℝ
  | 0 => x
  | n+1 => pellRealTail (Int.fract x)⁻¹ n

theorem pellRealTail_succ (x : ℝ) (n : ℕ) :
    pellRealTail x (n+1) = (Int.fract (pellRealTail x n))⁻¹ := by
  induction n generalizing x with
  | zero => rfl
  | succ n ih => simpa only [pellRealTail] using ih (Int.fract x)⁻¹

/-- The forward recurrence that connects the short executable certificate
to the independently proved real-convergent completeness theorem. -/
theorem pellConvergentPair_recurrence (x : ℝ) (n : ℕ) :
    pellConvergentPair x (n+2) =
      (⌊pellRealTail x (n+2)⌋ * (pellConvergentPair x (n+1)).1 +
          (pellConvergentPair x n).1,
       ⌊pellRealTail x (n+2)⌋ * (pellConvergentPair x (n+1)).2 +
          (pellConvergentPair x n).2) := by
  induction n generalizing x with
  | zero =>
      simp only [pellConvergentPair,pellRealTail]
      ext <;> ring
  | succ n ih =>
      let t := (Int.fract x)⁻¹
      change
        (⌊x⌋ * (pellConvergentPair t (n+2)).1 + (pellConvergentPair t (n+2)).2,
          (pellConvergentPair t (n+2)).1) =
        (⌊pellRealTail t (n+2)⌋ *
            (⌊x⌋ * (pellConvergentPair t (n+1)).1 + (pellConvergentPair t (n+1)).2) +
            (⌊x⌋ * (pellConvergentPair t n).1 + (pellConvergentPair t n).2),
         ⌊pellRealTail t (n+2)⌋ * (pellConvergentPair t (n+1)).1 +
            (pellConvergentPair t n).1)
      rw [ih t]
      ext <;> simp only [Prod.fst,Prod.snd] <;> ring

private theorem pell_sqrt_interval {d a0 : ℤ}
    (h0 : 0 ≤ a0) (hlo : a0^2 < d) (hhi : d < (a0+1)^2) :
    (a0 : ℝ) < Real.sqrt d ∧ Real.sqrt d < a0+1 := by
  have hd0 : (0 : ℝ) ≤ d := by
    exact_mod_cast (show 0 ≤ d by nlinarith [sq_nonneg a0])
  have hs := Real.sq_sqrt hd0
  have hs0 := Real.sqrt_nonneg (d : ℝ)
  have h0' : (0 : ℝ) ≤ a0 := by exact_mod_cast h0
  have hlo' : (a0 : ℝ)^2 < d := by exact_mod_cast hlo
  have hhi' : (d : ℝ) < ((a0 : ℝ)+1)^2 := by exact_mod_cast hhi
  constructor <;> nlinarith

private theorem pellCFState_floor {d a0 : ℤ} {s : PellCFState}
    (hr : (a0 : ℝ) < Real.sqrt d ∧ Real.sqrt d < a0+1)
    (hg : PellCFStateGood a0 s) :
    ⌊(Real.sqrt (d : ℝ)+s.m)/s.Q⌋ = s.a := by
  have hQ : (0 : ℝ) < s.Q := by exact_mod_cast hg.1
  apply Int.floor_eq_iff.mpr
  constructor
  · apply (le_div_iff₀ hQ).mpr
    have hlo : (s.a : ℝ)*s.Q ≤ a0+s.m := by exact_mod_cast hg.2.1
    linarith only [hlo,hr.1]
  · apply (div_lt_iff₀ hQ).mpr
    have hhi : (a0 : ℝ)+s.m+1 ≤ (s.a+1)*s.Q := by
      exact_mod_cast (show a0+s.m+1 ≤ (s.a+1)*s.Q by omega)
    linarith only [hhi,hr.2]

private theorem pellCFState_tail {d a0 : ℤ} {s : PellCFState}
    (hr : (a0 : ℝ) < Real.sqrt d ∧ Real.sqrt d < a0+1)
    (hd0 : (0 : ℝ) ≤ d)
    (hg : PellCFStateGood a0 s)
    (hg' : PellCFStateGood a0 (pellCFStep d a0 s))
    (ht : PellCFTransitionGood d a0 s) :
    (Int.fract ((Real.sqrt (d : ℝ)+s.m)/s.Q))⁻¹ =
      (Real.sqrt d+(pellCFStep d a0 s).m)/(pellCFStep d a0 s).Q := by
  have hf := pellCFState_floor hr hg
  have hQ : (s.Q : ℝ) ≠ 0 := by exact_mod_cast hg.1.ne'
  have hQ' : ((pellCFStep d a0 s).Q : ℝ) ≠ 0 := by exact_mod_cast hg'.1.ne'
  have hlo : (s.a : ℝ)*s.Q ≤ a0+s.m := by exact_mod_cast hg.2.1
  have hm : (0 : ℝ) < Real.sqrt d-(pellCFStep d a0 s).m := by
    simp only [pellCFStep]
    push_cast
    linarith only [hlo,hr.1]
  have ht' : (s.Q : ℝ)*(pellCFStep d a0 s).Q =
      d-((pellCFStep d a0 s).m : ℝ)^2 := by exact_mod_cast ht
  have hs := Real.sq_sqrt hd0
  rw [Int.fract,hf]
  have hrewrite : (Real.sqrt (d : ℝ)+s.m)/s.Q-(s.a : ℝ) =
      (Real.sqrt d-(pellCFStep d a0 s).m)/s.Q := by
    simp only [pellCFStep]
    push_cast
    field_simp [hQ]
    <;> ring
  rw [hrewrite,inv_div]
  apply (div_eq_div_iff hm.ne' hQ').mpr
  nlinarith

theorem pellCFPrefixCheck_nonsquare {d a0 : ℤ} {N : ℕ}
    (h : pellCFPrefixCheck d a0 N = true) : ¬IsSquare d := by
  have hh : (0 ≤ a0 ∧ a0^2 < d ∧ d < (a0+1)^2) ∧
      pellCFCheckFrom d a0 (pellCFInit a0) N = true := by
    simpa only [pellCFPrefixCheck,Bool.and_eq_true,decide_eq_true_eq] using h
  rintro ⟨z,hz⟩
  have hz' : d = z^2 := by simpa only [pow_two] using hz
  have hs : |z|^2=z^2 := sq_abs z
  have hz0 : 0 ≤ |z| := abs_nonneg z
  have hlo : a0 < |z| := by nlinarith [hh.1.1,hh.1.2.1]
  have hhi : |z| < a0+1 := by nlinarith [hh.1.1,hh.1.2.2]
  omega

theorem pellCFPrefixCheck_pairs {d a0 : ℤ} {N : ℕ}
    (h : pellCFPrefixCheck d a0 N = true) :
    ∀ i ≤ N, pellConvergentPair (Real.sqrt (d : ℝ)) i =
      ((pellCFAt d a0 (pellCFInit a0) i).p,
       (pellCFAt d a0 (pellCFInit a0) i).q) := by
  have hh : (0 ≤ a0 ∧ a0^2 < d ∧ d < (a0+1)^2) ∧
      pellCFCheckFrom d a0 (pellCFInit a0) N = true := by
    simpa only [pellCFPrefixCheck,Bool.and_eq_true,decide_eq_true_eq] using h
  have hr := pell_sqrt_interval hh.1.1 hh.1.2.1 hh.1.2.2
  have hd0 : (0 : ℝ) ≤ d := by
    exact_mod_cast (show 0 ≤ d by nlinarith [sq_nonneg a0,hh.1.2.1])
  obtain ⟨hg,ht⟩ := pellCFCheckFrom_sound d a0 (pellCFInit a0) N hh.2
  let s (i : ℕ) := pellCFAt d a0 (pellCFInit a0) i
  have hs (i : ℕ) : s (i+1) = pellCFStep d a0 (s i) := pellCFAt_succ _ _ _ _
  have htail : ∀ i ≤ N, pellRealTail (Real.sqrt (d : ℝ)) i =
      (Real.sqrt d+(s i).m)/(s i).Q := by
    intro i
    induction i with
    | zero => intro hi; simp [pellRealTail,s,pellCFAt,pellCFInit]
    | succ i ih =>
        intro hi
        rw [pellRealTail_succ,ih (by omega),hs]
        exact pellCFState_tail hr hd0 (hg i (by omega))
          (hs i ▸ hg (i+1) hi) (ht i (by omega))
  have hf (i : ℕ) (hi : i ≤ N) :
      ⌊pellRealTail (Real.sqrt (d : ℝ)) i⌋ = (s i).a := by
    rw [htail i hi]
    exact pellCFState_floor hr (hg i hi)
  intro i
  induction i using Nat.strong_induction_on with
  | h i ih =>
      intro hi
      rcases i with (_ | _ | i)
      · change (⌊Real.sqrt (d : ℝ)⌋,1) = (a0,1)
        have hf0 := hf 0 (by omega)
        simpa only [pellRealTail,s,pellCFAt,pellCFInit] using
          congrArg (fun a : ℤ => (a,1)) hf0
      · have hf0 := hf 0 (by omega)
        have hf1 := hf 1 hi
        change
          (⌊Real.sqrt (d : ℝ)⌋ * ⌊pellRealTail (Real.sqrt (d : ℝ)) 1⌋+1,
            ⌊pellRealTail (Real.sqrt (d : ℝ)) 1⌋) = ((s 1).p,(s 1).q)
        rw [hf0,hf1]
        simp only [s,pellCFAt,pellCFInit,pellCFStep]
        ext <;> ring
      · rw [pellConvergentPair_recurrence,
          ih (i+1) (by omega) (by omega),ih i (by omega) (by omega),hf (i+2) hi]
        have hpp : (s (i+1)).pp = (s i).p := by rw [hs]; rfl
        have hqq : (s (i+1)).qq = (s i).q := by rw [hs]; rfl
        change
          ((s (i+2)).a*(s (i+1)).p+(s i).p,
           (s (i+2)).a*(s (i+1)).q+(s i).q) = ((s (i+2)).p,(s (i+2)).q)
        rw [hs (i+1)]
        change
          ((pellCFStep d a0 (s (i+1))).a*(s (i+1)).p+(s i).p,
           (pellCFStep d a0 (s (i+1))).a*(s (i+1)).q+(s i).q) =
          ((pellCFStep d a0 (s (i+1))).a*(s (i+1)).p+(s (i+1)).pp,
           (pellCFStep d a0 (s (i+1))).a*(s (i+1)).q+(s (i+1)).qq)
        rw [hpp,hqq]

/-- A finite checked continued-fraction computation contains every positive
norm-two solution below its stopping numerator. The output list is the
actual filtered trace of the integer algorithm. -/
theorem pellCFSolutions_complete {d a0 X x y : ℤ} {N : ℕ}
    (hd : 7 ≤ d) (hcheck : pellCFPrefixCheck d a0 N = true)
    (hstop : X < (pellCFAt d a0 (pellCFInit a0) N).p)
    (hx : 0 < x) (hy : 0 < y) (heq : x^2-d*y^2=2) (hX : x ≤ X) :
    (x,y) ∈ pellCFSolutions d a0 X N := by
  have hpairs := pellCFPrefixCheck_pairs hcheck
  have hstop' : X < (pellConvergentPair (Real.sqrt (d : ℝ)) N).1 := by
    simpa only [hpairs N le_rfl,Prod.fst] using hstop
  obtain ⟨i,hi,hxy⟩ := pell_norm_two_bounded_prefix hd
    (pellCFPrefixCheck_nonsquare hcheck) hx hy heq hX hstop'
  have hpair : ((pellCFAt d a0 (pellCFInit a0) i).p,
      (pellCFAt d a0 (pellCFInit a0) i).q) = (x,y) :=
    (hpairs i hi.le).symm.trans hxy
  obtain ⟨hp,hq⟩ := Prod.mk.inj hpair
  apply List.mem_filterMap.mpr
  refine ⟨pellCFAt d a0 (pellCFInit a0) i,
    pellCFAt_mem_trace d a0 (pellCFInit a0) hi.le, ?_⟩
  simp [hp,hq,hx,hy,hX,heq]

/-- This is the cutoff used for the signed rational extensions: their
magnitude is u^2-1, and the bound is X^2. Both Pell signs are retained via
absolute values; no positivity assumption on the supplied roots is made. -/
theorem pellCFSolutions_complete_abs {d a0 X u v : ℤ} {N : ℕ}
    (hd : 7 ≤ d) (hcheck : pellCFPrefixCheck d a0 N = true)
    (hstop : X < (pellCFAt d a0 (pellCFInit a0) N).p)
    (hX : 1 ≤ X) (hv : v ≠ 0) (heq : u^2-d*v^2=2)
    (hbound : u^2-1 ≤ X^2) :
    (|u|,|v|) ∈ pellCFSolutions d a0 X N := by
  have hu : u ≠ 0 := by
    intro hu
    rw [hu] at heq
    have hprod : 0 ≤ d*v^2 := mul_nonneg (by omega) (sq_nonneg v)
    nlinarith
  have hupos : 0 < |u| := abs_pos.mpr hu
  have hvpos : 0 < |v| := abs_pos.mpr hv
  have huX : |u| ≤ X := by
    by_contra h
    have hle : X+1 ≤ |u| := by omega
    nlinarith [sq_abs u]
  apply pellCFSolutions_complete hd hcheck hstop hupos hvpos _ huX
  simpa only [sq_abs] using heq

end D1Bound5
