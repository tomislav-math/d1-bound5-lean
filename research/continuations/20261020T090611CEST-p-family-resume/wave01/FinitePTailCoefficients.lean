import D1Bound5.FinitePResidualIdentity
import D1Bound5.FinitePMonomial

namespace D1Bound5

attribute [local simp] Matrix.cons_val_two Matrix.cons_val_three

/-- Signed coefficient, power of the root anchor, power of the other
anchor. Zero padding keeps each coefficient a sum over Fin3. -/
def finitePTailCoeffTerms : Fin 2 → Fin 2 → Fin 3 → Fin 3 → ℤ × ℕ × ℕ :=
  ![![![![(7,2,0),(-35,1,1),(0,0,0)],
        ![(64,3,0),(-140,2,1),(0,0,0)],
        ![(72,4,0),(-120,3,1),(0,0,0)]],
      ![![(35,1,1),(-7,2,0),(0,0,0)],
        ![(140,2,1),(-64,3,0),(0,0,0)],
        ![(120,3,1),(-72,4,0),(0,0,0)]]],
    ![![![(-15,3,0),(56,2,1),(-105,1,2)],
        ![(-180,4,0),(512,3,1),(-420,2,2)],
        ![(-240,5,0),(576,4,1),(-360,3,2)]],
      ![![(70,2,1),(-6,3,0),(0,0,0)],
        ![(100,3,1),(-12,4,0),(0,0,0)],
        ![(24,5,0),(0,0,0),(0,0,0)]]]]

def finitePTailCoeffWeight (kind side : Fin 2) (l : Fin 3) : ℕ :=
  ∑ t : Fin 3, (finitePTailCoeffTerms kind side l t).1.natAbs

theorem finitePTailCoeffTerms_admissible (kind side : Fin 2) (l t : Fin 3) :
    (finitePTailCoeffTerms kind side l t).2.2 ≤ 2 ∧
      (finitePTailCoeffTerms kind side l t).2.1+
        (finitePTailCoeffTerms kind side l t).2.2 ≤ 3+(l : ℕ) := by
  fin_cases kind <;> fin_cases side <;> fin_cases l <;> fin_cases t <;> decide

theorem finitePTailCoeffWeight_sum (kind : Fin 2) :
    (∑ side : Fin 2, ∑ l : Fin 3, finitePTailCoeffWeight kind side l) =
      ![876,2676] kind := by
  fin_cases kind <;> decide

theorem finitePPairCoeff_eq_terms (u v : ℂ) (kind side : Fin 2) (l : Fin 3) :
    finitePPairCoeff u v kind side l =
      ∑ t : Fin 3, ((finitePTailCoeffTerms kind side l t).1 : ℂ)*
        (![u,v] side)^(finitePTailCoeffTerms kind side l t).2.1*
        (![v,u] side)^(finitePTailCoeffTerms kind side l t).2.2 := by
  fin_cases kind <;> fin_cases side <;> fin_cases l <;>
    simp [finitePPairCoeff,finitePRLeftCoeff,finitePRRightCoeff,
      finitePTLeftCoeff,finitePTRightCoeff,finitePTailCoeffTerms,Fin.sum_univ_succ] <;> ring

/-- Coefficient-height control with the exact reciprocal-anchor power
needed by its Taylor remainder, proved term by term from integer data. -/
theorem finitePPairCoeff_norm_le (u v : ℂ) (A S : ℝ)
    (hA1 : 1 ≤ A) (hAu : A ≤ ‖u‖) (hAv : A ≤ ‖v‖)
    (huS : ‖u‖ ≤ S) (hvS : ‖v‖ ≤ S)
    (kind side : Fin 2) (l : Fin 3) :
    ‖finitePPairCoeff u v kind side l‖ ≤
      (finitePTailCoeffWeight kind side l : ℝ)*(S^2/A^4)*
        ‖![u,v] side‖^(5+(l : ℕ)) := by
  let U := ‖![u,v] side‖
  let V := ‖![v,u] side‖
  have hAU : A ≤ U := by fin_cases side <;> assumption
  have hAV : A ≤ V := by fin_cases side <;> assumption
  have hUS : U ≤ S := by fin_cases side <;> assumption
  have hVS : V ≤ S := by fin_cases side <;> assumption
  have hU : 0 < U := by linarith only [hA1,hAU]
  have ht (t : Fin 3) :
      ‖((finitePTailCoeffTerms kind side l t).1 : ℂ)*
        (![u,v] side)^(finitePTailCoeffTerms kind side l t).2.1*
        (![v,u] side)^(finitePTailCoeffTerms kind side l t).2.2‖ ≤
      ((finitePTailCoeffTerms kind side l t).1.natAbs : ℝ)*
        (S^2/A^4)*U^(5+(l : ℕ)) := by
    let m := finitePTailCoeffTerms kind side l t
    have hadm := finitePTailCoeffTerms_admissible kind side l t
    have hq := finiteP_monomial_bound A S U V 4 (5+(l : ℕ)) m.2.1 m.2.2
      hA1 hAU hAV hUS hVS hadm.1 (by dsimp [m]; omega)
    have hm := (div_le_iff₀ (pow_pos hU _)).mp hq
    have hn : ‖(m.1 : ℂ)‖ = (m.1.natAbs : ℝ) := by simp
    change ‖(m.1 : ℂ)*(![u,v] side)^m.2.1*(![v,u] side)^m.2.2‖ ≤ _
    simp only [norm_mul,norm_pow,hn]
    have hh := mul_le_mul_of_nonneg_left hm (show 0 ≤ (m.1.natAbs : ℝ) by positivity)
    simpa only [U, V, mul_assoc] using hh
  rw [finitePPairCoeff_eq_terms]
  calc
    _ ≤ ∑ t : Fin 3, ‖((finitePTailCoeffTerms kind side l t).1 : ℂ)*
        (![u,v] side)^(finitePTailCoeffTerms kind side l t).2.1*
        (![v,u] side)^(finitePTailCoeffTerms kind side l t).2.2‖ := norm_sum_le _ _
    _ ≤ ∑ t : Fin 3, ((finitePTailCoeffTerms kind side l t).1.natAbs : ℝ)*
        (S^2/A^4)*U^(5+(l : ℕ)) := Finset.sum_le_sum (fun t _ => ht t)
    _ = _ := by simp [finitePTailCoeffWeight,Finset.sum_mul,Nat.cast_sum,U]

end D1Bound5
