import D1Bound5.SmallPairLightAdaptiveLeft17_000
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0
run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part04_checked,
    `D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"GRAPH17_LEFT000_AXIOMS_PASS {name}: {ax}"
namespace D1Bound5.PairLightAdaptivePrepared17

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 28
      (leftCached000.drop 0) (leftRows000.drop 0) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part00_checked

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 31
      (leftCached000.drop 28) (leftRows000.drop 28) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part01_checked

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 35
      (leftCached000.drop 59) (leftRows000.drop 59) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part02_checked

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 40
      (leftCached000.drop 94) (leftRows000.drop 94) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part03_checked

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 3
      (leftCached000.drop 134) (leftRows000.drop 134) = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part04_checked

example
:
    pairLightSelectedFloorPrefixBool 0 2 PairLightPrepared17.sieve 137
      leftCached000 leftRows000 = true :=
  _root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_checked

end D1Bound5.PairLightAdaptivePrepared17
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part00_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part01_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part02_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part03_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_part04_checked
#check @_root_.D1Bound5.PairLightAdaptivePrepared17.left_prefix_000_checked
