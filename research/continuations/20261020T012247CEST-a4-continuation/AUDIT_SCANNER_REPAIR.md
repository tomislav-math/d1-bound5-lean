# Public header scanner repair

2026-10-20T02:01:04.947151+02:00

The old regex greedily consumed same-line := markers before searching for another assignment, making private helper insertion look like a changed public header. Replace that metadata-only scanner by a public name/kind parser followed by the first actual assignment boundary (:= by for theorem proofs, := for these concrete definitions). Original theorem signatures, all audit examples and axiom collection are unchanged. This fixes failed audit preparation only, not any proof. The failed directory is preserved and never treated as verification.
