import D1Bound5.SmallPairGraphClosure39Chunk01
import D1Bound5.SmallPairGraphClosure39Chunk02
import D1Bound5.SmallPairGraphClosure39Chunk03
import D1Bound5.SmallPairGraphClosure39Chunk04
import D1Bound5.SmallPairGraphClosure39Chunk05
import D1Bound5.SmallPairGraphClosure39Chunk06
import D1Bound5.SmallPairGraphClosure39Chunk07
import D1Bound5.SmallPairGraphClosure39Chunk08
import D1Bound5.SmallPairGraphClosure39Chunk09
import D1Bound5.SmallPairGraphClosure39Chunk10
import D1Bound5.SmallPairGraphClosure39Chunk11
import D1Bound5.SmallPairGraphClosure39Chunk12
import D1Bound5.SmallPairGraphClosure39Chunk13
import D1Bound5.SmallPairGraphClosure39Chunk14
import D1Bound5.SmallPairGraphClosure39
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 64) (destinations.drop 64) = true := indexed_chunk01_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 128) (destinations.drop 128) = true := indexed_chunk02_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 192) (destinations.drop 192) = true := indexed_chunk03_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 256) (destinations.drop 256) = true := indexed_chunk04_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 320) (destinations.drop 320) = true := indexed_chunk05_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 384) (destinations.drop 384) = true := indexed_chunk06_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 448) (destinations.drop 448) = true := indexed_chunk07_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 512) (destinations.drop 512) = true := indexed_chunk08_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 576) (destinations.drop 576) = true := indexed_chunk09_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 640) (destinations.drop 640) = true := indexed_chunk10_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 704) (destinations.drop 704) = true := indexed_chunk11_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 768) (destinations.drop 768) = true := indexed_chunk12_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 64
      (witnesses.drop 832) (destinations.drop 832) = true := indexed_chunk13_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5.PairGraphPrepared39

example :
    pairIndexedWitnessesPrefixBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 19
      (witnesses.drop 896) (destinations.drop 896) = true := indexed_chunk14_checked
end D1Bound5.PairGraphPrepared39
namespace D1Bound5
open PairGraphPrepared39
example :
    pairClosureIndexedWitnessBool smallPairA_39 smallPairB_39 anchorRoot
      (10^1100) smallPairClosure_39 witnesses destinations = true := PairGraphPrepared39.indexed_checked
end D1Bound5
namespace D1Bound5
open PairGraphPrepared39
example :
    pairClosureBool smallPairA_39 smallPairB_39
      (10^1100) smallPairClosure_39 = true := smallPairClosure_39_checked
end D1Bound5
run_cmd do
  for name in ([`D1Bound5.PairGraphPrepared39.indexed_chunk01_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk02_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk03_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk04_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk05_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk06_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk07_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk08_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk09_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk10_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk11_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk12_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk13_checked, `D1Bound5.PairGraphPrepared39.indexed_chunk14_checked, `D1Bound5.PairGraphPrepared39.indexed_checked, `D1Bound5.smallPairClosure_39_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
