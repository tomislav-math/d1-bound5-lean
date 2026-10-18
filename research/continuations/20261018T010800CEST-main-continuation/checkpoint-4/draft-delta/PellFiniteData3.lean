import D1Bound5.PellFiniteCertificate
import D1Bound5.PellMatchingData2

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def pellFiniteCertificate_303 : PellFiniteCertificate 303 (10^275) where
  a0 := 17
  lastIndex := 444
  graph := pellEmptyMatchingCertificate 303
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_311 : PellFiniteCertificate 311 (10^275) where
  a0 := 17
  lastIndex := 584
  graph := pellGraphCertificate_311
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_319 : PellFiniteCertificate 319 (10^275) where
  a0 := 17
  lastIndex := 518
  graph := pellEmptyMatchingCertificate 319
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_327 : PellFiniteCertificate 327 (10^275) where
  a0 := 18
  lastIndex := 208
  graph := pellEmptyMatchingCertificate 327
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_335 : PellFiniteCertificate 335 (10^275) where
  a0 := 18
  lastIndex := 356
  graph := pellEmptyMatchingCertificate 335
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_359 : PellFiniteCertificate 359 (10^275) where
  a0 := 18
  lastIndex := 384
  graph := pellGraphCertificate_359
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_367 : PellFiniteCertificate 367 (10^275) where
  a0 := 19
  lastIndex := 520
  graph := pellGraphCertificate_367
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_383 : PellFiniteCertificate 383 (10^275) where
  a0 := 19
  lastIndex := 480
  graph := pellGraphCertificate_383
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_391 : PellFiniteCertificate 391 (10^275) where
  a0 := 19
  lastIndex := 613
  graph := pellGraphCertificate_391
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_399 : PellFiniteCertificate 399 (10^275) where
  a0 := 19
  lastIndex := 342
  graph := pellEmptyMatchingCertificate 399
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_407 : PellFiniteCertificate 407 (10^275) where
  a0 := 20
  lastIndex := 443
  graph := pellEmptyMatchingCertificate 407
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_415 : PellFiniteCertificate 415 (10^275) where
  a0 := 20
  lastIndex := 580
  graph := pellEmptyMatchingCertificate 415
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_431 : PellFiniteCertificate 431 (10^275) where
  a0 := 20
  lastIndex := 518
  graph := pellGraphCertificate_431
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_439 : PellFiniteCertificate 439 (10^275) where
  a0 := 20
  lastIndex := 372
  graph := pellGraphCertificate_439
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_447 : PellFiniteCertificate 447 (10^275) where
  a0 := 21
  lastIndex := 222
  graph := pellEmptyMatchingCertificate 447
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

def pellFiniteCertificate_455 : PellFiniteCertificate 455 (10^275) where
  a0 := 21
  lastIndex := 260
  graph := pellEmptyMatchingCertificate 455
  prefix_checked := by decide +kernel
  stopping := by decide +kernel
  magnitudes_eq := by decide +kernel

end D1Bound5
