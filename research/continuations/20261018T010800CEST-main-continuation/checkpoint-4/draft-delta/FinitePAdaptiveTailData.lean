import D1Bound5.FinitePResidualIdentity
import D1Bound5.FinitePHeight

namespace D1Bound5

/-- Power of A/B retained by a combined root-column coefficient after
removing its first reciprocal-anchor factor. -/
def finitePAdaptiveTailExponent (i : Fin 4) (l j t : Fin 3) : ℕ :=
  2+(if j=0 then 0 else 4+(l : ℕ))-
    ((finitePRootTerms i l j t).2.2.1+(finitePRootTerms i l j t).2.2.2)

def finitePAdaptiveTailWeight (i : Fin 4) (x : ℝ) : ℝ :=
  ∑ j : Fin 3, ∑ l : Fin 3, ∑ t : Fin 3,
    |((finitePRootTerms i l j t).1 : ℝ)|*x^(finitePAdaptiveTailExponent i l j t)

/-- The four positive polynomials are computed from the actual integer
coefficient lists after the H and V cancellations. -/
theorem finitePAdaptiveTailWeight_eq (i : Fin 4) (x : ℝ) :
    finitePAdaptiveTailWeight i x =
      ![295*x+143*x^2+143*x^4+295*x^5,
        590*(x+x^4+x^5),
        885+1144*x+435*x^2+42*x^3+170*x^4,
        885+1144*x+435*x^2+2634*x^3+170*x^4] i := by
  fin_cases i <;>
    norm_num [finitePAdaptiveTailWeight,finitePAdaptiveTailExponent,
      finitePRootTerms,Fin.sum_univ_succ] <;> ring

/-- Every concrete term meets the exponent inequalities used by the
adaptive scalar estimate. Zero padding also satisfies these inequalities. -/
theorem finitePAdaptiveTailExponent_certificate (i : Fin 4) (l j t : Fin 3) :
    let u := finitePRootTerms i l j t
    u.2.1+u.2.2.1+u.2.2.2+3 ≤ (4+(l : ℕ))+2 ∧
    (j=0 → finitePAdaptiveTailExponent i l j t+u.2.2.1+u.2.2.2=2) ∧
    (j=1 → finitePAdaptiveTailExponent i l j t+u.2.2.1+u.2.2.2=(4+(l : ℕ))+2 ∧
      u.2.2.2 ≤ 2) ∧
    (j=2 → finitePAdaptiveTailExponent i l j t+u.2.2.1+u.2.2.2=(4+(l : ℕ))+2) := by
  fin_cases i <;> fin_cases l <;> fin_cases j <;> fin_cases t <;>
    norm_num [finitePAdaptiveTailExponent,finitePRootTerms]

set_option maxHeartbeats 4000000 in
/-- Combine the actual Taylor tails before applying the triangle inequality.
In particular the shared s-column terms in H and V cancel here. -/
theorem finitePTail_eq_combined (a b s c : ℂ) (i : Fin 4) :
    finitePTail a b s c i =
      ∑ j : Fin 3, ∑ l : Fin 3, ![a,b,s] j*finitePRootCoeff a b s i l j*c^(l : ℕ)*
        finiteQHalfRemainder (6+(l : ℕ)) (1/(![a,b,s] j*c)) := by
  fin_cases i
  all_goals
    norm_num [finitePTail,finitePPairTail,finitePRootCoeff,finitePRootTerms,
      finitePTermValue,finitePPairCoeff,finitePRLeftCoeff,finitePRRightCoeff,
      finitePTLeftCoeff,finitePTRightCoeff,Fin.sum_univ_succ]
    <;> ring

end D1Bound5
