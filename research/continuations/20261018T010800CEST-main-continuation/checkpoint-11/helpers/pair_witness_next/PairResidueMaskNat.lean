import D1Bound5.PairCachedResidues

namespace D1Bound5

/-- The existing coordinate mask with natural-number polynomial arithmetic
and one final reduction per coordinate. The two integer parameters are still
represented by their exact residues. All natural inputs are permitted, even
when they are not reduced or do not come from a valid cached signature. -/
def pairResidueMaskNatBool (tau nu : ℤ) (k mask : ℕ) (u v : ℕ × ℕ) : Bool :=
  let p := k + 1
  let nn := (-(nu : ZMod p)).val
  let tt := (tau : ZMod p).val
  let real := (u.1 * v.1 + nn * u.2 * v.2 + 1) % p
  let imag := (u.1 * v.2 + u.2 * v.1 + tt * u.2 * v.2) % p
  mask.testBit (real * p + imag)

/-- Exact equality with the accepted cached mask predicate for every input.
No signature validity, residue bound, mask validity, or discriminant premise
is needed. In particular, modulus one is included. -/
theorem pairResidueMaskNatBool_eq (tau nu : ℤ) (k mask : ℕ) (u v : ℕ × ℕ) :
    pairResidueMaskNatBool tau nu k mask u v = pairResidueMaskBool tau nu k mask u v := by
  have hre :
      (u.1 * v.1 + (-(nu : ZMod (k + 1))).val * u.2 * v.2 + 1) % (k + 1) =
        ((u.1 : ZMod (k + 1)) * (v.1 : ZMod (k + 1)) +
          (-(nu : ZMod (k + 1))) * (u.2 : ZMod (k + 1)) * (v.2 : ZMod (k + 1)) + 1).val := by
    rw [← ZMod.val_natCast]
    simp only [Nat.cast_add, Nat.cast_mul, Nat.cast_one, ZMod.natCast_zmod_val]
  have him :
      (u.1 * v.2 + u.2 * v.1 + (tau : ZMod (k + 1)).val * u.2 * v.2) % (k + 1) =
        ((u.1 : ZMod (k + 1)) * (v.2 : ZMod (k + 1)) +
          (u.2 : ZMod (k + 1)) * (v.1 : ZMod (k + 1)) +
          (tau : ZMod (k + 1)) * (u.2 : ZMod (k + 1)) * (v.2 : ZMod (k + 1))).val := by
    rw [← ZMod.val_natCast]
    simp only [Nat.cast_add, Nat.cast_mul, ZMod.natCast_zmod_val]
  dsimp only [pairResidueMaskNatBool, pairResidueMaskBool]
  rw [hre, him]

end D1Bound5
