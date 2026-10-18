import D1Bound5.PellFiniteCertificate
import D1Bound5.PellMatchingData5
import D1Bound5.PellMatchingData6

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def pellFiniteCertificate_1559 : PellFiniteCertificate 1559 (10^275) where
  a0 := 39
  lastIndex := 491
  graph := pellGraphCertificate_1559
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1567 : PellFiniteCertificate 1567 (10^275) where
  a0 := 39
  lastIndex := 490
  graph := pellGraphCertificate_1567
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1583 : PellFiniteCertificate 1583 (10^275) where
  a0 := 39
  lastIndex := 615
  graph := pellGraphCertificate_1583
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1591 : PellFiniteCertificate 1591 (10^275) where
  a0 := 39
  lastIndex := 539
  graph := pellEmptyMatchingCertificate 1591
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1599 : PellFiniteCertificate 1599 (10^275) where
  a0 := 39
  lastIndex := 288
  graph := pellEmptyMatchingCertificate 1599
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1607 : PellFiniteCertificate 1607 (10^275) where
  a0 := 40
  lastIndex := 532
  graph := pellGraphCertificate_1607
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1615 : PellFiniteCertificate 1615 (10^275) where
  a0 := 40
  lastIndex := 401
  graph := pellEmptyMatchingCertificate 1615
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1623 : PellFiniteCertificate 1623 (10^275) where
  a0 := 40
  lastIndex := 327
  graph := pellEmptyMatchingCertificate 1623
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1631 : PellFiniteCertificate 1631 (10^275) where
  a0 := 40
  lastIndex := 560
  graph := pellEmptyMatchingCertificate 1631
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1639 : PellFiniteCertificate 1639 (10^275) where
  a0 := 40
  lastIndex := 426
  graph := pellEmptyMatchingCertificate 1639
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1655 : PellFiniteCertificate 1655 (10^275) where
  a0 := 40
  lastIndex := 378
  graph := pellEmptyMatchingCertificate 1655
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1663 : PellFiniteCertificate 1663 (10^275) where
  a0 := 40
  lastIndex := 558
  graph := pellGraphCertificate_1663
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1671 : PellFiniteCertificate 1671 (10^275) where
  a0 := 40
  lastIndex := 377
  graph := pellEmptyMatchingCertificate 1671
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1679 : PellFiniteCertificate 1679 (10^275) where
  a0 := 40
  lastIndex := 312
  graph := pellGraphCertificate_1679
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1687 : PellFiniteCertificate 1687 (10^275) where
  a0 := 41
  lastIndex := 397
  graph := pellGraphCertificate_1687
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_1695 : PellFiniteCertificate 1695 (10^275) where
  a0 := 41
  lastIndex := 480
  graph := pellEmptyMatchingCertificate 1695
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

end D1Bound5
