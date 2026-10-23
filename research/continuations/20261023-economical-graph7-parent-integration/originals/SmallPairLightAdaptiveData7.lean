import D1Bound5.SmallPairLightData7
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared7
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared7.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared7.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 105
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 105

def leftCached002 : List PairLightCachedVertex := leftCached001.drop 163
def leftRows002 : List (Nat × List Nat) := leftRows001.drop 163

def leftCached003 : List PairLightCachedVertex := leftCached002.drop 164
def leftRows003 : List (Nat × List Nat) := leftRows002.drop 164

def rightCached000 : List PairLightCachedVertex := PairLightPrepared7.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared7.rightRows

def rightCached001 : List PairLightCachedVertex := rightCached000.drop 106
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 106

def rightCached002 : List PairLightCachedVertex := rightCached001.drop 166
def rightRows002 : List (Nat × List Nat) := rightRows001.drop 166

def rightCached003 : List PairLightCachedVertex := rightCached002.drop 158
def rightRows003 : List (Nat × List Nat) := rightRows002.drop 158


end D1Bound5.PairLightAdaptivePrepared7
