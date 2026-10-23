import D1Bound5.SmallPairGraphClosure19Chunk01
import D1Bound5.SmallPairGraphClosure19Chunk02
import D1Bound5.SmallPairGraphClosure19Chunk03
import D1Bound5.SmallPairGraphClosure19Chunk04
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairGraphPrepared19

example :
    pairIndexedWitnessesPrefixBool smallPairA_19 smallPairB_19 anchorRoot
      (10^1100) smallPairClosure_19 64
      (witnesses.drop 64) (destinations.drop 64) = true := indexed_chunk01_checked
end D1Bound5.PairGraphPrepared19
namespace D1Bound5.PairGraphPrepared19

example :
    pairIndexedWitnessesPrefixBool smallPairA_19 smallPairB_19 anchorRoot
      (10^1100) smallPairClosure_19 64
      (witnesses.drop 128) (destinations.drop 128) = true := indexed_chunk02_checked
end D1Bound5.PairGraphPrepared19
namespace D1Bound5.PairGraphPrepared19

example :
    pairIndexedWitnessesPrefixBool smallPairA_19 smallPairB_19 anchorRoot
      (10^1100) smallPairClosure_19 64
      (witnesses.drop 192) (destinations.drop 192) = true := indexed_chunk03_checked
end D1Bound5.PairGraphPrepared19
namespace D1Bound5.PairGraphPrepared19

example :
    pairIndexedWitnessesPrefixBool smallPairA_19 smallPairB_19 anchorRoot
      (10^1100) smallPairClosure_19 64
      (witnesses.drop 256) (destinations.drop 256) = true := indexed_chunk04_checked
end D1Bound5.PairGraphPrepared19
run_cmd do
  for name in ([`D1Bound5.PairGraphPrepared19.indexed_chunk01_checked, `D1Bound5.PairGraphPrepared19.indexed_chunk02_checked, `D1Bound5.PairGraphPrepared19.indexed_chunk03_checked, `D1Bound5.PairGraphPrepared19.indexed_chunk04_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
