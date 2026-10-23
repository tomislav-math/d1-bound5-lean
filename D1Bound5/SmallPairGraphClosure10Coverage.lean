import D1Bound5.SmallPairGraphWitnessData10
import D1Bound5.PairClosureIndexedChunks

namespace D1Bound5.PairGraphPrepared10
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 0

theorem indexed_coverage_checked :
    decide (anchorRoot * anchorRoot = smallPairA_10 * smallPairB_10 + 1 ∧
      witnesses.map PairRootWitness.vertex = smallPairClosure_10) = true := by
  have hzip {α β : Type} (xs : List α) (ys : List β)
      (hlen : xs.length ≤ ys.length) :
      List.zipWith (fun x _ => x) xs ys = xs := by
    induction xs generalizing ys with
    | nil => rfl
    | cons x xs ih =>
      cases ys with
      | nil => simp at hlen
      | cons y ys =>
        exact congrArg (List.cons x) (ih ys (Nat.le_of_succ_le_succ hlen))
  apply decide_eq_true
  constructor
  · decide +kernel
  · unfold witnesses
    rw [List.map_zipWith]
    change List.zipWith (fun (z : QuadInt 0 1) (_ : QuadInt 0 1 × QuadInt 0 1) => z)
      smallPairClosure_10 rootPairs = smallPairClosure_10
    exact hzip smallPairClosure_10 rootPairs (by decide +kernel)

end D1Bound5.PairGraphPrepared10
