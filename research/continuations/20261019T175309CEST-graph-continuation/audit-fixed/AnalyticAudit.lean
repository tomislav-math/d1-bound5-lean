import D1Bound5.PairLightArithmeticPrefixConcat
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part00
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part01
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part02
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part03
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part04
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part05
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part06
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part07
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part08
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part09
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part10
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part11
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part12
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part13
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part14
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part15
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part16
import D1Bound5.SmallPairLightAdaptiveLeft26_000Part17
import D1Bound5.SmallPairLightAdaptiveRight26_000Part00
import D1Bound5.SmallPairLightAdaptiveRight26_000Part01
import D1Bound5.SmallPairLightAdaptiveRight26_000Part02
import D1Bound5.SmallPairLightAdaptiveRight26_000Part03
import D1Bound5.SmallPairLightAdaptiveRight26_000Part04
import D1Bound5.SmallPairLightAdaptiveRight26_000Part05
import D1Bound5.SmallPairLightAdaptiveRight26_000Part06
import D1Bound5.SmallPairLightAdaptiveRight26_000Part07
import D1Bound5.SmallPairLightAdaptiveRight26_000Part08
import D1Bound5.SmallPairLightAdaptiveRight26_000Part09
import D1Bound5.SmallPairLightAdaptiveRight26_000Part10
import D1Bound5.SmallPairLightAdaptiveRight26_000Part11
import D1Bound5.SmallPairLightAdaptiveRight26_000Part12
import D1Bound5.SmallPairLightAdaptiveRight26_000Part13
import D1Bound5.SmallPairLightAdaptiveRight26_000Part14
import D1Bound5.SmallPairLightAdaptiveRight26_000Part15
import D1Bound5.SmallPairLightAdaptiveRight26_000Part16
import D1Bound5.SmallPairLightAdaptiveRight26_000Part17
import D1Bound5.SmallPairLightAdaptiveLeft26_000
import D1Bound5.SmallPairLightAdaptiveRight26_000
import Lean.Elab.Command
import Lean.Util.CollectAxioms

open Lean Elab Command
set_option maxRecDepth 100000

run_cmd do
  let names : List Name := [
    `D1Bound5.pairLightSelectedFloorPrefixBool_add,
    `D1Bound5.pairLightSelectedFloorPrefixBool_of_add,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part04_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part05_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part06_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part07_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part08_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part09_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part10_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part11_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part12_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part13_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part14_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part15_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part16_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part17_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part00_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part01_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part02_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part03_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part04_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part05_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part06_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part07_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part08_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part09_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part10_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part11_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part12_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part13_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part14_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part15_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part16_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part17_checked,
    `D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_checked,
    `D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_checked]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Name).contains n
    unless bad.isEmpty do
      throwError "Unexpected axioms in {name}: {bad}"
    logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"

#check @D1Bound5.pairLightSelectedFloorPrefixBool_add
#check @D1Bound5.pairLightSelectedFloorPrefixBool_of_add
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part00_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part01_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part02_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part03_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part04_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part05_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part06_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part07_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part08_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part09_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part10_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part11_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part12_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part13_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part14_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part15_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part16_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part17_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part00_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part01_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part02_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part03_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part04_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part05_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part06_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part07_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part08_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part09_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part10_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part11_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part12_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part13_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part14_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part15_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part16_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part17_checked
#check @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_checked
#check @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_checked

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

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 0) (leftRows000.drop 0) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part00_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 3) (leftRows000.drop 3) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part01_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 6) (leftRows000.drop 6) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part02_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 9) (leftRows000.drop 9) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part03_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 12) (leftRows000.drop 12) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part04_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 15) (leftRows000.drop 15) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part05_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 18) (leftRows000.drop 18) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part06_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 21) (leftRows000.drop 21) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part07_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 24) (leftRows000.drop 24) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part08_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 27) (leftRows000.drop 27) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part09_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 30) (leftRows000.drop 30) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part10_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 33) (leftRows000.drop 33) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part11_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 36) (leftRows000.drop 36) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part12_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 39) (leftRows000.drop 39) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part13_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 42) (leftRows000.drop 42) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part14_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 45) (leftRows000.drop 45) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part15_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 48) (leftRows000.drop 48) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part16_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (leftCached000.drop 51) (leftRows000.drop 51) = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_part17_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 0) (rightRows000.drop 0) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part00_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 3) (rightRows000.drop 3) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part01_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 6) (rightRows000.drop 6) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part02_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 9) (rightRows000.drop 9) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part03_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 12) (rightRows000.drop 12) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part04_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 15) (rightRows000.drop 15) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part05_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 18) (rightRows000.drop 18) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part06_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 21) (rightRows000.drop 21) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part07_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 24) (rightRows000.drop 24) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part08_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 27) (rightRows000.drop 27) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part09_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 30) (rightRows000.drop 30) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part10_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 33) (rightRows000.drop 33) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part11_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 36) (rightRows000.drop 36) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part12_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 39) (rightRows000.drop 39) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part13_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 42) (rightRows000.drop 42) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part14_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 45) (rightRows000.drop 45) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part15_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 48) (rightRows000.drop 48) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part16_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 3
      (rightCached000.drop 51) (rightRows000.drop 51) = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_part17_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 54
      leftCached000 leftRows000 = true := @D1Bound5.PairLightAdaptivePrepared26.left_prefix_000_checked

example :
    pairLightSelectedFloorPrefixBool 1 1 PairLightPrepared26.sieve 54
      rightCached000 rightRows000 = true := @D1Bound5.PairLightAdaptivePrepared26.right_prefix_000_checked

-- Exact source-list extents and index-pair count, for reporting only.
example : leftCached000.length = 761 ∧ leftRows000.length = 761 ∧
    rightCached000.length = 761 ∧ rightRows000.length = 761 := by decide +kernel
example : (54 : Nat) * (2*761-54-1) / 2 = 39609 := by decide +kernel
