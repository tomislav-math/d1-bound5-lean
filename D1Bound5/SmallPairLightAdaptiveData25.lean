import D1Bound5.SmallPairLightData25
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared25
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared25.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared25.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 126
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 126

def leftCached002 : List PairLightCachedVertex := leftCached001.drop 254
def leftRows002 : List (Nat × List Nat) := leftRows001.drop 254

def rightCached000 : List PairLightCachedVertex := PairLightPrepared25.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared25.rightRows

def rightCached001 : List PairLightCachedVertex := rightCached000.drop 125
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 125

def rightCached002 : List PairLightCachedVertex := rightCached001.drop 256
def rightRows002 : List (Nat × List Nat) := rightRows001.drop 256


end D1Bound5.PairLightAdaptivePrepared25
