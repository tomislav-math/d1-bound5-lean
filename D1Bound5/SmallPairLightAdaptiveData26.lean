import D1Bound5.SmallPairLightData26
import D1Bound5.PairLightArithmeticChunks

namespace D1Bound5.PairLightAdaptivePrepared26
set_option maxRecDepth 100000
set_option maxHeartbeats 0

def leftCached000 : List PairLightCachedVertex := PairLightPrepared26.leftCached
def leftRows000 : List (Nat × List Nat) := PairLightPrepared26.leftRows

def leftCached001 : List PairLightCachedVertex := leftCached000.drop 54
def leftRows001 : List (Nat × List Nat) := leftRows000.drop 54

def leftCached002 : List PairLightCachedVertex := leftCached001.drop 59
def leftRows002 : List (Nat × List Nat) := leftRows001.drop 59

def leftCached003 : List PairLightCachedVertex := leftCached002.drop 65
def leftRows003 : List (Nat × List Nat) := leftRows002.drop 65

def leftCached004 : List PairLightCachedVertex := leftCached003.drop 73
def leftRows004 : List (Nat × List Nat) := leftRows003.drop 73

def leftCached005 : List PairLightCachedVertex := leftCached004.drop 85
def leftRows005 : List (Nat × List Nat) := leftRows004.drop 85

def leftCached006 : List PairLightCachedVertex := leftCached005.drop 107
def leftRows006 : List (Nat × List Nat) := leftRows005.drop 107

def leftCached007 : List PairLightCachedVertex := leftCached006.drop 173
def leftRows007 : List (Nat × List Nat) := leftRows006.drop 173

def leftCached008 : List PairLightCachedVertex := leftCached007.drop 145
def leftRows008 : List (Nat × List Nat) := leftRows007.drop 145

def rightCached000 : List PairLightCachedVertex := PairLightPrepared26.rightCached
def rightRows000 : List (Nat × List Nat) := PairLightPrepared26.rightRows

def rightCached001 : List PairLightCachedVertex := rightCached000.drop 54
def rightRows001 : List (Nat × List Nat) := rightRows000.drop 54

def rightCached002 : List PairLightCachedVertex := rightCached001.drop 59
def rightRows002 : List (Nat × List Nat) := rightRows001.drop 59

def rightCached003 : List PairLightCachedVertex := rightCached002.drop 65
def rightRows003 : List (Nat × List Nat) := rightRows002.drop 65

def rightCached004 : List PairLightCachedVertex := rightCached003.drop 73
def rightRows004 : List (Nat × List Nat) := rightRows003.drop 73

def rightCached005 : List PairLightCachedVertex := rightCached004.drop 85
def rightRows005 : List (Nat × List Nat) := rightRows004.drop 85

def rightCached006 : List PairLightCachedVertex := rightCached005.drop 107
def rightRows006 : List (Nat × List Nat) := rightRows005.drop 107

def rightCached007 : List PairLightCachedVertex := rightCached006.drop 173
def rightRows007 : List (Nat × List Nat) := rightRows006.drop 173

def rightCached008 : List PairLightCachedVertex := rightCached007.drop 145
def rightRows008 : List (Nat × List Nat) := rightRows007.drop 145


end D1Bound5.PairLightAdaptivePrepared26
