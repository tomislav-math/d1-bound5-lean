import D1Bound5.PellLightFinitePilot
import D1Bound5.PellLightFiniteAdapter
import D1Bound5.PellMatchingPilot

namespace D1Bound5.PellLightPilot

/-- The optional pure-Init pilot produces the original finite certificate
type and uses the original accepted graph, without replacing either source. -/
def finiteCertificate4519 : PellFiniteCertificate 4519 (10^275) :=
  pellFiniteCertificateOfLight 4519 (10^275) 67 540 pellGraphCertificate_4519 (by
    change pellLightFiniteCheck 4519 67 (10^275) 540 magnitudes4519 = true
    exact finite_checked4519)

end D1Bound5.PellLightPilot
