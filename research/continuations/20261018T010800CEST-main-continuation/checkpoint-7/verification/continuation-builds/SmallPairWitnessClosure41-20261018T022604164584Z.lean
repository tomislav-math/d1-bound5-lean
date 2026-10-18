import D1Bound5.SmallPairWitnessData41

namespace D1Bound5.PairPhasePilot41
set_option maxRecDepth 100000
set_option maxHeartbeats 0

/-- All supplied roots and all bounded mutations are verified by the kernel. -/
theorem closure_witness_checked :
    pairClosureWitnessBool anchorA anchorB anchorRootWitness (10^1100)
      closure closureWitnesses = true := by
  decide +kernel

/-- The original closure certificate, obtained without recomputing roots. -/
theorem closure_checked_by_witness :
    pairClosureBool anchorA anchorB (10^1100) closure = true :=
  pairClosureBool_of_witness_checked (by decide) anchorA anchorB anchorRootWitness
    (10^1100) closure closureWitnesses closure_witness_checked

end D1Bound5.PairPhasePilot41
