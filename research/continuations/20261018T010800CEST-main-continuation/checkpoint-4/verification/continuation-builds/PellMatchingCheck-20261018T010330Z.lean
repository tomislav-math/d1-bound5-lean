import Mathlib.Data.ZMod.Basic
import Mathlib.Data.List.Defs
import Mathlib.Tactic

namespace D1Bound5

/-- A mask accepting every residue of c times an integral square.  Modulus
k+1 is always nonzero, including for the harmless default mask. -/
def PellScalarMaskValid (c : ℤ) (k mask : ℕ) : Prop :=
  ∀ r : ZMod (k+1), mask.testBit (((c : ZMod (k+1))*r*r).val) = true

def pellScalarMaskBool (k mask : ℕ) (z : ℤ) : Bool :=
  mask.testBit ((z : ZMod (k+1)).val)

theorem pellScalarMaskBool_of_square (c : ℤ) (k mask : ℕ)
    (hvalid : PellScalarMaskValid c k mask) (z r : ℤ)
    (hr : c*r*r = z) : pellScalarMaskBool k mask z = true := by
  unfold pellScalarMaskBool
  rw [← hr]
  simpa only [Int.cast_mul] using hvalid (r : ZMod (k+1))

/-- Ordinary-square and d-times-square masks for a single modulus. -/
structure PellSquareMasks where
  k : ℕ
  ordinary : ℕ
  scaled : ℕ
deriving DecidableEq, Repr

def PellSquareMasks.Valid (d : ℤ) (m : PellSquareMasks) : Prop :=
  PellScalarMaskValid 1 m.k m.ordinary ∧ PellScalarMaskValid d m.k m.scaled

def pellDefaultMasks : PellSquareMasks := ⟨0,1,1⟩

theorem pellDefaultMasks_valid (d : ℤ) : pellDefaultMasks.Valid d := by
  change PellScalarMaskValid 1 0 1 ∧ PellScalarMaskValid d 0 1
  letI : Subsingleton (ZMod 1) := ZMod.subsingleton_iff.mpr rfl
  constructor
  all_goals
    intro r
    have hr : r = (0 : ZMod 1) := Subsingleton.elim _ _
    subst r
    norm_num [pellDefaultMasks]

/-- Out-of-range witness indices use a mask that accepts everything. Thus
an invalid witness cannot make the graph checker accept a false rejection. -/
def pellSelectMasks : List PellSquareMasks → ℕ → PellSquareMasks
  | [], _ => pellDefaultMasks
  | m::_, 0 => m
  | _::ms, n+1 => pellSelectMasks ms n

theorem pellSelectMasks_valid (d : ℤ) (ms : List PellSquareMasks)
    (hvalid : ∀ m ∈ ms, m.Valid d) (n : ℕ) : (pellSelectMasks ms n).Valid d := by
  induction ms generalizing n with
  | nil => exact pellDefaultMasks_valid d
  | cons m ms ih =>
      cases n with
      | zero => exact hvalid m (by simp)
      | succ n => exact ih (fun m hm => hvalid m (by simp [hm])) n

/-- One witness for each sign of the product.  A positive edge would require
xy+1 to be a square, while an opposite-sign edge requires xy-1=d*r^2. -/
def pellPairChecks (ms : List PellSquareMasks) (x : ℤ) :
    List ℤ → List (ℕ × ℕ) → Bool
  | [], [] => true
  | y::ys, w::ws =>
      let p := pellSelectMasks ms w.1
      let n := pellSelectMasks ms w.2
      ((!pellScalarMaskBool p.k p.ordinary (x*y+1)) &&
        (!pellScalarMaskBool n.k n.scaled (x*y-1))) &&
        pellPairChecks ms x ys ws
  | _, _ => false

theorem pellPairChecks_sound (d : ℤ) (ms : List PellSquareMasks)
    (hvalid : ∀ m ∈ ms, m.Valid d) (x : ℤ) (ys : List ℤ)
    (ws : List (ℕ × ℕ)) (hcheck : pellPairChecks ms x ys ws = true)
    (y : ℤ) (hy : y ∈ ys) :
    (¬∃ r : ℤ, r*r = x*y+1) ∧ (¬∃ r : ℤ, d*r*r = x*y-1) := by
  induction ys generalizing ws with
  | nil => simp at hy
  | cons z zs ih =>
      cases ws with
      | nil => simp [pellPairChecks] at hcheck
      | cons w ws =>
          simp only [pellPairChecks, Bool.and_eq_true] at hcheck
          rcases List.mem_cons.mp hy with rfl | hy
          · constructor
            · rintro ⟨r,hr⟩
              have hh := pellScalarMaskBool_of_square 1 _ _
                (pellSelectMasks_valid d ms hvalid w.1).1 _ r
                (by simpa using hr)
              simpa only [hh, Bool.not_true, Bool.false_eq_true] using hcheck.1.1
            · rintro ⟨r,hr⟩
              have hh := pellScalarMaskBool_of_square d _ _
                (pellSelectMasks_valid d ms hvalid w.2).2 _ r hr
              simpa only [hh, Bool.not_true, Bool.false_eq_true] using hcheck.1.2
          · exact ih ws hcheck.2 hy

/-- The triangular witness array checks every unordered pair of distinct
positions. The empty-list cases enforce exact certificate lengths. -/
def pellMatchingCheck (ms : List PellSquareMasks) :
    List ℤ → List (List (ℕ × ℕ)) → Bool
  | [], [] => true
  | x::xs, ws::wss => pellPairChecks ms x xs ws && pellMatchingCheck ms xs wss
  | _, _ => false

theorem pellMatchingCheck_sound (d : ℤ) (ms : List PellSquareMasks)
    (hvalid : ∀ m ∈ ms, m.Valid d) (xs : List ℤ)
    (wss : List (List (ℕ × ℕ))) (hcheck : pellMatchingCheck ms xs wss = true)
    (x y : ℤ) (hx : x ∈ xs) (hy : y ∈ xs) (hne : x ≠ y) :
    (¬∃ r : ℤ, r*r = x*y+1) ∧ (¬∃ r : ℤ, d*r*r = x*y-1) := by
  induction xs generalizing wss with
  | nil => simp at hx
  | cons z zs ih =>
      cases wss with
      | nil => simp [pellMatchingCheck] at hcheck
      | cons ws wss =>
          simp only [pellMatchingCheck, Bool.and_eq_true] at hcheck
          rcases List.mem_cons.mp hx with hxz | hxt
          · have hyt : y ∈ zs := (List.mem_cons.mp hy).resolve_left
              (fun hyz => hne (hxz.trans hyz.symm))
            simpa only [hxz] using
              pellPairChecks_sound d ms hvalid z zs ws hcheck.1 y hyt
          · rcases List.mem_cons.mp hy with hyz | hyt
            · simpa only [hyz, mul_comm x z] using
                pellPairChecks_sound d ms hvalid z zs ws hcheck.1 x hxt
            · exact ih wss hcheck.2 hxt hyt

/-- Rational-square criterion in the fixed imaginary quadratic field. -/
def PellIntegerSquare (d n : ℤ) : Prop :=
  (∃ r : ℤ, r*r = n) ∨ (∃ r : ℤ, -d*r*r = n)

/-- Membership preserves both signs, without identifying opposite entries. -/
def PellSignedMember (xs : List ℤ) (z : ℤ) : Prop :=
  ∃ x ∈ xs, z = x ∨ z = -x

private theorem pell_signed_pair_abs_eq (d : ℤ) (hd : 0 < d)
    (ms : List PellSquareMasks) (hvalid : ∀ m ∈ ms, m.Valid d)
    (xs : List ℤ) (wss : List (List (ℕ × ℕ)))
    (hcheck : pellMatchingCheck ms xs wss = true)
    (hlarge : ∀ x ∈ xs, 2 ≤ x)
    (x y a b : ℤ) (hx : x ∈ xs) (hy : y ∈ xs)
    (ha : a = x ∨ a = -x) (hb : b = y ∨ b = -y)
    (hsq : PellIntegerSquare d (a*b+1)) : x = y := by
  by_contra hne
  obtain ⟨hnpos,hnneg⟩ := pellMatchingCheck_sound d ms hvalid xs wss hcheck x y hx hy hne
  have hx2 := hlarge x hx
  have hy2 := hlarge y hy
  have hxy : 0 < x*y-1 := by
    nlinarith [mul_nonneg (show 0 ≤ x-2 by omega) (show 0 ≤ y-2 by omega)]
  have hd0 : 0 ≤ d := hd.le
  rcases ha with rfl | rfl <;> rcases hb with rfl | rfl <;>
    rcases hsq with ⟨r,hr⟩ | ⟨r,hr⟩
  · exact hnpos ⟨r,hr⟩
  · nlinarith [sq_nonneg r, mul_nonneg hd0 (sq_nonneg r)]
  · nlinarith [sq_nonneg r]
  · apply hnneg; exact ⟨r,by nlinarith [hr]⟩
  · nlinarith [sq_nonneg r]
  · apply hnneg; exact ⟨r,by nlinarith [hr]⟩
  · apply hnpos; exact ⟨r,by nlinarith [hr]⟩
  · nlinarith [sq_nonneg r, mul_nonneg hd0 (sq_nonneg r)]

/-- The graph certificate proves a matching, a stronger property than the
triangle exclusion needed by the article. No huge integer square roots are
trusted or executed by this checker. -/
theorem pellMatchingCheck_no_three (d : ℤ) (hd : 0 < d)
    (ms : List PellSquareMasks) (hvalid : ∀ m ∈ ms, m.Valid d)
    (xs : List ℤ) (wss : List (List (ℕ × ℕ)))
    (hcheck : pellMatchingCheck ms xs wss = true)
    (hlarge : ∀ x ∈ xs, 2 ≤ x)
    (a b c : ℤ) (ha : PellSignedMember xs a) (hb : PellSignedMember xs b)
    (hc : PellSignedMember xs c) (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hsab : PellIntegerSquare d (a*b+1))
    (hsac : PellIntegerSquare d (a*c+1)) : False := by
  obtain ⟨x,hx,hax⟩ := ha
  obtain ⟨y,hy,hby⟩ := hb
  obtain ⟨z,hz,hcz⟩ := hc
  have hxy := pell_signed_pair_abs_eq d hd ms hvalid xs wss hcheck hlarge
    x y a b hx hy hax hby hsab
  have hxz := pell_signed_pair_abs_eq d hd ms hvalid xs wss hcheck hlarge
    x z a c hx hz hax hcz hsac
  subst y; subst z
  rcases hax with rfl | rfl <;> rcases hby with rfl | rfl <;>
    rcases hcz with rfl | rfl <;> simp_all

/-- Executable graph data together with its kernel certificates. Magnitude
completeness comes separately from the proved continued-fraction prefix. -/
structure PellMatchingCertificate (d : ℤ) where
  magnitudes : List ℤ
  masks : List PellSquareMasks
  witnesses : List (List (ℕ × ℕ))
  masks_valid : ∀ m ∈ masks, m.Valid d
  checked : pellMatchingCheck masks magnitudes witnesses = true
  large : ∀ x ∈ magnitudes, 2 ≤ x

def pellEmptyMatchingCertificate (d : ℤ) : PellMatchingCertificate d where
  magnitudes := []
  masks := []
  witnesses := []
  masks_valid := by simp
  checked := rfl
  large := by simp

theorem PellMatchingCertificate.no_three {d : ℤ} (C : PellMatchingCertificate d)
    (hd : 0 < d) (a b c : ℤ)
    (ha : PellSignedMember C.magnitudes a) (hb : PellSignedMember C.magnitudes b)
    (hc : PellSignedMember C.magnitudes c) (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hsab : PellIntegerSquare d (a*b+1))
    (hsac : PellIntegerSquare d (a*c+1)) : False :=
  pellMatchingCheck_no_three d hd C.masks C.masks_valid C.magnitudes C.witnesses
    C.checked C.large a b c ha hb hc hab hac hbc hsab hsac

end D1Bound5
