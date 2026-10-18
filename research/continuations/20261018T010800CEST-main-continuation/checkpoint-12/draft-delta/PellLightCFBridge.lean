import D1Bound5.PellLightCF
import D1Bound5.PellCFPrefixCheck

namespace D1Bound5

/-- An exact field-for-field copy, without changing the recurrence state. -/
def pellCFStateToLight (s : PellCFState) : PellLightCFState :=
  ⟨s.m, s.Q, s.a, s.pp, s.p, s.qq, s.q⟩

theorem pellLightCFInit_eq (a0 : ℤ) :
    pellLightCFInit a0 = pellCFStateToLight (pellCFInit a0) := rfl

theorem pellLightCFStep_eq (d a0 : ℤ) (s : PellCFState) :
    pellLightCFStep d a0 (pellCFStateToLight s) =
      pellCFStateToLight (pellCFStep d a0 s) := rfl

theorem pellLightCFAt_eq (d a0 : ℤ) (s : PellCFState) (N : ℕ) :
    pellLightCFAt d a0 (pellCFStateToLight s) N =
      pellCFStateToLight (pellCFAt d a0 s N) := by
  induction N generalizing s with
  | zero => rfl
  | succ N ih =>
      simpa only [pellLightCFAt, pellCFAt, pellLightCFStep_eq] using
        ih (pellCFStep d a0 s)

theorem pellLightCFTrace_eq (d a0 : ℤ) (s : PellCFState) (N : ℕ) :
    pellLightCFTrace d a0 (pellCFStateToLight s) N =
      (pellCFTrace d a0 s N).map pellCFStateToLight := by
  induction N generalizing s with
  | zero => rfl
  | succ N ih =>
      simp only [pellLightCFTrace, pellCFTrace, List.map_cons,
        pellLightCFStep_eq, ih]

theorem pellLightCFCheckFrom_eq (d a0 : ℤ) (s : PellCFState) (N : ℕ) :
    pellLightCFCheckFrom d a0 (pellCFStateToLight s) N =
      pellCFCheckFrom d a0 s N := by
  induction N generalizing s with
  | zero => rfl
  | succ N ih =>
      change
        (decide (PellLightCFStateGood a0 (pellCFStateToLight s) ∧
            PellLightCFTransitionGood d a0 (pellCFStateToLight s)) &&
          pellLightCFCheckFrom d a0 (pellLightCFStep d a0 (pellCFStateToLight s)) N) =
        (decide (PellCFStateGood a0 s ∧ PellCFTransitionGood d a0 s) &&
          pellCFCheckFrom d a0 (pellCFStep d a0 s) N)
      rw [pellLightCFStep_eq, ih]
      rfl

theorem pellLightCFPrefixCheck_eq (d a0 : ℤ) (N : ℕ) :
    pellLightCFPrefixCheck d a0 N = pellCFPrefixCheck d a0 N := by
  simp only [pellLightCFPrefixCheck, pellCFPrefixCheck,
    pellLightCFInit_eq, pellLightCFCheckFrom_eq]

theorem pellLightCFSolutions_eq (d a0 X : ℤ) (N : ℕ) :
    pellLightCFSolutions d a0 X N = pellCFSolutions d a0 X N := by
  simp only [pellLightCFSolutions, pellCFSolutions, pellLightCFInit_eq,
    pellLightCFTrace_eq, List.filterMap_map, Function.comp_def, pellCFStateToLight]

/-- The same prefix, the same stopping numerator, and the same complete
ordered filtered trace. No arithmetic or list-coverage premise is dropped. -/
theorem pellLightFiniteCheck_sound (d a0 X : ℤ) (N : ℕ) (magnitudes : List ℤ)
    (hcheck : pellLightFiniteCheck d a0 X N magnitudes = true) :
    pellCFPrefixCheck d a0 N = true ∧
      X < (pellCFAt d a0 (pellCFInit a0) N).p ∧
      (pellCFSolutions d a0 X N).map (fun uv => uv.1^2-1) = magnitudes := by
  have hp := Bool.and_eq_true_iff.mp hcheck
  have hr := Bool.and_eq_true_iff.mp hp.2
  refine ⟨?_, ?_, ?_⟩
  · simpa only [pellLightCFPrefixCheck_eq] using hp.1
  · have hs : X < (pellLightCFAt d a0 (pellLightCFInit a0) N).p :=
      of_decide_eq_true hr.1
    simpa only [pellLightCFInit_eq, pellLightCFAt_eq, pellCFStateToLight] using hs
  · have hm : (pellLightCFSolutions d a0 X N).map (fun uv => uv.1^2-1) = magnitudes :=
      of_decide_eq_true hr.2
    simpa only [pellLightCFSolutions_eq] using hm

end D1Bound5
