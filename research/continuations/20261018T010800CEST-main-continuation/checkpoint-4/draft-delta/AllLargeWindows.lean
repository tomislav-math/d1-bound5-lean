import D1Bound5.OrdinaryClosedIntervals

namespace D1Bound5

/-- The actual closed endpoints used in the all-large branch. Every
family receives its analytic exclusion in the final tuple assembly. -/
noncomputable def allLargeWindowQ (A T C : ℝ) : ℝ × ℝ :=
  (4*55^2*T^6*C^3/(1-1/4000 : ℝ), A^4*C^7/(9*T^2*(1+1/4000 : ℝ)))

noncomputable def allLargeWindowN2 (A B C : ℝ) : ℝ × ℝ :=
  (4*243^2*B^8*C^5/(1-1/4000 : ℝ), 4*A^6*C^7/(25*B^4*(1+1/4000 : ℝ)))

noncomputable def allLargeWindowP (A B S C : ℝ) : ℝ × ℝ :=
  (4*2400^2*(max (B*S^3) (B^3*S^2))^2*C^5/(1-1/4000 : ℝ),
    A^6*C^9/(36*S^4*(1+1/4000 : ℝ)))

noncomputable def allLargeWindowA3 (A B C : ℝ) : ℝ × ℝ :=
  (4*2265^2*B^12*C^7/(1-1/4000 : ℝ), 64*A^8*C^9/(1225*B^6*(1+1/4000 : ℝ)))

noncomputable def allLargeWindowM (A B S C : ℝ) : ℝ × ℝ :=
  (4*((8/9 : ℝ)*608^2)^2*B^6*S^16*C^5/(1-1/4000 : ℝ),
    A^6*C^11/(4*(3920/81 : ℝ)^2*B^4*S^10*(1+1/4000 : ℝ)))

noncomputable def allLargeWindowN3 (A B C : ℝ) : ℝ × ℝ :=
  (4*4143^2*B^14*C^7/(1-1/4000 : ℝ),
    256*A^8*C^11/(1225*B^6*(1+1/4000 : ℝ)))

noncomputable def allLargeWindowA4 (A B C : ℝ) : ℝ × ℝ :=
  (4*165763^2*B^18*C^9/(1-1/4000 : ℝ),
    16*A^10*C^13/(3969*B^8*(1+1/4000 : ℝ)))

noncomputable def allLargeWindowA5 (A B C : ℝ) : ℝ × ℝ :=
  (4*3113013^2*B^24*C^11/(1-1/4000 : ℝ),
    1024*A^12*C^17/(245025*B^10*(1+1/4000 : ℝ)))

theorem window_upper_lt_of_excluded (w : ℝ × ℝ) (D : ℝ)
    (hex : ¬ (w.1 ≤ D ∧ D ≤ w.2)) (hlo : w.1 ≤ D) : w.2 < D :=
  lt_of_not_ge (fun h => hex ⟨hlo,h⟩)

theorem window_overlap_of_ratio (l u q : ℝ) (hl : 0 < l)
    (heq : u/l=q) (hq : 1 < q) : l < u := by
  have hh : (1 : ℝ) < u/l := by rw [heq]; exact hq
  simpa only [one_mul] using (lt_div_iff₀ hl).mp hh

end D1Bound5
