import D1Bound5.PellLightCFBridge
import D1Bound5.PellFiniteCertificate

namespace D1Bound5

/-- Reuse the original finite certificate type, graph and completeness
theorems after kernel checking the pure-Init arithmetic certificate. -/
def pellFiniteCertificateOfLight (d X a0 : ℤ) (N : ℕ)
    (graph : PellMatchingCertificate d)
    (hcheck : pellLightFiniteCheck d a0 X N graph.magnitudes = true) :
    PellFiniteCertificate d X where
  a0 := a0
  lastIndex := N
  graph := graph
  prefix_checked := (pellLightFiniteCheck_sound d a0 X N graph.magnitudes hcheck).1
  stopping := (pellLightFiniteCheck_sound d a0 X N graph.magnitudes hcheck).2.1
  magnitudes_eq := (pellLightFiniteCheck_sound d a0 X N graph.magnitudes hcheck).2.2

end D1Bound5
