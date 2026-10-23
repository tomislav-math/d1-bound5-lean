This archive records a resource-only transition of the same genuine fresh source build. The coordinator naturally drained the old invocation at 2611 accepted modules, no active work and no failures, with actual exit code 3. The exact resume command changes only --max-mathlib-jobs from 2 to 3; jobs7, timeout1200, V2 hints, heavy exclusions, memory admission and all proof guards remain in place. No balancing pulse ran.

The independent observer verified that the new invocation revalidated exactly the same 2611 modules with zero rejected receipts, checked every pointer/receipt hash and source/build identity, and observed the exact prepared process argv. Artifact revalidation itself was performed by the unchanged guarded builder. The prepared pre-action record remains byte-identical.

The following 60-second measurement was read-only. It found no OOM or OOM kill, but cgroup max-limit counters increased; this is not evidence of zero memory pressure. Actual samples saw at most one Mathlib compiler at a time, so they do not establish the safety of three simultaneous large Mathlib jobs. The cap remains3, with no authorization to raise4. Total RSS includes shared file mappings; measured RssAnon is not exact private/PSS.

The resumed source build and final original-type/axiom/kernel gates remain separate. This resource archive does not claim proof completion or release acceptance.
