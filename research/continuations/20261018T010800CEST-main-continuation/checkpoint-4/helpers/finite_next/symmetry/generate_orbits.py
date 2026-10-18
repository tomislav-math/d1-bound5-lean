import json
from pathlib import Path
root=Path('/workspace/scratch/40edb97fa4c0')
rows=json.loads((root/'finite_next/triple/extensions.json').read_text())
s='''import D1Bound5.SmallTripleRepresentativeProperties

open scoped NumberField
open Module

namespace D1Bound5
open QuadInt

private theorem smallTripleProperty_of_table_orbits {tau nu : ℤ}
    (table : List (Finset (ℤ × ℤ))) (reps : Finset (Finset (ℤ × ℤ)))
    (horbits : table.toFinset = reps.biUnion (smallTripleOrbit tau))
    (hreps : ∀ row ∈ reps, SmallTripleExtensionProperty (smallCoordinateSet tau nu row))
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ table) :
    SmallTripleExtensionProperty (smallCoordinateSet tau nu row) := by
  have h : row ∈ reps.biUnion (smallTripleOrbit tau) := by
    rw [← horbits]
    exact List.mem_toFinset.mpr hrow
  obtain ⟨rep, hrep, horbit⟩ := Finset.mem_biUnion.mp h
  exact smallTripleExtensionProperty_of_orbit rep row (hreps rep hrep) horbit

'''
groups=[(0,1,[1,2,3,4],'smallTripleTable_orbits.1'),(0,2,[5],'smallTripleTable_orbits.2.1'),(1,1,[6,7,8],'smallTripleTable_orbits.2.2.1'),(1,2,[9,10],'smallTripleTable_orbits.2.2.2')]
for tau,nu,ks,orbit in groups:
 s+=f'''theorem smallTripleTable_{tau}_{nu}_extension_property_full_ring
    {{K : Type*}} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (e : QuadInt {tau} {nu} ≃+* 𝓞 K)
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallTripleTable {tau} {nu}) :
    SmallTripleExtensionProperty (smallCoordinateSet {tau} {nu} row) := by
  apply smallTripleProperty_of_table_orbits smallTriples_{tau}_{nu}
    smallTripleRepresentatives_{tau}_{nu} {orbit} ?_ row
    (by simpa [smallTripleTable] using hrow)
  intro rep hrep
  simp only [smallTripleRepresentatives_{tau}_{nu}, Finset.mem_insert, Finset.mem_singleton] at hrep
  rcases hrep with {' | '.join(['rfl']*len(ks))}
'''
 for k in ks:
  rr=rows[k-1]
  rowstr='{'+','.join(f'({x},{y})'for x,y in rr['triple'])+'}'
  s+=f'''  · have heq : smallCoordinateSet {tau} {nu} {rowstr} =
        {{smallTripleAnchorA_{k}, smallTripleAnchorB_{k}, smallTripleAnchorC_{k}}} := by decide
    rw [heq]
    exact smallTripleRepresentative_{k}_property hK phi e
'''
 s+='\n'
s+='''/-- All 24 coordinate triples inherit the representative extension theorem;
no ordering or unproved symmetry convention is imposed on the input row. -/
theorem smallTripleTable_extension_property_full_ring
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K)
    (hmodel : (tau = 0 ∧ nu = 1) ∨ (tau = 0 ∧ nu = 2) ∨
      (tau = 1 ∧ nu = 1) ∨ (tau = 1 ∧ nu = 2))
    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallTripleTable tau nu) :
    SmallTripleExtensionProperty (smallCoordinateSet tau nu row) := by
  rcases hmodel with ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩ | ⟨rfl,rfl⟩
  · exact smallTripleTable_0_1_extension_property_full_ring hK phi e row hrow
  · exact smallTripleTable_0_2_extension_property_full_ring hK phi e row hrow
  · exact smallTripleTable_1_1_extension_property_full_ring hK phi e row hrow
  · exact smallTripleTable_1_2_extension_property_full_ring hK phi e row hrow

end D1Bound5
'''
(root/'finite_next/symmetry/D1Bound5/SmallTripleOrbitProperties.lean').write_text(s)
