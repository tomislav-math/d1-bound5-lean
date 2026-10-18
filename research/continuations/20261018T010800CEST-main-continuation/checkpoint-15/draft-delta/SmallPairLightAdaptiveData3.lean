import D1Bound5.SmallPairLightData3
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared3
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared3.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared3.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 112
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 112

def leftCached002 : List PairLightCachedVertex := leftCached001.drop 199
def leftRows002 : List (Nat × List Nat) := leftRows001.drop 199

def leftCached003 : List PairLightCachedVertex := leftCached002.drop 102
def leftRows003 : List (Nat × List Nat) := leftRows002.drop 102

def rightCached000 : List PairLightCachedVertex := PairLightPrepared3.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared3.rightRows

def rightCached001 : List PairLightCachedVertex := rightCached000.drop 111
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 111

def rightCached002 : List PairLightCachedVertex := rightCached001.drop 195
def rightRows002 : List (Nat × List Nat) := rightRows001.drop 195

def rightCached003 : List PairLightCachedVertex := rightCached002.drop 108
def rightRows003 : List (Nat × List Nat) := rightRows002.drop 108


end D1Bound5.PairLightAdaptivePrepared3
