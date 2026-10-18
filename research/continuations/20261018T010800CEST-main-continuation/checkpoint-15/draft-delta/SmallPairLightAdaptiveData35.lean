import D1Bound5.SmallPairLightData35
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared35
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared35.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared35.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 132
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 132

def leftCached002 : List PairLightCachedVertex := leftCached001.drop 237
def leftRows002 : List (Nat × List Nat) := leftRows001.drop 237

def rightCached000 : List PairLightCachedVertex := PairLightPrepared35.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared35.rightRows

def rightCached001 : List PairLightCachedVertex := rightCached000.drop 132
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 132

def rightCached002 : List PairLightCachedVertex := rightCached001.drop 236
def rightRows002 : List (Nat × List Nat) := rightRows001.drop 236


end D1Bound5.PairLightAdaptivePrepared35
