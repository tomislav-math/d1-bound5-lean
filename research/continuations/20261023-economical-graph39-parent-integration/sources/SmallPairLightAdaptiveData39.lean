import D1Bound5.SmallPairLightData39
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared39
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared39.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared39.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 97
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 97

def leftCached002 : List PairLightCachedVertex := leftCached001.drop 136
def leftRows002 : List (Nat × List Nat) := leftRows001.drop 136

def leftCached003 : List PairLightCachedVertex := leftCached002.drop 225
def leftRows003 : List (Nat × List Nat) := leftRows002.drop 225

noncomputable
def rightCached000 : List PairLightCachedVertex := PairLightPrepared39.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared39.rightRows

noncomputable
def rightCached001 : List PairLightCachedVertex := rightCached000.drop 98
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 98

noncomputable
def rightCached002 : List PairLightCachedVertex := rightCached001.drop 138
def rightRows002 : List (Nat × List Nat) := rightRows001.drop 138

noncomputable
def rightCached003 : List PairLightCachedVertex := rightCached002.drop 220
def rightRows003 : List (Nat × List Nat) := rightRows002.drop 220


end D1Bound5.PairLightAdaptivePrepared39
