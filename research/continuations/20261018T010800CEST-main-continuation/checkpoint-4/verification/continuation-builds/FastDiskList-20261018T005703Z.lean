import D1Bound5.DiskEnumeration
import Mathlib.Data.Finset.Sort

namespace D1Bound5
namespace QuadInt

/-- The same complete normalized-coordinate disk as `disk`, computed as
a list before quotienting by order. Kernel certificates can compare lists
linearly without normalizing large finite-set duplicate-removal terms. -/
def fastDiskList (tau nu M : ℤ) : List (QuadInt tau nu) :=
  let r := Int.sqrt (4*M)
  let coords := (Finset.Icc (-r) r).sort (· ≤ ·)
  ((coords ×ˢ coords).filter (fun p : ℤ × ℤ =>
    decide (p.1 % 2 = (tau*p.2) % 2 ∧
      p.1^2+discriminant tau nu*p.2^2 ≤ 4*M))).map
    (fun p => (⟨(p.1-tau*p.2)/2,p.2⟩ : QuadInt tau nu))

/-- A propositional bridge to the existing complete disk enumeration.
The proof does not evaluate a finite set of concrete coordinates. -/
theorem fastDiskList_toFinset (tau nu M : ℤ) :
    (fastDiskList tau nu M).toFinset = disk tau nu M := by
  have mem_prod (a b : ℤ) (s t : Finset ℤ) :
      (a,b) ∈ s.product t ↔ a ∈ s ∧ b ∈ t := by
    change (a,b) ∈ s ×ˢ t ↔ a ∈ s ∧ b ∈ t
    exact Finset.mem_product
  ext z
  simp only [fastDiskList, disk, List.mem_toFinset, List.mem_map, Prod.exists,
    List.mem_filter, List.mem_product, Finset.mem_sort, decide_eq_true_eq,
    Finset.mem_image, Finset.mem_filter, mem_prod]

end QuadInt
end D1Bound5
