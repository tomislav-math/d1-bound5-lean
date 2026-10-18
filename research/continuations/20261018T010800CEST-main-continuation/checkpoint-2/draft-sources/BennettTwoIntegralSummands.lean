import D1Bound5.BennettTwoDenominatorClearing
import D1Bound5.BennettSubringSums

namespace D1Bound5

variable {F : Type*} [Field F] [CharZero F]

/-- The actual column-zero residue summand, with all binomial factors and
pole signs, is integral in every subring containing the anchor entries. -/
theorem bennett_two_integral_summand_zero (S : Subring F)
    (a b c : F) (ha : a ∈ S) (hb : b ∈ S) (hc : c ∈ S)
    (ha0 : a ≠ 0) (hb0 : b ≠ 0)
    (k d0 d1 d2 h0 h1 h2 : ℕ) (hk : 1 ≤ k)
    (hd : d0 + d1 + d2 = 1) (hh : h0 + h1 + h2 + 1 = k + d0) :
    ∃ q ∈ S,
      (((4 : F) ^ k * Ring.choose ((k : F) + 1 / 2) h0) *
        Ring.choose (-((k + d1 : ℕ) : F)) h1 *
        Ring.choose (-((k + d2 : ℕ) : F)) h2) *
      ((a * b * (a - b) ^ 2) ^ k * (a * b * c) ^ (k - h0) *
        ((-b)⁻¹) ^ (k + d1 + h1) * ((-a)⁻¹) ^ (k + d2 + h2)) = 1 * q := by
  let t : F := ((4 : F) ^ k * Ring.choose ((k : F) + 1 / 2) h0) *
    Ring.choose (-((k + d1 : ℕ) : F)) h1 *
    Ring.choose (-((k + d2 : ℕ) : F)) h2
  have ht : t ∈ S := bennett_two_taylor_scalar_mem S k h0 (k + d1) (k + d2) h1 h2
    (by omega)
  let u : F := (-1 : F) ^ ((k + d1 + h1) + (k + d2 + h2)) *
    (a ^ (d1 + h1) * b ^ (d2 + h2) * c ^ (k - h0) * (a - b) ^ (2 * k))
  have hu : u ∈ S := S.mul_mem (S.pow_mem (S.neg_mem S.one_mem) _)
    (S.mul_mem (S.mul_mem (S.mul_mem (S.pow_mem ha _) (S.pow_mem hb _))
      (S.pow_mem hc _)) (S.pow_mem (S.sub_mem ha hb) _))
  refine ⟨t * u, S.mul_mem ht hu, ?_⟩
  rw [bennett_two_clear_column_zero_signed a b c ha0 hb0 k d0 d1 d2 h0 h1 h2 hk hd hh]
  change t * u = 1 * (t * u)
  rw [one_mul]

/-- The actual column-one residue summand is divisible by `a^k` inside
every subring containing the anchors. -/
theorem bennett_two_integral_summand_one (S : Subring F)
    (a b c : F) (ha : a ∈ S) (hb : b ∈ S) (hc : c ∈ S)
    (hb0 : b ≠ 0) (hab : a ≠ b)
    (k d0 d1 d2 h0 h1 h2 : ℕ) (hk : 1 ≤ k)
    (hd : d0 + d1 + d2 = 1) (hh : h0 + h1 + h2 + 1 = k + d1) :
    ∃ q ∈ S,
      (((4 : F) ^ k * Ring.choose ((k : F) + 1 / 2) h1) *
        Ring.choose (-((k + d0 : ℕ) : F)) h0 *
        Ring.choose (-((k + d2 : ℕ) : F)) h2) *
      ((a * b * (a - b) ^ 2) ^ k * (a * b * c + b) ^ (k - h1) *
        (b⁻¹) ^ (k + d0 + h0) * ((b - a)⁻¹) ^ (k + d2 + h2)) = a ^ k * q := by
  let t : F := ((4 : F) ^ k * Ring.choose ((k : F) + 1 / 2) h1) *
    Ring.choose (-((k + d0 : ℕ) : F)) h0 *
    Ring.choose (-((k + d2 : ℕ) : F)) h2
  have ht : t ∈ S := bennett_two_taylor_scalar_mem S k h1 (k + d0) (k + d2) h0 h2
    (by omega)
  let u : F := (-1 : F) ^ (k + d2 + h2) *
    ((a * c + 1) ^ (k - h1) * b ^ (d2 + h2) * (a - b) ^ (k - (d2 + h2)))
  have hu : u ∈ S := S.mul_mem (S.pow_mem (S.neg_mem S.one_mem) _)
    (S.mul_mem (S.mul_mem (S.pow_mem (S.add_mem (S.mul_mem ha hc) S.one_mem) _)
      (S.pow_mem hb _)) (S.pow_mem (S.sub_mem ha hb) _))
  refine ⟨t * u, S.mul_mem ht hu, ?_⟩
  rw [bennett_two_clear_column_one_signed a b c hb0 hab k d0 d1 d2 h0 h1 h2 hk hd hh]
  dsimp [t, u]
  ring

/-- The actual column-two residue summand is divisible by `b^k` inside
every subring containing the anchors. -/
theorem bennett_two_integral_summand_two (S : Subring F)
    (a b c : F) (ha : a ∈ S) (hb : b ∈ S) (hc : c ∈ S)
    (ha0 : a ≠ 0) (hab : a ≠ b)
    (k d0 d1 d2 h0 h1 h2 : ℕ) (hk : 1 ≤ k)
    (hd : d0 + d1 + d2 = 1) (hh : h0 + h1 + h2 + 1 = k + d2) :
    ∃ q ∈ S,
      (((4 : F) ^ k * Ring.choose ((k : F) + 1 / 2) h2) *
        Ring.choose (-((k + d0 : ℕ) : F)) h0 *
        Ring.choose (-((k + d1 : ℕ) : F)) h1) *
      ((a * b * (a - b) ^ 2) ^ k * (a * b * c + a) ^ (k - h2) *
        (a⁻¹) ^ (k + d0 + h0) * ((a - b)⁻¹) ^ (k + d1 + h1)) = b ^ k * q := by
  let t : F := ((4 : F) ^ k * Ring.choose ((k : F) + 1 / 2) h2) *
    Ring.choose (-((k + d0 : ℕ) : F)) h0 *
    Ring.choose (-((k + d1 : ℕ) : F)) h1
  have ht : t ∈ S := bennett_two_taylor_scalar_mem S k h2 (k + d0) (k + d1) h0 h1
    (by omega)
  let u : F := (b * c + 1) ^ (k - h2) * a ^ (d1 + h1) *
    (a - b) ^ (k - (d1 + h1))
  have hu : u ∈ S := S.mul_mem
    (S.mul_mem (S.pow_mem (S.add_mem (S.mul_mem hb hc) S.one_mem) _) (S.pow_mem ha _))
    (S.pow_mem (S.sub_mem ha hb) _)
  refine ⟨t * u, S.mul_mem ht hu, ?_⟩
  rw [bennett_two_clear_column_two a b c ha0 hab k d0 d1 d2 h0 h1 h2 hk hd hh]
  dsimp [t, u]
  ring

end D1Bound5
