# Product-five normalized matrix bridge (16 October 2026)

New Lean module: `D1Bound5/ProductFiveMatrixBridge.lean`, SHA256 8ea3704fb4c1308113f0fd79cdba0ca29b02390fb0ce0be51946ee093a9ecedc.

Three proved statements establish (1) exact canonical Fin5 versus Fin4 ⊕ Fin1 block reindexing, (2) det N=d² det G, (3) for symmetric five-entry root matrix M with u_i²=t_i and M_ii=t_i, (∏ t_i)det M=t_4² det G. Only t_4≠0 is required; zero other entries and roots are allowed.

Checks: isolated Lean elaboration EXIT 0; targeted Lake build EXIT 0 (2910 jobs); exact theorem and transitive axiom audit EXIT 0 (only propext, Classical.choice, Quot.sound); targeted same-kernel leanchecker replay EXIT 0. Logs: `local-logs/product-five-matrix-hourly19-{trial05,build,axioms,replay}.log`.

Integration unfinished: two root-import edit attempts blocked before execution, unknown reason. Source/import audit EXIT 1 because ProductFiveBlockDet and ProductFiveMatrixBridge are not yet reachable from root. No root build, commit, push, clean checkout, independent review or complete bound-five proof is claimed. Next: root imports and audits, original-ring five-tuple transfer, quantitative product-five, arbitrary-order Bennett, certified finite exclusions.
