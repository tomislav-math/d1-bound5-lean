import D1Bound5.FastSquareTest

namespace D1Bound5

/-- The same mask obligation as CoordinateSquareMaskValid, evaluated by
plain integer arithmetic and two List.range traversals. This avoids
constructing a nested finite-universal proof over ZMod for every mask. -/
def coordinateSquareMaskRowCheck (tau nu : ℤ) (k mask x : ℕ) : Bool :=
  (List.range (k+1)).all fun y =>
    mask.testBit
      (((((x : ℤ)*(x : ℤ)-nu*(y : ℤ)*(y : ℤ)) % (k+1 : ℕ)).toNat)*(k+1)+
        (((x : ℤ)*(y : ℤ)+(y : ℤ)*(x : ℤ)+tau*(y : ℤ)*(y : ℤ)) %
          (k+1 : ℕ)).toNat)

def coordinateSquareMaskCheck (tau nu : ℤ) (k mask : ℕ) : Bool :=
  (List.range (k+1)).all fun x => coordinateSquareMaskRowCheck tau nu k mask x

/-- Every accepted integer residue check proves the original modular
mask validity. The modulus is positive, all residue pairs are covered,
and the zero square remains included. -/
theorem coordinateSquareMaskCheck_sound (tau nu : ℤ) (k mask : ℕ)
    (h : coordinateSquareMaskCheck tau nu k mask = true) :
    CoordinateSquareMaskValid tau nu k mask := by
  intro x y
  have hx : x.val ∈ List.range (k+1) := List.mem_range.mpr x.val_lt
  have hy : y.val ∈ List.range (k+1) := List.mem_range.mpr y.val_lt
  have hrow := List.all_eq_true.mp h x.val hx
  have hxy := List.all_eq_true.mp hrow y.val hy
  have val_cast (z : ℤ) : (z : ZMod (k+1)).val = (z % (k+1 : ℕ)).toNat := by
    simpa only [Int.toNat_natCast] using
      congrArg Int.toNat (ZMod.val_intCast (n := k+1) z)
  have hxcast : ((x.val : ℤ) : ZMod (k+1)) = x := by
    simp only [Int.cast_natCast,ZMod.natCast_zmod_val]
  have hycast : ((y.val : ℤ) : ZMod (k+1)) = y := by
    simp only [Int.cast_natCast,ZMod.natCast_zmod_val]
  have hre : (x*x+(-(nu : ZMod (k+1)))*y*y).val =
      ((((x.val : ℤ)*(x.val : ℤ)-nu*(y.val : ℤ)*(y.val : ℤ)) %
        (k+1 : ℕ)).toNat) := by
    rw [←val_cast]
    congr 1
    simp only [Int.cast_sub,Int.cast_mul,hxcast,hycast]
    ring
  have him : (x*y+y*x+(tau : ZMod (k+1))*y*y).val =
      ((((x.val : ℤ)*(y.val : ℤ)+(y.val : ℤ)*(x.val : ℤ)+
        tau*(y.val : ℤ)*(y.val : ℤ)) % (k+1 : ℕ)).toNat) := by
    rw [←val_cast]
    congr 1
    simp only [Int.cast_add,Int.cast_mul,hxcast,hycast]
  rw [hre,him]
  exact hxy

end D1Bound5

namespace D1Bound5

theorem coordinateSquareSieveValid_nil (tau nu : ℤ) :
    CoordinateSquareSieveValid tau nu [] := by
  intro item hi
  cases hi

theorem coordinateSquareSieveValid_cons {tau nu : ℤ} {k mask : ℕ}
    {tail : List (ℕ × ℕ)}
    (hm : CoordinateSquareMaskValid tau nu k mask)
    (ht : CoordinateSquareSieveValid tau nu tail) :
    CoordinateSquareSieveValid tau nu ((k,mask)::tail) := by
  intro item hi
  rcases List.mem_cons.mp hi with he | htail
  · subst item
    exact hm
  · exact ht item htail

end D1Bound5
