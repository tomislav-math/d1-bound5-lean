import D1Bound5.SmallPairLightData21
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared21
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared21.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared21.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 82
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 82

def leftCached002 : List PairLightCachedVertex := leftCached001.drop 102
def leftRows002 : List (Nat × List Nat) := leftRows001.drop 102

def leftCached003 : List PairLightCachedVertex := leftCached002.drop 151
def leftRows003 : List (Nat × List Nat) := leftRows002.drop 151

def leftCached004 : List PairLightCachedVertex := leftCached003.drop 189
def leftRows004 : List (Nat × List Nat) := leftRows003.drop 189

def rightCached000 : List PairLightCachedVertex := PairLightPrepared21.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared21.rightRows

def rightCached001 : List PairLightCachedVertex := rightCached000.drop 82
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 82

def rightCached002 : List PairLightCachedVertex := rightCached001.drop 102
def rightRows002 : List (Nat × List Nat) := rightRows001.drop 102

def rightCached003 : List PairLightCachedVertex := rightCached002.drop 151
def rightRows003 : List (Nat × List Nat) := rightRows002.drop 151

def rightCached004 : List PairLightCachedVertex := rightCached003.drop 189
def rightRows004 : List (Nat × List Nat) := rightRows003.drop 189


end D1Bound5.PairLightAdaptivePrepared21
