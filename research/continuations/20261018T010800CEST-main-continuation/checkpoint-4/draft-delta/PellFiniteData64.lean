import D1Bound5.PellFiniteCertificate
import D1Bound5.PellMatchingData26

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def pellFiniteCertificate_9935 : PellFiniteCertificate 9935 (10^275) where
  a0 := 99
  lastIndex := 504
  graph := pellEmptyMatchingCertificate 9935
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_9943 : PellFiniteCertificate 9943 (10^275) where
  a0 := 99
  lastIndex := 590
  graph := pellEmptyMatchingCertificate 9943
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_9951 : PellFiniteCertificate 9951 (10^275) where
  a0 := 99
  lastIndex := 329
  graph := pellEmptyMatchingCertificate 9951
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_9959 : PellFiniteCertificate 9959 (10^275) where
  a0 := 99
  lastIndex := 470
  graph := pellGraphCertificate_9959
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_9967 : PellFiniteCertificate 9967 (10^275) where
  a0 := 99
  lastIndex := 567
  graph := pellGraphCertificate_9967
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_9983 : PellFiniteCertificate 9983 (10^275) where
  a0 := 99
  lastIndex := 450
  graph := pellEmptyMatchingCertificate 9983
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_9991 : PellFiniteCertificate 9991 (10^275) where
  a0 := 99
  lastIndex := 440
  graph := pellGraphCertificate_9991
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

end D1Bound5
