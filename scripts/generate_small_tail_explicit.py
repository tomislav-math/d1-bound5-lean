#!/usr/bin/env python3
"""Emit explicit finite input lists. Generated equalities are proved by Lean.
Python's enumeration is not trusted; Lean checks disk equality and the
entire small-tail Boolean result through kernel reduction.
"""
from pathlib import Path

def emit(tau, nu):
    coords = [(x,y) for x in range(-15,16) for y in range(-15,16)
              if x*x+tau*x*y+nu*y*y <= 15]
    name = f"{tau}_{nu}"
    lit = ", ".join(f"⟨{x},{y}⟩" for x,y in coords)
    return f"""import D1Bound5.SmallTailExplicit

namespace D1Bound5
open QuadInt
set_option maxRecDepth 32768
set_option maxHeartbeats 6000000

def tailDisk_{name} : List (QuadInt {tau} {nu}) := [{lit}]

/-- Kernel-checked equality with the proved exhaustive disk enumeration. -/
theorem tailDisk_{name}_eq : disk {tau} {nu} 15 = tailDisk_{name}.toFinset := by
  decide +kernel

/-- No external execution or native-evaluation axiom is used. -/
theorem tailDisk_{name}_checked : tailListBool tailDisk_{name} = true := by
  decide +kernel

theorem smallTailExplicit_{name} : SmallTailCheck {tau} {nu} := by
  apply smallTailCheck_of_explicit_list tailDisk_{name}
  · intro z hz
    rw [tailDisk_{name}_eq, List.mem_toFinset] at hz
    exact hz
  · exact tailDisk_{name}_checked

end D1Bound5
"""

def emit_all():
    head = "import D1Bound5.SmallTailData0_1\nimport D1Bound5.SmallTailModel15\n\nnamespace D1Bound5\nopen QuadInt\nset_option maxRecDepth 32768\nset_option maxHeartbeats 6000000\n\n"
    blocks = []
    for tau in (0,1):
        for nu in range(1,16):
            if (tau,nu) in ((0,1),(0,15)):
                continue
            text = emit(tau,nu)
            blocks.append(text.split("set_option maxHeartbeats 6000000\n\n",1)[1].rsplit("\nend D1Bound5",1)[0])
    end = """
/-- Complete finite certificate for the normalized parameter rectangle.
Every data equality and every exclusion above is checked by the kernel. -/
theorem smallTailCheck_rectangular (tau nu : ℤ)
    (htau : tau = 0 ∨ tau = 1) (hlo : 1 ≤ nu) (hhi : nu ≤ 15)
    (_hpos : 0 < discriminant tau nu) : SmallTailCheck tau nu := by
  rcases htau with rfl | rfl
"""
    for tau in (0,1):
        end += "  · interval_cases nu\n"
        for nu in range(1,16):
            name = "small_tail_015" if (tau,nu)==(0,15) else f"smallTailExplicit_{tau}_{nu}"
            end += "    · exact " + name + "\n"
    return head + "\n".join(blocks) + end + "\nend D1Bound5\n"

if __name__ == "__main__":
    import sys
    if sys.argv[1:] == ["--check-all"]:
        assert Path("D1Bound5/SmallTailAllData.lean").read_text() == emit_all()
        assert Path("D1Bound5/SmallTailData0_1.lean").read_text() == emit(0,1)
        print("GENERATOR_SOURCE_IDENTITY_PASS (not a mathematical proof)")
    else:
        tau, nu = map(int,sys.argv[1:3])
        assert tau in (0,1) and 1 <= nu <= 15
        path = Path(f"D1Bound5/SmallTailData{tau}_{nu}.lean")
        if path.exists():
            raise SystemExit(f"Refusing to overwrite {path}")
        path.write_text(emit(tau,nu))
        print(path)
