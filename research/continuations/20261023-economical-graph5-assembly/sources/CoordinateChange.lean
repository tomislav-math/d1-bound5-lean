import D1Bound5.Coordinates

namespace D1Bound5.QuadInt

/-- Sending the new generator to omega-k changes its trace by 2k.
This is an isomorphism of the entire coordinate ring. -/
def shift (tau nu k : ℤ) :
    QuadInt (tau-2*k) (nu-tau*k+k^2) ≃+* QuadInt tau nu where
  toFun z := ⟨z.re-k*z.im,z.im⟩
  invFun z := ⟨z.re+k*z.im,z.im⟩
  left_inv z := by ext <;> simp
  right_inv z := by ext <;> simp
  map_add' z w := by ext <;> simp; ring
  map_mul' z w := by ext <;> simp <;> ring

/-- Integral translation leaves the discriminant unchanged. -/
theorem discriminant_shift (tau nu k : ℤ) :
    discriminant (tau-2*k) (nu-tau*k+k^2) = discriminant tau nu := by
  unfold discriminant
  ring

end D1Bound5.QuadInt
