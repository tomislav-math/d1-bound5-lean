import D1Bound5.SmallPairLightData44
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared44
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared44.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared44.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 220
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 220

def rightCached000 : List PairLightCachedVertex := PairLightPrepared44.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared44.rightRows

def rightCached001 : List PairLightCachedVertex := rightCached000.drop 220
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 220


end D1Bound5.PairLightAdaptivePrepared44
