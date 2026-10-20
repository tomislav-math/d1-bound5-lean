import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part00
import Lean.Elab.Command
import Lean.Util.CollectAxioms

open Lean Elab Command
set_option maxRecDepth 100000

run_cmd do
  let names : List Name := [
    `D1Bound5.pairLightSelectedFloorPrefixBool_add,
    `D1Bound5.pairLightSelectedFloorPrefixBool_of_add,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part00_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.pairLightSelectedFloorPrefixBool_add
#check @D1Bound5.pairLightSelectedFloorPrefixBool_of_add
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part00_checked

open D1Bound5 D1Bound5.PairLightAdaptivePrepared26

example : ∀ (tau nu : Int) (sieve : List (Nat × Nat)) (m n : Nat)
    (cached : List PairLightCachedVertex) (rows : List (Nat × List Nat)),
    pairLightSelectedFloorPrefixBool tau nu sieve (m+n) cached rows =
      (pairLightSelectedFloorPrefixBool tau nu sieve m cached rows &&
        pairLightSelectedFloorPrefixBool tau nu sieve n (cached.drop m) (rows.drop m)) := @D1Bound5.pairLightSelectedFloorPrefixBool_add

example : ∀ (tau nu : Int) (sieve : List (Nat × Nat)) (m n : Nat)
    (cached : List PairLightCachedVertex) (rows : List (Nat × List Nat))
    (hm : pairLightSelectedFloorPrefixBool tau nu sieve m cached rows = true)
    (hn : pairLightSelectedFloorPrefixBool tau nu sieve n
      (cached.drop m) (rows.drop m) = true),
    pairLightSelectedFloorPrefixBool tau nu sieve (m+n) cached rows = true := @D1Bound5.pairLightSelectedFloorPrefixBool_of_add

example : pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 0) (leftRows000.drop 0) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part00_checked
