import D1Bound5.SmallPairLightAdaptiveLeft11_000Part00
import D1Bound5.SmallPairLightAdaptiveRight11_000Part00
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightAdaptivePrepared11.left_prefix_000_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part00_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH11_SIDES_AXIOMS_PASS {name}: {ax}"

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 16
      (leftCached000.drop 0) (leftRows000.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.left_prefix_000_part00_checked
end D1Bound5.PairLightAdaptivePrepared11

namespace D1Bound5.PairLightAdaptivePrepared11

example
:
    pairLightSelectedFloorPrefixBool 0 1 PairLightPrepared11.sieve 16
      (rightCached000.drop 0) (rightRows000.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part00_checked
end D1Bound5.PairLightAdaptivePrepared11

#check @_root_.D1Bound5.PairLightAdaptivePrepared11.left_prefix_000_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared11.right_prefix_000_part00_checked
