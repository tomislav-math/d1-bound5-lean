import json
from pathlib import Path
root=Path('/workspace/scratch/40edb97fa4c0')
rows=json.loads((root/'finite_next/triple/extensions.json').read_text())
s='''import D1Bound5.SmallExtensionSymmetry

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

private theorem smallTripleExtensionProperty_of_list {tau nu : ℤ}
    (A : Finset (QuadInt tau nu)) (allowed : List (QuadInt tau nu))
    (hcomplete : ∀ z, ProperCommonExtension A z → z.norm ≤ 10^80 → z ∈ allowed)
    (hbound : ∀ z ∈ allowed, z.norm < 85^2)
    (hunique : ∀ z ∈ allowed, ∀ w ∈ allowed, z = w) :
    SmallTripleExtensionProperty A := by
  constructor
  · intro z hz hNz
    exact hbound z (hcomplete z hz hNz)
  · intro z w hz hw hNz hNw
    exact hunique z (hcomplete z hz hNz) w (hcomplete w hw hNw)

'''
for row in rows:
 k=row['row']; tau=row['tau'];nu=row['nu']
 s+=f'''/-- Both finite-extension consequences for manuscript representative {k}. -/
theorem smallTripleRepresentative_{k}_property
    {{K : Type*}} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt {tau} {nu} ≃+* 𝓞 K) :
    SmallTripleExtensionProperty
      {{smallTripleAnchorA_{k}, smallTripleAnchorB_{k}, smallTripleAnchorC_{k}}} := by
  apply smallTripleExtensionProperty_of_list _ smallTripleAllowed_{k}
  · intro z hz hNz
    exact smallTripleExtension_{k}_complete_full_ring hK phi e z
      ⟨hz.2.2 _ (by simp), hz.2.2 _ (by simp)⟩
      (hz.2.2 _ (by simp)) hz.1
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h]))
      (fun h => hz.2.1 (by simp [h])) hNz
  · norm_num [smallTripleAllowed_{k}, QuadInt.norm_formula]
  · simp [smallTripleAllowed_{k}]

'''
s+='end D1Bound5\n'
(root/'finite_next/symmetry/D1Bound5/SmallTripleRepresentativeProperties.lean').write_text(s)
