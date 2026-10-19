import D1Bound5.PellFiniteFieldCoverageData
import D1Bound5.PellFiniteFieldCoverageBlock00
import D1Bound5.PellFiniteFieldCoverageBlock01
import D1Bound5.PellFiniteFieldCoverageBlock02
import D1Bound5.PellFiniteFieldCoverageBlock03
import D1Bound5.PellFiniteFieldCoverageBlock04
import D1Bound5.PellFiniteFieldCoverageBlock05
import D1Bound5.PellFiniteFieldCoverageBlock06
import D1Bound5.PellFiniteFieldCoverageBlock07
import D1Bound5.PellFiniteFieldCoverageBlock08
import D1Bound5.PellFiniteFieldCoverageBlock09
import D1Bound5.PellFiniteFieldCoverageBlock10
import D1Bound5.PellFiniteFieldCoverageBlock11
import D1Bound5.PellFiniteFieldCoverageBlock12
import D1Bound5.PellFiniteFieldCoverageBlock13
import D1Bound5.PellFiniteFieldCoverageBlock14
import D1Bound5.PellFiniteFieldCoverageBlock15
import D1Bound5.PellFiniteFieldCoverageBlock16
import D1Bound5.PellFiniteFieldCoverageBlock17
import D1Bound5.PellFiniteFieldCoverageBlock18
import D1Bound5.PellFiniteFieldCoverageBlock19
import D1Bound5.PellFiniteFieldCoverageBlock20
import D1Bound5.PellFiniteFieldCoverageBlock21
import D1Bound5.PellFiniteFieldCoverageBlock22
import D1Bound5.PellFiniteFieldCoverageBlock23
import D1Bound5.PellFiniteFieldCoverageBlock24

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

private theorem pellFieldCoverage_blocks (b : Fin 25) (r : Fin 50) :
    PellFieldCoverageAt (50*b.val+r.val) := by
  fin_cases b
  · exact pellFieldCoverageBlock00_checked r
  · exact pellFieldCoverageBlock01_checked r
  · exact pellFieldCoverageBlock02_checked r
  · exact pellFieldCoverageBlock03_checked r
  · exact pellFieldCoverageBlock04_checked r
  · exact pellFieldCoverageBlock05_checked r
  · exact pellFieldCoverageBlock06_checked r
  · exact pellFieldCoverageBlock07_checked r
  · exact pellFieldCoverageBlock08_checked r
  · exact pellFieldCoverageBlock09_checked r
  · exact pellFieldCoverageBlock10_checked r
  · exact pellFieldCoverageBlock11_checked r
  · exact pellFieldCoverageBlock12_checked r
  · exact pellFieldCoverageBlock13_checked r
  · exact pellFieldCoverageBlock14_checked r
  · exact pellFieldCoverageBlock15_checked r
  · exact pellFieldCoverageBlock16_checked r
  · exact pellFieldCoverageBlock17_checked r
  · exact pellFieldCoverageBlock18_checked r
  · exact pellFieldCoverageBlock19_checked r
  · exact pellFieldCoverageBlock20_checked r
  · exact pellFieldCoverageBlock21_checked r
  · exact pellFieldCoverageBlock22_checked r
  · exact pellFieldCoverageBlock23_checked r
  · exact pellFieldCoverageBlock24_checked r

theorem pellFieldCoverage_checked :
    ∀ k : Fin 1250,
      let d : ℤ := 7+8*(k.val : ℤ)
      let p := pellExcludedFactors.getD k.val 0
      d ∈ pellCertifiedFields.map Sigma.fst ∨ (2 ≤ p ∧ p*p ∣ d) := by
  intro k
  change PellFieldCoverageAt k.val
  let b : Fin 25 := ⟨k.val/50, by omega⟩
  let r : Fin 50 := ⟨k.val%50, Nat.mod_lt _ (by decide)⟩
  have h := pellFieldCoverage_blocks b r
  have he : 50*b.val+r.val = k.val := by
    dsimp [b,r]
    omega
  simpa only [he] using h

/-- All 1016 eligible parameters have complete, kernel-checked certificates.
The excluded cases have explicit nonunit square divisors, so the coverage
proof does not trust the Python squarefree predicate. -/
theorem pellFiniteCertificate_exists (d : ℤ) (hd : 7 ≤ d) (hupper : d < 10000)
    (hmod : d % 8 = 7) (hsq : Squarefree d) :
    Nonempty (PellFiniteCertificate d (10^275)) := by
  have hk0 : 0 ≤ d/8 := by omega
  have hklt : (d/8).toNat < 1250 := by omega
  let k : Fin 1250 := ⟨(d/8).toNat,hklt⟩
  have heq : 7+8*(k.val : ℤ) = d := by dsimp [k]; omega
  have hc := pellFieldCoverage_checked k
  dsimp only at hc
  rw [heq] at hc
  rcases hc with hmem | hbad
  · obtain ⟨r,_,hr⟩ := List.mem_map.mp hmem
    cases hr
    exact ⟨r.2⟩
  · have hu : IsUnit (pellExcludedFactors.getD k.val 0) := hsq _ hbad.2
    have hh := Int.isUnit_iff.mp hu
    omega

end D1Bound5
