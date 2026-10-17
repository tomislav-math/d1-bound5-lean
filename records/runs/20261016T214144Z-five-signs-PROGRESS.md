# PROGRESS — compatible five-entry signs

Source: exploration/FiveSignsContinuation.lean. This is the active owned proof file; do not modify it concurrently.

The scalar last-column argument uses exists_root_error_control with c=49/50. For |ab|>=54 it yields |e|<50/99 and |e-1/2|<625/264627<1/400. The first sign-symmetry attempt had a Lean implicit-argument failure for or_comm; the next exposed dependent rewrite of Decidable, repaired by explicit case analysis. A subsequent completed run accepted the scalar and simultaneous matrix construction but reported index-coercion errors in two transfer lemmas. These have been repaired with explicit Fin 5 value maps.

The fourth isolated run is checking the complete ten-edge sign construction, prefix/last-column consequences, and an actual full-ring ordered D(1)-quintuple specialization. The latter derives D>54 by applying the already proved large product-four theorem to the last four entries. It does not assume D>54 or existence of compatible roots. No accepted integration or successful final compilation is yet asserted for this file.

Separate prepared fragment: exploration/FiveLastColumnNormPart.txt derives L2 last-column estimates from all four entrywise bounds. It has not yet been compiled. Source/axiom/kernel checks and normal private Git synchronization will follow only after successful source checking.

21:54 UTC: trial04 completed with EXIT 0 for the nine scalar/sign/tuple theorems; trial05 then completed with EXIT 0 including fiveLastColumn_l2_bounds. The final source has ten public theorems plus FiveSignedEntryGood and no compiler errors/warnings. It was copied byte-for-byte to D1Bound5/ProductFiveCompatibleSigns.lean and root imported. SHA256 7ef326eadce635a2fc8001d19ab9a7846a67febccdcf6d3cfe50963ad72c4cef. The integrated build is in progress. All three earlier failed logs are preserved. Dedicated eleven-declaration type/axiom script has been saved. No final acceptance or Git push is presumed before the remaining checks.
