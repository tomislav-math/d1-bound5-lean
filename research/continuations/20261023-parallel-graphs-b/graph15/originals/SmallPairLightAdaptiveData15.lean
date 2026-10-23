import D1Bound5.SmallPairLightData15
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared15
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared15.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared15.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 92
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 92

def leftCached002 : List PairLightCachedVertex := leftCached001.drop 122
def leftRows002 : List (Nat × List Nat) := leftRows001.drop 122

def leftCached003 : List PairLightCachedVertex := leftCached002.drop 267
def leftRows003 : List (Nat × List Nat) := leftRows002.drop 267

def rightCached000 : List PairLightCachedVertex := PairLightPrepared15.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared15.rightRows

def rightCached001 : List PairLightCachedVertex := rightCached000.drop 92
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 92

def rightCached002 : List PairLightCachedVertex := rightCached001.drop 122
def rightRows002 : List (Nat × List Nat) := rightRows001.drop 122

def rightCached003 : List PairLightCachedVertex := rightCached002.drop 266
def rightRows003 : List (Nat × List Nat) := rightRows002.drop 266


end D1Bound5.PairLightAdaptivePrepared15
