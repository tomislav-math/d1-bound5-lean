import D1Bound5.SmallPairLightData18
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared18
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared18.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared18.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 262
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 262

def rightCached000 : List PairLightCachedVertex := PairLightPrepared18.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared18.rightRows

def rightCached001 : List PairLightCachedVertex := rightCached000.drop 262
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 262


end D1Bound5.PairLightAdaptivePrepared18
