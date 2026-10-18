# Optional adaptive pair-check chunks

This is a source-only draft over the exact output format and SHA of light converter 67e224.
No generator, Lean compiler, queue operation, Git operation, or project-source replacement
was run while creating this recovery directory.

The generator emits a SMALL delta into a fresh directory. It references the existing
SmallPairLightDataN module and never emits its coordinates, signatures, masks, words,
or floor witnesses. Original raw data, graph scaffold, triangle theorem, and the heavy
four-input-equality assembly are not emitted or changed.

For a class of n vertices, head i has n-1-i unordered pairs. Greedy consecutive cuts
have at most --pair-budget pairs (default 8000), and may have different head counts.
The sum of all chunk counts is exactly n(n-1)/2. A head whose own full tail exceeds
the budget is rejected explicitly; this draft does not split within a head.

Each pure prefix module checks every selected head against its ENTIRE actual tail.
Thus every pair is checked once, in the chunk containing its earlier head, including
pairs whose later vertex lies beyond a cut. Packed words and floor lists advance
with the corresponding cached head; generic exact prefix/drop factorization rejects
missing/extra witnesses and retains all malformed-input behavior.

The computation modules import only the existing Init-only data and prefix definition.
The complete ordered vertex coverage and every canonical signature are checked in
a separate pure validation module. These checks are not weakened or sampled.

SmallPairLightLeftN and SmallPairLightRightN become proof-composition modules.
They import the separate chunk proof helper and checked pure prefixes. They retain
the original namespace and the exact four original theorem headers/types:
coverage_checked, signatures_checked, independent_checked, certificate_checked.
The independent theorem folds proof constants backwards from the empty remainder.
It does not reevaluate all pairs. The final certificate composes full coverage,
all signatures, and the assembled independence result.

SmallPairLightAssemblyN stays byte-identical. Its four original input equalities
(sieve, ordered split vertices, cached records, packed words/floors) still precede
the existing unconditional arithmetic bridge. Public graph endpoints are unchanged.

Before any output directory is created, the script checks an explicitly supplied
input-manifest SHA, converter67 provenance, both frozen generic helper hashes, every
selected row's original source size/SHA, literal class/row lengths, all chunk budgets,
and exact preservation of the original side theorem headers. The --rows argument is
mandatory, and structural rows are rejected. There is no default mass rollout.

By default only a dry manifest is written. --emit writes the small delta sources.
--expected-manifest requires an exact reproducible replay. Existing destinations,
symlink sources/ancestors, unsafe relative source names, unknown rows, and changed
inputs are rejected. All writes are exclusive inside a newly created directory.

The design bounds work per compilation and retains completed prefix artifacts.
It does not establish an overall speedup or memory reduction: repeated data/import
loading and current machine paging may dominate. Accepted LEFT34 is not replaced.
Independent source review and actual kernel compilation remain separate gates.
