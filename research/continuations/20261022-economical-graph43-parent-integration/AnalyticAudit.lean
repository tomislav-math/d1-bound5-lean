import D1Bound5.SmallPairLightAdaptiveLeft43_000
import D1Bound5.SmallPairLightAdaptiveLeft43_001
import D1Bound5.SmallPairLightAdaptiveLeft43_002
import D1Bound5.SmallPairLightAdaptiveRight43_000
import D1Bound5.SmallPairLightAdaptiveRight43_001
import D1Bound5.SmallPairLightAdaptiveRight43_002
import D1Bound5.SmallPairLightAdaptiveValidation43
import D1Bound5.SmallPairLightLeft43
import D1Bound5.SmallPairLightRight43
import Lean.Util.CollectAxioms
import Lean.Elab.Command
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
namespace D1Bound5.PairLightAdaptivePrepared43
example :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 91
      leftCached000 leftRows000 = true := left_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared43
namespace D1Bound5.PairLightAdaptivePrepared43
example :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 121
      leftCached001 leftRows001 = true := left_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared43
namespace D1Bound5.PairLightAdaptivePrepared43
example :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 270
      leftCached002 leftRows002 = true := left_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared43
namespace D1Bound5.PairLightAdaptivePrepared43
example :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 92
      rightCached000 rightRows000 = true := right_prefix_000_checked
end D1Bound5.PairLightAdaptivePrepared43
namespace D1Bound5.PairLightAdaptivePrepared43
example :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 122
      rightCached001 rightRows001 = true := right_prefix_001_checked
end D1Bound5.PairLightAdaptivePrepared43
namespace D1Bound5.PairLightAdaptivePrepared43
example :
    pairLightSelectedFloorPrefixBool 1 3 PairLightPrepared43.sieve 266
      rightCached002 rightRows002 = true := right_prefix_002_checked
end D1Bound5.PairLightAdaptivePrepared43
namespace D1Bound5.PairLightAdaptivePrepared43
example :
    decide (PairLightPrepared43.leftCached.map Prod.fst = PairLightPrepared43.leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightAdaptivePrepared43
namespace D1Bound5.PairLightAdaptivePrepared43
example :
    (PairLightPrepared43.leftCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared43.sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightAdaptivePrepared43
namespace D1Bound5.PairLightAdaptivePrepared43
example :
    decide (PairLightPrepared43.rightCached.map Prod.fst = PairLightPrepared43.rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightAdaptivePrepared43
namespace D1Bound5.PairLightAdaptivePrepared43
example :
    (PairLightPrepared43.rightCached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature PairLightPrepared43.sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightAdaptivePrepared43
namespace D1Bound5.PairLightPrepared43
example :
    decide (leftCached.map Prod.fst = leftVertices) = true := left_coverage_checked
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43
example :
    (leftCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := left_signatures_checked
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43
example :
    pairLightSelectedFloorIndependentBool 1 3 sieve leftCached leftRows = true := left_independent_checked
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43
example :
    pairLightSelectedFloorIndependentCertificateBool 1 3 sieve
      leftVertices leftCached leftRows = true := left_certificate_checked
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43
example :
    decide (rightCached.map Prod.fst = rightVertices) = true := right_coverage_checked
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43
example :
    (rightCached.all fun x => decide (x.2 = pairLightCoordinateSignature sieve x.1)) = true := right_signatures_checked
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43
example :
    pairLightSelectedFloorIndependentBool 1 3 sieve rightCached rightRows = true := right_independent_checked
end D1Bound5.PairLightPrepared43
namespace D1Bound5.PairLightPrepared43
example :
    pairLightSelectedFloorIndependentCertificateBool 1 3 sieve
      rightVertices rightCached rightRows = true := right_certificate_checked
end D1Bound5.PairLightPrepared43
run_cmd do
  for name in ([`D1Bound5.PairLightAdaptivePrepared43.left_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared43.left_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_000_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_001_checked, `D1Bound5.PairLightAdaptivePrepared43.right_prefix_002_checked, `D1Bound5.PairLightAdaptivePrepared43.left_coverage_checked, `D1Bound5.PairLightAdaptivePrepared43.left_signatures_checked, `D1Bound5.PairLightAdaptivePrepared43.right_coverage_checked, `D1Bound5.PairLightAdaptivePrepared43.right_signatures_checked, `D1Bound5.PairLightPrepared43.left_coverage_checked, `D1Bound5.PairLightPrepared43.left_signatures_checked, `D1Bound5.PairLightPrepared43.left_independent_checked, `D1Bound5.PairLightPrepared43.left_certificate_checked, `D1Bound5.PairLightPrepared43.right_coverage_checked, `D1Bound5.PairLightPrepared43.right_signatures_checked, `D1Bound5.PairLightPrepared43.right_independent_checked, `D1Bound5.PairLightPrepared43.right_certificate_checked] : List Lean.Name) do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do Lean.throwError "Unexpected axioms {name}: {bad}"
    Lean.logInfo m!"TYPE_AXIOMS_PASS {name}: {ax}"
