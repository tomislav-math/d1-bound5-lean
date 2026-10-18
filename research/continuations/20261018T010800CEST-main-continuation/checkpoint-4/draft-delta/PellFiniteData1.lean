import D1Bound5.PellFiniteCertificate
import D1Bound5.PellMatchingData1

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def pellFiniteCertificate_7 : PellFiniteCertificate 7 (10^275) where
  a0 := 2
  lastIndex := 915
  graph := pellGraphCertificate_7
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_15 : PellFiniteCertificate 15 (10^275) where
  a0 := 3
  lastIndex := 614
  graph := pellEmptyMatchingCertificate 15
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_23 : PellFiniteCertificate 23 (10^275) where
  a0 := 4
  lastIndex := 654
  graph := pellGraphCertificate_23
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_31 : PellFiniteCertificate 31 (10^275) where
  a0 := 5
  lastIndex := 632
  graph := pellGraphCertificate_31
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_39 : PellFiniteCertificate 39 (10^275) where
  a0 := 6
  lastIndex := 324
  graph := pellEmptyMatchingCertificate 39
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_47 : PellFiniteCertificate 47 (10^275) where
  a0 := 6
  lastIndex := 554
  graph := pellGraphCertificate_47
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_55 : PellFiniteCertificate 55 (10^275) where
  a0 := 7
  lastIndex := 488
  graph := pellEmptyMatchingCertificate 55
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_71 : PellFiniteCertificate 71 (10^275) where
  a0 := 8
  lastIndex := 572
  graph := pellGraphCertificate_71
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_79 : PellFiniteCertificate 79 (10^275) where
  a0 := 8
  lastIndex := 498
  graph := pellGraphCertificate_79
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_87 : PellFiniteCertificate 87 (10^275) where
  a0 := 9
  lastIndex := 314
  graph := pellEmptyMatchingCertificate 87
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_95 : PellFiniteCertificate 95 (10^275) where
  a0 := 9
  lastIndex := 580
  graph := pellEmptyMatchingCertificate 95
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_103 : PellFiniteCertificate 103 (10^275) where
  a0 := 10
  lastIndex := 582
  graph := pellGraphCertificate_103
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_111 : PellFiniteCertificate 111 (10^275) where
  a0 := 10
  lastIndex := 594
  graph := pellEmptyMatchingCertificate 111
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_119 : PellFiniteCertificate 119 (10^275) where
  a0 := 10
  lastIndex := 462
  graph := pellGraphCertificate_119
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_127 : PellFiniteCertificate 127 (10^275) where
  a0 := 11
  lastIndex := 473
  graph := pellGraphCertificate_127
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_143 : PellFiniteCertificate 143 (10^275) where
  a0 := 11
  lastIndex := 398
  graph := pellEmptyMatchingCertificate 143
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

end D1Bound5
