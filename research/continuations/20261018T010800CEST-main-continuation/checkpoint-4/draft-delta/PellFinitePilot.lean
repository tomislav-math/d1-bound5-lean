import D1Bound5.PellFiniteCertificate
import D1Bound5.PellMatchingPilot

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def pellFiniteCertificate_4519 : PellFiniteCertificate 4519 (10^275) where
  a0 := 67
  lastIndex := 540
  graph := pellGraphCertificate_4519
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

end D1Bound5
