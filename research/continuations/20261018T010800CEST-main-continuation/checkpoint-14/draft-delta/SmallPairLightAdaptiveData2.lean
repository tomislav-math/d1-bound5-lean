import D1Bound5.SmallPairLightData2
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared2
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared2.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared2.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 207
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 207

def rightCached000 : List PairLightCachedVertex := PairLightPrepared2.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared2.rightRows

def rightCached001 : List PairLightCachedVertex := rightCached000.drop 207
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 207


end D1Bound5.PairLightAdaptivePrepared2
