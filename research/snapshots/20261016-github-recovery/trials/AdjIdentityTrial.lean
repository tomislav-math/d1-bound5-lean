import D1Bound5.ReferencePerturbation

open Matrix
namespace D1Bound5

theorem adjugate_eq_det_smul_inverse (F : Matrix (Fin 4) (Fin 4) ℂ)
    (hd : F.det ≠ 0) : F.adjugate = F.det • F⁻¹ := by
  have hu : IsUnit F.det := isUnit_iff_ne_zero.mpr hd
  calc
    F.adjugate = (F⁻¹ * F) * F.adjugate := by
      rw [Matrix.nonsing_inv_mul F hu, one_mul]
    _ = F⁻¹ * (F * F.adjugate) := Matrix.mul_assoc _ _ _
    _ = F⁻¹ * (F.det • (1 : Matrix (Fin 4) (Fin 4) ℂ)) := by
      rw [Matrix.mul_adjugate]
    _ = F.det • F⁻¹ := by simp

end D1Bound5
