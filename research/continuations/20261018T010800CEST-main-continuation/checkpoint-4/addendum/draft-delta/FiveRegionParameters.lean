import D1Bound5.FiniteN2RatioHeight
import D1Bound5.FiniteN3RatioHeight
import D1Bound5.FiniteA3RatioHeight
import D1Bound5.FiniteA4RatioHeight
import D1Bound5.FiniteA5RatioHeight
import D1Bound5.FinitePAdaptiveResidual
import D1Bound5.CoupledPhaseBounds

noncomputable section

namespace D1Bound5

def fiveRegionMinB : Fin 5 → ℝ := ![8,4,3,3,3]
def fiveRegionMinNorm : Fin 5 → ℝ := ![1,2,3,4,5]
def fiveRegionMaxA : Fin 5 → ℝ := ![1,3/2,7/4,2,17/6]
def fiveRegionFrontier : Fin 5 → ℝ := ![27/8,3,11/4,29/10,3]
def fiveRegionQ : Fin 5 → ℝ := ![8,8/3,12/7,3/2,18/17]
def fiveRegionPhase : Fin 5 → ℝ := ![269,368,540,637,1121]
def fiveRegionGap : Fin 5 → ℝ := ![7495,1771,598,624,375]
def fiveRegionCoupledGap : Fin 5 → ℝ := ![20687,7973,3226,3507,2217]
def fiveRegionPResidual : Fin 5 → ℝ := ![7/50,7/20,18/25,47/50,201/100]

def fiveRegionN2Residual (r : Fin 5) : ℝ := (101/2560)*(1+fiveRegionAnchorRatio r)^4
def fiveRegionN3Residual (r : Fin 5) : ℝ := (3535/409600)*(1+fiveRegionAnchorRatio r)^6
def fiveRegionA3Residual (r : Fin 5) : ℝ := (707/40960)*(1+fiveRegionAnchorRatio r)^6
def fiveRegionA4Residual (r : Fin 5) : ℝ := (6363/409600)*(1+fiveRegionAnchorRatio r)^8
def fiveRegionA5Residual (r : Fin 5) : ℝ := (9999/2621440)*(1+fiveRegionAnchorRatio r)^10

def fiveRegionTriangle (r : Fin 5) : ℝ := 2*(1+fiveRegionAnchorRatio r)^2
def fiveRegionRetained (r : Fin 5) : ℝ :=
  (9999/10000 : ℝ)*(200/19)^2*(fiveRegionFrontier r)^5*
    (1-(51051/400000 : ℝ)*fiveRegionTriangle r/(fiveRegionMinB r)^2)^2

/-- The five norm alternatives, before any approximation or interval result. -/
def FiveRegionCase (r : Fin 5) (A B : ℝ) : Prop :=
  (if r=4 then 5 ≤ A^2 else A^2=fiveRegionMinNorm r) ∧ fiveRegionMinB r ≤ B

theorem fiveRegion_Q_reciprocal (r : Fin 5) : 1/fiveRegionQ r=fiveRegionAnchorRatio r := by
  fin_cases r <;> norm_num [fiveRegionQ,fiveRegionAnchorRatio]

theorem fiveRegion_parameters (r : Fin 5) :
    3 ≤ fiveRegionMinB r ∧ 1 ≤ fiveRegionMinNorm r ∧
    2 < fiveRegionFrontier r ∧ 1 ≤ fiveRegionQ r ∧
    0 < fiveRegionGap r ∧ 0 < fiveRegionCoupledGap r ∧
    0 < fiveRegionPhase r ∧ 0 < fiveRegionPResidual r ∧
    0 < fiveRegionTriangle r ∧
    (51051/400000 : ℝ)*fiveRegionTriangle r/(fiveRegionMinB r)^2 < 1 ∧
    fiveRegionGap r < fiveRegionRetained r/(fiveRegionTriangle r)^2 ∧
    fiveRegionCoupledGap r < fiveRegionRetained r/((3535/409600 : ℝ)*fiveRegionPhase r) ∧
    finitePAdaptiveRate (1/fiveRegionQ r) < fiveRegionPResidual r ∧
    CoupledPhaseRow (fiveRegionQ r) (fiveRegionPhase r) := by
  fin_cases r <;> norm_num [fiveRegionMinB,fiveRegionMinNorm,fiveRegionFrontier,
    fiveRegionQ,fiveRegionGap,fiveRegionCoupledGap,fiveRegionPhase,fiveRegionPResidual,
    fiveRegionTriangle,fiveRegionRetained,fiveRegionAnchorRatio,finitePAdaptiveRate,CoupledPhaseRow]

theorem fiveRegion_case_bounds (r : Fin 5) (A B : ℝ)
    (hA0 : 0 ≤ A) (hA8 : A^2 ≤ 8) (hc : FiveRegionCase r A B) :
    fiveRegionMinNorm r ≤ A^2 ∧ A ≤ fiveRegionMaxA r ∧
      fiveRegionMinB r ≤ B ∧ 3 ≤ B ∧
      fiveRegionQ r*A ≤ B ∧ A ≤ fiveRegionAnchorRatio r*B := by
  have hN : fiveRegionMinNorm r ≤ A^2 := by
    fin_cases r <;> norm_num [FiveRegionCase,fiveRegionMinNorm] at hc ⊢
    all_goals first | exact hc.1.ge | exact hc.1
  have hupper : A ≤ fiveRegionMaxA r := by
    fin_cases r <;> norm_num [FiveRegionCase,fiveRegionMinNorm,fiveRegionMaxA] at hc ⊢
    all_goals rcases hc with ⟨hN,hB⟩
    all_goals nlinarith only [hA0,hA8,hN]
  have hB : fiveRegionMinB r ≤ B := hc.2
  have hB3 : 3 ≤ B := (fiveRegion_parameters r).1.trans hB
  have hqA : fiveRegionQ r*A ≤ B := by
    fin_cases r <;> norm_num [fiveRegionMaxA,fiveRegionMinB,fiveRegionQ] at hupper hB ⊢
    all_goals linarith only [hupper,hB]
  have hq0 : 0 < fiveRegionQ r := lt_of_lt_of_le (by norm_num) (fiveRegion_parameters r).2.2.2.1
  refine ⟨hN,hupper,hB,hB3,hqA,?_⟩
  rw [← fiveRegion_Q_reciprocal]
  calc
    A ≤ B/fiveRegionQ r := (le_div_iff₀ hq0).mpr (by simpa only [mul_comm] using hqA)
    _ = (1/fiveRegionQ r)*B := by ring

end D1Bound5
