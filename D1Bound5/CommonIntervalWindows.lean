import D1Bound5.AllLargeWindows

namespace D1Bound5

noncomputable def commonWindowN2 (A B C M R : ℝ) : ℝ × ℝ :=
  (4*M^2*B^8*C^5/(1-1/4000 : ℝ),A^6*C^7/(4*R^2*B^4*(1+1/4000 : ℝ)))
noncomputable def commonWindowN3 (A B C M R : ℝ) : ℝ × ℝ :=
  (4*M^2*B^14*C^7/(1-1/4000 : ℝ),A^8*C^11/(4*R^2*B^6*(1+1/4000 : ℝ)))
noncomputable def commonWindowA3 (A B C M R : ℝ) : ℝ × ℝ :=
  (4*M^2*B^12*C^7/(1-1/4000 : ℝ),A^8*C^9/(4*R^2*B^6*(1+1/4000 : ℝ)))
noncomputable def commonWindowA4 (A B C M R : ℝ) : ℝ × ℝ :=
  (4*M^2*B^18*C^9/(1-1/4000 : ℝ),A^10*C^13/(4*R^2*B^8*(1+1/4000 : ℝ)))
noncomputable def commonWindowA5 (A B C M R : ℝ) : ℝ × ℝ :=
  (4*M^2*B^24*C^11/(1-1/4000 : ℝ),A^12*C^17/(4*R^2*B^10*(1+1/4000 : ℝ)))
noncomputable def commonWindowP (A B S C R : ℝ) : ℝ × ℝ :=
  (4*2400^2*(max (B*S^3) (B^3*S^2))^2*C^5/(1-1/4000 : ℝ),
    A^6*C^9/(4*R^2*S^4*(1+1/4000 : ℝ)))

/-- The exact sixteen numerical comparisons. They are supplied by
independently checked rational records for each application, not assumed
as analytic bounds for the approximation families. -/
def CommonOverlapBounds (A B S G rho K0 M2 Mn M3 M4 M5 Mbs R2 Rn R3 R4 R5 Rp : ℝ) : Prop :=
  1 < (1024*K0^4*(1-1/4000 : ℝ)/12100)*(A^10*B^10) ∧
  1 < (256*K0^2/(36*M2^2*(4001/3999 : ℝ)))*(A^8*S^4) ∧
  1 < (G^2/(16*R2^2*2400^2*(4001/3999 : ℝ)))*(A^20*B^4) ∧
  1 < (G^2/(16*R2^2*2400^2*(4001/3999 : ℝ)))*(A^20*S^2) ∧
  1 < (G^2/(16*Rp^2*Mn^2*(4001/3999 : ℝ)))*(A^20) ∧
  1 < (G^2/(16*Rp^2*M3^2*(4001/3999 : ℝ)))*(A^20) ∧
  1 < (G^4/(16*R3^2*((8/9 : ℝ)*608^2)^2*(4001/3999 : ℝ)))*(A^36) ∧
  1 < (G^4/(16*(3920/81 : ℝ)^2*Mn^2*(4001/3999 : ℝ)))*(A^34*B^2*S^2) ∧
  1 < (G^2/(16*Rn^2*M4^2*(4001/3999 : ℝ)))*(A^22*B^4) ∧
  1 < (G^4/(16*Rn^2*Mbs^2*(4001/3999 : ℝ)))*(A^36*B^8) ∧
  1 < (rho^2/(16*M4^2*(4001/3999 : ℝ)))*A^14 ∧
  1 < (G^4/(144*R4^2*42^8*(4001/3999 : ℝ)))*(A^38*B^2) ∧
  1 < (G^4/(4*M5^2*(5/2 : ℝ)^8*(4001/3999 : ℝ)))*(A^36) ∧
  1 < (G^6/(144*R5^2*42^10*(4001/3999 : ℝ)))*(A^54*B^10) ∧
  1 < (G^6/(36*42^12*(5/2 : ℝ)^10*(4001/3999 : ℝ)))*(A^52*B^4) ∧
  1 < (G/(105))*(A^8*B*S^3)

end D1Bound5
