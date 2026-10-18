from pathlib import Path
import json

base = Path('finite_next/two_small')
out = base / 'symmetry/D1Bound5'
rows = [json.loads(p.read_text()) for p in sorted((base/'closures').glob('pair_*.json'))]
models = sorted({(r['tau'], r['nu']) for r in rows})

head = ['open scoped NumberField', 'open Module', '', 'namespace D1Bound5', 'open QuadInt', '']
lines = ['import D1Bound5.SmallPairGraphSymmetry', 'import D1Bound5.SmallPairGraphs', ''] + head
for row in rows:
    i,t,n = row['row'],row['tau'],row['nu']
    lines += [
        f'/-- The full triangle exclusion for manuscript representative {i}. -/',
        f'theorem smallPairRepresentative_{i}_graph_property',
        '    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]',
        '    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)',
        f'    (e : QuadInt {t} {n} ≃+* 𝓞 K) :',
        f'    SmallPairGraphProperty {{smallPairA_{i},smallPairB_{i}}} := by',
        '  intro t ht hproper hlarge hbound',
        f'  apply smallPairGraph_{i}_excludes_three_full_ring hK phi e t ht ?_ hlarge hbound',
        '  · intro j',
        '    exact ⟨(hproper j).2.2 _ (by simp), (hproper j).2.2 _ (by simp)⟩',
        '  · intro j h',
        '    exact (hproper j).2.1 (by simp [h])',
        '  · intro j h',
        '    exact (hproper j).2.1 (by simp [h])',
        ''
    ]
lines += ['end D1Bound5', '']
(out/'SmallPairRepresentativeProperties.lean').write_text('\n'.join(lines))

lines = ['import D1Bound5.SmallPairRepresentativeProperties', ''] + head + [
    'private theorem smallPairProperty_of_table_orbits {tau nu : ℤ}',
    '    (table : List (Finset (ℤ × ℤ))) (reps : Finset (Finset (ℤ × ℤ)))',
    '    (horbits : table.toFinset = reps.biUnion (smallTripleOrbit tau))',
    '    (hreps : ∀ row ∈ reps, SmallPairGraphProperty (smallCoordinateSet tau nu row))',
    '    (row : Finset (ℤ × ℤ)) (hrow : row ∈ table) :',
    '    SmallPairGraphProperty (smallCoordinateSet tau nu row) := by',
    '  have h : row ∈ reps.biUnion (smallTripleOrbit tau) := by',
    '    rw [← horbits]',
    '    exact List.mem_toFinset.mpr hrow',
    '  obtain ⟨rep, hrep, horbit⟩ := Finset.mem_biUnion.mp h',
    '  exact smallPairGraphProperty_of_orbit rep row (hreps rep hrep) horbit',
    ''
]
for t,n in models:
    rs = [r for r in rows if (r['tau'],r['nu'])==(t,n)]
    lines += [
        f'theorem smallPairTable_{t}_{n}_graph_property_full_ring',
        '    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]',
        '    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)',
        f'    (e : QuadInt {t} {n} ≃+* 𝓞 K)',
        f'    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable {t} {n}) :',
        f'    SmallPairGraphProperty (smallCoordinateSet {t} {n} row) := by',
        f'  apply smallPairProperty_of_table_orbits smallPairs_{t}_{n}',
        f'    smallPairRepresentatives_{t}_{n} smallPairTable_{t}_{n}_orbits ?_ row',
        '    (by simpa [smallPairTable] using hrow)',
        '  intro rep hrep',
        f'  simp only [smallPairRepresentatives_{t}_{n}, Finset.mem_insert, Finset.mem_singleton] at hrep',
        '  rcases hrep with ' + ' | '.join('rfl' for r in rs)
    ]
    for r in rs:
        i=r['row']; a,b=r['anchors']
        xy='{'+f'({a[0]},{a[1]}),({b[0]},{b[1]})'+'}'
        lines += [
            f'  · have heq : smallCoordinateSet {t} {n} {xy} =',
            f'        {{smallPairA_{i},smallPairB_{i}}} := by decide',
            '    rw [heq]',
            f'    exact smallPairRepresentative_{i}_graph_property hK phi e'
        ]
    lines += ['']
lines += [
    '/-- Every table row inherits its representative triangle exclusion. -/',
    'theorem smallPairTable_graph_property_full_ring',
    '    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]',
    '    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)',
    '    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K)',
    '    (hmodel : (tau,nu) ∈ smallPairModels)',
    '    (row : Finset (ℤ × ℤ)) (hrow : row ∈ smallPairTable tau nu) :',
    '    SmallPairGraphProperty (smallCoordinateSet tau nu row) := by',
    '  simp only [smallPairModels, Finset.mem_insert, Finset.mem_singleton, Prod.mk.injEq] at hmodel',
    '  rcases hmodel with ' + ' | '.join('⟨rfl,rfl⟩' for _ in models)
]
for t,n in models:
    lines += [f'  · exact smallPairTable_{t}_{n}_graph_property_full_ring hK phi e row hrow']
lines += ['', 'end D1Bound5', '']
(out/'SmallPairOrbitProperties.lean').write_text('\n'.join(lines))
