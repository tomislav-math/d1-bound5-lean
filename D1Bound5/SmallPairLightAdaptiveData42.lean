import D1Bound5.SmallPairLightData42
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared42
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared42.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared42.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 242
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 242

def rightCached000 : List PairLightCachedVertex := PairLightPrepared42.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared42.rightRows

def rightCached001 : List PairLightCachedVertex := rightCached000.drop 242
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 242


end D1Bound5.PairLightAdaptivePrepared42
