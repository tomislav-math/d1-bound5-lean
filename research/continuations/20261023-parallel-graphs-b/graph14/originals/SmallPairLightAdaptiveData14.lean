import D1Bound5.SmallPairLightData14
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared14
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared14.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared14.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 88
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 88

def leftCached002 : List PairLightCachedVertex := leftCached001.drop 114
def leftRows002 : List (Nat × List Nat) := leftRows001.drop 114

def leftCached003 : List PairLightCachedVertex := leftCached002.drop 217
def leftRows003 : List (Nat × List Nat) := leftRows002.drop 217

def leftCached004 : List PairLightCachedVertex := leftCached003.drop 76
def leftRows004 : List (Nat × List Nat) := leftRows003.drop 76

def rightCached000 : List PairLightCachedVertex := PairLightPrepared14.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared14.rightRows

def rightCached001 : List PairLightCachedVertex := rightCached000.drop 88
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 88

def rightCached002 : List PairLightCachedVertex := rightCached001.drop 114
def rightRows002 : List (Nat × List Nat) := rightRows001.drop 114

def rightCached003 : List PairLightCachedVertex := rightCached002.drop 215
def rightRows003 : List (Nat × List Nat) := rightRows002.drop 215

def rightCached004 : List PairLightCachedVertex := rightCached003.drop 79
def rightRows004 : List (Nat × List Nat) := rightRows003.drop 79


end D1Bound5.PairLightAdaptivePrepared14
