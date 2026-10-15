/-
Copyright (c) 2023 Kim Morrison. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Kim Morrison, Sebastian Ullrich
-/
import Lean.CoreM
import Lean.Replay
import Lake.Load.Manifest

open Lean

unsafe def replayFromImports (module : Name) : IO Unit := do
  let mFile ← findOLean module
  unless (← mFile.pathExists) do
    throw <| IO.userError s!"object file '{mFile}' of module {module} does not exist"
  -- Load all module data parts (exported, server, private)
  let mut fnames := #[mFile]
  let sFile := OLeanLevel.server.adjustFileName mFile
  if (← sFile.pathExists) then
    fnames := fnames.push sFile
    let pFile := OLeanLevel.private.adjustFileName mFile
    if (← pFile.pathExists) then
      fnames := fnames.push pFile
  let parts ← readModuleDataParts fnames
  if h : parts.size = 0 then throw <| IO.userError "failed to read module data" else
  let (mod, _) := parts[0]
  let (_, s) ← importModulesCore mod.imports |>.run
  let env ← finalizeImport s mod.imports {} 0 false false (isModule := true)
  let mut newConstants := {}
  -- Collect constants from last ("most private") part, which subsumes all prior ones
  for name in parts[parts.size-1].1.constNames, ci in parts[parts.size-1].1.constants do
    newConstants := newConstants.insert name ci
  let env' ← env.replay newConstants
  env'.freeRegions


/-- Sequential scheduling of the unchanged bundled kernel replay function.
Explicit module arguments avoid including stale or unrelated object files. -/
unsafe def main (args : List String) : IO UInt32 := do
  if args.isEmpty then throw <| IO.userError "Provide all project module names"
  initSearchPath (← findSysroot)
  let out ← IO.getStdout
  for arg in args do
    let m := arg.toName
    if m.isAnonymous then throw <| IO.userError "Invalid module name"
    IO.println s!"REPLAY_BEGIN: {m}"
    out.flush
    replayFromImports m
    IO.println s!"REPLAY_PASS: {m}"
    out.flush
  IO.println s!"SEQUENTIAL_KERNEL_REPLAY_PASS: {args.length} modules"
  out.flush
  return 0
