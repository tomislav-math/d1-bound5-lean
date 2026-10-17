import D1Bound5.FullRingClassification
import Mathlib.Tactic.IntervalCases

namespace D1Bound5

def traceZeroParametersFast : Finset ℤ :=
  {1, 2, 4, 5, 6, 8, 9, 10, 12, 13, 14}

def traceOneParametersFast : Finset ℤ :=
  {3, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59}

theorem trace_zero_bounded_fast (d : ℤ) (hd : 0 < d)
    (hmod : d % 4 ≠ 3) (hDelta : 4*d ≤ 60) :
    d ∈ traceZeroParametersFast := by
  have hlo : 1 ≤ d := by omega
  have hhi : d ≤ 15 := by omega
  interval_cases d <;> norm_num [traceZeroParametersFast] at *

theorem trace_one_bounded_fast (d : ℤ) (hd : 0 < d)
    (hmod : d % 4 = 3) (hDelta : d ≤ 60) :
    d ∈ traceOneParametersFast := by
  let k : ℤ := (d+1)/4
  have hlo : 1 ≤ k := by dsimp [k]; omega
  have hhi : k ≤ 15 := by dsimp [k]; omega
  have hdk : d = 4*k-1 := by dsimp [k]; omega
  rw [hdk]
  interval_cases k <;> norm_num [traceOneParametersFast]

end D1Bound5
