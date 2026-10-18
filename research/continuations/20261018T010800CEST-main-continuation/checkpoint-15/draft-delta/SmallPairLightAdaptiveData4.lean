import D1Bound5.SmallPairLightData4
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared4
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared4.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared4.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 71
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 71

def leftCached002 : List PairLightCachedVertex := leftCached001.drop 82
def leftRows002 : List (Nat × List Nat) := leftRows001.drop 82

def leftCached003 : List PairLightCachedVertex := leftCached002.drop 102
def leftRows003 : List (Nat × List Nat) := leftRows002.drop 102

def leftCached004 : List PairLightCachedVertex := leftCached003.drop 150
def leftRows004 : List (Nat × List Nat) := leftRows003.drop 150

def leftCached005 : List PairLightCachedVertex := leftCached004.drop 191
def leftRows005 : List (Nat × List Nat) := leftRows004.drop 191

def rightCached000 : List PairLightCachedVertex := PairLightPrepared4.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared4.rightRows

def rightCached001 : List PairLightCachedVertex := rightCached000.drop 71
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 71

def rightCached002 : List PairLightCachedVertex := rightCached001.drop 82
def rightRows002 : List (Nat × List Nat) := rightRows001.drop 82

def rightCached003 : List PairLightCachedVertex := rightCached002.drop 102
def rightRows003 : List (Nat × List Nat) := rightRows002.drop 102

def rightCached004 : List PairLightCachedVertex := rightCached003.drop 150
def rightRows004 : List (Nat × List Nat) := rightRows003.drop 150

def rightCached005 : List PairLightCachedVertex := rightCached004.drop 191
def rightRows005 : List (Nat × List Nat) := rightRows004.drop 191


end D1Bound5.PairLightAdaptivePrepared4
