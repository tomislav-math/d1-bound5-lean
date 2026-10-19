# Audit log formatting

The completed Lean audit printed all 110 public declarations and checked their transitive axioms. One long declaration name caused the pretty-printer to wrap its three-element axiom list across lines, and polymorphic #check @ output has an @ prefix. The final-record parser was adjusted to read those actual display formats. The audit source, theorem statements, kernel results and axiom whitelist were not changed.
