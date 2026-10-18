import D1Bound5.PellLightFiniteAdapter
import D1Bound5.PellLightPrefixPilot
import D1Bound5.PellLightPrefixData1
import D1Bound5.PellLightPrefixData2
import D1Bound5.PellLightPrefixData3
import D1Bound5.PellLightPrefixData4
import D1Bound5.PellLightPrefixData5
import D1Bound5.PellLightPrefixData6
import D1Bound5.PellLightPrefixData7
import D1Bound5.PellLightPrefixData8
import D1Bound5.PellLightPrefixData9
import D1Bound5.PellLightPrefixData10
import D1Bound5.PellLightPrefixData11
import D1Bound5.PellLightPrefixData12
import D1Bound5.PellLightPrefixData13
import D1Bound5.PellLightPrefixData14
import D1Bound5.PellLightPrefixData15
import D1Bound5.PellLightPrefixData16
import D1Bound5.PellLightPrefixData17
import D1Bound5.PellLightPrefixData18
import D1Bound5.PellLightPrefixData19
import D1Bound5.PellLightPrefixData20
import D1Bound5.PellLightPrefixData21
import D1Bound5.PellLightPrefixData22
import D1Bound5.PellLightPrefixData23
import D1Bound5.PellLightPrefixData24
import D1Bound5.PellLightPrefixData25
import D1Bound5.PellLightPrefixData26
import D1Bound5.PellLightPrefixData27
import D1Bound5.PellLightPrefixData28
import D1Bound5.PellLightPrefixData29
import D1Bound5.PellLightPrefixData30
import D1Bound5.PellLightPrefixData31
import D1Bound5.PellLightPrefixData32
import D1Bound5.PellLightPrefixData33
import D1Bound5.PellLightPrefixData34
import D1Bound5.PellLightPrefixData35
import D1Bound5.PellLightPrefixData36
import D1Bound5.PellLightPrefixData37
import D1Bound5.PellLightPrefixData38
import D1Bound5.PellLightPrefixData39
import D1Bound5.PellLightPrefixData40
import D1Bound5.PellLightPrefixData41
import D1Bound5.PellLightPrefixData42
import D1Bound5.PellLightPrefixData43
import D1Bound5.PellLightPrefixData44
import D1Bound5.PellLightPrefixData45
import D1Bound5.PellLightPrefixData46
import D1Bound5.PellLightPrefixData47
import D1Bound5.PellLightPrefixData48
import D1Bound5.PellLightPrefixData49
import D1Bound5.PellLightPrefixData50
import D1Bound5.PellLightPrefixData51
import D1Bound5.PellLightPrefixData52
import D1Bound5.PellLightPrefixData53
import D1Bound5.PellLightPrefixData54
import D1Bound5.PellLightPrefixData55
import D1Bound5.PellLightPrefixData56
import D1Bound5.PellLightPrefixData57
import D1Bound5.PellLightPrefixData58
import D1Bound5.PellLightPrefixData59
import D1Bound5.PellLightPrefixData60
import D1Bound5.PellLightPrefixData61
import D1Bound5.PellLightPrefixData62
import D1Bound5.PellLightPrefixData63
import D1Bound5.PellLightPrefixData64
import D1Bound5.PellMatchingPilot
import D1Bound5.PellMatchingData1
import D1Bound5.PellMatchingData2
import D1Bound5.PellMatchingData3
import D1Bound5.PellMatchingData4
import D1Bound5.PellMatchingData5
import D1Bound5.PellMatchingData6
import D1Bound5.PellMatchingData7
import D1Bound5.PellMatchingData8
import D1Bound5.PellMatchingData9
import D1Bound5.PellMatchingData10
import D1Bound5.PellMatchingData11
import D1Bound5.PellMatchingData12
import D1Bound5.PellMatchingData13
import D1Bound5.PellMatchingData14
import D1Bound5.PellMatchingData15
import D1Bound5.PellMatchingData16
import D1Bound5.PellMatchingData17
import D1Bound5.PellMatchingData18
import D1Bound5.PellMatchingData19
import D1Bound5.PellMatchingData20
import D1Bound5.PellMatchingData21
import D1Bound5.PellMatchingData22
import D1Bound5.PellMatchingData23
import D1Bound5.PellMatchingData24
import D1Bound5.PellMatchingData25
import D1Bound5.PellMatchingData26

namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

def pellFiniteCertificate_4519 : PellFiniteCertificate 4519 (10^275) :=
  pellFiniteCertificateOfLight 4519 (10^275) 67 540 pellGraphCertificate_4519 (by
    change pellLightFiniteCheck 4519 67 (10^275) 540 PellLightProduction.magnitudes_4519 = true
    exact PellLightProduction.checked_4519)

def pellFiniteCertificate_7 : PellFiniteCertificate 7 (10^275) :=
  pellFiniteCertificateOfLight 7 (10^275) 2 915 pellGraphCertificate_7 (by
    change pellLightFiniteCheck 7 2 (10^275) 915 PellLightProduction.magnitudes_7 = true
    exact PellLightProduction.checked_7)

def pellFiniteCertificate_15 : PellFiniteCertificate 15 (10^275) :=
  pellFiniteCertificateOfLight 15 (10^275) 3 614 (pellEmptyMatchingCertificate 15) (by
    change pellLightFiniteCheck 15 3 (10^275) 614 PellLightProduction.magnitudes_15 = true
    exact PellLightProduction.checked_15)

def pellFiniteCertificate_23 : PellFiniteCertificate 23 (10^275) :=
  pellFiniteCertificateOfLight 23 (10^275) 4 654 pellGraphCertificate_23 (by
    change pellLightFiniteCheck 23 4 (10^275) 654 PellLightProduction.magnitudes_23 = true
    exact PellLightProduction.checked_23)

def pellFiniteCertificate_31 : PellFiniteCertificate 31 (10^275) :=
  pellFiniteCertificateOfLight 31 (10^275) 5 632 pellGraphCertificate_31 (by
    change pellLightFiniteCheck 31 5 (10^275) 632 PellLightProduction.magnitudes_31 = true
    exact PellLightProduction.checked_31)

def pellFiniteCertificate_39 : PellFiniteCertificate 39 (10^275) :=
  pellFiniteCertificateOfLight 39 (10^275) 6 324 (pellEmptyMatchingCertificate 39) (by
    change pellLightFiniteCheck 39 6 (10^275) 324 PellLightProduction.magnitudes_39 = true
    exact PellLightProduction.checked_39)

def pellFiniteCertificate_47 : PellFiniteCertificate 47 (10^275) :=
  pellFiniteCertificateOfLight 47 (10^275) 6 554 pellGraphCertificate_47 (by
    change pellLightFiniteCheck 47 6 (10^275) 554 PellLightProduction.magnitudes_47 = true
    exact PellLightProduction.checked_47)

def pellFiniteCertificate_55 : PellFiniteCertificate 55 (10^275) :=
  pellFiniteCertificateOfLight 55 (10^275) 7 488 (pellEmptyMatchingCertificate 55) (by
    change pellLightFiniteCheck 55 7 (10^275) 488 PellLightProduction.magnitudes_55 = true
    exact PellLightProduction.checked_55)

def pellFiniteCertificate_71 : PellFiniteCertificate 71 (10^275) :=
  pellFiniteCertificateOfLight 71 (10^275) 8 572 pellGraphCertificate_71 (by
    change pellLightFiniteCheck 71 8 (10^275) 572 PellLightProduction.magnitudes_71 = true
    exact PellLightProduction.checked_71)

def pellFiniteCertificate_79 : PellFiniteCertificate 79 (10^275) :=
  pellFiniteCertificateOfLight 79 (10^275) 8 498 pellGraphCertificate_79 (by
    change pellLightFiniteCheck 79 8 (10^275) 498 PellLightProduction.magnitudes_79 = true
    exact PellLightProduction.checked_79)

def pellFiniteCertificate_87 : PellFiniteCertificate 87 (10^275) :=
  pellFiniteCertificateOfLight 87 (10^275) 9 314 (pellEmptyMatchingCertificate 87) (by
    change pellLightFiniteCheck 87 9 (10^275) 314 PellLightProduction.magnitudes_87 = true
    exact PellLightProduction.checked_87)

def pellFiniteCertificate_95 : PellFiniteCertificate 95 (10^275) :=
  pellFiniteCertificateOfLight 95 (10^275) 9 580 (pellEmptyMatchingCertificate 95) (by
    change pellLightFiniteCheck 95 9 (10^275) 580 PellLightProduction.magnitudes_95 = true
    exact PellLightProduction.checked_95)

def pellFiniteCertificate_103 : PellFiniteCertificate 103 (10^275) :=
  pellFiniteCertificateOfLight 103 (10^275) 10 582 pellGraphCertificate_103 (by
    change pellLightFiniteCheck 103 10 (10^275) 582 PellLightProduction.magnitudes_103 = true
    exact PellLightProduction.checked_103)

def pellFiniteCertificate_111 : PellFiniteCertificate 111 (10^275) :=
  pellFiniteCertificateOfLight 111 (10^275) 10 594 (pellEmptyMatchingCertificate 111) (by
    change pellLightFiniteCheck 111 10 (10^275) 594 PellLightProduction.magnitudes_111 = true
    exact PellLightProduction.checked_111)

def pellFiniteCertificate_119 : PellFiniteCertificate 119 (10^275) :=
  pellFiniteCertificateOfLight 119 (10^275) 10 462 pellGraphCertificate_119 (by
    change pellLightFiniteCheck 119 10 (10^275) 462 PellLightProduction.magnitudes_119 = true
    exact PellLightProduction.checked_119)

def pellFiniteCertificate_127 : PellFiniteCertificate 127 (10^275) :=
  pellFiniteCertificateOfLight 127 (10^275) 11 473 pellGraphCertificate_127 (by
    change pellLightFiniteCheck 127 11 (10^275) 473 PellLightProduction.magnitudes_127 = true
    exact PellLightProduction.checked_127)

def pellFiniteCertificate_143 : PellFiniteCertificate 143 (10^275) :=
  pellFiniteCertificateOfLight 143 (10^275) 11 398 (pellEmptyMatchingCertificate 143) (by
    change pellLightFiniteCheck 143 11 (10^275) 398 PellLightProduction.magnitudes_143 = true
    exact PellLightProduction.checked_143)

def pellFiniteCertificate_151 : PellFiniteCertificate 151 (10^275) :=
  pellFiniteCertificateOfLight 151 (10^275) 12 577 pellGraphCertificate_151 (by
    change pellLightFiniteCheck 151 12 (10^275) 577 PellLightProduction.magnitudes_151 = true
    exact PellLightProduction.checked_151)

def pellFiniteCertificate_159 : PellFiniteCertificate 159 (10^275) :=
  pellFiniteCertificateOfLight 159 (10^275) 12 802 (pellEmptyMatchingCertificate 159) (by
    change pellLightFiniteCheck 159 12 (10^275) 802 PellLightProduction.magnitudes_159 = true
    exact PellLightProduction.checked_159)

def pellFiniteCertificate_167 : PellFiniteCertificate 167 (10^275) :=
  pellFiniteCertificateOfLight 167 (10^275) 12 434 pellGraphCertificate_167 (by
    change pellLightFiniteCheck 167 12 (10^275) 434 PellLightProduction.magnitudes_167 = true
    exact PellLightProduction.checked_167)

def pellFiniteCertificate_183 : PellFiniteCertificate 183 (10^275) :=
  pellFiniteCertificateOfLight 183 (10^275) 13 552 (pellEmptyMatchingCertificate 183) (by
    change pellLightFiniteCheck 183 13 (10^275) 552 PellLightProduction.magnitudes_183 = true
    exact PellLightProduction.checked_183)

def pellFiniteCertificate_191 : PellFiniteCertificate 191 (10^275) :=
  pellFiniteCertificateOfLight 191 (10^275) 13 606 pellGraphCertificate_191 (by
    change pellLightFiniteCheck 191 13 (10^275) 606 PellLightProduction.magnitudes_191 = true
    exact PellLightProduction.checked_191)

def pellFiniteCertificate_199 : PellFiniteCertificate 199 (10^275) :=
  pellFiniteCertificateOfLight 199 (10^275) 14 521 pellGraphCertificate_199 (by
    change pellLightFiniteCheck 199 14 (10^275) 521 PellLightProduction.magnitudes_199 = true
    exact PellLightProduction.checked_199)

def pellFiniteCertificate_215 : PellFiniteCertificate 215 (10^275) :=
  pellFiniteCertificateOfLight 215 (10^275) 14 564 (pellEmptyMatchingCertificate 215) (by
    change pellLightFiniteCheck 215 14 (10^275) 564 PellLightProduction.magnitudes_215 = true
    exact PellLightProduction.checked_215)

def pellFiniteCertificate_223 : PellFiniteCertificate 223 (10^275) :=
  pellFiniteCertificateOfLight 223 (10^275) 14 414 pellGraphCertificate_223 (by
    change pellLightFiniteCheck 223 14 (10^275) 414 PellLightProduction.magnitudes_223 = true
    exact PellLightProduction.checked_223)

def pellFiniteCertificate_231 : PellFiniteCertificate 231 (10^275) :=
  pellFiniteCertificateOfLight 231 (10^275) 15 252 (pellEmptyMatchingCertificate 231) (by
    change pellLightFiniteCheck 231 15 (10^275) 252 PellLightProduction.magnitudes_231 = true
    exact PellLightProduction.checked_231)

def pellFiniteCertificate_239 : PellFiniteCertificate 239 (10^275) :=
  pellFiniteCertificateOfLight 239 (10^275) 15 464 pellGraphCertificate_239 (by
    change pellLightFiniteCheck 239 15 (10^275) 464 PellLightProduction.magnitudes_239 = true
    exact PellLightProduction.checked_239)

def pellFiniteCertificate_247 : PellFiniteCertificate 247 (10^275) :=
  pellFiniteCertificateOfLight 247 (10^275) 15 629 (pellEmptyMatchingCertificate 247) (by
    change pellLightFiniteCheck 247 15 (10^275) 629 PellLightProduction.magnitudes_247 = true
    exact PellLightProduction.checked_247)

def pellFiniteCertificate_255 : PellFiniteCertificate 255 (10^275) :=
  pellFiniteCertificateOfLight 255 (10^275) 15 364 (pellEmptyMatchingCertificate 255) (by
    change pellLightFiniteCheck 255 15 (10^275) 364 PellLightProduction.magnitudes_255 = true
    exact PellLightProduction.checked_255)

def pellFiniteCertificate_263 : PellFiniteCertificate 263 (10^275) :=
  pellFiniteCertificateOfLight 263 (10^275) 16 606 pellGraphCertificate_263 (by
    change pellLightFiniteCheck 263 16 (10^275) 606 PellLightProduction.magnitudes_263 = true
    exact PellLightProduction.checked_263)

def pellFiniteCertificate_271 : PellFiniteCertificate 271 (10^275) :=
  pellFiniteCertificateOfLight 271 (10^275) 16 578 pellGraphCertificate_271 (by
    change pellLightFiniteCheck 271 16 (10^275) 578 PellLightProduction.magnitudes_271 = true
    exact PellLightProduction.checked_271)

def pellFiniteCertificate_287 : PellFiniteCertificate 287 (10^275) :=
  pellFiniteCertificateOfLight 287 (10^275) 16 398 pellGraphCertificate_287 (by
    change pellLightFiniteCheck 287 16 (10^275) 398 PellLightProduction.magnitudes_287 = true
    exact PellLightProduction.checked_287)

def pellFiniteCertificate_295 : PellFiniteCertificate 295 (10^275) :=
  pellFiniteCertificateOfLight 295 (10^275) 17 498 (pellEmptyMatchingCertificate 295) (by
    change pellLightFiniteCheck 295 17 (10^275) 498 PellLightProduction.magnitudes_295 = true
    exact PellLightProduction.checked_295)

def pellFiniteCertificate_303 : PellFiniteCertificate 303 (10^275) :=
  pellFiniteCertificateOfLight 303 (10^275) 17 444 (pellEmptyMatchingCertificate 303) (by
    change pellLightFiniteCheck 303 17 (10^275) 444 PellLightProduction.magnitudes_303 = true
    exact PellLightProduction.checked_303)

def pellFiniteCertificate_311 : PellFiniteCertificate 311 (10^275) :=
  pellFiniteCertificateOfLight 311 (10^275) 17 584 pellGraphCertificate_311 (by
    change pellLightFiniteCheck 311 17 (10^275) 584 PellLightProduction.magnitudes_311 = true
    exact PellLightProduction.checked_311)

def pellFiniteCertificate_319 : PellFiniteCertificate 319 (10^275) :=
  pellFiniteCertificateOfLight 319 (10^275) 17 518 (pellEmptyMatchingCertificate 319) (by
    change pellLightFiniteCheck 319 17 (10^275) 518 PellLightProduction.magnitudes_319 = true
    exact PellLightProduction.checked_319)

def pellFiniteCertificate_327 : PellFiniteCertificate 327 (10^275) :=
  pellFiniteCertificateOfLight 327 (10^275) 18 208 (pellEmptyMatchingCertificate 327) (by
    change pellLightFiniteCheck 327 18 (10^275) 208 PellLightProduction.magnitudes_327 = true
    exact PellLightProduction.checked_327)

def pellFiniteCertificate_335 : PellFiniteCertificate 335 (10^275) :=
  pellFiniteCertificateOfLight 335 (10^275) 18 356 (pellEmptyMatchingCertificate 335) (by
    change pellLightFiniteCheck 335 18 (10^275) 356 PellLightProduction.magnitudes_335 = true
    exact PellLightProduction.checked_335)

def pellFiniteCertificate_359 : PellFiniteCertificate 359 (10^275) :=
  pellFiniteCertificateOfLight 359 (10^275) 18 384 pellGraphCertificate_359 (by
    change pellLightFiniteCheck 359 18 (10^275) 384 PellLightProduction.magnitudes_359 = true
    exact PellLightProduction.checked_359)

def pellFiniteCertificate_367 : PellFiniteCertificate 367 (10^275) :=
  pellFiniteCertificateOfLight 367 (10^275) 19 520 pellGraphCertificate_367 (by
    change pellLightFiniteCheck 367 19 (10^275) 520 PellLightProduction.magnitudes_367 = true
    exact PellLightProduction.checked_367)

def pellFiniteCertificate_383 : PellFiniteCertificate 383 (10^275) :=
  pellFiniteCertificateOfLight 383 (10^275) 19 480 pellGraphCertificate_383 (by
    change pellLightFiniteCheck 383 19 (10^275) 480 PellLightProduction.magnitudes_383 = true
    exact PellLightProduction.checked_383)

def pellFiniteCertificate_391 : PellFiniteCertificate 391 (10^275) :=
  pellFiniteCertificateOfLight 391 (10^275) 19 613 pellGraphCertificate_391 (by
    change pellLightFiniteCheck 391 19 (10^275) 613 PellLightProduction.magnitudes_391 = true
    exact PellLightProduction.checked_391)

def pellFiniteCertificate_399 : PellFiniteCertificate 399 (10^275) :=
  pellFiniteCertificateOfLight 399 (10^275) 19 342 (pellEmptyMatchingCertificate 399) (by
    change pellLightFiniteCheck 399 19 (10^275) 342 PellLightProduction.magnitudes_399 = true
    exact PellLightProduction.checked_399)

def pellFiniteCertificate_407 : PellFiniteCertificate 407 (10^275) :=
  pellFiniteCertificateOfLight 407 (10^275) 20 443 (pellEmptyMatchingCertificate 407) (by
    change pellLightFiniteCheck 407 20 (10^275) 443 PellLightProduction.magnitudes_407 = true
    exact PellLightProduction.checked_407)

def pellFiniteCertificate_415 : PellFiniteCertificate 415 (10^275) :=
  pellFiniteCertificateOfLight 415 (10^275) 20 580 (pellEmptyMatchingCertificate 415) (by
    change pellLightFiniteCheck 415 20 (10^275) 580 PellLightProduction.magnitudes_415 = true
    exact PellLightProduction.checked_415)

def pellFiniteCertificate_431 : PellFiniteCertificate 431 (10^275) :=
  pellFiniteCertificateOfLight 431 (10^275) 20 518 pellGraphCertificate_431 (by
    change pellLightFiniteCheck 431 20 (10^275) 518 PellLightProduction.magnitudes_431 = true
    exact PellLightProduction.checked_431)

def pellFiniteCertificate_439 : PellFiniteCertificate 439 (10^275) :=
  pellFiniteCertificateOfLight 439 (10^275) 20 372 pellGraphCertificate_439 (by
    change pellLightFiniteCheck 439 20 (10^275) 372 PellLightProduction.magnitudes_439 = true
    exact PellLightProduction.checked_439)

def pellFiniteCertificate_447 : PellFiniteCertificate 447 (10^275) :=
  pellFiniteCertificateOfLight 447 (10^275) 21 222 (pellEmptyMatchingCertificate 447) (by
    change pellLightFiniteCheck 447 21 (10^275) 222 PellLightProduction.magnitudes_447 = true
    exact PellLightProduction.checked_447)

def pellFiniteCertificate_455 : PellFiniteCertificate 455 (10^275) :=
  pellFiniteCertificateOfLight 455 (10^275) 21 260 (pellEmptyMatchingCertificate 455) (by
    change pellLightFiniteCheck 455 21 (10^275) 260 PellLightProduction.magnitudes_455 = true
    exact PellLightProduction.checked_455)

def pellFiniteCertificate_463 : PellFiniteCertificate 463 (10^275) :=
  pellFiniteCertificateOfLight 463 (10^275) 21 597 pellGraphCertificate_463 (by
    change pellLightFiniteCheck 463 21 (10^275) 597 PellLightProduction.magnitudes_463 = true
    exact PellLightProduction.checked_463)

def pellFiniteCertificate_471 : PellFiniteCertificate 471 (10^275) :=
  pellFiniteCertificateOfLight 471 (10^275) 21 534 (pellEmptyMatchingCertificate 471) (by
    change pellLightFiniteCheck 471 21 (10^275) 534 PellLightProduction.magnitudes_471 = true
    exact PellLightProduction.checked_471)

def pellFiniteCertificate_479 : PellFiniteCertificate 479 (10^275) :=
  pellFiniteCertificateOfLight 479 (10^275) 21 486 pellGraphCertificate_479 (by
    change pellLightFiniteCheck 479 21 (10^275) 486 PellLightProduction.magnitudes_479 = true
    exact PellLightProduction.checked_479)

def pellFiniteCertificate_487 : PellFiniteCertificate 487 (10^275) :=
  pellFiniteCertificateOfLight 487 (10^275) 22 549 pellGraphCertificate_487 (by
    change pellLightFiniteCheck 487 22 (10^275) 549 PellLightProduction.magnitudes_487 = true
    exact PellLightProduction.checked_487)

def pellFiniteCertificate_503 : PellFiniteCertificate 503 (10^275) :=
  pellFiniteCertificateOfLight 503 (10^275) 22 468 pellGraphCertificate_503 (by
    change pellLightFiniteCheck 503 22 (10^275) 468 PellLightProduction.magnitudes_503 = true
    exact PellLightProduction.checked_503)

def pellFiniteCertificate_511 : PellFiniteCertificate 511 (10^275) :=
  pellFiniteCertificateOfLight 511 (10^275) 22 553 pellGraphCertificate_511 (by
    change pellLightFiniteCheck 511 22 (10^275) 553 PellLightProduction.magnitudes_511 = true
    exact PellLightProduction.checked_511)

def pellFiniteCertificate_519 : PellFiniteCertificate 519 (10^275) :=
  pellFiniteCertificateOfLight 519 (10^275) 22 661 (pellEmptyMatchingCertificate 519) (by
    change pellLightFiniteCheck 519 22 (10^275) 661 PellLightProduction.magnitudes_519 = true
    exact PellLightProduction.checked_519)

def pellFiniteCertificate_527 : PellFiniteCertificate 527 (10^275) :=
  pellFiniteCertificateOfLight 527 (10^275) 22 364 pellGraphCertificate_527 (by
    change pellLightFiniteCheck 527 22 (10^275) 364 PellLightProduction.magnitudes_527 = true
    exact PellLightProduction.checked_527)

def pellFiniteCertificate_535 : PellFiniteCertificate 535 (10^275) :=
  pellFiniteCertificateOfLight 535 (10^275) 23 505 (pellEmptyMatchingCertificate 535) (by
    change pellLightFiniteCheck 535 23 (10^275) 505 PellLightProduction.magnitudes_535 = true
    exact PellLightProduction.checked_535)

def pellFiniteCertificate_543 : PellFiniteCertificate 543 (10^275) :=
  pellFiniteCertificateOfLight 543 (10^275) 23 449 (pellEmptyMatchingCertificate 543) (by
    change pellLightFiniteCheck 543 23 (10^275) 449 PellLightProduction.magnitudes_543 = true
    exact PellLightProduction.checked_543)

def pellFiniteCertificate_551 : PellFiniteCertificate 551 (10^275) :=
  pellFiniteCertificateOfLight 551 (10^275) 23 390 (pellEmptyMatchingCertificate 551) (by
    change pellLightFiniteCheck 551 23 (10^275) 390 PellLightProduction.magnitudes_551 = true
    exact PellLightProduction.checked_551)

def pellFiniteCertificate_559 : PellFiniteCertificate 559 (10^275) :=
  pellFiniteCertificateOfLight 559 (10^275) 23 610 (pellEmptyMatchingCertificate 559) (by
    change pellLightFiniteCheck 559 23 (10^275) 610 PellLightProduction.magnitudes_559 = true
    exact PellLightProduction.checked_559)

def pellFiniteCertificate_583 : PellFiniteCertificate 583 (10^275) :=
  pellFiniteCertificateOfLight 583 (10^275) 24 380 (pellEmptyMatchingCertificate 583) (by
    change pellLightFiniteCheck 583 24 (10^275) 380 PellLightProduction.magnitudes_583 = true
    exact PellLightProduction.checked_583)

def pellFiniteCertificate_591 : PellFiniteCertificate 591 (10^275) :=
  pellFiniteCertificateOfLight 591 (10^275) 24 498 (pellEmptyMatchingCertificate 591) (by
    change pellLightFiniteCheck 591 24 (10^275) 498 PellLightProduction.magnitudes_591 = true
    exact PellLightProduction.checked_591)

def pellFiniteCertificate_599 : PellFiniteCertificate 599 (10^275) :=
  pellFiniteCertificateOfLight 599 (10^275) 24 560 pellGraphCertificate_599 (by
    change pellLightFiniteCheck 599 24 (10^275) 560 PellLightProduction.magnitudes_599 = true
    exact PellLightProduction.checked_599)

def pellFiniteCertificate_607 : PellFiniteCertificate 607 (10^275) :=
  pellFiniteCertificateOfLight 607 (10^275) 24 571 pellGraphCertificate_607 (by
    change pellLightFiniteCheck 607 24 (10^275) 571 PellLightProduction.magnitudes_607 = true
    exact PellLightProduction.checked_607)

def pellFiniteCertificate_615 : PellFiniteCertificate 615 (10^275) :=
  pellFiniteCertificateOfLight 615 (10^275) 24 459 (pellEmptyMatchingCertificate 615) (by
    change pellLightFiniteCheck 615 24 (10^275) 459 PellLightProduction.magnitudes_615 = true
    exact PellLightProduction.checked_615)

def pellFiniteCertificate_623 : PellFiniteCertificate 623 (10^275) :=
  pellFiniteCertificateOfLight 623 (10^275) 24 354 pellGraphCertificate_623 (by
    change pellLightFiniteCheck 623 24 (10^275) 354 PellLightProduction.magnitudes_623 = true
    exact PellLightProduction.checked_623)

def pellFiniteCertificate_631 : PellFiniteCertificate 631 (10^275) :=
  pellFiniteCertificateOfLight 631 (10^275) 25 575 pellGraphCertificate_631 (by
    change pellLightFiniteCheck 631 25 (10^275) 575 PellLightProduction.magnitudes_631 = true
    exact PellLightProduction.checked_631)

def pellFiniteCertificate_647 : PellFiniteCertificate 647 (10^275) :=
  pellFiniteCertificateOfLight 647 (10^275) 25 525 pellGraphCertificate_647 (by
    change pellLightFiniteCheck 647 25 (10^275) 525 PellLightProduction.magnitudes_647 = true
    exact PellLightProduction.checked_647)

def pellFiniteCertificate_655 : PellFiniteCertificate 655 (10^275) :=
  pellFiniteCertificateOfLight 655 (10^275) 25 480 (pellEmptyMatchingCertificate 655) (by
    change pellLightFiniteCheck 655 25 (10^275) 480 PellLightProduction.magnitudes_655 = true
    exact PellLightProduction.checked_655)

def pellFiniteCertificate_663 : PellFiniteCertificate 663 (10^275) :=
  pellFiniteCertificateOfLight 663 (10^275) 25 475 (pellEmptyMatchingCertificate 663) (by
    change pellLightFiniteCheck 663 25 (10^275) 475 PellLightProduction.magnitudes_663 = true
    exact PellLightProduction.checked_663)

def pellFiniteCertificate_671 : PellFiniteCertificate 671 (10^275) :=
  pellFiniteCertificateOfLight 671 (10^275) 25 540 (pellEmptyMatchingCertificate 671) (by
    change pellLightFiniteCheck 671 25 (10^275) 540 PellLightProduction.magnitudes_671 = true
    exact PellLightProduction.checked_671)

def pellFiniteCertificate_679 : PellFiniteCertificate 679 (10^275) :=
  pellFiniteCertificateOfLight 679 (10^275) 26 416 pellGraphCertificate_679 (by
    change pellLightFiniteCheck 679 26 (10^275) 416 PellLightProduction.magnitudes_679 = true
    exact PellLightProduction.checked_679)

def pellFiniteCertificate_687 : PellFiniteCertificate 687 (10^275) :=
  pellFiniteCertificateOfLight 687 (10^275) 26 499 (pellEmptyMatchingCertificate 687) (by
    change pellLightFiniteCheck 687 26 (10^275) 499 PellLightProduction.magnitudes_687 = true
    exact PellLightProduction.checked_687)

def pellFiniteCertificate_695 : PellFiniteCertificate 695 (10^275) :=
  pellFiniteCertificateOfLight 695 (10^275) 26 456 (pellEmptyMatchingCertificate 695) (by
    change pellLightFiniteCheck 695 26 (10^275) 456 PellLightProduction.magnitudes_695 = true
    exact PellLightProduction.checked_695)

def pellFiniteCertificate_703 : PellFiniteCertificate 703 (10^275) :=
  pellFiniteCertificateOfLight 703 (10^275) 26 430 (pellEmptyMatchingCertificate 703) (by
    change pellLightFiniteCheck 703 26 (10^275) 430 PellLightProduction.magnitudes_703 = true
    exact PellLightProduction.checked_703)

def pellFiniteCertificate_719 : PellFiniteCertificate 719 (10^275) :=
  pellFiniteCertificateOfLight 719 (10^275) 26 644 pellGraphCertificate_719 (by
    change pellLightFiniteCheck 719 26 (10^275) 644 PellLightProduction.magnitudes_719 = true
    exact PellLightProduction.checked_719)

def pellFiniteCertificate_727 : PellFiniteCertificate 727 (10^275) :=
  pellFiniteCertificateOfLight 727 (10^275) 26 348 pellGraphCertificate_727 (by
    change pellLightFiniteCheck 727 26 (10^275) 348 PellLightProduction.magnitudes_727 = true
    exact PellLightProduction.checked_727)

def pellFiniteCertificate_743 : PellFiniteCertificate 743 (10^275) :=
  pellFiniteCertificateOfLight 743 (10^275) 27 356 pellGraphCertificate_743 (by
    change pellLightFiniteCheck 743 27 (10^275) 356 PellLightProduction.magnitudes_743 = true
    exact PellLightProduction.checked_743)

def pellFiniteCertificate_751 : PellFiniteCertificate 751 (10^275) :=
  pellFiniteCertificateOfLight 751 (10^275) 27 569 pellGraphCertificate_751 (by
    change pellLightFiniteCheck 751 27 (10^275) 569 PellLightProduction.magnitudes_751 = true
    exact PellLightProduction.checked_751)

def pellFiniteCertificate_759 : PellFiniteCertificate 759 (10^275) :=
  pellFiniteCertificateOfLight 759 (10^275) 27 540 (pellEmptyMatchingCertificate 759) (by
    change pellLightFiniteCheck 759 27 (10^275) 540 PellLightProduction.magnitudes_759 = true
    exact PellLightProduction.checked_759)

def pellFiniteCertificate_767 : PellFiniteCertificate 767 (10^275) :=
  pellFiniteCertificateOfLight 767 (10^275) 27 686 (pellEmptyMatchingCertificate 767) (by
    change pellLightFiniteCheck 767 27 (10^275) 686 PellLightProduction.magnitudes_767 = true
    exact PellLightProduction.checked_767)

def pellFiniteCertificate_791 : PellFiniteCertificate 791 (10^275) :=
  pellFiniteCertificateOfLight 791 (10^275) 28 207 (pellEmptyMatchingCertificate 791) (by
    change pellLightFiniteCheck 791 28 (10^275) 207 PellLightProduction.magnitudes_791 = true
    exact PellLightProduction.checked_791)

def pellFiniteCertificate_799 : PellFiniteCertificate 799 (10^275) :=
  pellFiniteCertificateOfLight 799 (10^275) 28 376 (pellEmptyMatchingCertificate 799) (by
    change pellLightFiniteCheck 799 28 (10^275) 376 PellLightProduction.magnitudes_799 = true
    exact PellLightProduction.checked_799)

def pellFiniteCertificate_807 : PellFiniteCertificate 807 (10^275) :=
  pellFiniteCertificateOfLight 807 (10^275) 28 479 (pellEmptyMatchingCertificate 807) (by
    change pellLightFiniteCheck 807 28 (10^275) 479 PellLightProduction.magnitudes_807 = true
    exact PellLightProduction.checked_807)

def pellFiniteCertificate_815 : PellFiniteCertificate 815 (10^275) :=
  pellFiniteCertificateOfLight 815 (10^275) 28 600 (pellEmptyMatchingCertificate 815) (by
    change pellLightFiniteCheck 815 28 (10^275) 600 PellLightProduction.magnitudes_815 = true
    exact PellLightProduction.checked_815)

def pellFiniteCertificate_823 : PellFiniteCertificate 823 (10^275) :=
  pellFiniteCertificateOfLight 823 (10^275) 28 585 pellGraphCertificate_823 (by
    change pellLightFiniteCheck 823 28 (10^275) 585 PellLightProduction.magnitudes_823 = true
    exact PellLightProduction.checked_823)

def pellFiniteCertificate_831 : PellFiniteCertificate 831 (10^275) :=
  pellFiniteCertificateOfLight 831 (10^275) 28 678 (pellEmptyMatchingCertificate 831) (by
    change pellLightFiniteCheck 831 28 (10^275) 678 PellLightProduction.magnitudes_831 = true
    exact PellLightProduction.checked_831)

def pellFiniteCertificate_839 : PellFiniteCertificate 839 (10^275) :=
  pellFiniteCertificateOfLight 839 (10^275) 28 340 pellGraphCertificate_839 (by
    change pellLightFiniteCheck 839 28 (10^275) 340 PellLightProduction.magnitudes_839 = true
    exact PellLightProduction.checked_839)

def pellFiniteCertificate_863 : PellFiniteCertificate 863 (10^275) :=
  pellFiniteCertificateOfLight 863 (10^275) 29 520 pellGraphCertificate_863 (by
    change pellLightFiniteCheck 863 29 (10^275) 520 PellLightProduction.magnitudes_863 = true
    exact PellLightProduction.checked_863)

def pellFiniteCertificate_871 : PellFiniteCertificate 871 (10^275) :=
  pellFiniteCertificateOfLight 871 (10^275) 29 623 (pellEmptyMatchingCertificate 871) (by
    change pellLightFiniteCheck 871 29 (10^275) 623 PellLightProduction.magnitudes_871 = true
    exact PellLightProduction.checked_871)

def pellFiniteCertificate_879 : PellFiniteCertificate 879 (10^275) :=
  pellFiniteCertificateOfLight 879 (10^275) 29 594 (pellEmptyMatchingCertificate 879) (by
    change pellLightFiniteCheck 879 29 (10^275) 594 PellLightProduction.magnitudes_879 = true
    exact PellLightProduction.checked_879)

def pellFiniteCertificate_887 : PellFiniteCertificate 887 (10^275) :=
  pellFiniteCertificateOfLight 887 (10^275) 29 552 pellGraphCertificate_887 (by
    change pellLightFiniteCheck 887 29 (10^275) 552 PellLightProduction.magnitudes_887 = true
    exact PellLightProduction.checked_887)

def pellFiniteCertificate_895 : PellFiniteCertificate 895 (10^275) :=
  pellFiniteCertificateOfLight 895 (10^275) 29 384 (pellEmptyMatchingCertificate 895) (by
    change pellLightFiniteCheck 895 29 (10^275) 384 PellLightProduction.magnitudes_895 = true
    exact PellLightProduction.checked_895)

def pellFiniteCertificate_903 : PellFiniteCertificate 903 (10^275) :=
  pellFiniteCertificateOfLight 903 (10^275) 30 178 (pellEmptyMatchingCertificate 903) (by
    change pellLightFiniteCheck 903 30 (10^275) 178 PellLightProduction.magnitudes_903 = true
    exact PellLightProduction.checked_903)

def pellFiniteCertificate_911 : PellFiniteCertificate 911 (10^275) :=
  pellFiniteCertificateOfLight 911 (10^275) 30 444 pellGraphCertificate_911 (by
    change pellLightFiniteCheck 911 30 (10^275) 444 PellLightProduction.magnitudes_911 = true
    exact PellLightProduction.checked_911)

def pellFiniteCertificate_919 : PellFiniteCertificate 919 (10^275) :=
  pellFiniteCertificateOfLight 919 (10^275) 30 587 pellGraphCertificate_919 (by
    change pellLightFiniteCheck 919 30 (10^275) 587 PellLightProduction.magnitudes_919 = true
    exact PellLightProduction.checked_919)

def pellFiniteCertificate_935 : PellFiniteCertificate 935 (10^275) :=
  pellFiniteCertificateOfLight 935 (10^275) 30 640 (pellEmptyMatchingCertificate 935) (by
    change pellLightFiniteCheck 935 30 (10^275) 640 PellLightProduction.magnitudes_935 = true
    exact PellLightProduction.checked_935)

def pellFiniteCertificate_943 : PellFiniteCertificate 943 (10^275) :=
  pellFiniteCertificateOfLight 943 (10^275) 30 520 (pellEmptyMatchingCertificate 943) (by
    change pellLightFiniteCheck 943 30 (10^275) 520 PellLightProduction.magnitudes_943 = true
    exact PellLightProduction.checked_943)

def pellFiniteCertificate_951 : PellFiniteCertificate 951 (10^275) :=
  pellFiniteCertificateOfLight 951 (10^275) 30 572 (pellEmptyMatchingCertificate 951) (by
    change pellLightFiniteCheck 951 30 (10^275) 572 PellLightProduction.magnitudes_951 = true
    exact PellLightProduction.checked_951)

def pellFiniteCertificate_959 : PellFiniteCertificate 959 (10^275) :=
  pellFiniteCertificateOfLight 959 (10^275) 30 334 pellGraphCertificate_959 (by
    change pellLightFiniteCheck 959 30 (10^275) 334 PellLightProduction.magnitudes_959 = true
    exact PellLightProduction.checked_959)

def pellFiniteCertificate_967 : PellFiniteCertificate 967 (10^275) :=
  pellFiniteCertificateOfLight 967 (10^275) 31 464 pellGraphCertificate_967 (by
    change pellLightFiniteCheck 967 31 (10^275) 464 PellLightProduction.magnitudes_967 = true
    exact PellLightProduction.checked_967)

def pellFiniteCertificate_983 : PellFiniteCertificate 983 (10^275) :=
  pellFiniteCertificateOfLight 983 (10^275) 31 381 pellGraphCertificate_983 (by
    change pellLightFiniteCheck 983 31 (10^275) 381 PellLightProduction.magnitudes_983 = true
    exact PellLightProduction.checked_983)

def pellFiniteCertificate_991 : PellFiniteCertificate 991 (10^275) :=
  pellFiniteCertificateOfLight 991 (10^275) 31 550 pellGraphCertificate_991 (by
    change pellLightFiniteCheck 991 31 (10^275) 550 PellLightProduction.magnitudes_991 = true
    exact PellLightProduction.checked_991)

def pellFiniteCertificate_1007 : PellFiniteCertificate 1007 (10^275) :=
  pellFiniteCertificateOfLight 1007 (10^275) 31 552 (pellEmptyMatchingCertificate 1007) (by
    change pellLightFiniteCheck 1007 31 (10^275) 552 PellLightProduction.magnitudes_1007 = true
    exact PellLightProduction.checked_1007)

def pellFiniteCertificate_1015 : PellFiniteCertificate 1015 (10^275) :=
  pellFiniteCertificateOfLight 1015 (10^275) 31 376 (pellEmptyMatchingCertificate 1015) (by
    change pellLightFiniteCheck 1015 31 (10^275) 376 PellLightProduction.magnitudes_1015 = true
    exact PellLightProduction.checked_1015)

def pellFiniteCertificate_1023 : PellFiniteCertificate 1023 (10^275) :=
  pellFiniteCertificateOfLight 1023 (10^275) 31 304 (pellEmptyMatchingCertificate 1023) (by
    change pellLightFiniteCheck 1023 31 (10^275) 304 PellLightProduction.magnitudes_1023 = true
    exact PellLightProduction.checked_1023)

def pellFiniteCertificate_1031 : PellFiniteCertificate 1031 (10^275) :=
  pellFiniteCertificateOfLight 1031 (10^275) 32 506 pellGraphCertificate_1031 (by
    change pellLightFiniteCheck 1031 32 (10^275) 506 PellLightProduction.magnitudes_1031 = true
    exact PellLightProduction.checked_1031)

def pellFiniteCertificate_1039 : PellFiniteCertificate 1039 (10^275) :=
  pellFiniteCertificateOfLight 1039 (10^275) 32 569 pellGraphCertificate_1039 (by
    change pellLightFiniteCheck 1039 32 (10^275) 569 PellLightProduction.magnitudes_1039 = true
    exact PellLightProduction.checked_1039)

def pellFiniteCertificate_1047 : PellFiniteCertificate 1047 (10^275) :=
  pellFiniteCertificateOfLight 1047 (10^275) 32 505 (pellEmptyMatchingCertificate 1047) (by
    change pellLightFiniteCheck 1047 32 (10^275) 505 PellLightProduction.magnitudes_1047 = true
    exact PellLightProduction.checked_1047)

def pellFiniteCertificate_1055 : PellFiniteCertificate 1055 (10^275) :=
  pellFiniteCertificateOfLight 1055 (10^275) 32 312 (pellEmptyMatchingCertificate 1055) (by
    change pellLightFiniteCheck 1055 32 (10^275) 312 PellLightProduction.magnitudes_1055 = true
    exact PellLightProduction.checked_1055)

def pellFiniteCertificate_1063 : PellFiniteCertificate 1063 (10^275) :=
  pellFiniteCertificateOfLight 1063 (10^275) 32 563 pellGraphCertificate_1063 (by
    change pellLightFiniteCheck 1063 32 (10^275) 563 PellLightProduction.magnitudes_1063 = true
    exact PellLightProduction.checked_1063)

def pellFiniteCertificate_1079 : PellFiniteCertificate 1079 (10^275) :=
  pellFiniteCertificateOfLight 1079 (10^275) 32 640 (pellEmptyMatchingCertificate 1079) (by
    change pellLightFiniteCheck 1079 32 (10^275) 640 PellLightProduction.magnitudes_1079 = true
    exact PellLightProduction.checked_1079)

def pellFiniteCertificate_1087 : PellFiniteCertificate 1087 (10^275) :=
  pellFiniteCertificateOfLight 1087 (10^275) 32 328 pellGraphCertificate_1087 (by
    change pellLightFiniteCheck 1087 32 (10^275) 328 PellLightProduction.magnitudes_1087 = true
    exact PellLightProduction.checked_1087)

def pellFiniteCertificate_1095 : PellFiniteCertificate 1095 (10^275) :=
  pellFiniteCertificateOfLight 1095 (10^275) 33 192 (pellEmptyMatchingCertificate 1095) (by
    change pellLightFiniteCheck 1095 33 (10^275) 192 PellLightProduction.magnitudes_1095 = true
    exact PellLightProduction.checked_1095)

def pellFiniteCertificate_1103 : PellFiniteCertificate 1103 (10^275) :=
  pellFiniteCertificateOfLight 1103 (10^275) 33 518 pellGraphCertificate_1103 (by
    change pellLightFiniteCheck 1103 33 (10^275) 518 PellLightProduction.magnitudes_1103 = true
    exact PellLightProduction.checked_1103)

def pellFiniteCertificate_1111 : PellFiniteCertificate 1111 (10^275) :=
  pellFiniteCertificateOfLight 1111 (10^275) 33 238 (pellEmptyMatchingCertificate 1111) (by
    change pellLightFiniteCheck 1111 33 (10^275) 238 PellLightProduction.magnitudes_1111 = true
    exact PellLightProduction.checked_1111)

def pellFiniteCertificate_1119 : PellFiniteCertificate 1119 (10^275) :=
  pellFiniteCertificateOfLight 1119 (10^275) 33 492 (pellEmptyMatchingCertificate 1119) (by
    change pellLightFiniteCheck 1119 33 (10^275) 492 PellLightProduction.magnitudes_1119 = true
    exact PellLightProduction.checked_1119)

def pellFiniteCertificate_1135 : PellFiniteCertificate 1135 (10^275) :=
  pellFiniteCertificateOfLight 1135 (10^275) 33 658 (pellEmptyMatchingCertificate 1135) (by
    change pellLightFiniteCheck 1135 33 (10^275) 658 PellLightProduction.magnitudes_1135 = true
    exact PellLightProduction.checked_1135)

def pellFiniteCertificate_1151 : PellFiniteCertificate 1151 (10^275) :=
  pellFiniteCertificateOfLight 1151 (10^275) 33 493 pellGraphCertificate_1151 (by
    change pellLightFiniteCheck 1151 33 (10^275) 493 PellLightProduction.magnitudes_1151 = true
    exact PellLightProduction.checked_1151)

def pellFiniteCertificate_1159 : PellFiniteCertificate 1159 (10^275) :=
  pellFiniteCertificateOfLight 1159 (10^275) 34 460 (pellEmptyMatchingCertificate 1159) (by
    change pellLightFiniteCheck 1159 34 (10^275) 460 PellLightProduction.magnitudes_1159 = true
    exact PellLightProduction.checked_1159)

def pellFiniteCertificate_1167 : PellFiniteCertificate 1167 (10^275) :=
  pellFiniteCertificateOfLight 1167 (10^275) 34 281 (pellEmptyMatchingCertificate 1167) (by
    change pellLightFiniteCheck 1167 34 (10^275) 281 PellLightProduction.magnitudes_1167 = true
    exact PellLightProduction.checked_1167)

def pellFiniteCertificate_1191 : PellFiniteCertificate 1191 (10^275) :=
  pellFiniteCertificateOfLight 1191 (10^275) 34 432 (pellEmptyMatchingCertificate 1191) (by
    change pellLightFiniteCheck 1191 34 (10^275) 432 PellLightProduction.magnitudes_1191 = true
    exact PellLightProduction.checked_1191)

def pellFiniteCertificate_1199 : PellFiniteCertificate 1199 (10^275) :=
  pellFiniteCertificateOfLight 1199 (10^275) 34 549 (pellEmptyMatchingCertificate 1199) (by
    change pellLightFiniteCheck 1199 34 (10^275) 549 PellLightProduction.magnitudes_1199 = true
    exact PellLightProduction.checked_1199)

def pellFiniteCertificate_1207 : PellFiniteCertificate 1207 (10^275) :=
  pellFiniteCertificateOfLight 1207 (10^275) 34 516 pellGraphCertificate_1207 (by
    change pellLightFiniteCheck 1207 34 (10^275) 516 PellLightProduction.magnitudes_1207 = true
    exact PellLightProduction.checked_1207)

def pellFiniteCertificate_1223 : PellFiniteCertificate 1223 (10^275) :=
  pellFiniteCertificateOfLight 1223 (10^275) 34 324 pellGraphCertificate_1223 (by
    change pellLightFiniteCheck 1223 34 (10^275) 324 PellLightProduction.magnitudes_1223 = true
    exact PellLightProduction.checked_1223)

def pellFiniteCertificate_1231 : PellFiniteCertificate 1231 (10^275) :=
  pellFiniteCertificateOfLight 1231 (10^275) 35 489 pellGraphCertificate_1231 (by
    change pellLightFiniteCheck 1231 35 (10^275) 489 PellLightProduction.magnitudes_1231 = true
    exact PellLightProduction.checked_1231)

def pellFiniteCertificate_1239 : PellFiniteCertificate 1239 (10^275) :=
  pellFiniteCertificateOfLight 1239 (10^275) 35 216 (pellEmptyMatchingCertificate 1239) (by
    change pellLightFiniteCheck 1239 35 (10^275) 216 PellLightProduction.magnitudes_1239 = true
    exact PellLightProduction.checked_1239)

def pellFiniteCertificate_1247 : PellFiniteCertificate 1247 (10^275) :=
  pellFiniteCertificateOfLight 1247 (10^275) 35 350 (pellEmptyMatchingCertificate 1247) (by
    change pellLightFiniteCheck 1247 35 (10^275) 350 PellLightProduction.magnitudes_1247 = true
    exact PellLightProduction.checked_1247)

def pellFiniteCertificate_1255 : PellFiniteCertificate 1255 (10^275) :=
  pellFiniteCertificateOfLight 1255 (10^275) 35 478 (pellEmptyMatchingCertificate 1255) (by
    change pellLightFiniteCheck 1255 35 (10^275) 478 PellLightProduction.magnitudes_1255 = true
    exact PellLightProduction.checked_1255)

def pellFiniteCertificate_1263 : PellFiniteCertificate 1263 (10^275) :=
  pellFiniteCertificateOfLight 1263 (10^275) 35 503 (pellEmptyMatchingCertificate 1263) (by
    change pellLightFiniteCheck 1263 35 (10^275) 503 PellLightProduction.magnitudes_1263 = true
    exact PellLightProduction.checked_1263)

def pellFiniteCertificate_1271 : PellFiniteCertificate 1271 (10^275) :=
  pellFiniteCertificateOfLight 1271 (10^275) 35 570 (pellEmptyMatchingCertificate 1271) (by
    change pellLightFiniteCheck 1271 35 (10^275) 570 PellLightProduction.magnitudes_1271 = true
    exact PellLightProduction.checked_1271)

def pellFiniteCertificate_1279 : PellFiniteCertificate 1279 (10^275) :=
  pellFiniteCertificateOfLight 1279 (10^275) 35 594 pellGraphCertificate_1279 (by
    change pellLightFiniteCheck 1279 35 (10^275) 594 PellLightProduction.magnitudes_1279 = true
    exact PellLightProduction.checked_1279)

def pellFiniteCertificate_1295 : PellFiniteCertificate 1295 (10^275) :=
  pellFiniteCertificateOfLight 1295 (10^275) 35 296 (pellEmptyMatchingCertificate 1295) (by
    change pellLightFiniteCheck 1295 35 (10^275) 296 PellLightProduction.magnitudes_1295 = true
    exact PellLightProduction.checked_1295)

def pellFiniteCertificate_1303 : PellFiniteCertificate 1303 (10^275) :=
  pellFiniteCertificateOfLight 1303 (10^275) 36 553 pellGraphCertificate_1303 (by
    change pellLightFiniteCheck 1303 36 (10^275) 553 PellLightProduction.magnitudes_1303 = true
    exact PellLightProduction.checked_1303)

def pellFiniteCertificate_1311 : PellFiniteCertificate 1311 (10^275) :=
  pellFiniteCertificateOfLight 1311 (10^275) 36 490 (pellEmptyMatchingCertificate 1311) (by
    change pellLightFiniteCheck 1311 36 (10^275) 490 PellLightProduction.magnitudes_1311 = true
    exact PellLightProduction.checked_1311)

def pellFiniteCertificate_1319 : PellFiniteCertificate 1319 (10^275) :=
  pellFiniteCertificateOfLight 1319 (10^275) 36 466 pellGraphCertificate_1319 (by
    change pellLightFiniteCheck 1319 36 (10^275) 466 PellLightProduction.magnitudes_1319 = true
    exact PellLightProduction.checked_1319)

def pellFiniteCertificate_1327 : PellFiniteCertificate 1327 (10^275) :=
  pellFiniteCertificateOfLight 1327 (10^275) 36 428 pellGraphCertificate_1327 (by
    change pellLightFiniteCheck 1327 36 (10^275) 428 PellLightProduction.magnitudes_1327 = true
    exact PellLightProduction.checked_1327)

def pellFiniteCertificate_1335 : PellFiniteCertificate 1335 (10^275) :=
  pellFiniteCertificateOfLight 1335 (10^275) 36 443 (pellEmptyMatchingCertificate 1335) (by
    change pellLightFiniteCheck 1335 36 (10^275) 443 PellLightProduction.magnitudes_1335 = true
    exact PellLightProduction.checked_1335)

def pellFiniteCertificate_1343 : PellFiniteCertificate 1343 (10^275) :=
  pellFiniteCertificateOfLight 1343 (10^275) 36 558 pellGraphCertificate_1343 (by
    change pellLightFiniteCheck 1343 36 (10^275) 558 PellLightProduction.magnitudes_1343 = true
    exact PellLightProduction.checked_1343)

def pellFiniteCertificate_1351 : PellFiniteCertificate 1351 (10^275) :=
  pellFiniteCertificateOfLight 1351 (10^275) 36 402 (pellEmptyMatchingCertificate 1351) (by
    change pellLightFiniteCheck 1351 36 (10^275) 402 PellLightProduction.magnitudes_1351 = true
    exact PellLightProduction.checked_1351)

def pellFiniteCertificate_1367 : PellFiniteCertificate 1367 (10^275) :=
  pellFiniteCertificateOfLight 1367 (10^275) 36 320 pellGraphCertificate_1367 (by
    change pellLightFiniteCheck 1367 36 (10^275) 320 PellLightProduction.magnitudes_1367 = true
    exact PellLightProduction.checked_1367)

def pellFiniteCertificate_1383 : PellFiniteCertificate 1383 (10^275) :=
  pellFiniteCertificateOfLight 1383 (10^275) 37 429 (pellEmptyMatchingCertificate 1383) (by
    change pellLightFiniteCheck 1383 37 (10^275) 429 PellLightProduction.magnitudes_1383 = true
    exact PellLightProduction.checked_1383)

def pellFiniteCertificate_1391 : PellFiniteCertificate 1391 (10^275) :=
  pellFiniteCertificateOfLight 1391 (10^275) 37 606 (pellEmptyMatchingCertificate 1391) (by
    change pellLightFiniteCheck 1391 37 (10^275) 606 PellLightProduction.magnitudes_1391 = true
    exact PellLightProduction.checked_1391)

def pellFiniteCertificate_1399 : PellFiniteCertificate 1399 (10^275) :=
  pellFiniteCertificateOfLight 1399 (10^275) 37 476 pellGraphCertificate_1399 (by
    change pellLightFiniteCheck 1399 37 (10^275) 476 PellLightProduction.magnitudes_1399 = true
    exact PellLightProduction.checked_1399)

def pellFiniteCertificate_1407 : PellFiniteCertificate 1407 (10^275) :=
  pellFiniteCertificateOfLight 1407 (10^275) 37 426 (pellEmptyMatchingCertificate 1407) (by
    change pellLightFiniteCheck 1407 37 (10^275) 426 PellLightProduction.magnitudes_1407 = true
    exact PellLightProduction.checked_1407)

def pellFiniteCertificate_1415 : PellFiniteCertificate 1415 (10^275) :=
  pellFiniteCertificateOfLight 1415 (10^275) 37 720 (pellEmptyMatchingCertificate 1415) (by
    change pellLightFiniteCheck 1415 37 (10^275) 720 PellLightProduction.magnitudes_1415 = true
    exact PellLightProduction.checked_1415)

def pellFiniteCertificate_1423 : PellFiniteCertificate 1423 (10^275) :=
  pellFiniteCertificateOfLight 1423 (10^275) 37 503 pellGraphCertificate_1423 (by
    change pellLightFiniteCheck 1423 37 (10^275) 503 PellLightProduction.magnitudes_1423 = true
    exact PellLightProduction.checked_1423)

def pellFiniteCertificate_1439 : PellFiniteCertificate 1439 (10^275) :=
  pellFiniteCertificateOfLight 1439 (10^275) 37 507 pellGraphCertificate_1439 (by
    change pellLightFiniteCheck 1439 37 (10^275) 507 PellLightProduction.magnitudes_1439 = true
    exact PellLightProduction.checked_1439)

def pellFiniteCertificate_1447 : PellFiniteCertificate 1447 (10^275) :=
  pellFiniteCertificateOfLight 1447 (10^275) 38 506 pellGraphCertificate_1447 (by
    change pellLightFiniteCheck 1447 38 (10^275) 506 PellLightProduction.magnitudes_1447 = true
    exact PellLightProduction.checked_1447)

def pellFiniteCertificate_1455 : PellFiniteCertificate 1455 (10^275) :=
  pellFiniteCertificateOfLight 1455 (10^275) 38 353 (pellEmptyMatchingCertificate 1455) (by
    change pellLightFiniteCheck 1455 38 (10^275) 353 PellLightProduction.magnitudes_1455 = true
    exact PellLightProduction.checked_1455)

def pellFiniteCertificate_1463 : PellFiniteCertificate 1463 (10^275) :=
  pellFiniteCertificateOfLight 1463 (10^275) 38 220 (pellEmptyMatchingCertificate 1463) (by
    change pellLightFiniteCheck 1463 38 (10^275) 220 PellLightProduction.magnitudes_1463 = true
    exact PellLightProduction.checked_1463)

def pellFiniteCertificate_1471 : PellFiniteCertificate 1471 (10^275) :=
  pellFiniteCertificateOfLight 1471 (10^275) 38 553 pellGraphCertificate_1471 (by
    change pellLightFiniteCheck 1471 38 (10^275) 553 PellLightProduction.magnitudes_1471 = true
    exact PellLightProduction.checked_1471)

def pellFiniteCertificate_1479 : PellFiniteCertificate 1479 (10^275) :=
  pellFiniteCertificateOfLight 1479 (10^275) 38 632 (pellEmptyMatchingCertificate 1479) (by
    change pellLightFiniteCheck 1479 38 (10^275) 632 PellLightProduction.magnitudes_1479 = true
    exact PellLightProduction.checked_1479)

def pellFiniteCertificate_1487 : PellFiniteCertificate 1487 (10^275) :=
  pellFiniteCertificateOfLight 1487 (10^275) 38 608 pellGraphCertificate_1487 (by
    change pellLightFiniteCheck 1487 38 (10^275) 608 PellLightProduction.magnitudes_1487 = true
    exact PellLightProduction.checked_1487)

def pellFiniteCertificate_1495 : PellFiniteCertificate 1495 (10^275) :=
  pellFiniteCertificateOfLight 1495 (10^275) 38 464 (pellEmptyMatchingCertificate 1495) (by
    change pellLightFiniteCheck 1495 38 (10^275) 464 PellLightProduction.magnitudes_1495 = true
    exact PellLightProduction.checked_1495)

def pellFiniteCertificate_1511 : PellFiniteCertificate 1511 (10^275) :=
  pellFiniteCertificateOfLight 1511 (10^275) 38 584 pellGraphCertificate_1511 (by
    change pellLightFiniteCheck 1511 38 (10^275) 584 PellLightProduction.magnitudes_1511 = true
    exact PellLightProduction.checked_1511)

def pellFiniteCertificate_1527 : PellFiniteCertificate 1527 (10^275) :=
  pellFiniteCertificateOfLight 1527 (10^275) 39 182 (pellEmptyMatchingCertificate 1527) (by
    change pellLightFiniteCheck 1527 39 (10^275) 182 PellLightProduction.magnitudes_1527 = true
    exact PellLightProduction.checked_1527)

def pellFiniteCertificate_1535 : PellFiniteCertificate 1535 (10^275) :=
  pellFiniteCertificateOfLight 1535 (10^275) 39 511 (pellEmptyMatchingCertificate 1535) (by
    change pellLightFiniteCheck 1535 39 (10^275) 511 PellLightProduction.magnitudes_1535 = true
    exact PellLightProduction.checked_1535)

def pellFiniteCertificate_1543 : PellFiniteCertificate 1543 (10^275) :=
  pellFiniteCertificateOfLight 1543 (10^275) 39 568 pellGraphCertificate_1543 (by
    change pellLightFiniteCheck 1543 39 (10^275) 568 PellLightProduction.magnitudes_1543 = true
    exact PellLightProduction.checked_1543)

def pellFiniteCertificate_1551 : PellFiniteCertificate 1551 (10^275) :=
  pellFiniteCertificateOfLight 1551 (10^275) 39 754 (pellEmptyMatchingCertificate 1551) (by
    change pellLightFiniteCheck 1551 39 (10^275) 754 PellLightProduction.magnitudes_1551 = true
    exact PellLightProduction.checked_1551)

def pellFiniteCertificate_1559 : PellFiniteCertificate 1559 (10^275) :=
  pellFiniteCertificateOfLight 1559 (10^275) 39 491 pellGraphCertificate_1559 (by
    change pellLightFiniteCheck 1559 39 (10^275) 491 PellLightProduction.magnitudes_1559 = true
    exact PellLightProduction.checked_1559)

def pellFiniteCertificate_1567 : PellFiniteCertificate 1567 (10^275) :=
  pellFiniteCertificateOfLight 1567 (10^275) 39 490 pellGraphCertificate_1567 (by
    change pellLightFiniteCheck 1567 39 (10^275) 490 PellLightProduction.magnitudes_1567 = true
    exact PellLightProduction.checked_1567)

def pellFiniteCertificate_1583 : PellFiniteCertificate 1583 (10^275) :=
  pellFiniteCertificateOfLight 1583 (10^275) 39 615 pellGraphCertificate_1583 (by
    change pellLightFiniteCheck 1583 39 (10^275) 615 PellLightProduction.magnitudes_1583 = true
    exact PellLightProduction.checked_1583)

def pellFiniteCertificate_1591 : PellFiniteCertificate 1591 (10^275) :=
  pellFiniteCertificateOfLight 1591 (10^275) 39 539 (pellEmptyMatchingCertificate 1591) (by
    change pellLightFiniteCheck 1591 39 (10^275) 539 PellLightProduction.magnitudes_1591 = true
    exact PellLightProduction.checked_1591)

def pellFiniteCertificate_1599 : PellFiniteCertificate 1599 (10^275) :=
  pellFiniteCertificateOfLight 1599 (10^275) 39 288 (pellEmptyMatchingCertificate 1599) (by
    change pellLightFiniteCheck 1599 39 (10^275) 288 PellLightProduction.magnitudes_1599 = true
    exact PellLightProduction.checked_1599)

def pellFiniteCertificate_1607 : PellFiniteCertificate 1607 (10^275) :=
  pellFiniteCertificateOfLight 1607 (10^275) 40 532 pellGraphCertificate_1607 (by
    change pellLightFiniteCheck 1607 40 (10^275) 532 PellLightProduction.magnitudes_1607 = true
    exact PellLightProduction.checked_1607)

def pellFiniteCertificate_1615 : PellFiniteCertificate 1615 (10^275) :=
  pellFiniteCertificateOfLight 1615 (10^275) 40 401 (pellEmptyMatchingCertificate 1615) (by
    change pellLightFiniteCheck 1615 40 (10^275) 401 PellLightProduction.magnitudes_1615 = true
    exact PellLightProduction.checked_1615)

def pellFiniteCertificate_1623 : PellFiniteCertificate 1623 (10^275) :=
  pellFiniteCertificateOfLight 1623 (10^275) 40 327 (pellEmptyMatchingCertificate 1623) (by
    change pellLightFiniteCheck 1623 40 (10^275) 327 PellLightProduction.magnitudes_1623 = true
    exact PellLightProduction.checked_1623)

def pellFiniteCertificate_1631 : PellFiniteCertificate 1631 (10^275) :=
  pellFiniteCertificateOfLight 1631 (10^275) 40 560 (pellEmptyMatchingCertificate 1631) (by
    change pellLightFiniteCheck 1631 40 (10^275) 560 PellLightProduction.magnitudes_1631 = true
    exact PellLightProduction.checked_1631)

def pellFiniteCertificate_1639 : PellFiniteCertificate 1639 (10^275) :=
  pellFiniteCertificateOfLight 1639 (10^275) 40 426 (pellEmptyMatchingCertificate 1639) (by
    change pellLightFiniteCheck 1639 40 (10^275) 426 PellLightProduction.magnitudes_1639 = true
    exact PellLightProduction.checked_1639)

def pellFiniteCertificate_1655 : PellFiniteCertificate 1655 (10^275) :=
  pellFiniteCertificateOfLight 1655 (10^275) 40 378 (pellEmptyMatchingCertificate 1655) (by
    change pellLightFiniteCheck 1655 40 (10^275) 378 PellLightProduction.magnitudes_1655 = true
    exact PellLightProduction.checked_1655)

def pellFiniteCertificate_1663 : PellFiniteCertificate 1663 (10^275) :=
  pellFiniteCertificateOfLight 1663 (10^275) 40 558 pellGraphCertificate_1663 (by
    change pellLightFiniteCheck 1663 40 (10^275) 558 PellLightProduction.magnitudes_1663 = true
    exact PellLightProduction.checked_1663)

def pellFiniteCertificate_1671 : PellFiniteCertificate 1671 (10^275) :=
  pellFiniteCertificateOfLight 1671 (10^275) 40 377 (pellEmptyMatchingCertificate 1671) (by
    change pellLightFiniteCheck 1671 40 (10^275) 377 PellLightProduction.magnitudes_1671 = true
    exact PellLightProduction.checked_1671)

def pellFiniteCertificate_1679 : PellFiniteCertificate 1679 (10^275) :=
  pellFiniteCertificateOfLight 1679 (10^275) 40 312 pellGraphCertificate_1679 (by
    change pellLightFiniteCheck 1679 40 (10^275) 312 PellLightProduction.magnitudes_1679 = true
    exact PellLightProduction.checked_1679)

def pellFiniteCertificate_1687 : PellFiniteCertificate 1687 (10^275) :=
  pellFiniteCertificateOfLight 1687 (10^275) 41 397 pellGraphCertificate_1687 (by
    change pellLightFiniteCheck 1687 41 (10^275) 397 PellLightProduction.magnitudes_1687 = true
    exact PellLightProduction.checked_1687)

def pellFiniteCertificate_1695 : PellFiniteCertificate 1695 (10^275) :=
  pellFiniteCertificateOfLight 1695 (10^275) 41 480 (pellEmptyMatchingCertificate 1695) (by
    change pellLightFiniteCheck 1695 41 (10^275) 480 PellLightProduction.magnitudes_1695 = true
    exact PellLightProduction.checked_1695)

def pellFiniteCertificate_1703 : PellFiniteCertificate 1703 (10^275) :=
  pellFiniteCertificateOfLight 1703 (10^275) 41 499 (pellEmptyMatchingCertificate 1703) (by
    change pellLightFiniteCheck 1703 41 (10^275) 499 PellLightProduction.magnitudes_1703 = true
    exact PellLightProduction.checked_1703)

def pellFiniteCertificate_1711 : PellFiniteCertificate 1711 (10^275) :=
  pellFiniteCertificateOfLight 1711 (10^275) 41 492 (pellEmptyMatchingCertificate 1711) (by
    change pellLightFiniteCheck 1711 41 (10^275) 492 PellLightProduction.magnitudes_1711 = true
    exact PellLightProduction.checked_1711)

def pellFiniteCertificate_1727 : PellFiniteCertificate 1727 (10^275) :=
  pellFiniteCertificateOfLight 1727 (10^275) 41 583 (pellEmptyMatchingCertificate 1727) (by
    change pellLightFiniteCheck 1727 41 (10^275) 583 PellLightProduction.magnitudes_1727 = true
    exact PellLightProduction.checked_1727)

def pellFiniteCertificate_1735 : PellFiniteCertificate 1735 (10^275) :=
  pellFiniteCertificateOfLight 1735 (10^275) 41 578 (pellEmptyMatchingCertificate 1735) (by
    change pellLightFiniteCheck 1735 41 (10^275) 578 PellLightProduction.magnitudes_1735 = true
    exact PellLightProduction.checked_1735)

def pellFiniteCertificate_1743 : PellFiniteCertificate 1743 (10^275) :=
  pellFiniteCertificateOfLight 1743 (10^275) 41 436 (pellEmptyMatchingCertificate 1743) (by
    change pellLightFiniteCheck 1743 41 (10^275) 436 PellLightProduction.magnitudes_1743 = true
    exact PellLightProduction.checked_1743)

def pellFiniteCertificate_1751 : PellFiniteCertificate 1751 (10^275) :=
  pellFiniteCertificateOfLight 1751 (10^275) 41 454 (pellEmptyMatchingCertificate 1751) (by
    change pellLightFiniteCheck 1751 41 (10^275) 454 PellLightProduction.magnitudes_1751 = true
    exact PellLightProduction.checked_1751)

def pellFiniteCertificate_1759 : PellFiniteCertificate 1759 (10^275) :=
  pellFiniteCertificateOfLight 1759 (10^275) 41 571 pellGraphCertificate_1759 (by
    change pellLightFiniteCheck 1759 41 (10^275) 571 PellLightProduction.magnitudes_1759 = true
    exact PellLightProduction.checked_1759)

def pellFiniteCertificate_1767 : PellFiniteCertificate 1767 (10^275) :=
  pellFiniteCertificateOfLight 1767 (10^275) 42 163 (pellEmptyMatchingCertificate 1767) (by
    change pellLightFiniteCheck 1767 42 (10^275) 163 PellLightProduction.magnitudes_1767 = true
    exact PellLightProduction.checked_1767)

def pellFiniteCertificate_1783 : PellFiniteCertificate 1783 (10^275) :=
  pellFiniteCertificateOfLight 1783 (10^275) 42 554 pellGraphCertificate_1783 (by
    change pellLightFiniteCheck 1783 42 (10^275) 554 PellLightProduction.magnitudes_1783 = true
    exact PellLightProduction.checked_1783)

def pellFiniteCertificate_1799 : PellFiniteCertificate 1799 (10^275) :=
  pellFiniteCertificateOfLight 1799 (10^275) 42 486 pellGraphCertificate_1799 (by
    change pellLightFiniteCheck 1799 42 (10^275) 486 PellLightProduction.magnitudes_1799 = true
    exact PellLightProduction.checked_1799)

def pellFiniteCertificate_1807 : PellFiniteCertificate 1807 (10^275) :=
  pellFiniteCertificateOfLight 1807 (10^275) 42 532 (pellEmptyMatchingCertificate 1807) (by
    change pellLightFiniteCheck 1807 42 (10^275) 532 PellLightProduction.magnitudes_1807 = true
    exact PellLightProduction.checked_1807)

def pellFiniteCertificate_1823 : PellFiniteCertificate 1823 (10^275) :=
  pellFiniteCertificateOfLight 1823 (10^275) 42 644 pellGraphCertificate_1823 (by
    change pellLightFiniteCheck 1823 42 (10^275) 644 PellLightProduction.magnitudes_1823 = true
    exact PellLightProduction.checked_1823)

def pellFiniteCertificate_1831 : PellFiniteCertificate 1831 (10^275) :=
  pellFiniteCertificateOfLight 1831 (10^275) 42 583 pellGraphCertificate_1831 (by
    change pellLightFiniteCheck 1831 42 (10^275) 583 PellLightProduction.magnitudes_1831 = true
    exact PellLightProduction.checked_1831)

def pellFiniteCertificate_1839 : PellFiniteCertificate 1839 (10^275) :=
  pellFiniteCertificateOfLight 1839 (10^275) 42 497 (pellEmptyMatchingCertificate 1839) (by
    change pellLightFiniteCheck 1839 42 (10^275) 497 PellLightProduction.magnitudes_1839 = true
    exact PellLightProduction.checked_1839)

def pellFiniteCertificate_1847 : PellFiniteCertificate 1847 (10^275) :=
  pellFiniteCertificateOfLight 1847 (10^275) 42 308 pellGraphCertificate_1847 (by
    change pellLightFiniteCheck 1847 42 (10^275) 308 PellLightProduction.magnitudes_1847 = true
    exact PellLightProduction.checked_1847)

def pellFiniteCertificate_1855 : PellFiniteCertificate 1855 (10^275) :=
  pellFiniteCertificateOfLight 1855 (10^275) 43 381 (pellEmptyMatchingCertificate 1855) (by
    change pellLightFiniteCheck 1855 43 (10^275) 381 PellLightProduction.magnitudes_1855 = true
    exact PellLightProduction.checked_1855)

def pellFiniteCertificate_1871 : PellFiniteCertificate 1871 (10^275) :=
  pellFiniteCertificateOfLight 1871 (10^275) 43 516 pellGraphCertificate_1871 (by
    change pellLightFiniteCheck 1871 43 (10^275) 516 PellLightProduction.magnitudes_1871 = true
    exact PellLightProduction.checked_1871)

def pellFiniteCertificate_1879 : PellFiniteCertificate 1879 (10^275) :=
  pellFiniteCertificateOfLight 1879 (10^275) 43 531 pellGraphCertificate_1879 (by
    change pellLightFiniteCheck 1879 43 (10^275) 531 PellLightProduction.magnitudes_1879 = true
    exact PellLightProduction.checked_1879)

def pellFiniteCertificate_1887 : PellFiniteCertificate 1887 (10^275) :=
  pellFiniteCertificateOfLight 1887 (10^275) 43 516 (pellEmptyMatchingCertificate 1887) (by
    change pellLightFiniteCheck 1887 43 (10^275) 516 PellLightProduction.magnitudes_1887 = true
    exact PellLightProduction.checked_1887)

def pellFiniteCertificate_1895 : PellFiniteCertificate 1895 (10^275) :=
  pellFiniteCertificateOfLight 1895 (10^275) 43 544 (pellEmptyMatchingCertificate 1895) (by
    change pellLightFiniteCheck 1895 43 (10^275) 544 PellLightProduction.magnitudes_1895 = true
    exact PellLightProduction.checked_1895)

def pellFiniteCertificate_1903 : PellFiniteCertificate 1903 (10^275) :=
  pellFiniteCertificateOfLight 1903 (10^275) 43 533 (pellEmptyMatchingCertificate 1903) (by
    change pellLightFiniteCheck 1903 43 (10^275) 533 PellLightProduction.magnitudes_1903 = true
    exact PellLightProduction.checked_1903)

def pellFiniteCertificate_1919 : PellFiniteCertificate 1919 (10^275) :=
  pellFiniteCertificateOfLight 1919 (10^275) 43 441 (pellEmptyMatchingCertificate 1919) (by
    change pellLightFiniteCheck 1919 43 (10^275) 441 PellLightProduction.magnitudes_1919 = true
    exact PellLightProduction.checked_1919)

def pellFiniteCertificate_1927 : PellFiniteCertificate 1927 (10^275) :=
  pellFiniteCertificateOfLight 1927 (10^275) 43 627 pellGraphCertificate_1927 (by
    change pellLightFiniteCheck 1927 43 (10^275) 627 PellLightProduction.magnitudes_1927 = true
    exact PellLightProduction.checked_1927)

def pellFiniteCertificate_1943 : PellFiniteCertificate 1943 (10^275) :=
  pellFiniteCertificateOfLight 1943 (10^275) 44 420 (pellEmptyMatchingCertificate 1943) (by
    change pellLightFiniteCheck 1943 44 (10^275) 420 PellLightProduction.magnitudes_1943 = true
    exact PellLightProduction.checked_1943)

def pellFiniteCertificate_1951 : PellFiniteCertificate 1951 (10^275) :=
  pellFiniteCertificateOfLight 1951 (10^275) 44 525 pellGraphCertificate_1951 (by
    change pellLightFiniteCheck 1951 44 (10^275) 525 PellLightProduction.magnitudes_1951 = true
    exact PellLightProduction.checked_1951)

def pellFiniteCertificate_1959 : PellFiniteCertificate 1959 (10^275) :=
  pellFiniteCertificateOfLight 1959 (10^275) 44 536 (pellEmptyMatchingCertificate 1959) (by
    change pellLightFiniteCheck 1959 44 (10^275) 536 PellLightProduction.magnitudes_1959 = true
    exact PellLightProduction.checked_1959)

def pellFiniteCertificate_1967 : PellFiniteCertificate 1967 (10^275) :=
  pellFiniteCertificateOfLight 1967 (10^275) 44 444 (pellEmptyMatchingCertificate 1967) (by
    change pellLightFiniteCheck 1967 44 (10^275) 444 PellLightProduction.magnitudes_1967 = true
    exact PellLightProduction.checked_1967)

def pellFiniteCertificate_1983 : PellFiniteCertificate 1983 (10^275) :=
  pellFiniteCertificateOfLight 1983 (10^275) 44 558 (pellEmptyMatchingCertificate 1983) (by
    change pellLightFiniteCheck 1983 44 (10^275) 558 PellLightProduction.magnitudes_1983 = true
    exact PellLightProduction.checked_1983)

def pellFiniteCertificate_1991 : PellFiniteCertificate 1991 (10^275) :=
  pellFiniteCertificateOfLight 1991 (10^275) 44 596 (pellEmptyMatchingCertificate 1991) (by
    change pellLightFiniteCheck 1991 44 (10^275) 596 PellLightProduction.magnitudes_1991 = true
    exact PellLightProduction.checked_1991)

def pellFiniteCertificate_1999 : PellFiniteCertificate 1999 (10^275) :=
  pellFiniteCertificateOfLight 1999 (10^275) 44 578 pellGraphCertificate_1999 (by
    change pellLightFiniteCheck 1999 44 (10^275) 578 PellLightProduction.magnitudes_1999 = true
    exact PellLightProduction.checked_1999)

def pellFiniteCertificate_2015 : PellFiniteCertificate 2015 (10^275) :=
  pellFiniteCertificateOfLight 2015 (10^275) 44 378 (pellEmptyMatchingCertificate 2015) (by
    change pellLightFiniteCheck 2015 44 (10^275) 378 PellLightProduction.magnitudes_2015 = true
    exact PellLightProduction.checked_2015)

def pellFiniteCertificate_2031 : PellFiniteCertificate 2031 (10^275) :=
  pellFiniteCertificateOfLight 2031 (10^275) 45 175 (pellEmptyMatchingCertificate 2031) (by
    change pellLightFiniteCheck 2031 45 (10^275) 175 PellLightProduction.magnitudes_2031 = true
    exact PellLightProduction.checked_2031)

def pellFiniteCertificate_2039 : PellFiniteCertificate 2039 (10^275) :=
  pellFiniteCertificateOfLight 2039 (10^275) 45 511 pellGraphCertificate_2039 (by
    change pellLightFiniteCheck 2039 45 (10^275) 511 PellLightProduction.magnitudes_2039 = true
    exact PellLightProduction.checked_2039)

def pellFiniteCertificate_2047 : PellFiniteCertificate 2047 (10^275) :=
  pellFiniteCertificateOfLight 2047 (10^275) 45 328 pellGraphCertificate_2047 (by
    change pellLightFiniteCheck 2047 45 (10^275) 328 PellLightProduction.magnitudes_2047 = true
    exact PellLightProduction.checked_2047)

def pellFiniteCertificate_2055 : PellFiniteCertificate 2055 (10^275) :=
  pellFiniteCertificateOfLight 2055 (10^275) 45 226 (pellEmptyMatchingCertificate 2055) (by
    change pellLightFiniteCheck 2055 45 (10^275) 226 PellLightProduction.magnitudes_2055 = true
    exact PellLightProduction.checked_2055)

def pellFiniteCertificate_2063 : PellFiniteCertificate 2063 (10^275) :=
  pellFiniteCertificateOfLight 2063 (10^275) 45 570 pellGraphCertificate_2063 (by
    change pellLightFiniteCheck 2063 45 (10^275) 570 PellLightProduction.magnitudes_2063 = true
    exact PellLightProduction.checked_2063)

def pellFiniteCertificate_2071 : PellFiniteCertificate 2071 (10^275) :=
  pellFiniteCertificateOfLight 2071 (10^275) 45 497 (pellEmptyMatchingCertificate 2071) (by
    change pellLightFiniteCheck 2071 45 (10^275) 497 PellLightProduction.magnitudes_2071 = true
    exact PellLightProduction.checked_2071)

def pellFiniteCertificate_2087 : PellFiniteCertificate 2087 (10^275) :=
  pellFiniteCertificateOfLight 2087 (10^275) 45 534 pellGraphCertificate_2087 (by
    change pellLightFiniteCheck 2087 45 (10^275) 534 PellLightProduction.magnitudes_2087 = true
    exact PellLightProduction.checked_2087)

def pellFiniteCertificate_2095 : PellFiniteCertificate 2095 (10^275) :=
  pellFiniteCertificateOfLight 2095 (10^275) 45 601 (pellEmptyMatchingCertificate 2095) (by
    change pellLightFiniteCheck 2095 45 (10^275) 601 PellLightProduction.magnitudes_2095 = true
    exact PellLightProduction.checked_2095)

def pellFiniteCertificate_2103 : PellFiniteCertificate 2103 (10^275) :=
  pellFiniteCertificateOfLight 2103 (10^275) 45 340 (pellEmptyMatchingCertificate 2103) (by
    change pellLightFiniteCheck 2103 45 (10^275) 340 PellLightProduction.magnitudes_2103 = true
    exact PellLightProduction.checked_2103)

def pellFiniteCertificate_2111 : PellFiniteCertificate 2111 (10^275) :=
  pellFiniteCertificateOfLight 2111 (10^275) 45 542 pellGraphCertificate_2111 (by
    change pellLightFiniteCheck 2111 45 (10^275) 542 PellLightProduction.magnitudes_2111 = true
    exact PellLightProduction.checked_2111)

def pellFiniteCertificate_2119 : PellFiniteCertificate 2119 (10^275) :=
  pellFiniteCertificateOfLight 2119 (10^275) 46 454 (pellEmptyMatchingCertificate 2119) (by
    change pellLightFiniteCheck 2119 46 (10^275) 454 PellLightProduction.magnitudes_2119 = true
    exact PellLightProduction.checked_2119)

def pellFiniteCertificate_2127 : PellFiniteCertificate 2127 (10^275) :=
  pellFiniteCertificateOfLight 2127 (10^275) 46 386 (pellEmptyMatchingCertificate 2127) (by
    change pellLightFiniteCheck 2127 46 (10^275) 386 PellLightProduction.magnitudes_2127 = true
    exact PellLightProduction.checked_2127)

def pellFiniteCertificate_2135 : PellFiniteCertificate 2135 (10^275) :=
  pellFiniteCertificateOfLight 2135 (10^275) 46 393 (pellEmptyMatchingCertificate 2135) (by
    change pellLightFiniteCheck 2135 46 (10^275) 393 PellLightProduction.magnitudes_2135 = true
    exact PellLightProduction.checked_2135)

def pellFiniteCertificate_2143 : PellFiniteCertificate 2143 (10^275) :=
  pellFiniteCertificateOfLight 2143 (10^275) 46 623 pellGraphCertificate_2143 (by
    change pellLightFiniteCheck 2143 46 (10^275) 623 PellLightProduction.magnitudes_2143 = true
    exact PellLightProduction.checked_2143)

def pellFiniteCertificate_2159 : PellFiniteCertificate 2159 (10^275) :=
  pellFiniteCertificateOfLight 2159 (10^275) 46 462 (pellEmptyMatchingCertificate 2159) (by
    change pellLightFiniteCheck 2159 46 (10^275) 462 PellLightProduction.magnitudes_2159 = true
    exact PellLightProduction.checked_2159)

def pellFiniteCertificate_2167 : PellFiniteCertificate 2167 (10^275) :=
  pellFiniteCertificateOfLight 2167 (10^275) 46 679 (pellEmptyMatchingCertificate 2167) (by
    change pellLightFiniteCheck 2167 46 (10^275) 679 PellLightProduction.magnitudes_2167 = true
    exact PellLightProduction.checked_2167)

def pellFiniteCertificate_2183 : PellFiniteCertificate 2183 (10^275) :=
  pellFiniteCertificateOfLight 2183 (10^275) 46 691 (pellEmptyMatchingCertificate 2183) (by
    change pellLightFiniteCheck 2183 46 (10^275) 691 PellLightProduction.magnitudes_2183 = true
    exact PellLightProduction.checked_2183)

def pellFiniteCertificate_2191 : PellFiniteCertificate 2191 (10^275) :=
  pellFiniteCertificateOfLight 2191 (10^275) 46 526 pellGraphCertificate_2191 (by
    change pellLightFiniteCheck 2191 46 (10^275) 526 PellLightProduction.magnitudes_2191 = true
    exact PellLightProduction.checked_2191)

def pellFiniteCertificate_2199 : PellFiniteCertificate 2199 (10^275) :=
  pellFiniteCertificateOfLight 2199 (10^275) 46 589 (pellEmptyMatchingCertificate 2199) (by
    change pellLightFiniteCheck 2199 46 (10^275) 589 PellLightProduction.magnitudes_2199 = true
    exact PellLightProduction.checked_2199)

def pellFiniteCertificate_2207 : PellFiniteCertificate 2207 (10^275) :=
  pellFiniteCertificateOfLight 2207 (10^275) 46 300 pellGraphCertificate_2207 (by
    change pellLightFiniteCheck 2207 46 (10^275) 300 PellLightProduction.magnitudes_2207 = true
    exact PellLightProduction.checked_2207)

def pellFiniteCertificate_2215 : PellFiniteCertificate 2215 (10^275) :=
  pellFiniteCertificateOfLight 2215 (10^275) 47 399 (pellEmptyMatchingCertificate 2215) (by
    change pellLightFiniteCheck 2215 47 (10^275) 399 PellLightProduction.magnitudes_2215 = true
    exact PellLightProduction.checked_2215)

def pellFiniteCertificate_2231 : PellFiniteCertificate 2231 (10^275) :=
  pellFiniteCertificateOfLight 2231 (10^275) 47 389 pellGraphCertificate_2231 (by
    change pellLightFiniteCheck 2231 47 (10^275) 389 PellLightProduction.magnitudes_2231 = true
    exact PellLightProduction.checked_2231)

def pellFiniteCertificate_2239 : PellFiniteCertificate 2239 (10^275) :=
  pellFiniteCertificateOfLight 2239 (10^275) 47 528 pellGraphCertificate_2239 (by
    change pellLightFiniteCheck 2239 47 (10^275) 528 PellLightProduction.magnitudes_2239 = true
    exact PellLightProduction.checked_2239)

def pellFiniteCertificate_2247 : PellFiniteCertificate 2247 (10^275) :=
  pellFiniteCertificateOfLight 2247 (10^275) 47 360 (pellEmptyMatchingCertificate 2247) (by
    change pellLightFiniteCheck 2247 47 (10^275) 360 PellLightProduction.magnitudes_2247 = true
    exact PellLightProduction.checked_2247)

def pellFiniteCertificate_2255 : PellFiniteCertificate 2255 (10^275) :=
  pellFiniteCertificateOfLight 2255 (10^275) 47 284 (pellEmptyMatchingCertificate 2255) (by
    change pellLightFiniteCheck 2255 47 (10^275) 284 PellLightProduction.magnitudes_2255 = true
    exact PellLightProduction.checked_2255)

def pellFiniteCertificate_2263 : PellFiniteCertificate 2263 (10^275) :=
  pellFiniteCertificateOfLight 2263 (10^275) 47 411 pellGraphCertificate_2263 (by
    change pellLightFiniteCheck 2263 47 (10^275) 411 PellLightProduction.magnitudes_2263 = true
    exact PellLightProduction.checked_2263)

def pellFiniteCertificate_2271 : PellFiniteCertificate 2271 (10^275) :=
  pellFiniteCertificateOfLight 2271 (10^275) 47 559 (pellEmptyMatchingCertificate 2271) (by
    change pellLightFiniteCheck 2271 47 (10^275) 559 PellLightProduction.magnitudes_2271 = true
    exact PellLightProduction.checked_2271)

def pellFiniteCertificate_2279 : PellFiniteCertificate 2279 (10^275) :=
  pellFiniteCertificateOfLight 2279 (10^275) 47 522 (pellEmptyMatchingCertificate 2279) (by
    change pellLightFiniteCheck 2279 47 (10^275) 522 PellLightProduction.magnitudes_2279 = true
    exact PellLightProduction.checked_2279)

def pellFiniteCertificate_2287 : PellFiniteCertificate 2287 (10^275) :=
  pellFiniteCertificateOfLight 2287 (10^275) 47 530 pellGraphCertificate_2287 (by
    change pellLightFiniteCheck 2287 47 (10^275) 530 PellLightProduction.magnitudes_2287 = true
    exact PellLightProduction.checked_2287)

def pellFiniteCertificate_2311 : PellFiniteCertificate 2311 (10^275) :=
  pellFiniteCertificateOfLight 2311 (10^275) 48 548 pellGraphCertificate_2311 (by
    change pellLightFiniteCheck 2311 48 (10^275) 548 PellLightProduction.magnitudes_2311 = true
    exact PellLightProduction.checked_2311)

def pellFiniteCertificate_2319 : PellFiniteCertificate 2319 (10^275) :=
  pellFiniteCertificateOfLight 2319 (10^275) 48 504 (pellEmptyMatchingCertificate 2319) (by
    change pellLightFiniteCheck 2319 48 (10^275) 504 PellLightProduction.magnitudes_2319 = true
    exact PellLightProduction.checked_2319)

def pellFiniteCertificate_2327 : PellFiniteCertificate 2327 (10^275) :=
  pellFiniteCertificateOfLight 2327 (10^275) 48 455 (pellEmptyMatchingCertificate 2327) (by
    change pellLightFiniteCheck 2327 48 (10^275) 455 PellLightProduction.magnitudes_2327 = true
    exact PellLightProduction.checked_2327)

def pellFiniteCertificate_2335 : PellFiniteCertificate 2335 (10^275) :=
  pellFiniteCertificateOfLight 2335 (10^275) 48 280 (pellEmptyMatchingCertificate 2335) (by
    change pellLightFiniteCheck 2335 48 (10^275) 280 PellLightProduction.magnitudes_2335 = true
    exact PellLightProduction.checked_2335)

def pellFiniteCertificate_2343 : PellFiniteCertificate 2343 (10^275) :=
  pellFiniteCertificateOfLight 2343 (10^275) 48 380 (pellEmptyMatchingCertificate 2343) (by
    change pellLightFiniteCheck 2343 48 (10^275) 380 PellLightProduction.magnitudes_2343 = true
    exact PellLightProduction.checked_2343)

def pellFiniteCertificate_2351 : PellFiniteCertificate 2351 (10^275) :=
  pellFiniteCertificateOfLight 2351 (10^275) 48 436 pellGraphCertificate_2351 (by
    change pellLightFiniteCheck 2351 48 (10^275) 436 PellLightProduction.magnitudes_2351 = true
    exact PellLightProduction.checked_2351)

def pellFiniteCertificate_2359 : PellFiniteCertificate 2359 (10^275) :=
  pellFiniteCertificateOfLight 2359 (10^275) 48 483 (pellEmptyMatchingCertificate 2359) (by
    change pellLightFiniteCheck 2359 48 (10^275) 483 PellLightProduction.magnitudes_2359 = true
    exact PellLightProduction.checked_2359)

def pellFiniteCertificate_2383 : PellFiniteCertificate 2383 (10^275) :=
  pellFiniteCertificateOfLight 2383 (10^275) 48 504 pellGraphCertificate_2383 (by
    change pellLightFiniteCheck 2383 48 (10^275) 504 PellLightProduction.magnitudes_2383 = true
    exact PellLightProduction.checked_2383)

def pellFiniteCertificate_2391 : PellFiniteCertificate 2391 (10^275) :=
  pellFiniteCertificateOfLight 2391 (10^275) 48 596 (pellEmptyMatchingCertificate 2391) (by
    change pellLightFiniteCheck 2391 48 (10^275) 596 PellLightProduction.magnitudes_2391 = true
    exact PellLightProduction.checked_2391)

def pellFiniteCertificate_2399 : PellFiniteCertificate 2399 (10^275) :=
  pellFiniteCertificateOfLight 2399 (10^275) 48 298 pellGraphCertificate_2399 (by
    change pellLightFiniteCheck 2399 48 (10^275) 298 PellLightProduction.magnitudes_2399 = true
    exact PellLightProduction.checked_2399)

def pellFiniteCertificate_2407 : PellFiniteCertificate 2407 (10^275) :=
  pellFiniteCertificateOfLight 2407 (10^275) 49 431 (pellEmptyMatchingCertificate 2407) (by
    change pellLightFiniteCheck 2407 49 (10^275) 431 PellLightProduction.magnitudes_2407 = true
    exact PellLightProduction.checked_2407)

def pellFiniteCertificate_2415 : PellFiniteCertificate 2415 (10^275) :=
  pellFiniteCertificateOfLight 2415 (10^275) 49 194 (pellEmptyMatchingCertificate 2415) (by
    change pellLightFiniteCheck 2415 49 (10^275) 194 PellLightProduction.magnitudes_2415 = true
    exact PellLightProduction.checked_2415)

def pellFiniteCertificate_2423 : PellFiniteCertificate 2423 (10^275) :=
  pellFiniteCertificateOfLight 2423 (10^275) 49 537 pellGraphCertificate_2423 (by
    change pellLightFiniteCheck 2423 49 (10^275) 537 PellLightProduction.magnitudes_2423 = true
    exact PellLightProduction.checked_2423)

def pellFiniteCertificate_2431 : PellFiniteCertificate 2431 (10^275) :=
  pellFiniteCertificateOfLight 2431 (10^275) 49 663 (pellEmptyMatchingCertificate 2431) (by
    change pellLightFiniteCheck 2431 49 (10^275) 663 PellLightProduction.magnitudes_2431 = true
    exact PellLightProduction.checked_2431)

def pellFiniteCertificate_2447 : PellFiniteCertificate 2447 (10^275) :=
  pellFiniteCertificateOfLight 2447 (10^275) 49 471 pellGraphCertificate_2447 (by
    change pellLightFiniteCheck 2447 49 (10^275) 471 PellLightProduction.magnitudes_2447 = true
    exact PellLightProduction.checked_2447)

def pellFiniteCertificate_2455 : PellFiniteCertificate 2455 (10^275) :=
  pellFiniteCertificateOfLight 2455 (10^275) 49 474 (pellEmptyMatchingCertificate 2455) (by
    change pellLightFiniteCheck 2455 49 (10^275) 474 PellLightProduction.magnitudes_2455 = true
    exact PellLightProduction.checked_2455)

def pellFiniteCertificate_2463 : PellFiniteCertificate 2463 (10^275) :=
  pellFiniteCertificateOfLight 2463 (10^275) 49 609 (pellEmptyMatchingCertificate 2463) (by
    change pellLightFiniteCheck 2463 49 (10^275) 609 PellLightProduction.magnitudes_2463 = true
    exact PellLightProduction.checked_2463)

def pellFiniteCertificate_2471 : PellFiniteCertificate 2471 (10^275) :=
  pellFiniteCertificateOfLight 2471 (10^275) 49 573 pellGraphCertificate_2471 (by
    change pellLightFiniteCheck 2471 49 (10^275) 573 PellLightProduction.magnitudes_2471 = true
    exact PellLightProduction.checked_2471)

def pellFiniteCertificate_2479 : PellFiniteCertificate 2479 (10^275) :=
  pellFiniteCertificateOfLight 2479 (10^275) 49 528 (pellEmptyMatchingCertificate 2479) (by
    change pellLightFiniteCheck 2479 49 (10^275) 528 PellLightProduction.magnitudes_2479 = true
    exact PellLightProduction.checked_2479)

def pellFiniteCertificate_2487 : PellFiniteCertificate 2487 (10^275) :=
  pellFiniteCertificateOfLight 2487 (10^275) 49 605 (pellEmptyMatchingCertificate 2487) (by
    change pellLightFiniteCheck 2487 49 (10^275) 605 PellLightProduction.magnitudes_2487 = true
    exact PellLightProduction.checked_2487)

def pellFiniteCertificate_2495 : PellFiniteCertificate 2495 (10^275) :=
  pellFiniteCertificateOfLight 2495 (10^275) 49 332 (pellEmptyMatchingCertificate 2495) (by
    change pellLightFiniteCheck 2495 49 (10^275) 332 PellLightProduction.magnitudes_2495 = true
    exact PellLightProduction.checked_2495)

def pellFiniteCertificate_2503 : PellFiniteCertificate 2503 (10^275) :=
  pellFiniteCertificateOfLight 2503 (10^275) 50 516 pellGraphCertificate_2503 (by
    change pellLightFiniteCheck 2503 50 (10^275) 516 PellLightProduction.magnitudes_2503 = true
    exact PellLightProduction.checked_2503)

def pellFiniteCertificate_2519 : PellFiniteCertificate 2519 (10^275) :=
  pellFiniteCertificateOfLight 2519 (10^275) 50 526 (pellEmptyMatchingCertificate 2519) (by
    change pellLightFiniteCheck 2519 50 (10^275) 526 PellLightProduction.magnitudes_2519 = true
    exact PellLightProduction.checked_2519)

def pellFiniteCertificate_2543 : PellFiniteCertificate 2543 (10^275) :=
  pellFiniteCertificateOfLight 2543 (10^275) 50 408 pellGraphCertificate_2543 (by
    change pellLightFiniteCheck 2543 50 (10^275) 408 PellLightProduction.magnitudes_2543 = true
    exact PellLightProduction.checked_2543)

def pellFiniteCertificate_2551 : PellFiniteCertificate 2551 (10^275) :=
  pellFiniteCertificateOfLight 2551 (10^275) 50 529 pellGraphCertificate_2551 (by
    change pellLightFiniteCheck 2551 50 (10^275) 529 PellLightProduction.magnitudes_2551 = true
    exact PellLightProduction.checked_2551)

def pellFiniteCertificate_2559 : PellFiniteCertificate 2559 (10^275) :=
  pellFiniteCertificateOfLight 2559 (10^275) 50 631 (pellEmptyMatchingCertificate 2559) (by
    change pellLightFiniteCheck 2559 50 (10^275) 631 PellLightProduction.magnitudes_2559 = true
    exact PellLightProduction.checked_2559)

def pellFiniteCertificate_2567 : PellFiniteCertificate 2567 (10^275) :=
  pellFiniteCertificateOfLight 2567 (10^275) 50 442 (pellEmptyMatchingCertificate 2567) (by
    change pellLightFiniteCheck 2567 50 (10^275) 442 PellLightProduction.magnitudes_2567 = true
    exact PellLightProduction.checked_2567)

def pellFiniteCertificate_2591 : PellFiniteCertificate 2591 (10^275) :=
  pellFiniteCertificateOfLight 2591 (10^275) 50 535 pellGraphCertificate_2591 (by
    change pellLightFiniteCheck 2591 50 (10^275) 535 PellLightProduction.magnitudes_2591 = true
    exact PellLightProduction.checked_2591)

def pellFiniteCertificate_2599 : PellFiniteCertificate 2599 (10^275) :=
  pellFiniteCertificateOfLight 2599 (10^275) 50 296 pellGraphCertificate_2599 (by
    change pellLightFiniteCheck 2599 50 (10^275) 296 PellLightProduction.magnitudes_2599 = true
    exact PellLightProduction.checked_2599)

def pellFiniteCertificate_2607 : PellFiniteCertificate 2607 (10^275) :=
  pellFiniteCertificateOfLight 2607 (10^275) 51 169 (pellEmptyMatchingCertificate 2607) (by
    change pellLightFiniteCheck 2607 51 (10^275) 169 PellLightProduction.magnitudes_2607 = true
    exact PellLightProduction.checked_2607)

def pellFiniteCertificate_2615 : PellFiniteCertificate 2615 (10^275) :=
  pellFiniteCertificateOfLight 2615 (10^275) 51 545 (pellEmptyMatchingCertificate 2615) (by
    change pellLightFiniteCheck 2615 51 (10^275) 545 PellLightProduction.magnitudes_2615 = true
    exact PellLightProduction.checked_2615)

def pellFiniteCertificate_2623 : PellFiniteCertificate 2623 (10^275) :=
  pellFiniteCertificateOfLight 2623 (10^275) 51 517 (pellEmptyMatchingCertificate 2623) (by
    change pellLightFiniteCheck 2623 51 (10^275) 517 PellLightProduction.magnitudes_2623 = true
    exact PellLightProduction.checked_2623)

def pellFiniteCertificate_2631 : PellFiniteCertificate 2631 (10^275) :=
  pellFiniteCertificateOfLight 2631 (10^275) 51 431 (pellEmptyMatchingCertificate 2631) (by
    change pellLightFiniteCheck 2631 51 (10^275) 431 PellLightProduction.magnitudes_2631 = true
    exact PellLightProduction.checked_2631)

def pellFiniteCertificate_2639 : PellFiniteCertificate 2639 (10^275) :=
  pellFiniteCertificateOfLight 2639 (10^275) 51 584 (pellEmptyMatchingCertificate 2639) (by
    change pellLightFiniteCheck 2639 51 (10^275) 584 PellLightProduction.magnitudes_2639 = true
    exact PellLightProduction.checked_2639)

def pellFiniteCertificate_2647 : PellFiniteCertificate 2647 (10^275) :=
  pellFiniteCertificateOfLight 2647 (10^275) 51 501 pellGraphCertificate_2647 (by
    change pellLightFiniteCheck 2647 51 (10^275) 501 PellLightProduction.magnitudes_2647 = true
    exact PellLightProduction.checked_2647)

def pellFiniteCertificate_2663 : PellFiniteCertificate 2663 (10^275) :=
  pellFiniteCertificateOfLight 2663 (10^275) 51 585 pellGraphCertificate_2663 (by
    change pellLightFiniteCheck 2663 51 (10^275) 585 PellLightProduction.magnitudes_2663 = true
    exact PellLightProduction.checked_2663)

def pellFiniteCertificate_2671 : PellFiniteCertificate 2671 (10^275) :=
  pellFiniteCertificateOfLight 2671 (10^275) 51 550 pellGraphCertificate_2671 (by
    change pellLightFiniteCheck 2671 51 (10^275) 550 PellLightProduction.magnitudes_2671 = true
    exact PellLightProduction.checked_2671)

def pellFiniteCertificate_2679 : PellFiniteCertificate 2679 (10^275) :=
  pellFiniteCertificateOfLight 2679 (10^275) 51 510 (pellEmptyMatchingCertificate 2679) (by
    change pellLightFiniteCheck 2679 51 (10^275) 510 PellLightProduction.magnitudes_2679 = true
    exact PellLightProduction.checked_2679)

def pellFiniteCertificate_2687 : PellFiniteCertificate 2687 (10^275) :=
  pellFiniteCertificateOfLight 2687 (10^275) 51 480 pellGraphCertificate_2687 (by
    change pellLightFiniteCheck 2687 51 (10^275) 480 PellLightProduction.magnitudes_2687 = true
    exact PellLightProduction.checked_2687)

def pellFiniteCertificate_2703 : PellFiniteCertificate 2703 (10^275) :=
  pellFiniteCertificateOfLight 2703 (10^275) 51 272 (pellEmptyMatchingCertificate 2703) (by
    change pellLightFiniteCheck 2703 51 (10^275) 272 PellLightProduction.magnitudes_2703 = true
    exact PellLightProduction.checked_2703)

def pellFiniteCertificate_2711 : PellFiniteCertificate 2711 (10^275) :=
  pellFiniteCertificateOfLight 2711 (10^275) 52 390 pellGraphCertificate_2711 (by
    change pellLightFiniteCheck 2711 52 (10^275) 390 PellLightProduction.magnitudes_2711 = true
    exact PellLightProduction.checked_2711)

def pellFiniteCertificate_2719 : PellFiniteCertificate 2719 (10^275) :=
  pellFiniteCertificateOfLight 2719 (10^275) 52 544 pellGraphCertificate_2719 (by
    change pellLightFiniteCheck 2719 52 (10^275) 544 PellLightProduction.magnitudes_2719 = true
    exact PellLightProduction.checked_2719)

def pellFiniteCertificate_2735 : PellFiniteCertificate 2735 (10^275) :=
  pellFiniteCertificateOfLight 2735 (10^275) 52 533 (pellEmptyMatchingCertificate 2735) (by
    change pellLightFiniteCheck 2735 52 (10^275) 533 PellLightProduction.magnitudes_2735 = true
    exact PellLightProduction.checked_2735)

def pellFiniteCertificate_2743 : PellFiniteCertificate 2743 (10^275) :=
  pellFiniteCertificateOfLight 2743 (10^275) 52 475 (pellEmptyMatchingCertificate 2743) (by
    change pellLightFiniteCheck 2743 52 (10^275) 475 PellLightProduction.magnitudes_2743 = true
    exact PellLightProduction.checked_2743)

def pellFiniteCertificate_2751 : PellFiniteCertificate 2751 (10^275) :=
  pellFiniteCertificateOfLight 2751 (10^275) 52 330 (pellEmptyMatchingCertificate 2751) (by
    change pellLightFiniteCheck 2751 52 (10^275) 330 PellLightProduction.magnitudes_2751 = true
    exact PellLightProduction.checked_2751)

def pellFiniteCertificate_2759 : PellFiniteCertificate 2759 (10^275) :=
  pellFiniteCertificateOfLight 2759 (10^275) 52 465 pellGraphCertificate_2759 (by
    change pellLightFiniteCheck 2759 52 (10^275) 465 PellLightProduction.magnitudes_2759 = true
    exact PellLightProduction.checked_2759)

def pellFiniteCertificate_2767 : PellFiniteCertificate 2767 (10^275) :=
  pellFiniteCertificateOfLight 2767 (10^275) 52 570 pellGraphCertificate_2767 (by
    change pellLightFiniteCheck 2767 52 (10^275) 570 PellLightProduction.magnitudes_2767 = true
    exact PellLightProduction.checked_2767)

def pellFiniteCertificate_2791 : PellFiniteCertificate 2791 (10^275) :=
  pellFiniteCertificateOfLight 2791 (10^275) 52 577 pellGraphCertificate_2791 (by
    change pellLightFiniteCheck 2791 52 (10^275) 577 PellLightProduction.magnitudes_2791 = true
    exact PellLightProduction.checked_2791)

def pellFiniteCertificate_2807 : PellFiniteCertificate 2807 (10^275) :=
  pellFiniteCertificateOfLight 2807 (10^275) 52 292 pellGraphCertificate_2807 (by
    change pellLightFiniteCheck 2807 52 (10^275) 292 PellLightProduction.magnitudes_2807 = true
    exact PellLightProduction.checked_2807)

def pellFiniteCertificate_2815 : PellFiniteCertificate 2815 (10^275) :=
  pellFiniteCertificateOfLight 2815 (10^275) 53 511 (pellEmptyMatchingCertificate 2815) (by
    change pellLightFiniteCheck 2815 53 (10^275) 511 PellLightProduction.magnitudes_2815 = true
    exact PellLightProduction.checked_2815)

def pellFiniteCertificate_2823 : PellFiniteCertificate 2823 (10^275) :=
  pellFiniteCertificateOfLight 2823 (10^275) 53 582 (pellEmptyMatchingCertificate 2823) (by
    change pellLightFiniteCheck 2823 53 (10^275) 582 PellLightProduction.magnitudes_2823 = true
    exact PellLightProduction.checked_2823)

def pellFiniteCertificate_2831 : PellFiniteCertificate 2831 (10^275) :=
  pellFiniteCertificateOfLight 2831 (10^275) 53 395 (pellEmptyMatchingCertificate 2831) (by
    change pellLightFiniteCheck 2831 53 (10^275) 395 PellLightProduction.magnitudes_2831 = true
    exact PellLightProduction.checked_2831)

def pellFiniteCertificate_2839 : PellFiniteCertificate 2839 (10^275) :=
  pellFiniteCertificateOfLight 2839 (10^275) 53 588 pellGraphCertificate_2839 (by
    change pellLightFiniteCheck 2839 53 (10^275) 588 PellLightProduction.magnitudes_2839 = true
    exact PellLightProduction.checked_2839)

def pellFiniteCertificate_2847 : PellFiniteCertificate 2847 (10^275) :=
  pellFiniteCertificateOfLight 2847 (10^275) 53 467 (pellEmptyMatchingCertificate 2847) (by
    change pellLightFiniteCheck 2847 53 (10^275) 467 PellLightProduction.magnitudes_2847 = true
    exact PellLightProduction.checked_2847)

def pellFiniteCertificate_2855 : PellFiniteCertificate 2855 (10^275) :=
  pellFiniteCertificateOfLight 2855 (10^275) 53 438 (pellEmptyMatchingCertificate 2855) (by
    change pellLightFiniteCheck 2855 53 (10^275) 438 PellLightProduction.magnitudes_2855 = true
    exact PellLightProduction.checked_2855)

def pellFiniteCertificate_2863 : PellFiniteCertificate 2863 (10^275) :=
  pellFiniteCertificateOfLight 2863 (10^275) 53 369 pellGraphCertificate_2863 (by
    change pellLightFiniteCheck 2863 53 (10^275) 369 PellLightProduction.magnitudes_2863 = true
    exact PellLightProduction.checked_2863)

def pellFiniteCertificate_2879 : PellFiniteCertificate 2879 (10^275) :=
  pellFiniteCertificateOfLight 2879 (10^275) 53 515 pellGraphCertificate_2879 (by
    change pellLightFiniteCheck 2879 53 (10^275) 515 PellLightProduction.magnitudes_2879 = true
    exact PellLightProduction.checked_2879)

def pellFiniteCertificate_2887 : PellFiniteCertificate 2887 (10^275) :=
  pellFiniteCertificateOfLight 2887 (10^275) 53 535 pellGraphCertificate_2887 (by
    change pellLightFiniteCheck 2887 53 (10^275) 535 PellLightProduction.magnitudes_2887 = true
    exact PellLightProduction.checked_2887)

def pellFiniteCertificate_2895 : PellFiniteCertificate 2895 (10^275) :=
  pellFiniteCertificateOfLight 2895 (10^275) 53 390 (pellEmptyMatchingCertificate 2895) (by
    change pellLightFiniteCheck 2895 53 (10^275) 390 PellLightProduction.magnitudes_2895 = true
    exact PellLightProduction.checked_2895)

def pellFiniteCertificate_2903 : PellFiniteCertificate 2903 (10^275) :=
  pellFiniteCertificateOfLight 2903 (10^275) 53 550 pellGraphCertificate_2903 (by
    change pellLightFiniteCheck 2903 53 (10^275) 550 PellLightProduction.magnitudes_2903 = true
    exact PellLightProduction.checked_2903)

def pellFiniteCertificate_2911 : PellFiniteCertificate 2911 (10^275) :=
  pellFiniteCertificateOfLight 2911 (10^275) 53 563 pellGraphCertificate_2911 (by
    change pellLightFiniteCheck 2911 53 (10^275) 563 PellLightProduction.magnitudes_2911 = true
    exact PellLightProduction.checked_2911)

def pellFiniteCertificate_2919 : PellFiniteCertificate 2919 (10^275) :=
  pellFiniteCertificateOfLight 2919 (10^275) 54 153 (pellEmptyMatchingCertificate 2919) (by
    change pellLightFiniteCheck 2919 54 (10^275) 153 PellLightProduction.magnitudes_2919 = true
    exact PellLightProduction.checked_2919)

def pellFiniteCertificate_2927 : PellFiniteCertificate 2927 (10^275) :=
  pellFiniteCertificateOfLight 2927 (10^275) 54 558 pellGraphCertificate_2927 (by
    change pellLightFiniteCheck 2927 54 (10^275) 558 PellLightProduction.magnitudes_2927 = true
    exact PellLightProduction.checked_2927)

def pellFiniteCertificate_2935 : PellFiniteCertificate 2935 (10^275) :=
  pellFiniteCertificateOfLight 2935 (10^275) 54 518 (pellEmptyMatchingCertificate 2935) (by
    change pellLightFiniteCheck 2935 54 (10^275) 518 PellLightProduction.magnitudes_2935 = true
    exact PellLightProduction.checked_2935)

def pellFiniteCertificate_2951 : PellFiniteCertificate 2951 (10^275) :=
  pellFiniteCertificateOfLight 2951 (10^275) 54 541 (pellEmptyMatchingCertificate 2951) (by
    change pellLightFiniteCheck 2951 54 (10^275) 541 PellLightProduction.magnitudes_2951 = true
    exact PellLightProduction.checked_2951)

def pellFiniteCertificate_2959 : PellFiniteCertificate 2959 (10^275) :=
  pellFiniteCertificateOfLight 2959 (10^275) 54 541 (pellEmptyMatchingCertificate 2959) (by
    change pellLightFiniteCheck 2959 54 (10^275) 541 PellLightProduction.magnitudes_2959 = true
    exact PellLightProduction.checked_2959)

def pellFiniteCertificate_2967 : PellFiniteCertificate 2967 (10^275) :=
  pellFiniteCertificateOfLight 2967 (10^275) 54 366 (pellEmptyMatchingCertificate 2967) (by
    change pellLightFiniteCheck 2967 54 (10^275) 366 PellLightProduction.magnitudes_2967 = true
    exact PellLightProduction.checked_2967)

def pellFiniteCertificate_2983 : PellFiniteCertificate 2983 (10^275) :=
  pellFiniteCertificateOfLight 2983 (10^275) 54 604 (pellEmptyMatchingCertificate 2983) (by
    change pellLightFiniteCheck 2983 54 (10^275) 604 PellLightProduction.magnitudes_2983 = true
    exact PellLightProduction.checked_2983)

def pellFiniteCertificate_2991 : PellFiniteCertificate 2991 (10^275) :=
  pellFiniteCertificateOfLight 2991 (10^275) 54 516 (pellEmptyMatchingCertificate 2991) (by
    change pellLightFiniteCheck 2991 54 (10^275) 516 PellLightProduction.magnitudes_2991 = true
    exact PellLightProduction.checked_2991)

def pellFiniteCertificate_2999 : PellFiniteCertificate 2999 (10^275) :=
  pellFiniteCertificateOfLight 2999 (10^275) 54 490 pellGraphCertificate_2999 (by
    change pellLightFiniteCheck 2999 54 (10^275) 490 PellLightProduction.magnitudes_2999 = true
    exact PellLightProduction.checked_2999)

def pellFiniteCertificate_3007 : PellFiniteCertificate 3007 (10^275) :=
  pellFiniteCertificateOfLight 3007 (10^275) 54 402 pellGraphCertificate_3007 (by
    change pellLightFiniteCheck 3007 54 (10^275) 402 PellLightProduction.magnitudes_3007 = true
    exact PellLightProduction.checked_3007)

def pellFiniteCertificate_3023 : PellFiniteCertificate 3023 (10^275) :=
  pellFiniteCertificateOfLight 3023 (10^275) 54 290 pellGraphCertificate_3023 (by
    change pellLightFiniteCheck 3023 54 (10^275) 290 PellLightProduction.magnitudes_3023 = true
    exact PellLightProduction.checked_3023)

def pellFiniteCertificate_3031 : PellFiniteCertificate 3031 (10^275) :=
  pellFiniteCertificateOfLight 3031 (10^275) 55 465 pellGraphCertificate_3031 (by
    change pellLightFiniteCheck 3031 55 (10^275) 465 PellLightProduction.magnitudes_3031 = true
    exact PellLightProduction.checked_3031)

def pellFiniteCertificate_3039 : PellFiniteCertificate 3039 (10^275) :=
  pellFiniteCertificateOfLight 3039 (10^275) 55 546 (pellEmptyMatchingCertificate 3039) (by
    change pellLightFiniteCheck 3039 55 (10^275) 546 PellLightProduction.magnitudes_3039 = true
    exact PellLightProduction.checked_3039)

def pellFiniteCertificate_3047 : PellFiniteCertificate 3047 (10^275) :=
  pellFiniteCertificateOfLight 3047 (10^275) 55 200 (pellEmptyMatchingCertificate 3047) (by
    change pellLightFiniteCheck 3047 55 (10^275) 200 PellLightProduction.magnitudes_3047 = true
    exact PellLightProduction.checked_3047)

def pellFiniteCertificate_3055 : PellFiniteCertificate 3055 (10^275) :=
  pellFiniteCertificateOfLight 3055 (10^275) 55 434 (pellEmptyMatchingCertificate 3055) (by
    change pellLightFiniteCheck 3055 55 (10^275) 434 PellLightProduction.magnitudes_3055 = true
    exact PellLightProduction.checked_3055)

def pellFiniteCertificate_3063 : PellFiniteCertificate 3063 (10^275) :=
  pellFiniteCertificateOfLight 3063 (10^275) 55 475 (pellEmptyMatchingCertificate 3063) (by
    change pellLightFiniteCheck 3063 55 (10^275) 475 PellLightProduction.magnitudes_3063 = true
    exact PellLightProduction.checked_3063)

def pellFiniteCertificate_3071 : PellFiniteCertificate 3071 (10^275) :=
  pellFiniteCertificateOfLight 3071 (10^275) 55 352 (pellEmptyMatchingCertificate 3071) (by
    change pellLightFiniteCheck 3071 55 (10^275) 352 PellLightProduction.magnitudes_3071 = true
    exact PellLightProduction.checked_3071)

def pellFiniteCertificate_3079 : PellFiniteCertificate 3079 (10^275) :=
  pellFiniteCertificateOfLight 3079 (10^275) 55 487 pellGraphCertificate_3079 (by
    change pellLightFiniteCheck 3079 55 (10^275) 487 PellLightProduction.magnitudes_3079 = true
    exact PellLightProduction.checked_3079)

def pellFiniteCertificate_3095 : PellFiniteCertificate 3095 (10^275) :=
  pellFiniteCertificateOfLight 3095 (10^275) 55 575 (pellEmptyMatchingCertificate 3095) (by
    change pellLightFiniteCheck 3095 55 (10^275) 575 PellLightProduction.magnitudes_3095 = true
    exact PellLightProduction.checked_3095)

def pellFiniteCertificate_3103 : PellFiniteCertificate 3103 (10^275) :=
  pellFiniteCertificateOfLight 3103 (10^275) 55 621 (pellEmptyMatchingCertificate 3103) (by
    change pellLightFiniteCheck 3103 55 (10^275) 621 PellLightProduction.magnitudes_3103 = true
    exact PellLightProduction.checked_3103)

def pellFiniteCertificate_3111 : PellFiniteCertificate 3111 (10^275) :=
  pellFiniteCertificateOfLight 3111 (10^275) 55 410 (pellEmptyMatchingCertificate 3111) (by
    change pellLightFiniteCheck 3111 55 (10^275) 410 PellLightProduction.magnitudes_3111 = true
    exact PellLightProduction.checked_3111)

def pellFiniteCertificate_3119 : PellFiniteCertificate 3119 (10^275) :=
  pellFiniteCertificateOfLight 3119 (10^275) 55 588 pellGraphCertificate_3119 (by
    change pellLightFiniteCheck 3119 55 (10^275) 588 PellLightProduction.magnitudes_3119 = true
    exact PellLightProduction.checked_3119)

def pellFiniteCertificate_3127 : PellFiniteCertificate 3127 (10^275) :=
  pellFiniteCertificateOfLight 3127 (10^275) 55 516 (pellEmptyMatchingCertificate 3127) (by
    change pellLightFiniteCheck 3127 55 (10^275) 516 PellLightProduction.magnitudes_3127 = true
    exact PellLightProduction.checked_3127)

def pellFiniteCertificate_3135 : PellFiniteCertificate 3135 (10^275) :=
  pellFiniteCertificateOfLight 3135 (10^275) 55 268 (pellEmptyMatchingCertificate 3135) (by
    change pellLightFiniteCheck 3135 55 (10^275) 268 PellLightProduction.magnitudes_3135 = true
    exact PellLightProduction.checked_3135)

def pellFiniteCertificate_3143 : PellFiniteCertificate 3143 (10^275) :=
  pellFiniteCertificateOfLight 3143 (10^275) 56 168 (pellEmptyMatchingCertificate 3143) (by
    change pellLightFiniteCheck 3143 56 (10^275) 168 PellLightProduction.magnitudes_3143 = true
    exact PellLightProduction.checked_3143)

def pellFiniteCertificate_3151 : PellFiniteCertificate 3151 (10^275) :=
  pellFiniteCertificateOfLight 3151 (10^275) 56 465 pellGraphCertificate_3151 (by
    change pellLightFiniteCheck 3151 56 (10^275) 465 PellLightProduction.magnitudes_3151 = true
    exact PellLightProduction.checked_3151)

def pellFiniteCertificate_3167 : PellFiniteCertificate 3167 (10^275) :=
  pellFiniteCertificateOfLight 3167 (10^275) 56 648 pellGraphCertificate_3167 (by
    change pellLightFiniteCheck 3167 56 (10^275) 648 PellLightProduction.magnitudes_3167 = true
    exact PellLightProduction.checked_3167)

def pellFiniteCertificate_3183 : PellFiniteCertificate 3183 (10^275) :=
  pellFiniteCertificateOfLight 3183 (10^275) 56 502 (pellEmptyMatchingCertificate 3183) (by
    change pellLightFiniteCheck 3183 56 (10^275) 502 PellLightProduction.magnitudes_3183 = true
    exact PellLightProduction.checked_3183)

def pellFiniteCertificate_3191 : PellFiniteCertificate 3191 (10^275) :=
  pellFiniteCertificateOfLight 3191 (10^275) 56 528 pellGraphCertificate_3191 (by
    change pellLightFiniteCheck 3191 56 (10^275) 528 PellLightProduction.magnitudes_3191 = true
    exact PellLightProduction.checked_3191)

def pellFiniteCertificate_3199 : PellFiniteCertificate 3199 (10^275) :=
  pellFiniteCertificateOfLight 3199 (10^275) 56 449 (pellEmptyMatchingCertificate 3199) (by
    change pellLightFiniteCheck 3199 56 (10^275) 449 PellLightProduction.magnitudes_3199 = true
    exact PellLightProduction.checked_3199)

def pellFiniteCertificate_3207 : PellFiniteCertificate 3207 (10^275) :=
  pellFiniteCertificateOfLight 3207 (10^275) 56 566 (pellEmptyMatchingCertificate 3207) (by
    change pellLightFiniteCheck 3207 56 (10^275) 566 PellLightProduction.magnitudes_3207 = true
    exact PellLightProduction.checked_3207)

def pellFiniteCertificate_3215 : PellFiniteCertificate 3215 (10^275) :=
  pellFiniteCertificateOfLight 3215 (10^275) 56 608 (pellEmptyMatchingCertificate 3215) (by
    change pellLightFiniteCheck 3215 56 (10^275) 608 PellLightProduction.magnitudes_3215 = true
    exact PellLightProduction.checked_3215)

def pellFiniteCertificate_3223 : PellFiniteCertificate 3223 (10^275) :=
  pellFiniteCertificateOfLight 3223 (10^275) 56 562 (pellEmptyMatchingCertificate 3223) (by
    change pellLightFiniteCheck 3223 56 (10^275) 562 PellLightProduction.magnitudes_3223 = true
    exact PellLightProduction.checked_3223)

def pellFiniteCertificate_3239 : PellFiniteCertificate 3239 (10^275) :=
  pellFiniteCertificateOfLight 3239 (10^275) 56 482 pellGraphCertificate_3239 (by
    change pellLightFiniteCheck 3239 56 (10^275) 482 PellLightProduction.magnitudes_3239 = true
    exact PellLightProduction.checked_3239)

def pellFiniteCertificate_3247 : PellFiniteCertificate 3247 (10^275) :=
  pellFiniteCertificateOfLight 3247 (10^275) 56 288 pellGraphCertificate_3247 (by
    change pellLightFiniteCheck 3247 56 (10^275) 288 PellLightProduction.magnitudes_3247 = true
    exact PellLightProduction.checked_3247)

def pellFiniteCertificate_3255 : PellFiniteCertificate 3255 (10^275) :=
  pellFiniteCertificateOfLight 3255 (10^275) 57 164 (pellEmptyMatchingCertificate 3255) (by
    change pellLightFiniteCheck 3255 57 (10^275) 164 PellLightProduction.magnitudes_3255 = true
    exact PellLightProduction.checked_3255)

def pellFiniteCertificate_3263 : PellFiniteCertificate 3263 (10^275) :=
  pellFiniteCertificateOfLight 3263 (10^275) 57 420 (pellEmptyMatchingCertificate 3263) (by
    change pellLightFiniteCheck 3263 57 (10^275) 420 PellLightProduction.magnitudes_3263 = true
    exact PellLightProduction.checked_3263)

def pellFiniteCertificate_3271 : PellFiniteCertificate 3271 (10^275) :=
  pellFiniteCertificateOfLight 3271 (10^275) 57 573 pellGraphCertificate_3271 (by
    change pellLightFiniteCheck 3271 57 (10^275) 573 PellLightProduction.magnitudes_3271 = true
    exact PellLightProduction.checked_3271)

def pellFiniteCertificate_3279 : PellFiniteCertificate 3279 (10^275) :=
  pellFiniteCertificateOfLight 3279 (10^275) 57 454 (pellEmptyMatchingCertificate 3279) (by
    change pellLightFiniteCheck 3279 57 (10^275) 454 PellLightProduction.magnitudes_3279 = true
    exact PellLightProduction.checked_3279)

def pellFiniteCertificate_3287 : PellFiniteCertificate 3287 (10^275) :=
  pellFiniteCertificateOfLight 3287 (10^275) 57 216 (pellEmptyMatchingCertificate 3287) (by
    change pellLightFiniteCheck 3287 57 (10^275) 216 PellLightProduction.magnitudes_3287 = true
    exact PellLightProduction.checked_3287)

def pellFiniteCertificate_3295 : PellFiniteCertificate 3295 (10^275) :=
  pellFiniteCertificateOfLight 3295 (10^275) 57 437 (pellEmptyMatchingCertificate 3295) (by
    change pellLightFiniteCheck 3295 57 (10^275) 437 PellLightProduction.magnitudes_3295 = true
    exact PellLightProduction.checked_3295)

def pellFiniteCertificate_3311 : PellFiniteCertificate 3311 (10^275) :=
  pellFiniteCertificateOfLight 3311 (10^275) 57 523 (pellEmptyMatchingCertificate 3311) (by
    change pellLightFiniteCheck 3311 57 (10^275) 523 PellLightProduction.magnitudes_3311 = true
    exact PellLightProduction.checked_3311)

def pellFiniteCertificate_3319 : PellFiniteCertificate 3319 (10^275) :=
  pellFiniteCertificateOfLight 3319 (10^275) 57 549 pellGraphCertificate_3319 (by
    change pellLightFiniteCheck 3319 57 (10^275) 549 PellLightProduction.magnitudes_3319 = true
    exact PellLightProduction.checked_3319)

def pellFiniteCertificate_3327 : PellFiniteCertificate 3327 (10^275) :=
  pellFiniteCertificateOfLight 3327 (10^275) 57 549 (pellEmptyMatchingCertificate 3327) (by
    change pellLightFiniteCheck 3327 57 (10^275) 549 PellLightProduction.magnitudes_3327 = true
    exact PellLightProduction.checked_3327)

def pellFiniteCertificate_3335 : PellFiniteCertificate 3335 (10^275) :=
  pellFiniteCertificateOfLight 3335 (10^275) 57 412 (pellEmptyMatchingCertificate 3335) (by
    change pellLightFiniteCheck 3335 57 (10^275) 412 PellLightProduction.magnitudes_3335 = true
    exact PellLightProduction.checked_3335)

def pellFiniteCertificate_3343 : PellFiniteCertificate 3343 (10^275) :=
  pellFiniteCertificateOfLight 3343 (10^275) 57 542 pellGraphCertificate_3343 (by
    change pellLightFiniteCheck 3343 57 (10^275) 542 PellLightProduction.magnitudes_3343 = true
    exact PellLightProduction.checked_3343)

def pellFiniteCertificate_3351 : PellFiniteCertificate 3351 (10^275) :=
  pellFiniteCertificateOfLight 3351 (10^275) 57 574 (pellEmptyMatchingCertificate 3351) (by
    change pellLightFiniteCheck 3351 57 (10^275) 574 PellLightProduction.magnitudes_3351 = true
    exact PellLightProduction.checked_3351)

def pellFiniteCertificate_3359 : PellFiniteCertificate 3359 (10^275) :=
  pellFiniteCertificateOfLight 3359 (10^275) 57 417 pellGraphCertificate_3359 (by
    change pellLightFiniteCheck 3359 57 (10^275) 417 PellLightProduction.magnitudes_3359 = true
    exact PellLightProduction.checked_3359)

def pellFiniteCertificate_3367 : PellFiniteCertificate 3367 (10^275) :=
  pellFiniteCertificateOfLight 3367 (10^275) 58 428 (pellEmptyMatchingCertificate 3367) (by
    change pellLightFiniteCheck 3367 58 (10^275) 428 PellLightProduction.magnitudes_3367 = true
    exact PellLightProduction.checked_3367)

def pellFiniteCertificate_3383 : PellFiniteCertificate 3383 (10^275) :=
  pellFiniteCertificateOfLight 3383 (10^275) 58 510 pellGraphCertificate_3383 (by
    change pellLightFiniteCheck 3383 58 (10^275) 510 PellLightProduction.magnitudes_3383 = true
    exact PellLightProduction.checked_3383)

def pellFiniteCertificate_3391 : PellFiniteCertificate 3391 (10^275) :=
  pellFiniteCertificateOfLight 3391 (10^275) 58 604 pellGraphCertificate_3391 (by
    change pellLightFiniteCheck 3391 58 (10^275) 604 PellLightProduction.magnitudes_3391 = true
    exact PellLightProduction.checked_3391)

def pellFiniteCertificate_3399 : PellFiniteCertificate 3399 (10^275) :=
  pellFiniteCertificateOfLight 3399 (10^275) 58 324 (pellEmptyMatchingCertificate 3399) (by
    change pellLightFiniteCheck 3399 58 (10^275) 324 PellLightProduction.magnitudes_3399 = true
    exact PellLightProduction.checked_3399)

def pellFiniteCertificate_3407 : PellFiniteCertificate 3407 (10^275) :=
  pellFiniteCertificateOfLight 3407 (10^275) 58 549 pellGraphCertificate_3407 (by
    change pellLightFiniteCheck 3407 58 (10^275) 549 PellLightProduction.magnitudes_3407 = true
    exact PellLightProduction.checked_3407)

def pellFiniteCertificate_3415 : PellFiniteCertificate 3415 (10^275) :=
  pellFiniteCertificateOfLight 3415 (10^275) 58 543 (pellEmptyMatchingCertificate 3415) (by
    change pellLightFiniteCheck 3415 58 (10^275) 543 PellLightProduction.magnitudes_3415 = true
    exact PellLightProduction.checked_3415)

def pellFiniteCertificate_3423 : PellFiniteCertificate 3423 (10^275) :=
  pellFiniteCertificateOfLight 3423 (10^275) 58 387 (pellEmptyMatchingCertificate 3423) (by
    change pellLightFiniteCheck 3423 58 (10^275) 387 PellLightProduction.magnitudes_3423 = true
    exact PellLightProduction.checked_3423)

def pellFiniteCertificate_3431 : PellFiniteCertificate 3431 (10^275) :=
  pellFiniteCertificateOfLight 3431 (10^275) 58 684 pellGraphCertificate_3431 (by
    change pellLightFiniteCheck 3431 58 (10^275) 684 PellLightProduction.magnitudes_3431 = true
    exact PellLightProduction.checked_3431)

def pellFiniteCertificate_3439 : PellFiniteCertificate 3439 (10^275) :=
  pellFiniteCertificateOfLight 3439 (10^275) 58 489 (pellEmptyMatchingCertificate 3439) (by
    change pellLightFiniteCheck 3439 58 (10^275) 489 PellLightProduction.magnitudes_3439 = true
    exact PellLightProduction.checked_3439)

def pellFiniteCertificate_3455 : PellFiniteCertificate 3455 (10^275) :=
  pellFiniteCertificateOfLight 3455 (10^275) 58 520 (pellEmptyMatchingCertificate 3455) (by
    change pellLightFiniteCheck 3455 58 (10^275) 520 PellLightProduction.magnitudes_3455 = true
    exact PellLightProduction.checked_3455)

def pellFiniteCertificate_3463 : PellFiniteCertificate 3463 (10^275) :=
  pellFiniteCertificateOfLight 3463 (10^275) 58 581 pellGraphCertificate_3463 (by
    change pellLightFiniteCheck 3463 58 (10^275) 581 PellLightProduction.magnitudes_3463 = true
    exact PellLightProduction.checked_3463)

def pellFiniteCertificate_3471 : PellFiniteCertificate 3471 (10^275) :=
  pellFiniteCertificateOfLight 3471 (10^275) 58 490 (pellEmptyMatchingCertificate 3471) (by
    change pellLightFiniteCheck 3471 58 (10^275) 490 PellLightProduction.magnitudes_3471 = true
    exact PellLightProduction.checked_3471)

def pellFiniteCertificate_3487 : PellFiniteCertificate 3487 (10^275) :=
  pellFiniteCertificateOfLight 3487 (10^275) 59 602 (pellEmptyMatchingCertificate 3487) (by
    change pellLightFiniteCheck 3487 59 (10^275) 602 PellLightProduction.magnitudes_3487 = true
    exact PellLightProduction.checked_3487)

def pellFiniteCertificate_3495 : PellFiniteCertificate 3495 (10^275) :=
  pellFiniteCertificateOfLight 3495 (10^275) 59 321 (pellEmptyMatchingCertificate 3495) (by
    change pellLightFiniteCheck 3495 59 (10^275) 321 PellLightProduction.magnitudes_3495 = true
    exact PellLightProduction.checked_3495)

def pellFiniteCertificate_3503 : PellFiniteCertificate 3503 (10^275) :=
  pellFiniteCertificateOfLight 3503 (10^275) 59 372 (pellEmptyMatchingCertificate 3503) (by
    change pellLightFiniteCheck 3503 59 (10^275) 372 PellLightProduction.magnitudes_3503 = true
    exact PellLightProduction.checked_3503)

def pellFiniteCertificate_3511 : PellFiniteCertificate 3511 (10^275) :=
  pellFiniteCertificateOfLight 3511 (10^275) 59 530 pellGraphCertificate_3511 (by
    change pellLightFiniteCheck 3511 59 (10^275) 530 PellLightProduction.magnitudes_3511 = true
    exact PellLightProduction.checked_3511)

def pellFiniteCertificate_3527 : PellFiniteCertificate 3527 (10^275) :=
  pellFiniteCertificateOfLight 3527 (10^275) 59 551 pellGraphCertificate_3527 (by
    change pellLightFiniteCheck 3527 59 (10^275) 551 PellLightProduction.magnitudes_3527 = true
    exact PellLightProduction.checked_3527)

def pellFiniteCertificate_3535 : PellFiniteCertificate 3535 (10^275) :=
  pellFiniteCertificateOfLight 3535 (10^275) 59 391 (pellEmptyMatchingCertificate 3535) (by
    change pellLightFiniteCheck 3535 59 (10^275) 391 PellLightProduction.magnitudes_3535 = true
    exact PellLightProduction.checked_3535)

def pellFiniteCertificate_3543 : PellFiniteCertificate 3543 (10^275) :=
  pellFiniteCertificateOfLight 3543 (10^275) 59 551 (pellEmptyMatchingCertificate 3543) (by
    change pellLightFiniteCheck 3543 59 (10^275) 551 PellLightProduction.magnitudes_3543 = true
    exact PellLightProduction.checked_3543)

def pellFiniteCertificate_3551 : PellFiniteCertificate 3551 (10^275) :=
  pellFiniteCertificateOfLight 3551 (10^275) 59 514 (pellEmptyMatchingCertificate 3551) (by
    change pellLightFiniteCheck 3551 59 (10^275) 514 PellLightProduction.magnitudes_3551 = true
    exact PellLightProduction.checked_3551)

def pellFiniteCertificate_3559 : PellFiniteCertificate 3559 (10^275) :=
  pellFiniteCertificateOfLight 3559 (10^275) 59 518 pellGraphCertificate_3559 (by
    change pellLightFiniteCheck 3559 59 (10^275) 518 PellLightProduction.magnitudes_3559 = true
    exact PellLightProduction.checked_3559)

def pellFiniteCertificate_3567 : PellFiniteCertificate 3567 (10^275) :=
  pellFiniteCertificateOfLight 3567 (10^275) 59 681 (pellEmptyMatchingCertificate 3567) (by
    change pellLightFiniteCheck 3567 59 (10^275) 681 PellLightProduction.magnitudes_3567 = true
    exact PellLightProduction.checked_3567)

def pellFiniteCertificate_3583 : PellFiniteCertificate 3583 (10^275) :=
  pellFiniteCertificateOfLight 3583 (10^275) 59 561 pellGraphCertificate_3583 (by
    change pellLightFiniteCheck 3583 59 (10^275) 561 PellLightProduction.magnitudes_3583 = true
    exact PellLightProduction.checked_3583)

def pellFiniteCertificate_3599 : PellFiniteCertificate 3599 (10^275) :=
  pellFiniteCertificateOfLight 3599 (10^275) 59 264 (pellEmptyMatchingCertificate 3599) (by
    change pellLightFiniteCheck 3599 59 (10^275) 264 PellLightProduction.magnitudes_3599 = true
    exact PellLightProduction.checked_3599)

def pellFiniteCertificate_3607 : PellFiniteCertificate 3607 (10^275) :=
  pellFiniteCertificateOfLight 3607 (10^275) 60 469 pellGraphCertificate_3607 (by
    change pellLightFiniteCheck 3607 60 (10^275) 469 PellLightProduction.magnitudes_3607 = true
    exact PellLightProduction.checked_3607)

def pellFiniteCertificate_3615 : PellFiniteCertificate 3615 (10^275) :=
  pellFiniteCertificateOfLight 3615 (10^275) 60 184 (pellEmptyMatchingCertificate 3615) (by
    change pellLightFiniteCheck 3615 60 (10^275) 184 PellLightProduction.magnitudes_3615 = true
    exact PellLightProduction.checked_3615)

def pellFiniteCertificate_3623 : PellFiniteCertificate 3623 (10^275) :=
  pellFiniteCertificateOfLight 3623 (10^275) 60 476 pellGraphCertificate_3623 (by
    change pellLightFiniteCheck 3623 60 (10^275) 476 PellLightProduction.magnitudes_3623 = true
    exact PellLightProduction.checked_3623)

def pellFiniteCertificate_3631 : PellFiniteCertificate 3631 (10^275) :=
  pellFiniteCertificateOfLight 3631 (10^275) 60 563 pellGraphCertificate_3631 (by
    change pellLightFiniteCheck 3631 60 (10^275) 563 PellLightProduction.magnitudes_3631 = true
    exact PellLightProduction.checked_3631)

def pellFiniteCertificate_3639 : PellFiniteCertificate 3639 (10^275) :=
  pellFiniteCertificateOfLight 3639 (10^275) 60 454 (pellEmptyMatchingCertificate 3639) (by
    change pellLightFiniteCheck 3639 60 (10^275) 454 PellLightProduction.magnitudes_3639 = true
    exact PellLightProduction.checked_3639)

def pellFiniteCertificate_3647 : PellFiniteCertificate 3647 (10^275) :=
  pellFiniteCertificateOfLight 3647 (10^275) 60 595 pellGraphCertificate_3647 (by
    change pellLightFiniteCheck 3647 60 (10^275) 595 PellLightProduction.magnitudes_3647 = true
    exact PellLightProduction.checked_3647)

def pellFiniteCertificate_3655 : PellFiniteCertificate 3655 (10^275) :=
  pellFiniteCertificateOfLight 3655 (10^275) 60 584 (pellEmptyMatchingCertificate 3655) (by
    change pellLightFiniteCheck 3655 60 (10^275) 584 PellLightProduction.magnitudes_3655 = true
    exact PellLightProduction.checked_3655)

def pellFiniteCertificate_3671 : PellFiniteCertificate 3671 (10^275) :=
  pellFiniteCertificateOfLight 3671 (10^275) 60 454 pellGraphCertificate_3671 (by
    change pellLightFiniteCheck 3671 60 (10^275) 454 PellLightProduction.magnitudes_3671 = true
    exact PellLightProduction.checked_3671)

def pellFiniteCertificate_3679 : PellFiniteCertificate 3679 (10^275) :=
  pellFiniteCertificateOfLight 3679 (10^275) 60 548 (pellEmptyMatchingCertificate 3679) (by
    change pellLightFiniteCheck 3679 60 (10^275) 548 PellLightProduction.magnitudes_3679 = true
    exact PellLightProduction.checked_3679)

def pellFiniteCertificate_3687 : PellFiniteCertificate 3687 (10^275) :=
  pellFiniteCertificateOfLight 3687 (10^275) 60 765 (pellEmptyMatchingCertificate 3687) (by
    change pellLightFiniteCheck 3687 60 (10^275) 765 PellLightProduction.magnitudes_3687 = true
    exact PellLightProduction.checked_3687)

def pellFiniteCertificate_3695 : PellFiniteCertificate 3695 (10^275) :=
  pellFiniteCertificateOfLight 3695 (10^275) 60 446 (pellEmptyMatchingCertificate 3695) (by
    change pellLightFiniteCheck 3695 60 (10^275) 446 PellLightProduction.magnitudes_3695 = true
    exact PellLightProduction.checked_3695)

def pellFiniteCertificate_3711 : PellFiniteCertificate 3711 (10^275) :=
  pellFiniteCertificateOfLight 3711 (10^275) 60 542 (pellEmptyMatchingCertificate 3711) (by
    change pellLightFiniteCheck 3711 60 (10^275) 542 PellLightProduction.magnitudes_3711 = true
    exact PellLightProduction.checked_3711)

def pellFiniteCertificate_3719 : PellFiniteCertificate 3719 (10^275) :=
  pellFiniteCertificateOfLight 3719 (10^275) 60 284 pellGraphCertificate_3719 (by
    change pellLightFiniteCheck 3719 60 (10^275) 284 PellLightProduction.magnitudes_3719 = true
    exact PellLightProduction.checked_3719)

def pellFiniteCertificate_3727 : PellFiniteCertificate 3727 (10^275) :=
  pellFiniteCertificateOfLight 3727 (10^275) 61 529 pellGraphCertificate_3727 (by
    change pellLightFiniteCheck 3727 61 (10^275) 529 PellLightProduction.magnitudes_3727 = true
    exact PellLightProduction.checked_3727)

def pellFiniteCertificate_3743 : PellFiniteCertificate 3743 (10^275) :=
  pellFiniteCertificateOfLight 3743 (10^275) 61 436 (pellEmptyMatchingCertificate 3743) (by
    change pellLightFiniteCheck 3743 61 (10^275) 436 PellLightProduction.magnitudes_3743 = true
    exact PellLightProduction.checked_3743)

def pellFiniteCertificate_3759 : PellFiniteCertificate 3759 (10^275) :=
  pellFiniteCertificateOfLight 3759 (10^275) 61 518 (pellEmptyMatchingCertificate 3759) (by
    change pellLightFiniteCheck 3759 61 (10^275) 518 PellLightProduction.magnitudes_3759 = true
    exact PellLightProduction.checked_3759)

def pellFiniteCertificate_3767 : PellFiniteCertificate 3767 (10^275) :=
  pellFiniteCertificateOfLight 3767 (10^275) 61 511 pellGraphCertificate_3767 (by
    change pellLightFiniteCheck 3767 61 (10^275) 511 PellLightProduction.magnitudes_3767 = true
    exact PellLightProduction.checked_3767)

def pellFiniteCertificate_3783 : PellFiniteCertificate 3783 (10^275) :=
  pellFiniteCertificateOfLight 3783 (10^275) 61 383 (pellEmptyMatchingCertificate 3783) (by
    change pellLightFiniteCheck 3783 61 (10^275) 383 PellLightProduction.magnitudes_3783 = true
    exact PellLightProduction.checked_3783)

def pellFiniteCertificate_3791 : PellFiniteCertificate 3791 (10^275) :=
  pellFiniteCertificateOfLight 3791 (10^275) 61 394 pellGraphCertificate_3791 (by
    change pellLightFiniteCheck 3791 61 (10^275) 394 PellLightProduction.magnitudes_3791 = true
    exact PellLightProduction.checked_3791)

def pellFiniteCertificate_3799 : PellFiniteCertificate 3799 (10^275) :=
  pellFiniteCertificateOfLight 3799 (10^275) 61 582 (pellEmptyMatchingCertificate 3799) (by
    change pellLightFiniteCheck 3799 61 (10^275) 582 PellLightProduction.magnitudes_3799 = true
    exact PellLightProduction.checked_3799)

def pellFiniteCertificate_3815 : PellFiniteCertificate 3815 (10^275) :=
  pellFiniteCertificateOfLight 3815 (10^275) 61 538 (pellEmptyMatchingCertificate 3815) (by
    change pellLightFiniteCheck 3815 61 (10^275) 538 PellLightProduction.magnitudes_3815 = true
    exact PellLightProduction.checked_3815)

def pellFiniteCertificate_3823 : PellFiniteCertificate 3823 (10^275) :=
  pellFiniteCertificateOfLight 3823 (10^275) 61 535 pellGraphCertificate_3823 (by
    change pellLightFiniteCheck 3823 61 (10^275) 535 PellLightProduction.magnitudes_3823 = true
    exact PellLightProduction.checked_3823)

def pellFiniteCertificate_3831 : PellFiniteCertificate 3831 (10^275) :=
  pellFiniteCertificateOfLight 3831 (10^275) 61 520 (pellEmptyMatchingCertificate 3831) (by
    change pellLightFiniteCheck 3831 61 (10^275) 520 PellLightProduction.magnitudes_3831 = true
    exact PellLightProduction.checked_3831)

def pellFiniteCertificate_3839 : PellFiniteCertificate 3839 (10^275) :=
  pellFiniteCertificateOfLight 3839 (10^275) 61 450 (pellEmptyMatchingCertificate 3839) (by
    change pellLightFiniteCheck 3839 61 (10^275) 450 PellLightProduction.magnitudes_3839 = true
    exact PellLightProduction.checked_3839)

def pellFiniteCertificate_3847 : PellFiniteCertificate 3847 (10^275) :=
  pellFiniteCertificateOfLight 3847 (10^275) 62 508 pellGraphCertificate_3847 (by
    change pellLightFiniteCheck 3847 62 (10^275) 508 PellLightProduction.magnitudes_3847 = true
    exact PellLightProduction.checked_3847)

def pellFiniteCertificate_3855 : PellFiniteCertificate 3855 (10^275) :=
  pellFiniteCertificateOfLight 3855 (10^275) 62 420 (pellEmptyMatchingCertificate 3855) (by
    change pellLightFiniteCheck 3855 62 (10^275) 420 PellLightProduction.magnitudes_3855 = true
    exact PellLightProduction.checked_3855)

def pellFiniteCertificate_3863 : PellFiniteCertificate 3863 (10^275) :=
  pellFiniteCertificateOfLight 3863 (10^275) 62 612 pellGraphCertificate_3863 (by
    change pellLightFiniteCheck 3863 62 (10^275) 612 PellLightProduction.magnitudes_3863 = true
    exact PellLightProduction.checked_3863)

def pellFiniteCertificate_3895 : PellFiniteCertificate 3895 (10^275) :=
  pellFiniteCertificateOfLight 3895 (10^275) 62 509 (pellEmptyMatchingCertificate 3895) (by
    change pellLightFiniteCheck 3895 62 (10^275) 509 PellLightProduction.magnitudes_3895 = true
    exact PellLightProduction.checked_3895)

def pellFiniteCertificate_3903 : PellFiniteCertificate 3903 (10^275) :=
  pellFiniteCertificateOfLight 3903 (10^275) 62 473 (pellEmptyMatchingCertificate 3903) (by
    change pellLightFiniteCheck 3903 62 (10^275) 473 PellLightProduction.magnitudes_3903 = true
    exact PellLightProduction.checked_3903)

def pellFiniteCertificate_3911 : PellFiniteCertificate 3911 (10^275) :=
  pellFiniteCertificateOfLight 3911 (10^275) 62 594 pellGraphCertificate_3911 (by
    change pellLightFiniteCheck 3911 62 (10^275) 594 PellLightProduction.magnitudes_3911 = true
    exact PellLightProduction.checked_3911)

def pellFiniteCertificate_3919 : PellFiniteCertificate 3919 (10^275) :=
  pellFiniteCertificateOfLight 3919 (10^275) 62 587 pellGraphCertificate_3919 (by
    change pellLightFiniteCheck 3919 62 (10^275) 587 PellLightProduction.magnitudes_3919 = true
    exact PellLightProduction.checked_3919)

def pellFiniteCertificate_3927 : PellFiniteCertificate 3927 (10^275) :=
  pellFiniteCertificateOfLight 3927 (10^275) 62 426 (pellEmptyMatchingCertificate 3927) (by
    change pellLightFiniteCheck 3927 62 (10^275) 426 PellLightProduction.magnitudes_3927 = true
    exact PellLightProduction.checked_3927)

def pellFiniteCertificate_3935 : PellFiniteCertificate 3935 (10^275) :=
  pellFiniteCertificateOfLight 3935 (10^275) 62 597 (pellEmptyMatchingCertificate 3935) (by
    change pellLightFiniteCheck 3935 62 (10^275) 597 PellLightProduction.magnitudes_3935 = true
    exact PellLightProduction.checked_3935)

def pellFiniteCertificate_3943 : PellFiniteCertificate 3943 (10^275) :=
  pellFiniteCertificateOfLight 3943 (10^275) 62 546 pellGraphCertificate_3943 (by
    change pellLightFiniteCheck 3943 62 (10^275) 546 PellLightProduction.magnitudes_3943 = true
    exact PellLightProduction.checked_3943)

def pellFiniteCertificate_3959 : PellFiniteCertificate 3959 (10^275) :=
  pellFiniteCertificateOfLight 3959 (10^275) 62 617 (pellEmptyMatchingCertificate 3959) (by
    change pellLightFiniteCheck 3959 62 (10^275) 617 PellLightProduction.magnitudes_3959 = true
    exact PellLightProduction.checked_3959)

def pellFiniteCertificate_3967 : PellFiniteCertificate 3967 (10^275) :=
  pellFiniteCertificateOfLight 3967 (10^275) 62 282 pellGraphCertificate_3967 (by
    change pellLightFiniteCheck 3967 62 (10^275) 282 PellLightProduction.magnitudes_3967 = true
    exact PellLightProduction.checked_3967)

def pellFiniteCertificate_3983 : PellFiniteCertificate 3983 (10^275) :=
  pellFiniteCertificateOfLight 3983 (10^275) 63 180 (pellEmptyMatchingCertificate 3983) (by
    change pellLightFiniteCheck 3983 63 (10^275) 180 PellLightProduction.magnitudes_3983 = true
    exact PellLightProduction.checked_3983)

def pellFiniteCertificate_3991 : PellFiniteCertificate 3991 (10^275) :=
  pellFiniteCertificateOfLight 3991 (10^275) 63 571 (pellEmptyMatchingCertificate 3991) (by
    change pellLightFiniteCheck 3991 63 (10^275) 571 PellLightProduction.magnitudes_3991 = true
    exact PellLightProduction.checked_3991)

def pellFiniteCertificate_3999 : PellFiniteCertificate 3999 (10^275) :=
  pellFiniteCertificateOfLight 3999 (10^275) 63 348 (pellEmptyMatchingCertificate 3999) (by
    change pellLightFiniteCheck 3999 63 (10^275) 348 PellLightProduction.magnitudes_3999 = true
    exact PellLightProduction.checked_3999)

def pellFiniteCertificate_4007 : PellFiniteCertificate 4007 (10^275) :=
  pellFiniteCertificateOfLight 4007 (10^275) 63 515 pellGraphCertificate_4007 (by
    change pellLightFiniteCheck 4007 63 (10^275) 515 PellLightProduction.magnitudes_4007 = true
    exact PellLightProduction.checked_4007)

def pellFiniteCertificate_4015 : PellFiniteCertificate 4015 (10^275) :=
  pellFiniteCertificateOfLight 4015 (10^275) 63 496 (pellEmptyMatchingCertificate 4015) (by
    change pellLightFiniteCheck 4015 63 (10^275) 496 PellLightProduction.magnitudes_4015 = true
    exact PellLightProduction.checked_4015)

def pellFiniteCertificate_4031 : PellFiniteCertificate 4031 (10^275) :=
  pellFiniteCertificateOfLight 4031 (10^275) 63 463 (pellEmptyMatchingCertificate 4031) (by
    change pellLightFiniteCheck 4031 63 (10^275) 463 PellLightProduction.magnitudes_4031 = true
    exact PellLightProduction.checked_4031)

def pellFiniteCertificate_4039 : PellFiniteCertificate 4039 (10^275) :=
  pellFiniteCertificateOfLight 4039 (10^275) 63 557 pellGraphCertificate_4039 (by
    change pellLightFiniteCheck 4039 63 (10^275) 557 PellLightProduction.magnitudes_4039 = true
    exact PellLightProduction.checked_4039)

def pellFiniteCertificate_4047 : PellFiniteCertificate 4047 (10^275) :=
  pellFiniteCertificateOfLight 4047 (10^275) 63 672 (pellEmptyMatchingCertificate 4047) (by
    change pellLightFiniteCheck 4047 63 (10^275) 672 PellLightProduction.magnitudes_4047 = true
    exact PellLightProduction.checked_4047)

def pellFiniteCertificate_4055 : PellFiniteCertificate 4055 (10^275) :=
  pellFiniteCertificateOfLight 4055 (10^275) 63 618 (pellEmptyMatchingCertificate 4055) (by
    change pellLightFiniteCheck 4055 63 (10^275) 618 PellLightProduction.magnitudes_4055 = true
    exact PellLightProduction.checked_4055)

def pellFiniteCertificate_4063 : PellFiniteCertificate 4063 (10^275) :=
  pellFiniteCertificateOfLight 4063 (10^275) 63 524 (pellEmptyMatchingCertificate 4063) (by
    change pellLightFiniteCheck 4063 63 (10^275) 524 PellLightProduction.magnitudes_4063 = true
    exact PellLightProduction.checked_4063)

def pellFiniteCertificate_4071 : PellFiniteCertificate 4071 (10^275) :=
  pellFiniteCertificateOfLight 4071 (10^275) 63 533 (pellEmptyMatchingCertificate 4071) (by
    change pellLightFiniteCheck 4071 63 (10^275) 533 PellLightProduction.magnitudes_4071 = true
    exact PellLightProduction.checked_4071)

def pellFiniteCertificate_4079 : PellFiniteCertificate 4079 (10^275) :=
  pellFiniteCertificateOfLight 4079 (10^275) 63 521 pellGraphCertificate_4079 (by
    change pellLightFiniteCheck 4079 63 (10^275) 521 PellLightProduction.magnitudes_4079 = true
    exact PellLightProduction.checked_4079)

def pellFiniteCertificate_4087 : PellFiniteCertificate 4087 (10^275) :=
  pellFiniteCertificateOfLight 4087 (10^275) 63 441 (pellEmptyMatchingCertificate 4087) (by
    change pellLightFiniteCheck 4087 63 (10^275) 441 PellLightProduction.magnitudes_4087 = true
    exact PellLightProduction.checked_4087)

def pellFiniteCertificate_4103 : PellFiniteCertificate 4103 (10^275) :=
  pellFiniteCertificateOfLight 4103 (10^275) 64 350 (pellEmptyMatchingCertificate 4103) (by
    change pellLightFiniteCheck 4103 64 (10^275) 350 PellLightProduction.magnitudes_4103 = true
    exact PellLightProduction.checked_4103)

def pellFiniteCertificate_4111 : PellFiniteCertificate 4111 (10^275) :=
  pellFiniteCertificateOfLight 4111 (10^275) 64 581 pellGraphCertificate_4111 (by
    change pellLightFiniteCheck 4111 64 (10^275) 581 PellLightProduction.magnitudes_4111 = true
    exact PellLightProduction.checked_4111)

def pellFiniteCertificate_4119 : PellFiniteCertificate 4119 (10^275) :=
  pellFiniteCertificateOfLight 4119 (10^275) 64 407 (pellEmptyMatchingCertificate 4119) (by
    change pellLightFiniteCheck 4119 64 (10^275) 407 PellLightProduction.magnitudes_4119 = true
    exact PellLightProduction.checked_4119)

def pellFiniteCertificate_4127 : PellFiniteCertificate 4127 (10^275) :=
  pellFiniteCertificateOfLight 4127 (10^275) 64 470 pellGraphCertificate_4127 (by
    change pellLightFiniteCheck 4127 64 (10^275) 470 PellLightProduction.magnitudes_4127 = true
    exact PellLightProduction.checked_4127)

def pellFiniteCertificate_4135 : PellFiniteCertificate 4135 (10^275) :=
  pellFiniteCertificateOfLight 4135 (10^275) 64 593 (pellEmptyMatchingCertificate 4135) (by
    change pellLightFiniteCheck 4135 64 (10^275) 593 PellLightProduction.magnitudes_4135 = true
    exact PellLightProduction.checked_4135)

def pellFiniteCertificate_4143 : PellFiniteCertificate 4143 (10^275) :=
  pellFiniteCertificateOfLight 4143 (10^275) 64 562 (pellEmptyMatchingCertificate 4143) (by
    change pellLightFiniteCheck 4143 64 (10^275) 562 PellLightProduction.magnitudes_4143 = true
    exact PellLightProduction.checked_4143)

def pellFiniteCertificate_4151 : PellFiniteCertificate 4151 (10^275) :=
  pellFiniteCertificateOfLight 4151 (10^275) 64 392 pellGraphCertificate_4151 (by
    change pellLightFiniteCheck 4151 64 (10^275) 392 PellLightProduction.magnitudes_4151 = true
    exact PellLightProduction.checked_4151)

def pellFiniteCertificate_4159 : PellFiniteCertificate 4159 (10^275) :=
  pellFiniteCertificateOfLight 4159 (10^275) 64 498 pellGraphCertificate_4159 (by
    change pellLightFiniteCheck 4159 64 (10^275) 498 PellLightProduction.magnitudes_4159 = true
    exact PellLightProduction.checked_4159)

def pellFiniteCertificate_4183 : PellFiniteCertificate 4183 (10^275) :=
  pellFiniteCertificateOfLight 4183 (10^275) 64 464 pellGraphCertificate_4183 (by
    change pellLightFiniteCheck 4183 64 (10^275) 464 PellLightProduction.magnitudes_4183 = true
    exact PellLightProduction.checked_4183)

def pellFiniteCertificate_4191 : PellFiniteCertificate 4191 (10^275) :=
  pellFiniteCertificateOfLight 4191 (10^275) 64 494 (pellEmptyMatchingCertificate 4191) (by
    change pellLightFiniteCheck 4191 64 (10^275) 494 PellLightProduction.magnitudes_4191 = true
    exact PellLightProduction.checked_4191)

def pellFiniteCertificate_4199 : PellFiniteCertificate 4199 (10^275) :=
  pellFiniteCertificateOfLight 4199 (10^275) 64 390 (pellEmptyMatchingCertificate 4199) (by
    change pellLightFiniteCheck 4199 64 (10^275) 390 PellLightProduction.magnitudes_4199 = true
    exact PellLightProduction.checked_4199)

def pellFiniteCertificate_4207 : PellFiniteCertificate 4207 (10^275) :=
  pellFiniteCertificateOfLight 4207 (10^275) 64 429 pellGraphCertificate_4207 (by
    change pellLightFiniteCheck 4207 64 (10^275) 429 PellLightProduction.magnitudes_4207 = true
    exact PellLightProduction.checked_4207)

def pellFiniteCertificate_4215 : PellFiniteCertificate 4215 (10^275) :=
  pellFiniteCertificateOfLight 4215 (10^275) 64 340 (pellEmptyMatchingCertificate 4215) (by
    change pellLightFiniteCheck 4215 64 (10^275) 340 PellLightProduction.magnitudes_4215 = true
    exact PellLightProduction.checked_4215)

def pellFiniteCertificate_4223 : PellFiniteCertificate 4223 (10^275) :=
  pellFiniteCertificateOfLight 4223 (10^275) 64 280 pellGraphCertificate_4223 (by
    change pellLightFiniteCheck 4223 64 (10^275) 280 PellLightProduction.magnitudes_4223 = true
    exact PellLightProduction.checked_4223)

def pellFiniteCertificate_4231 : PellFiniteCertificate 4231 (10^275) :=
  pellFiniteCertificateOfLight 4231 (10^275) 65 475 pellGraphCertificate_4231 (by
    change pellLightFiniteCheck 4231 65 (10^275) 475 PellLightProduction.magnitudes_4231 = true
    exact PellLightProduction.checked_4231)

def pellFiniteCertificate_4247 : PellFiniteCertificate 4247 (10^275) :=
  pellFiniteCertificateOfLight 4247 (10^275) 65 288 pellGraphCertificate_4247 (by
    change pellLightFiniteCheck 4247 65 (10^275) 288 PellLightProduction.magnitudes_4247 = true
    exact PellLightProduction.checked_4247)

def pellFiniteCertificate_4255 : PellFiniteCertificate 4255 (10^275) :=
  pellFiniteCertificateOfLight 4255 (10^275) 65 462 (pellEmptyMatchingCertificate 4255) (by
    change pellLightFiniteCheck 4255 65 (10^275) 462 PellLightProduction.magnitudes_4255 = true
    exact PellLightProduction.checked_4255)

def pellFiniteCertificate_4271 : PellFiniteCertificate 4271 (10^275) :=
  pellFiniteCertificateOfLight 4271 (10^275) 65 344 pellGraphCertificate_4271 (by
    change pellLightFiniteCheck 4271 65 (10^275) 344 PellLightProduction.magnitudes_4271 = true
    exact PellLightProduction.checked_4271)

def pellFiniteCertificate_4279 : PellFiniteCertificate 4279 (10^275) :=
  pellFiniteCertificateOfLight 4279 (10^275) 65 496 (pellEmptyMatchingCertificate 4279) (by
    change pellLightFiniteCheck 4279 65 (10^275) 496 PellLightProduction.magnitudes_4279 = true
    exact PellLightProduction.checked_4279)

def pellFiniteCertificate_4287 : PellFiniteCertificate 4287 (10^275) :=
  pellFiniteCertificateOfLight 4287 (10^275) 65 515 (pellEmptyMatchingCertificate 4287) (by
    change pellLightFiniteCheck 4287 65 (10^275) 515 PellLightProduction.magnitudes_4287 = true
    exact PellLightProduction.checked_4287)

def pellFiniteCertificate_4295 : PellFiniteCertificate 4295 (10^275) :=
  pellFiniteCertificateOfLight 4295 (10^275) 65 449 (pellEmptyMatchingCertificate 4295) (by
    change pellLightFiniteCheck 4295 65 (10^275) 449 PellLightProduction.magnitudes_4295 = true
    exact PellLightProduction.checked_4295)

def pellFiniteCertificate_4303 : PellFiniteCertificate 4303 (10^275) :=
  pellFiniteCertificateOfLight 4303 (10^275) 65 512 (pellEmptyMatchingCertificate 4303) (by
    change pellLightFiniteCheck 4303 65 (10^275) 512 PellLightProduction.magnitudes_4303 = true
    exact PellLightProduction.checked_4303)

def pellFiniteCertificate_4319 : PellFiniteCertificate 4319 (10^275) :=
  pellFiniteCertificateOfLight 4319 (10^275) 65 560 pellGraphCertificate_4319 (by
    change pellLightFiniteCheck 4319 65 (10^275) 560 PellLightProduction.magnitudes_4319 = true
    exact PellLightProduction.checked_4319)

def pellFiniteCertificate_4327 : PellFiniteCertificate 4327 (10^275) :=
  pellFiniteCertificateOfLight 4327 (10^275) 65 574 pellGraphCertificate_4327 (by
    change pellLightFiniteCheck 4327 65 (10^275) 574 PellLightProduction.magnitudes_4327 = true
    exact PellLightProduction.checked_4327)

def pellFiniteCertificate_4343 : PellFiniteCertificate 4343 (10^275) :=
  pellFiniteCertificateOfLight 4343 (10^275) 65 484 (pellEmptyMatchingCertificate 4343) (by
    change pellLightFiniteCheck 4343 65 (10^275) 484 PellLightProduction.magnitudes_4343 = true
    exact PellLightProduction.checked_4343)

def pellFiniteCertificate_4351 : PellFiniteCertificate 4351 (10^275) :=
  pellFiniteCertificateOfLight 4351 (10^275) 65 529 (pellEmptyMatchingCertificate 4351) (by
    change pellLightFiniteCheck 4351 65 (10^275) 529 PellLightProduction.magnitudes_4351 = true
    exact PellLightProduction.checked_4351)

def pellFiniteCertificate_4359 : PellFiniteCertificate 4359 (10^275) :=
  pellFiniteCertificateOfLight 4359 (10^275) 66 146 (pellEmptyMatchingCertificate 4359) (by
    change pellLightFiniteCheck 4359 66 (10^275) 146 PellLightProduction.magnitudes_4359 = true
    exact PellLightProduction.checked_4359)

def pellFiniteCertificate_4367 : PellFiniteCertificate 4367 (10^275) :=
  pellFiniteCertificateOfLight 4367 (10^275) 66 172 (pellEmptyMatchingCertificate 4367) (by
    change pellLightFiniteCheck 4367 66 (10^275) 172 PellLightProduction.magnitudes_4367 = true
    exact PellLightProduction.checked_4367)

def pellFiniteCertificate_4391 : PellFiniteCertificate 4391 (10^275) :=
  pellFiniteCertificateOfLight 4391 (10^275) 66 580 pellGraphCertificate_4391 (by
    change pellLightFiniteCheck 4391 66 (10^275) 580 PellLightProduction.magnitudes_4391 = true
    exact PellLightProduction.checked_4391)

def pellFiniteCertificate_4399 : PellFiniteCertificate 4399 (10^275) :=
  pellFiniteCertificateOfLight 4399 (10^275) 66 480 (pellEmptyMatchingCertificate 4399) (by
    change pellLightFiniteCheck 4399 66 (10^275) 480 PellLightProduction.magnitudes_4399 = true
    exact PellLightProduction.checked_4399)

def pellFiniteCertificate_4407 : PellFiniteCertificate 4407 (10^275) :=
  pellFiniteCertificateOfLight 4407 (10^275) 66 450 (pellEmptyMatchingCertificate 4407) (by
    change pellLightFiniteCheck 4407 66 (10^275) 450 PellLightProduction.magnitudes_4407 = true
    exact PellLightProduction.checked_4407)

def pellFiniteCertificate_4415 : PellFiniteCertificate 4415 (10^275) :=
  pellFiniteCertificateOfLight 4415 (10^275) 66 366 (pellEmptyMatchingCertificate 4415) (by
    change pellLightFiniteCheck 4415 66 (10^275) 366 PellLightProduction.magnitudes_4415 = true
    exact PellLightProduction.checked_4415)

def pellFiniteCertificate_4423 : PellFiniteCertificate 4423 (10^275) :=
  pellFiniteCertificateOfLight 4423 (10^275) 66 501 pellGraphCertificate_4423 (by
    change pellLightFiniteCheck 4423 66 (10^275) 501 PellLightProduction.magnitudes_4423 = true
    exact PellLightProduction.checked_4423)

def pellFiniteCertificate_4431 : PellFiniteCertificate 4431 (10^275) :=
  pellFiniteCertificateOfLight 4431 (10^275) 66 427 (pellEmptyMatchingCertificate 4431) (by
    change pellLightFiniteCheck 4431 66 (10^275) 427 PellLightProduction.magnitudes_4431 = true
    exact PellLightProduction.checked_4431)

def pellFiniteCertificate_4439 : PellFiniteCertificate 4439 (10^275) :=
  pellFiniteCertificateOfLight 4439 (10^275) 66 551 (pellEmptyMatchingCertificate 4439) (by
    change pellLightFiniteCheck 4439 66 (10^275) 551 PellLightProduction.magnitudes_4439 = true
    exact PellLightProduction.checked_4439)

def pellFiniteCertificate_4447 : PellFiniteCertificate 4447 (10^275) :=
  pellFiniteCertificateOfLight 4447 (10^275) 66 587 pellGraphCertificate_4447 (by
    change pellLightFiniteCheck 4447 66 (10^275) 587 PellLightProduction.magnitudes_4447 = true
    exact PellLightProduction.checked_4447)

def pellFiniteCertificate_4463 : PellFiniteCertificate 4463 (10^275) :=
  pellFiniteCertificateOfLight 4463 (10^275) 66 463 pellGraphCertificate_4463 (by
    change pellLightFiniteCheck 4463 66 (10^275) 463 PellLightProduction.magnitudes_4463 = true
    exact PellLightProduction.checked_4463)

def pellFiniteCertificate_4471 : PellFiniteCertificate 4471 (10^275) :=
  pellFiniteCertificateOfLight 4471 (10^275) 66 432 (pellEmptyMatchingCertificate 4471) (by
    change pellLightFiniteCheck 4471 66 (10^275) 432 PellLightProduction.magnitudes_4471 = true
    exact PellLightProduction.checked_4471)

def pellFiniteCertificate_4479 : PellFiniteCertificate 4479 (10^275) :=
  pellFiniteCertificateOfLight 4479 (10^275) 66 564 (pellEmptyMatchingCertificate 4479) (by
    change pellLightFiniteCheck 4479 66 (10^275) 564 PellLightProduction.magnitudes_4479 = true
    exact PellLightProduction.checked_4479)

def pellFiniteCertificate_4487 : PellFiniteCertificate 4487 (10^275) :=
  pellFiniteCertificateOfLight 4487 (10^275) 66 278 pellGraphCertificate_4487 (by
    change pellLightFiniteCheck 4487 66 (10^275) 278 PellLightProduction.magnitudes_4487 = true
    exact PellLightProduction.checked_4487)

def pellFiniteCertificate_4495 : PellFiniteCertificate 4495 (10^275) :=
  pellFiniteCertificateOfLight 4495 (10^275) 67 358 (pellEmptyMatchingCertificate 4495) (by
    change pellLightFiniteCheck 4495 67 (10^275) 358 PellLightProduction.magnitudes_4495 = true
    exact PellLightProduction.checked_4495)

def pellFiniteCertificate_4503 : PellFiniteCertificate 4503 (10^275) :=
  pellFiniteCertificateOfLight 4503 (10^275) 67 462 (pellEmptyMatchingCertificate 4503) (by
    change pellLightFiniteCheck 4503 67 (10^275) 462 PellLightProduction.magnitudes_4503 = true
    exact PellLightProduction.checked_4503)

def pellFiniteCertificate_4511 : PellFiniteCertificate 4511 (10^275) :=
  pellFiniteCertificateOfLight 4511 (10^275) 67 233 (pellEmptyMatchingCertificate 4511) (by
    change pellLightFiniteCheck 4511 67 (10^275) 233 PellLightProduction.magnitudes_4511 = true
    exact PellLightProduction.checked_4511)

def pellFiniteCertificate_4535 : PellFiniteCertificate 4535 (10^275) :=
  pellFiniteCertificateOfLight 4535 (10^275) 67 523 (pellEmptyMatchingCertificate 4535) (by
    change pellLightFiniteCheck 4535 67 (10^275) 523 PellLightProduction.magnitudes_4535 = true
    exact PellLightProduction.checked_4535)

def pellFiniteCertificate_4543 : PellFiniteCertificate 4543 (10^275) :=
  pellFiniteCertificateOfLight 4543 (10^275) 67 320 (pellEmptyMatchingCertificate 4543) (by
    change pellLightFiniteCheck 4543 67 (10^275) 320 PellLightProduction.magnitudes_4543 = true
    exact PellLightProduction.checked_4543)

def pellFiniteCertificate_4551 : PellFiniteCertificate 4551 (10^275) :=
  pellFiniteCertificateOfLight 4551 (10^275) 67 568 (pellEmptyMatchingCertificate 4551) (by
    change pellLightFiniteCheck 4551 67 (10^275) 568 PellLightProduction.magnitudes_4551 = true
    exact PellLightProduction.checked_4551)

def pellFiniteCertificate_4559 : PellFiniteCertificate 4559 (10^275) :=
  pellFiniteCertificateOfLight 4559 (10^275) 67 543 (pellEmptyMatchingCertificate 4559) (by
    change pellLightFiniteCheck 4559 67 (10^275) 543 PellLightProduction.magnitudes_4559 = true
    exact PellLightProduction.checked_4559)

def pellFiniteCertificate_4567 : PellFiniteCertificate 4567 (10^275) :=
  pellFiniteCertificateOfLight 4567 (10^275) 67 528 pellGraphCertificate_4567 (by
    change pellLightFiniteCheck 4567 67 (10^275) 528 PellLightProduction.magnitudes_4567 = true
    exact PellLightProduction.checked_4567)

def pellFiniteCertificate_4583 : PellFiniteCertificate 4583 (10^275) :=
  pellFiniteCertificateOfLight 4583 (10^275) 67 523 pellGraphCertificate_4583 (by
    change pellLightFiniteCheck 4583 67 (10^275) 523 PellLightProduction.magnitudes_4583 = true
    exact PellLightProduction.checked_4583)

def pellFiniteCertificate_4591 : PellFiniteCertificate 4591 (10^275) :=
  pellFiniteCertificateOfLight 4591 (10^275) 67 538 pellGraphCertificate_4591 (by
    change pellLightFiniteCheck 4591 67 (10^275) 538 PellLightProduction.magnitudes_4591 = true
    exact PellLightProduction.checked_4591)

def pellFiniteCertificate_4607 : PellFiniteCertificate 4607 (10^275) :=
  pellFiniteCertificateOfLight 4607 (10^275) 67 360 (pellEmptyMatchingCertificate 4607) (by
    change pellLightFiniteCheck 4607 67 (10^275) 360 PellLightProduction.magnitudes_4607 = true
    exact PellLightProduction.checked_4607)

def pellFiniteCertificate_4615 : PellFiniteCertificate 4615 (10^275) :=
  pellFiniteCertificateOfLight 4615 (10^275) 67 488 (pellEmptyMatchingCertificate 4615) (by
    change pellLightFiniteCheck 4615 67 (10^275) 488 PellLightProduction.magnitudes_4615 = true
    exact PellLightProduction.checked_4615)

def pellFiniteCertificate_4623 : PellFiniteCertificate 4623 (10^275) :=
  pellFiniteCertificateOfLight 4623 (10^275) 67 258 (pellEmptyMatchingCertificate 4623) (by
    change pellLightFiniteCheck 4623 67 (10^275) 258 PellLightProduction.magnitudes_4623 = true
    exact PellLightProduction.checked_4623)

def pellFiniteCertificate_4631 : PellFiniteCertificate 4631 (10^275) :=
  pellFiniteCertificateOfLight 4631 (10^275) 68 422 (pellEmptyMatchingCertificate 4631) (by
    change pellLightFiniteCheck 4631 68 (10^275) 422 PellLightProduction.magnitudes_4631 = true
    exact PellLightProduction.checked_4631)

def pellFiniteCertificate_4639 : PellFiniteCertificate 4639 (10^275) :=
  pellFiniteCertificateOfLight 4639 (10^275) 68 504 pellGraphCertificate_4639 (by
    change pellLightFiniteCheck 4639 68 (10^275) 504 PellLightProduction.magnitudes_4639 = true
    exact PellLightProduction.checked_4639)

def pellFiniteCertificate_4647 : PellFiniteCertificate 4647 (10^275) :=
  pellFiniteCertificateOfLight 4647 (10^275) 68 599 (pellEmptyMatchingCertificate 4647) (by
    change pellLightFiniteCheck 4647 68 (10^275) 599 PellLightProduction.magnitudes_4647 = true
    exact PellLightProduction.checked_4647)

def pellFiniteCertificate_4663 : PellFiniteCertificate 4663 (10^275) :=
  pellFiniteCertificateOfLight 4663 (10^275) 68 536 pellGraphCertificate_4663 (by
    change pellLightFiniteCheck 4663 68 (10^275) 536 PellLightProduction.magnitudes_4663 = true
    exact PellLightProduction.checked_4663)

def pellFiniteCertificate_4679 : PellFiniteCertificate 4679 (10^275) :=
  pellFiniteCertificateOfLight 4679 (10^275) 68 512 pellGraphCertificate_4679 (by
    change pellLightFiniteCheck 4679 68 (10^275) 512 PellLightProduction.magnitudes_4679 = true
    exact PellLightProduction.checked_4679)

def pellFiniteCertificate_4687 : PellFiniteCertificate 4687 (10^275) :=
  pellFiniteCertificateOfLight 4687 (10^275) 68 395 (pellEmptyMatchingCertificate 4687) (by
    change pellLightFiniteCheck 4687 68 (10^275) 395 PellLightProduction.magnitudes_4687 = true
    exact PellLightProduction.checked_4687)

def pellFiniteCertificate_4695 : PellFiniteCertificate 4695 (10^275) :=
  pellFiniteCertificateOfLight 4695 (10^275) 68 435 (pellEmptyMatchingCertificate 4695) (by
    change pellLightFiniteCheck 4695 68 (10^275) 435 PellLightProduction.magnitudes_4695 = true
    exact PellLightProduction.checked_4695)

def pellFiniteCertificate_4703 : PellFiniteCertificate 4703 (10^275) :=
  pellFiniteCertificateOfLight 4703 (10^275) 68 610 pellGraphCertificate_4703 (by
    change pellLightFiniteCheck 4703 68 (10^275) 610 PellLightProduction.magnitudes_4703 = true
    exact PellLightProduction.checked_4703)

def pellFiniteCertificate_4711 : PellFiniteCertificate 4711 (10^275) :=
  pellFiniteCertificateOfLight 4711 (10^275) 68 558 (pellEmptyMatchingCertificate 4711) (by
    change pellLightFiniteCheck 4711 68 (10^275) 558 PellLightProduction.magnitudes_4711 = true
    exact PellLightProduction.checked_4711)

def pellFiniteCertificate_4727 : PellFiniteCertificate 4727 (10^275) :=
  pellFiniteCertificateOfLight 4727 (10^275) 68 538 (pellEmptyMatchingCertificate 4727) (by
    change pellLightFiniteCheck 4727 68 (10^275) 538 PellLightProduction.magnitudes_4727 = true
    exact PellLightProduction.checked_4727)

def pellFiniteCertificate_4735 : PellFiniteCertificate 4735 (10^275) :=
  pellFiniteCertificateOfLight 4735 (10^275) 68 588 (pellEmptyMatchingCertificate 4735) (by
    change pellLightFiniteCheck 4735 68 (10^275) 588 PellLightProduction.magnitudes_4735 = true
    exact PellLightProduction.checked_4735)

def pellFiniteCertificate_4751 : PellFiniteCertificate 4751 (10^275) :=
  pellFiniteCertificateOfLight 4751 (10^275) 68 617 pellGraphCertificate_4751 (by
    change pellLightFiniteCheck 4751 68 (10^275) 617 PellLightProduction.magnitudes_4751 = true
    exact PellLightProduction.checked_4751)

def pellFiniteCertificate_4759 : PellFiniteCertificate 4759 (10^275) :=
  pellFiniteCertificateOfLight 4759 (10^275) 68 276 pellGraphCertificate_4759 (by
    change pellLightFiniteCheck 4759 68 (10^275) 276 PellLightProduction.magnitudes_4759 = true
    exact PellLightProduction.checked_4759)

def pellFiniteCertificate_4767 : PellFiniteCertificate 4767 (10^275) :=
  pellFiniteCertificateOfLight 4767 (10^275) 69 157 (pellEmptyMatchingCertificate 4767) (by
    change pellLightFiniteCheck 4767 69 (10^275) 157 PellLightProduction.magnitudes_4767 = true
    exact PellLightProduction.checked_4767)

def pellFiniteCertificate_4783 : PellFiniteCertificate 4783 (10^275) :=
  pellFiniteCertificateOfLight 4783 (10^275) 69 525 pellGraphCertificate_4783 (by
    change pellLightFiniteCheck 4783 69 (10^275) 525 PellLightProduction.magnitudes_4783 = true
    exact PellLightProduction.checked_4783)

def pellFiniteCertificate_4791 : PellFiniteCertificate 4791 (10^275) :=
  pellFiniteCertificateOfLight 4791 (10^275) 69 478 (pellEmptyMatchingCertificate 4791) (by
    change pellLightFiniteCheck 4791 69 (10^275) 478 PellLightProduction.magnitudes_4791 = true
    exact PellLightProduction.checked_4791)

def pellFiniteCertificate_4799 : PellFiniteCertificate 4799 (10^275) :=
  pellFiniteCertificateOfLight 4799 (10^275) 69 519 pellGraphCertificate_4799 (by
    change pellLightFiniteCheck 4799 69 (10^275) 519 PellLightProduction.magnitudes_4799 = true
    exact PellLightProduction.checked_4799)

def pellFiniteCertificate_4807 : PellFiniteCertificate 4807 (10^275) :=
  pellFiniteCertificateOfLight 4807 (10^275) 69 210 (pellEmptyMatchingCertificate 4807) (by
    change pellLightFiniteCheck 4807 69 (10^275) 210 PellLightProduction.magnitudes_4807 = true
    exact PellLightProduction.checked_4807)

def pellFiniteCertificate_4823 : PellFiniteCertificate 4823 (10^275) :=
  pellFiniteCertificateOfLight 4823 (10^275) 69 400 (pellEmptyMatchingCertificate 4823) (by
    change pellLightFiniteCheck 4823 69 (10^275) 400 PellLightProduction.magnitudes_4823 = true
    exact PellLightProduction.checked_4823)

def pellFiniteCertificate_4831 : PellFiniteCertificate 4831 (10^275) :=
  pellFiniteCertificateOfLight 4831 (10^275) 69 533 pellGraphCertificate_4831 (by
    change pellLightFiniteCheck 4831 69 (10^275) 533 PellLightProduction.magnitudes_4831 = true
    exact PellLightProduction.checked_4831)

def pellFiniteCertificate_4839 : PellFiniteCertificate 4839 (10^275) :=
  pellFiniteCertificateOfLight 4839 (10^275) 69 482 (pellEmptyMatchingCertificate 4839) (by
    change pellLightFiniteCheck 4839 69 (10^275) 482 PellLightProduction.magnitudes_4839 = true
    exact PellLightProduction.checked_4839)

def pellFiniteCertificate_4847 : PellFiniteCertificate 4847 (10^275) :=
  pellFiniteCertificateOfLight 4847 (10^275) 69 760 (pellEmptyMatchingCertificate 4847) (by
    change pellLightFiniteCheck 4847 69 (10^275) 760 PellLightProduction.magnitudes_4847 = true
    exact PellLightProduction.checked_4847)

def pellFiniteCertificate_4855 : PellFiniteCertificate 4855 (10^275) :=
  pellFiniteCertificateOfLight 4855 (10^275) 69 554 (pellEmptyMatchingCertificate 4855) (by
    change pellLightFiniteCheck 4855 69 (10^275) 554 PellLightProduction.magnitudes_4855 = true
    exact PellLightProduction.checked_4855)

def pellFiniteCertificate_4863 : PellFiniteCertificate 4863 (10^275) :=
  pellFiniteCertificateOfLight 4863 (10^275) 69 429 (pellEmptyMatchingCertificate 4863) (by
    change pellLightFiniteCheck 4863 69 (10^275) 429 PellLightProduction.magnitudes_4863 = true
    exact PellLightProduction.checked_4863)

def pellFiniteCertificate_4871 : PellFiniteCertificate 4871 (10^275) :=
  pellFiniteCertificateOfLight 4871 (10^275) 69 533 pellGraphCertificate_4871 (by
    change pellLightFiniteCheck 4871 69 (10^275) 533 PellLightProduction.magnitudes_4871 = true
    exact PellLightProduction.checked_4871)

def pellFiniteCertificate_4879 : PellFiniteCertificate 4879 (10^275) :=
  pellFiniteCertificateOfLight 4879 (10^275) 69 550 pellGraphCertificate_4879 (by
    change pellLightFiniteCheck 4879 69 (10^275) 550 PellLightProduction.magnitudes_4879 = true
    exact PellLightProduction.checked_4879)

def pellFiniteCertificate_4895 : PellFiniteCertificate 4895 (10^275) :=
  pellFiniteCertificateOfLight 4895 (10^275) 69 306 (pellEmptyMatchingCertificate 4895) (by
    change pellLightFiniteCheck 4895 69 (10^275) 306 PellLightProduction.magnitudes_4895 = true
    exact PellLightProduction.checked_4895)

def pellFiniteCertificate_4903 : PellFiniteCertificate 4903 (10^275) :=
  pellFiniteCertificateOfLight 4903 (10^275) 70 524 pellGraphCertificate_4903 (by
    change pellLightFiniteCheck 4903 70 (10^275) 524 PellLightProduction.magnitudes_4903 = true
    exact PellLightProduction.checked_4903)

def pellFiniteCertificate_4911 : PellFiniteCertificate 4911 (10^275) :=
  pellFiniteCertificateOfLight 4911 (10^275) 70 534 (pellEmptyMatchingCertificate 4911) (by
    change pellLightFiniteCheck 4911 70 (10^275) 534 PellLightProduction.magnitudes_4911 = true
    exact PellLightProduction.checked_4911)

def pellFiniteCertificate_4919 : PellFiniteCertificate 4919 (10^275) :=
  pellFiniteCertificateOfLight 4919 (10^275) 70 474 pellGraphCertificate_4919 (by
    change pellLightFiniteCheck 4919 70 (10^275) 474 PellLightProduction.magnitudes_4919 = true
    exact PellLightProduction.checked_4919)

def pellFiniteCertificate_4927 : PellFiniteCertificate 4927 (10^275) :=
  pellFiniteCertificateOfLight 4927 (10^275) 70 256 (pellEmptyMatchingCertificate 4927) (by
    change pellLightFiniteCheck 4927 70 (10^275) 256 PellLightProduction.magnitudes_4927 = true
    exact PellLightProduction.checked_4927)

def pellFiniteCertificate_4935 : PellFiniteCertificate 4935 (10^275) :=
  pellFiniteCertificateOfLight 4935 (10^275) 70 200 (pellEmptyMatchingCertificate 4935) (by
    change pellLightFiniteCheck 4935 70 (10^275) 200 PellLightProduction.magnitudes_4935 = true
    exact PellLightProduction.checked_4935)

def pellFiniteCertificate_4943 : PellFiniteCertificate 4943 (10^275) :=
  pellFiniteCertificateOfLight 4943 (10^275) 70 556 pellGraphCertificate_4943 (by
    change pellLightFiniteCheck 4943 70 (10^275) 556 PellLightProduction.magnitudes_4943 = true
    exact PellLightProduction.checked_4943)

def pellFiniteCertificate_4951 : PellFiniteCertificate 4951 (10^275) :=
  pellFiniteCertificateOfLight 4951 (10^275) 70 561 pellGraphCertificate_4951 (by
    change pellLightFiniteCheck 4951 70 (10^275) 561 PellLightProduction.magnitudes_4951 = true
    exact PellLightProduction.checked_4951)

def pellFiniteCertificate_4967 : PellFiniteCertificate 4967 (10^275) :=
  pellFiniteCertificateOfLight 4967 (10^275) 70 532 pellGraphCertificate_4967 (by
    change pellLightFiniteCheck 4967 70 (10^275) 532 PellLightProduction.magnitudes_4967 = true
    exact PellLightProduction.checked_4967)

def pellFiniteCertificate_4983 : PellFiniteCertificate 4983 (10^275) :=
  pellFiniteCertificateOfLight 4983 (10^275) 70 522 (pellEmptyMatchingCertificate 4983) (by
    change pellLightFiniteCheck 4983 70 (10^275) 522 PellLightProduction.magnitudes_4983 = true
    exact PellLightProduction.checked_4983)

def pellFiniteCertificate_4991 : PellFiniteCertificate 4991 (10^275) :=
  pellFiniteCertificateOfLight 4991 (10^275) 70 510 pellGraphCertificate_4991 (by
    change pellLightFiniteCheck 4991 70 (10^275) 510 PellLightProduction.magnitudes_4991 = true
    exact PellLightProduction.checked_4991)

def pellFiniteCertificate_4999 : PellFiniteCertificate 4999 (10^275) :=
  pellFiniteCertificateOfLight 4999 (10^275) 70 591 pellGraphCertificate_4999 (by
    change pellLightFiniteCheck 4999 70 (10^275) 591 PellLightProduction.magnitudes_4999 = true
    exact PellLightProduction.checked_4999)

def pellFiniteCertificate_5007 : PellFiniteCertificate 5007 (10^275) :=
  pellFiniteCertificateOfLight 5007 (10^275) 70 640 (pellEmptyMatchingCertificate 5007) (by
    change pellLightFiniteCheck 5007 70 (10^275) 640 PellLightProduction.magnitudes_5007 = true
    exact PellLightProduction.checked_5007)

def pellFiniteCertificate_5015 : PellFiniteCertificate 5015 (10^275) :=
  pellFiniteCertificateOfLight 5015 (10^275) 70 420 (pellEmptyMatchingCertificate 5015) (by
    change pellLightFiniteCheck 5015 70 (10^275) 420 PellLightProduction.magnitudes_5015 = true
    exact PellLightProduction.checked_5015)

def pellFiniteCertificate_5023 : PellFiniteCertificate 5023 (10^275) :=
  pellFiniteCertificateOfLight 5023 (10^275) 70 553 pellGraphCertificate_5023 (by
    change pellLightFiniteCheck 5023 70 (10^275) 553 PellLightProduction.magnitudes_5023 = true
    exact PellLightProduction.checked_5023)

def pellFiniteCertificate_5039 : PellFiniteCertificate 5039 (10^275) :=
  pellFiniteCertificateOfLight 5039 (10^275) 70 274 pellGraphCertificate_5039 (by
    change pellLightFiniteCheck 5039 70 (10^275) 274 PellLightProduction.magnitudes_5039 = true
    exact PellLightProduction.checked_5039)

def pellFiniteCertificate_5055 : PellFiniteCertificate 5055 (10^275) :=
  pellFiniteCertificateOfLight 5055 (10^275) 71 338 (pellEmptyMatchingCertificate 5055) (by
    change pellLightFiniteCheck 5055 71 (10^275) 338 PellLightProduction.magnitudes_5055 = true
    exact PellLightProduction.checked_5055)

def pellFiniteCertificate_5063 : PellFiniteCertificate 5063 (10^275) :=
  pellFiniteCertificateOfLight 5063 (10^275) 71 268 (pellEmptyMatchingCertificate 5063) (by
    change pellLightFiniteCheck 5063 71 (10^275) 268 PellLightProduction.magnitudes_5063 = true
    exact PellLightProduction.checked_5063)

def pellFiniteCertificate_5071 : PellFiniteCertificate 5071 (10^275) :=
  pellFiniteCertificateOfLight 5071 (10^275) 71 497 (pellEmptyMatchingCertificate 5071) (by
    change pellLightFiniteCheck 5071 71 (10^275) 497 PellLightProduction.magnitudes_5071 = true
    exact PellLightProduction.checked_5071)

def pellFiniteCertificate_5079 : PellFiniteCertificate 5079 (10^275) :=
  pellFiniteCertificateOfLight 5079 (10^275) 71 586 (pellEmptyMatchingCertificate 5079) (by
    change pellLightFiniteCheck 5079 71 (10^275) 586 PellLightProduction.magnitudes_5079 = true
    exact PellLightProduction.checked_5079)

def pellFiniteCertificate_5087 : PellFiniteCertificate 5087 (10^275) :=
  pellFiniteCertificateOfLight 5087 (10^275) 71 448 pellGraphCertificate_5087 (by
    change pellLightFiniteCheck 5087 71 (10^275) 448 PellLightProduction.magnitudes_5087 = true
    exact PellLightProduction.checked_5087)

def pellFiniteCertificate_5095 : PellFiniteCertificate 5095 (10^275) :=
  pellFiniteCertificateOfLight 5095 (10^275) 71 504 (pellEmptyMatchingCertificate 5095) (by
    change pellLightFiniteCheck 5095 71 (10^275) 504 PellLightProduction.magnitudes_5095 = true
    exact PellLightProduction.checked_5095)

def pellFiniteCertificate_5111 : PellFiniteCertificate 5111 (10^275) :=
  pellFiniteCertificateOfLight 5111 (10^275) 71 485 (pellEmptyMatchingCertificate 5111) (by
    change pellLightFiniteCheck 5111 71 (10^275) 485 PellLightProduction.magnitudes_5111 = true
    exact PellLightProduction.checked_5111)

def pellFiniteCertificate_5119 : PellFiniteCertificate 5119 (10^275) :=
  pellFiniteCertificateOfLight 5119 (10^275) 71 574 pellGraphCertificate_5119 (by
    change pellLightFiniteCheck 5119 71 (10^275) 574 PellLightProduction.magnitudes_5119 = true
    exact PellLightProduction.checked_5119)

def pellFiniteCertificate_5127 : PellFiniteCertificate 5127 (10^275) :=
  pellFiniteCertificateOfLight 5127 (10^275) 71 585 (pellEmptyMatchingCertificate 5127) (by
    change pellLightFiniteCheck 5127 71 (10^275) 585 PellLightProduction.magnitudes_5127 = true
    exact PellLightProduction.checked_5127)

def pellFiniteCertificate_5135 : PellFiniteCertificate 5135 (10^275) :=
  pellFiniteCertificateOfLight 5135 (10^275) 71 514 (pellEmptyMatchingCertificate 5135) (by
    change pellLightFiniteCheck 5135 71 (10^275) 514 PellLightProduction.magnitudes_5135 = true
    exact PellLightProduction.checked_5135)

def pellFiniteCertificate_5143 : PellFiniteCertificate 5143 (10^275) :=
  pellFiniteCertificateOfLight 5143 (10^275) 71 427 (pellEmptyMatchingCertificate 5143) (by
    change pellLightFiniteCheck 5143 71 (10^275) 427 PellLightProduction.magnitudes_5143 = true
    exact PellLightProduction.checked_5143)

def pellFiniteCertificate_5151 : PellFiniteCertificate 5151 (10^275) :=
  pellFiniteCertificateOfLight 5151 (10^275) 71 527 (pellEmptyMatchingCertificate 5151) (by
    change pellLightFiniteCheck 5151 71 (10^275) 527 PellLightProduction.magnitudes_5151 = true
    exact PellLightProduction.checked_5151)

def pellFiniteCertificate_5159 : PellFiniteCertificate 5159 (10^275) :=
  pellFiniteCertificateOfLight 5159 (10^275) 71 442 (pellEmptyMatchingCertificate 5159) (by
    change pellLightFiniteCheck 5159 71 (10^275) 442 PellLightProduction.magnitudes_5159 = true
    exact PellLightProduction.checked_5159)

def pellFiniteCertificate_5167 : PellFiniteCertificate 5167 (10^275) :=
  pellFiniteCertificateOfLight 5167 (10^275) 71 472 pellGraphCertificate_5167 (by
    change pellLightFiniteCheck 5167 71 (10^275) 472 PellLightProduction.magnitudes_5167 = true
    exact PellLightProduction.checked_5167)

def pellFiniteCertificate_5183 : PellFiniteCertificate 5183 (10^275) :=
  pellFiniteCertificateOfLight 5183 (10^275) 71 254 (pellEmptyMatchingCertificate 5183) (by
    change pellLightFiniteCheck 5183 71 (10^275) 254 PellLightProduction.magnitudes_5183 = true
    exact PellLightProduction.checked_5183)

def pellFiniteCertificate_5191 : PellFiniteCertificate 5191 (10^275) :=
  pellFiniteCertificateOfLight 5191 (10^275) 72 558 (pellEmptyMatchingCertificate 5191) (by
    change pellLightFiniteCheck 5191 72 (10^275) 558 PellLightProduction.magnitudes_5191 = true
    exact PellLightProduction.checked_5191)

def pellFiniteCertificate_5199 : PellFiniteCertificate 5199 (10^275) :=
  pellFiniteCertificateOfLight 5199 (10^275) 72 475 (pellEmptyMatchingCertificate 5199) (by
    change pellLightFiniteCheck 5199 72 (10^275) 475 PellLightProduction.magnitudes_5199 = true
    exact PellLightProduction.checked_5199)

def pellFiniteCertificate_5207 : PellFiniteCertificate 5207 (10^275) :=
  pellFiniteCertificateOfLight 5207 (10^275) 72 400 (pellEmptyMatchingCertificate 5207) (by
    change pellLightFiniteCheck 5207 72 (10^275) 400 PellLightProduction.magnitudes_5207 = true
    exact PellLightProduction.checked_5207)

def pellFiniteCertificate_5215 : PellFiniteCertificate 5215 (10^275) :=
  pellFiniteCertificateOfLight 5215 (10^275) 72 450 (pellEmptyMatchingCertificate 5215) (by
    change pellLightFiniteCheck 5215 72 (10^275) 450 PellLightProduction.magnitudes_5215 = true
    exact PellLightProduction.checked_5215)

def pellFiniteCertificate_5223 : PellFiniteCertificate 5223 (10^275) :=
  pellFiniteCertificateOfLight 5223 (10^275) 72 462 (pellEmptyMatchingCertificate 5223) (by
    change pellLightFiniteCheck 5223 72 (10^275) 462 PellLightProduction.magnitudes_5223 = true
    exact PellLightProduction.checked_5223)

def pellFiniteCertificate_5231 : PellFiniteCertificate 5231 (10^275) :=
  pellFiniteCertificateOfLight 5231 (10^275) 72 507 pellGraphCertificate_5231 (by
    change pellLightFiniteCheck 5231 72 (10^275) 507 PellLightProduction.magnitudes_5231 = true
    exact PellLightProduction.checked_5231)

def pellFiniteCertificate_5255 : PellFiniteCertificate 5255 (10^275) :=
  pellFiniteCertificateOfLight 5255 (10^275) 72 260 (pellEmptyMatchingCertificate 5255) (by
    change pellLightFiniteCheck 5255 72 (10^275) 260 PellLightProduction.magnitudes_5255 = true
    exact PellLightProduction.checked_5255)

def pellFiniteCertificate_5263 : PellFiniteCertificate 5263 (10^275) :=
  pellFiniteCertificateOfLight 5263 (10^275) 72 535 (pellEmptyMatchingCertificate 5263) (by
    change pellLightFiniteCheck 5263 72 (10^275) 535 PellLightProduction.magnitudes_5263 = true
    exact PellLightProduction.checked_5263)

def pellFiniteCertificate_5271 : PellFiniteCertificate 5271 (10^275) :=
  pellFiniteCertificateOfLight 5271 (10^275) 72 555 (pellEmptyMatchingCertificate 5271) (by
    change pellLightFiniteCheck 5271 72 (10^275) 555 PellLightProduction.magnitudes_5271 = true
    exact PellLightProduction.checked_5271)

def pellFiniteCertificate_5279 : PellFiniteCertificate 5279 (10^275) :=
  pellFiniteCertificateOfLight 5279 (10^275) 72 556 pellGraphCertificate_5279 (by
    change pellLightFiniteCheck 5279 72 (10^275) 556 PellLightProduction.magnitudes_5279 = true
    exact PellLightProduction.checked_5279)

def pellFiniteCertificate_5287 : PellFiniteCertificate 5287 (10^275) :=
  pellFiniteCertificateOfLight 5287 (10^275) 72 532 pellGraphCertificate_5287 (by
    change pellLightFiniteCheck 5287 72 (10^275) 532 PellLightProduction.magnitudes_5287 = true
    exact PellLightProduction.checked_5287)

def pellFiniteCertificate_5295 : PellFiniteCertificate 5295 (10^275) :=
  pellFiniteCertificateOfLight 5295 (10^275) 72 476 (pellEmptyMatchingCertificate 5295) (by
    change pellLightFiniteCheck 5295 72 (10^275) 476 PellLightProduction.magnitudes_5295 = true
    exact PellLightProduction.checked_5295)

def pellFiniteCertificate_5303 : PellFiniteCertificate 5303 (10^275) :=
  pellFiniteCertificateOfLight 5303 (10^275) 72 530 pellGraphCertificate_5303 (by
    change pellLightFiniteCheck 5303 72 (10^275) 530 PellLightProduction.magnitudes_5303 = true
    exact PellLightProduction.checked_5303)

def pellFiniteCertificate_5311 : PellFiniteCertificate 5311 (10^275) :=
  pellFiniteCertificateOfLight 5311 (10^275) 72 487 pellGraphCertificate_5311 (by
    change pellLightFiniteCheck 5311 72 (10^275) 487 PellLightProduction.magnitudes_5311 = true
    exact PellLightProduction.checked_5311)

def pellFiniteCertificate_5327 : PellFiniteCertificate 5327 (10^275) :=
  pellFiniteCertificateOfLight 5327 (10^275) 72 272 pellGraphCertificate_5327 (by
    change pellLightFiniteCheck 5327 72 (10^275) 272 PellLightProduction.magnitudes_5327 = true
    exact PellLightProduction.checked_5327)

def pellFiniteCertificate_5335 : PellFiniteCertificate 5335 (10^275) :=
  pellFiniteCertificateOfLight 5335 (10^275) 73 493 (pellEmptyMatchingCertificate 5335) (by
    change pellLightFiniteCheck 5335 73 (10^275) 493 PellLightProduction.magnitudes_5335 = true
    exact PellLightProduction.checked_5335)

def pellFiniteCertificate_5343 : PellFiniteCertificate 5343 (10^275) :=
  pellFiniteCertificateOfLight 5343 (10^275) 73 399 (pellEmptyMatchingCertificate 5343) (by
    change pellLightFiniteCheck 5343 73 (10^275) 399 PellLightProduction.magnitudes_5343 = true
    exact PellLightProduction.checked_5343)

def pellFiniteCertificate_5351 : PellFiniteCertificate 5351 (10^275) :=
  pellFiniteCertificateOfLight 5351 (10^275) 73 458 pellGraphCertificate_5351 (by
    change pellLightFiniteCheck 5351 73 (10^275) 458 PellLightProduction.magnitudes_5351 = true
    exact PellLightProduction.checked_5351)

def pellFiniteCertificate_5359 : PellFiniteCertificate 5359 (10^275) :=
  pellFiniteCertificateOfLight 5359 (10^275) 73 520 (pellEmptyMatchingCertificate 5359) (by
    change pellLightFiniteCheck 5359 73 (10^275) 520 PellLightProduction.magnitudes_5359 = true
    exact PellLightProduction.checked_5359)

def pellFiniteCertificate_5367 : PellFiniteCertificate 5367 (10^275) :=
  pellFiniteCertificateOfLight 5367 (10^275) 73 598 (pellEmptyMatchingCertificate 5367) (by
    change pellLightFiniteCheck 5367 73 (10^275) 598 PellLightProduction.magnitudes_5367 = true
    exact PellLightProduction.checked_5367)

def pellFiniteCertificate_5383 : PellFiniteCertificate 5383 (10^275) :=
  pellFiniteCertificateOfLight 5383 (10^275) 73 408 pellGraphCertificate_5383 (by
    change pellLightFiniteCheck 5383 73 (10^275) 408 PellLightProduction.magnitudes_5383 = true
    exact PellLightProduction.checked_5383)

def pellFiniteCertificate_5399 : PellFiniteCertificate 5399 (10^275) :=
  pellFiniteCertificateOfLight 5399 (10^275) 73 505 pellGraphCertificate_5399 (by
    change pellLightFiniteCheck 5399 73 (10^275) 505 PellLightProduction.magnitudes_5399 = true
    exact PellLightProduction.checked_5399)

def pellFiniteCertificate_5407 : PellFiniteCertificate 5407 (10^275) :=
  pellFiniteCertificateOfLight 5407 (10^275) 73 529 pellGraphCertificate_5407 (by
    change pellLightFiniteCheck 5407 73 (10^275) 529 PellLightProduction.magnitudes_5407 = true
    exact PellLightProduction.checked_5407)

def pellFiniteCertificate_5423 : PellFiniteCertificate 5423 (10^275) :=
  pellFiniteCertificateOfLight 5423 (10^275) 73 584 (pellEmptyMatchingCertificate 5423) (by
    change pellLightFiniteCheck 5423 73 (10^275) 584 PellLightProduction.magnitudes_5423 = true
    exact PellLightProduction.checked_5423)

def pellFiniteCertificate_5431 : PellFiniteCertificate 5431 (10^275) :=
  pellFiniteCertificateOfLight 5431 (10^275) 73 522 pellGraphCertificate_5431 (by
    change pellLightFiniteCheck 5431 73 (10^275) 522 PellLightProduction.magnitudes_5431 = true
    exact PellLightProduction.checked_5431)

def pellFiniteCertificate_5447 : PellFiniteCertificate 5447 (10^275) :=
  pellFiniteCertificateOfLight 5447 (10^275) 73 432 (pellEmptyMatchingCertificate 5447) (by
    change pellLightFiniteCheck 5447 73 (10^275) 432 PellLightProduction.magnitudes_5447 = true
    exact PellLightProduction.checked_5447)

def pellFiniteCertificate_5455 : PellFiniteCertificate 5455 (10^275) :=
  pellFiniteCertificateOfLight 5455 (10^275) 73 522 (pellEmptyMatchingCertificate 5455) (by
    change pellLightFiniteCheck 5455 73 (10^275) 522 PellLightProduction.magnitudes_5455 = true
    exact PellLightProduction.checked_5455)

def pellFiniteCertificate_5471 : PellFiniteCertificate 5471 (10^275) :=
  pellFiniteCertificateOfLight 5471 (10^275) 73 545 pellGraphCertificate_5471 (by
    change pellLightFiniteCheck 5471 73 (10^275) 545 PellLightProduction.magnitudes_5471 = true
    exact PellLightProduction.checked_5471)

def pellFiniteCertificate_5479 : PellFiniteCertificate 5479 (10^275) :=
  pellFiniteCertificateOfLight 5479 (10^275) 74 493 pellGraphCertificate_5479 (by
    change pellLightFiniteCheck 5479 74 (10^275) 493 PellLightProduction.magnitudes_5479 = true
    exact PellLightProduction.checked_5479)

def pellFiniteCertificate_5487 : PellFiniteCertificate 5487 (10^275) :=
  pellFiniteCertificateOfLight 5487 (10^275) 74 340 (pellEmptyMatchingCertificate 5487) (by
    change pellLightFiniteCheck 5487 74 (10^275) 340 PellLightProduction.magnitudes_5487 = true
    exact PellLightProduction.checked_5487)

def pellFiniteCertificate_5495 : PellFiniteCertificate 5495 (10^275) :=
  pellFiniteCertificateOfLight 5495 (10^275) 74 430 (pellEmptyMatchingCertificate 5495) (by
    change pellLightFiniteCheck 5495 74 (10^275) 430 PellLightProduction.magnitudes_5495 = true
    exact PellLightProduction.checked_5495)

def pellFiniteCertificate_5503 : PellFiniteCertificate 5503 (10^275) :=
  pellFiniteCertificateOfLight 5503 (10^275) 74 514 pellGraphCertificate_5503 (by
    change pellLightFiniteCheck 5503 74 (10^275) 514 PellLightProduction.magnitudes_5503 = true
    exact PellLightProduction.checked_5503)

def pellFiniteCertificate_5511 : PellFiniteCertificate 5511 (10^275) :=
  pellFiniteCertificateOfLight 5511 (10^275) 74 272 (pellEmptyMatchingCertificate 5511) (by
    change pellLightFiniteCheck 5511 74 (10^275) 272 PellLightProduction.magnitudes_5511 = true
    exact PellLightProduction.checked_5511)

def pellFiniteCertificate_5519 : PellFiniteCertificate 5519 (10^275) :=
  pellFiniteCertificateOfLight 5519 (10^275) 74 486 pellGraphCertificate_5519 (by
    change pellLightFiniteCheck 5519 74 (10^275) 486 PellLightProduction.magnitudes_5519 = true
    exact PellLightProduction.checked_5519)

def pellFiniteCertificate_5527 : PellFiniteCertificate 5527 (10^275) :=
  pellFiniteCertificateOfLight 5527 (10^275) 74 411 pellGraphCertificate_5527 (by
    change pellLightFiniteCheck 5527 74 (10^275) 411 PellLightProduction.magnitudes_5527 = true
    exact PellLightProduction.checked_5527)

def pellFiniteCertificate_5543 : PellFiniteCertificate 5543 (10^275) :=
  pellFiniteCertificateOfLight 5543 (10^275) 74 538 pellGraphCertificate_5543 (by
    change pellLightFiniteCheck 5543 74 (10^275) 538 PellLightProduction.magnitudes_5543 = true
    exact PellLightProduction.checked_5543)

def pellFiniteCertificate_5551 : PellFiniteCertificate 5551 (10^275) :=
  pellFiniteCertificateOfLight 5551 (10^275) 74 540 (pellEmptyMatchingCertificate 5551) (by
    change pellLightFiniteCheck 5551 74 (10^275) 540 PellLightProduction.magnitudes_5551 = true
    exact PellLightProduction.checked_5551)

def pellFiniteCertificate_5559 : PellFiniteCertificate 5559 (10^275) :=
  pellFiniteCertificateOfLight 5559 (10^275) 74 575 (pellEmptyMatchingCertificate 5559) (by
    change pellLightFiniteCheck 5559 74 (10^275) 575 PellLightProduction.magnitudes_5559 = true
    exact PellLightProduction.checked_5559)

def pellFiniteCertificate_5567 : PellFiniteCertificate 5567 (10^275) :=
  pellFiniteCertificateOfLight 5567 (10^275) 74 622 (pellEmptyMatchingCertificate 5567) (by
    change pellLightFiniteCheck 5567 74 (10^275) 622 PellLightProduction.magnitudes_5567 = true
    exact PellLightProduction.checked_5567)

def pellFiniteCertificate_5583 : PellFiniteCertificate 5583 (10^275) :=
  pellFiniteCertificateOfLight 5583 (10^275) 74 598 (pellEmptyMatchingCertificate 5583) (by
    change pellLightFiniteCheck 5583 74 (10^275) 598 PellLightProduction.magnitudes_5583 = true
    exact PellLightProduction.checked_5583)

def pellFiniteCertificate_5591 : PellFiniteCertificate 5591 (10^275) :=
  pellFiniteCertificateOfLight 5591 (10^275) 74 540 pellGraphCertificate_5591 (by
    change pellLightFiniteCheck 5591 74 (10^275) 540 PellLightProduction.magnitudes_5591 = true
    exact PellLightProduction.checked_5591)

def pellFiniteCertificate_5599 : PellFiniteCertificate 5599 (10^275) :=
  pellFiniteCertificateOfLight 5599 (10^275) 74 545 (pellEmptyMatchingCertificate 5599) (by
    change pellLightFiniteCheck 5599 74 (10^275) 545 PellLightProduction.magnitudes_5599 = true
    exact PellLightProduction.checked_5599)

def pellFiniteCertificate_5615 : PellFiniteCertificate 5615 (10^275) :=
  pellFiniteCertificateOfLight 5615 (10^275) 74 328 (pellEmptyMatchingCertificate 5615) (by
    change pellLightFiniteCheck 5615 74 (10^275) 328 PellLightProduction.magnitudes_5615 = true
    exact PellLightProduction.checked_5615)

def pellFiniteCertificate_5623 : PellFiniteCertificate 5623 (10^275) :=
  pellFiniteCertificateOfLight 5623 (10^275) 74 270 pellGraphCertificate_5623 (by
    change pellLightFiniteCheck 5623 74 (10^275) 270 PellLightProduction.magnitudes_5623 = true
    exact PellLightProduction.checked_5623)

def pellFiniteCertificate_5631 : PellFiniteCertificate 5631 (10^275) :=
  pellFiniteCertificateOfLight 5631 (10^275) 75 154 (pellEmptyMatchingCertificate 5631) (by
    change pellLightFiniteCheck 5631 75 (10^275) 154 PellLightProduction.magnitudes_5631 = true
    exact PellLightProduction.checked_5631)

def pellFiniteCertificate_5639 : PellFiniteCertificate 5639 (10^275) :=
  pellFiniteCertificateOfLight 5639 (10^275) 75 508 pellGraphCertificate_5639 (by
    change pellLightFiniteCheck 5639 75 (10^275) 508 PellLightProduction.magnitudes_5639 = true
    exact PellLightProduction.checked_5639)

def pellFiniteCertificate_5647 : PellFiniteCertificate 5647 (10^275) :=
  pellFiniteCertificateOfLight 5647 (10^275) 75 570 pellGraphCertificate_5647 (by
    change pellLightFiniteCheck 5647 75 (10^275) 570 PellLightProduction.magnitudes_5647 = true
    exact PellLightProduction.checked_5647)

def pellFiniteCertificate_5655 : PellFiniteCertificate 5655 (10^275) :=
  pellFiniteCertificateOfLight 5655 (10^275) 75 190 (pellEmptyMatchingCertificate 5655) (by
    change pellLightFiniteCheck 5655 75 (10^275) 190 PellLightProduction.magnitudes_5655 = true
    exact PellLightProduction.checked_5655)

def pellFiniteCertificate_5663 : PellFiniteCertificate 5663 (10^275) :=
  pellFiniteCertificateOfLight 5663 (10^275) 75 348 (pellEmptyMatchingCertificate 5663) (by
    change pellLightFiniteCheck 5663 75 (10^275) 348 PellLightProduction.magnitudes_5663 = true
    exact PellLightProduction.checked_5663)

def pellFiniteCertificate_5671 : PellFiniteCertificate 5671 (10^275) :=
  pellFiniteCertificateOfLight 5671 (10^275) 75 549 (pellEmptyMatchingCertificate 5671) (by
    change pellLightFiniteCheck 5671 75 (10^275) 549 PellLightProduction.magnitudes_5671 = true
    exact PellLightProduction.checked_5671)

def pellFiniteCertificate_5695 : PellFiniteCertificate 5695 (10^275) :=
  pellFiniteCertificateOfLight 5695 (10^275) 75 527 (pellEmptyMatchingCertificate 5695) (by
    change pellLightFiniteCheck 5695 75 (10^275) 527 PellLightProduction.magnitudes_5695 = true
    exact PellLightProduction.checked_5695)

def pellFiniteCertificate_5703 : PellFiniteCertificate 5703 (10^275) :=
  pellFiniteCertificateOfLight 5703 (10^275) 75 484 (pellEmptyMatchingCertificate 5703) (by
    change pellLightFiniteCheck 5703 75 (10^275) 484 PellLightProduction.magnitudes_5703 = true
    exact PellLightProduction.checked_5703)

def pellFiniteCertificate_5711 : PellFiniteCertificate 5711 (10^275) :=
  pellFiniteCertificateOfLight 5711 (10^275) 75 381 pellGraphCertificate_5711 (by
    change pellLightFiniteCheck 5711 75 (10^275) 381 PellLightProduction.magnitudes_5711 = true
    exact PellLightProduction.checked_5711)

def pellFiniteCertificate_5719 : PellFiniteCertificate 5719 (10^275) :=
  pellFiniteCertificateOfLight 5719 (10^275) 75 550 (pellEmptyMatchingCertificate 5719) (by
    change pellLightFiniteCheck 5719 75 (10^275) 550 PellLightProduction.magnitudes_5719 = true
    exact PellLightProduction.checked_5719)

def pellFiniteCertificate_5727 : PellFiniteCertificate 5727 (10^275) :=
  pellFiniteCertificateOfLight 5727 (10^275) 75 400 (pellEmptyMatchingCertificate 5727) (by
    change pellLightFiniteCheck 5727 75 (10^275) 400 PellLightProduction.magnitudes_5727 = true
    exact PellLightProduction.checked_5727)

def pellFiniteCertificate_5735 : PellFiniteCertificate 5735 (10^275) :=
  pellFiniteCertificateOfLight 5735 (10^275) 75 501 (pellEmptyMatchingCertificate 5735) (by
    change pellLightFiniteCheck 5735 75 (10^275) 501 PellLightProduction.magnitudes_5735 = true
    exact PellLightProduction.checked_5735)

def pellFiniteCertificate_5743 : PellFiniteCertificate 5743 (10^275) :=
  pellFiniteCertificateOfLight 5743 (10^275) 75 486 pellGraphCertificate_5743 (by
    change pellLightFiniteCheck 5743 75 (10^275) 486 PellLightProduction.magnitudes_5743 = true
    exact PellLightProduction.checked_5743)

def pellFiniteCertificate_5759 : PellFiniteCertificate 5759 (10^275) :=
  pellFiniteCertificateOfLight 5759 (10^275) 75 442 (pellEmptyMatchingCertificate 5759) (by
    change pellLightFiniteCheck 5759 75 (10^275) 442 PellLightProduction.magnitudes_5759 = true
    exact PellLightProduction.checked_5759)

def pellFiniteCertificate_5767 : PellFiniteCertificate 5767 (10^275) :=
  pellFiniteCertificateOfLight 5767 (10^275) 75 366 pellGraphCertificate_5767 (by
    change pellLightFiniteCheck 5767 75 (10^275) 366 PellLightProduction.magnitudes_5767 = true
    exact PellLightProduction.checked_5767)

def pellFiniteCertificate_5783 : PellFiniteCertificate 5783 (10^275) :=
  pellFiniteCertificateOfLight 5783 (10^275) 76 571 pellGraphCertificate_5783 (by
    change pellLightFiniteCheck 5783 76 (10^275) 571 PellLightProduction.magnitudes_5783 = true
    exact PellLightProduction.checked_5783)

def pellFiniteCertificate_5791 : PellFiniteCertificate 5791 (10^275) :=
  pellFiniteCertificateOfLight 5791 (10^275) 76 541 pellGraphCertificate_5791 (by
    change pellLightFiniteCheck 5791 76 (10^275) 541 PellLightProduction.magnitudes_5791 = true
    exact PellLightProduction.checked_5791)

def pellFiniteCertificate_5799 : PellFiniteCertificate 5799 (10^275) :=
  pellFiniteCertificateOfLight 5799 (10^275) 76 496 (pellEmptyMatchingCertificate 5799) (by
    change pellLightFiniteCheck 5799 76 (10^275) 496 PellLightProduction.magnitudes_5799 = true
    exact PellLightProduction.checked_5799)

def pellFiniteCertificate_5807 : PellFiniteCertificate 5807 (10^275) :=
  pellFiniteCertificateOfLight 5807 (10^275) 76 510 pellGraphCertificate_5807 (by
    change pellLightFiniteCheck 5807 76 (10^275) 510 PellLightProduction.magnitudes_5807 = true
    exact PellLightProduction.checked_5807)

def pellFiniteCertificate_5815 : PellFiniteCertificate 5815 (10^275) :=
  pellFiniteCertificateOfLight 5815 (10^275) 76 509 (pellEmptyMatchingCertificate 5815) (by
    change pellLightFiniteCheck 5815 76 (10^275) 509 PellLightProduction.magnitudes_5815 = true
    exact PellLightProduction.checked_5815)

def pellFiniteCertificate_5839 : PellFiniteCertificate 5839 (10^275) :=
  pellFiniteCertificateOfLight 5839 (10^275) 76 561 pellGraphCertificate_5839 (by
    change pellLightFiniteCheck 5839 76 (10^275) 561 PellLightProduction.magnitudes_5839 = true
    exact PellLightProduction.checked_5839)

def pellFiniteCertificate_5847 : PellFiniteCertificate 5847 (10^275) :=
  pellFiniteCertificateOfLight 5847 (10^275) 76 510 (pellEmptyMatchingCertificate 5847) (by
    change pellLightFiniteCheck 5847 76 (10^275) 510 PellLightProduction.magnitudes_5847 = true
    exact PellLightProduction.checked_5847)

def pellFiniteCertificate_5855 : PellFiniteCertificate 5855 (10^275) :=
  pellFiniteCertificateOfLight 5855 (10^275) 76 436 (pellEmptyMatchingCertificate 5855) (by
    change pellLightFiniteCheck 5855 76 (10^275) 436 PellLightProduction.magnitudes_5855 = true
    exact PellLightProduction.checked_5855)

def pellFiniteCertificate_5863 : PellFiniteCertificate 5863 (10^275) :=
  pellFiniteCertificateOfLight 5863 (10^275) 76 649 (pellEmptyMatchingCertificate 5863) (by
    change pellLightFiniteCheck 5863 76 (10^275) 649 PellLightProduction.magnitudes_5863 = true
    exact PellLightProduction.checked_5863)

def pellFiniteCertificate_5871 : PellFiniteCertificate 5871 (10^275) :=
  pellFiniteCertificateOfLight 5871 (10^275) 76 628 (pellEmptyMatchingCertificate 5871) (by
    change pellLightFiniteCheck 5871 76 (10^275) 628 PellLightProduction.magnitudes_5871 = true
    exact PellLightProduction.checked_5871)

def pellFiniteCertificate_5879 : PellFiniteCertificate 5879 (10^275) :=
  pellFiniteCertificateOfLight 5879 (10^275) 76 573 pellGraphCertificate_5879 (by
    change pellLightFiniteCheck 5879 76 (10^275) 573 PellLightProduction.magnitudes_5879 = true
    exact PellLightProduction.checked_5879)

def pellFiniteCertificate_5903 : PellFiniteCertificate 5903 (10^275) :=
  pellFiniteCertificateOfLight 5903 (10^275) 76 424 pellGraphCertificate_5903 (by
    change pellLightFiniteCheck 5903 76 (10^275) 424 PellLightProduction.magnitudes_5903 = true
    exact PellLightProduction.checked_5903)

def pellFiniteCertificate_5911 : PellFiniteCertificate 5911 (10^275) :=
  pellFiniteCertificateOfLight 5911 (10^275) 76 545 (pellEmptyMatchingCertificate 5911) (by
    change pellLightFiniteCheck 5911 76 (10^275) 545 PellLightProduction.magnitudes_5911 = true
    exact PellLightProduction.checked_5911)

def pellFiniteCertificate_5919 : PellFiniteCertificate 5919 (10^275) :=
  pellFiniteCertificateOfLight 5919 (10^275) 76 482 (pellEmptyMatchingCertificate 5919) (by
    change pellLightFiniteCheck 5919 76 (10^275) 482 PellLightProduction.magnitudes_5919 = true
    exact PellLightProduction.checked_5919)

def pellFiniteCertificate_5927 : PellFiniteCertificate 5927 (10^275) :=
  pellFiniteCertificateOfLight 5927 (10^275) 76 270 pellGraphCertificate_5927 (by
    change pellLightFiniteCheck 5927 76 (10^275) 270 PellLightProduction.magnitudes_5927 = true
    exact PellLightProduction.checked_5927)

def pellFiniteCertificate_5935 : PellFiniteCertificate 5935 (10^275) :=
  pellFiniteCertificateOfLight 5935 (10^275) 77 541 (pellEmptyMatchingCertificate 5935) (by
    change pellLightFiniteCheck 5935 77 (10^275) 541 PellLightProduction.magnitudes_5935 = true
    exact PellLightProduction.checked_5935)

def pellFiniteCertificate_5943 : PellFiniteCertificate 5943 (10^275) :=
  pellFiniteCertificateOfLight 5943 (10^275) 77 170 (pellEmptyMatchingCertificate 5943) (by
    change pellLightFiniteCheck 5943 77 (10^275) 170 PellLightProduction.magnitudes_5943 = true
    exact PellLightProduction.checked_5943)

def pellFiniteCertificate_5951 : PellFiniteCertificate 5951 (10^275) :=
  pellFiniteCertificateOfLight 5951 (10^275) 77 181 (pellEmptyMatchingCertificate 5951) (by
    change pellLightFiniteCheck 5951 77 (10^275) 181 PellLightProduction.magnitudes_5951 = true
    exact PellLightProduction.checked_5951)

def pellFiniteCertificate_5959 : PellFiniteCertificate 5959 (10^275) :=
  pellFiniteCertificateOfLight 5959 (10^275) 77 485 (pellEmptyMatchingCertificate 5959) (by
    change pellLightFiniteCheck 5959 77 (10^275) 485 PellLightProduction.magnitudes_5959 = true
    exact PellLightProduction.checked_5959)

def pellFiniteCertificate_5983 : PellFiniteCertificate 5983 (10^275) :=
  pellFiniteCertificateOfLight 5983 (10^275) 77 421 (pellEmptyMatchingCertificate 5983) (by
    change pellLightFiniteCheck 5983 77 (10^275) 421 PellLightProduction.magnitudes_5983 = true
    exact PellLightProduction.checked_5983)

def pellFiniteCertificate_5991 : PellFiniteCertificate 5991 (10^275) :=
  pellFiniteCertificateOfLight 5991 (10^275) 77 330 (pellEmptyMatchingCertificate 5991) (by
    change pellLightFiniteCheck 5991 77 (10^275) 330 PellLightProduction.magnitudes_5991 = true
    exact PellLightProduction.checked_5991)

def pellFiniteCertificate_5999 : PellFiniteCertificate 5999 (10^275) :=
  pellFiniteCertificateOfLight 5999 (10^275) 77 562 pellGraphCertificate_5999 (by
    change pellLightFiniteCheck 5999 77 (10^275) 562 PellLightProduction.magnitudes_5999 = true
    exact PellLightProduction.checked_5999)

def pellFiniteCertificate_6007 : PellFiniteCertificate 6007 (10^275) :=
  pellFiniteCertificateOfLight 6007 (10^275) 77 530 pellGraphCertificate_6007 (by
    change pellLightFiniteCheck 6007 77 (10^275) 530 PellLightProduction.magnitudes_6007 = true
    exact PellLightProduction.checked_6007)

def pellFiniteCertificate_6015 : PellFiniteCertificate 6015 (10^275) :=
  pellFiniteCertificateOfLight 6015 (10^275) 77 464 (pellEmptyMatchingCertificate 6015) (by
    change pellLightFiniteCheck 6015 77 (10^275) 464 PellLightProduction.magnitudes_6015 = true
    exact PellLightProduction.checked_6015)

def pellFiniteCertificate_6023 : PellFiniteCertificate 6023 (10^275) :=
  pellFiniteCertificateOfLight 6023 (10^275) 77 660 (pellEmptyMatchingCertificate 6023) (by
    change pellLightFiniteCheck 6023 77 (10^275) 660 PellLightProduction.magnitudes_6023 = true
    exact PellLightProduction.checked_6023)

def pellFiniteCertificate_6031 : PellFiniteCertificate 6031 (10^275) :=
  pellFiniteCertificateOfLight 6031 (10^275) 77 620 (pellEmptyMatchingCertificate 6031) (by
    change pellLightFiniteCheck 6031 77 (10^275) 620 PellLightProduction.magnitudes_6031 = true
    exact PellLightProduction.checked_6031)

def pellFiniteCertificate_6047 : PellFiniteCertificate 6047 (10^275) :=
  pellFiniteCertificateOfLight 6047 (10^275) 77 623 pellGraphCertificate_6047 (by
    change pellLightFiniteCheck 6047 77 (10^275) 623 PellLightProduction.magnitudes_6047 = true
    exact PellLightProduction.checked_6047)

def pellFiniteCertificate_6055 : PellFiniteCertificate 6055 (10^275) :=
  pellFiniteCertificateOfLight 6055 (10^275) 77 405 (pellEmptyMatchingCertificate 6055) (by
    change pellLightFiniteCheck 6055 77 (10^275) 405 PellLightProduction.magnitudes_6055 = true
    exact PellLightProduction.checked_6055)

def pellFiniteCertificate_6063 : PellFiniteCertificate 6063 (10^275) :=
  pellFiniteCertificateOfLight 6063 (10^275) 77 490 (pellEmptyMatchingCertificate 6063) (by
    change pellLightFiniteCheck 6063 77 (10^275) 490 PellLightProduction.magnitudes_6063 = true
    exact PellLightProduction.checked_6063)

def pellFiniteCertificate_6071 : PellFiniteCertificate 6071 (10^275) :=
  pellFiniteCertificateOfLight 6071 (10^275) 77 336 (pellEmptyMatchingCertificate 6071) (by
    change pellLightFiniteCheck 6071 77 (10^275) 336 PellLightProduction.magnitudes_6071 = true
    exact PellLightProduction.checked_6071)

def pellFiniteCertificate_6079 : PellFiniteCertificate 6079 (10^275) :=
  pellFiniteCertificateOfLight 6079 (10^275) 77 488 pellGraphCertificate_6079 (by
    change pellLightFiniteCheck 6079 77 (10^275) 488 PellLightProduction.magnitudes_6079 = true
    exact PellLightProduction.checked_6079)

def pellFiniteCertificate_6087 : PellFiniteCertificate 6087 (10^275) :=
  pellFiniteCertificateOfLight 6087 (10^275) 78 140 (pellEmptyMatchingCertificate 6087) (by
    change pellLightFiniteCheck 6087 78 (10^275) 140 PellLightProduction.magnitudes_6087 = true
    exact PellLightProduction.checked_6087)

def pellFiniteCertificate_6095 : PellFiniteCertificate 6095 (10^275) :=
  pellFiniteCertificateOfLight 6095 (10^275) 78 257 (pellEmptyMatchingCertificate 6095) (by
    change pellLightFiniteCheck 6095 78 (10^275) 257 PellLightProduction.magnitudes_6095 = true
    exact PellLightProduction.checked_6095)

def pellFiniteCertificate_6103 : PellFiniteCertificate 6103 (10^275) :=
  pellFiniteCertificateOfLight 6103 (10^275) 78 522 pellGraphCertificate_6103 (by
    change pellLightFiniteCheck 6103 78 (10^275) 522 PellLightProduction.magnitudes_6103 = true
    exact PellLightProduction.checked_6103)

def pellFiniteCertificate_6119 : PellFiniteCertificate 6119 (10^275) :=
  pellFiniteCertificateOfLight 6119 (10^275) 78 491 (pellEmptyMatchingCertificate 6119) (by
    change pellLightFiniteCheck 6119 78 (10^275) 491 PellLightProduction.magnitudes_6119 = true
    exact PellLightProduction.checked_6119)

def pellFiniteCertificate_6127 : PellFiniteCertificate 6127 (10^275) :=
  pellFiniteCertificateOfLight 6127 (10^275) 78 564 (pellEmptyMatchingCertificate 6127) (by
    change pellLightFiniteCheck 6127 78 (10^275) 564 PellLightProduction.magnitudes_6127 = true
    exact PellLightProduction.checked_6127)

def pellFiniteCertificate_6135 : PellFiniteCertificate 6135 (10^275) :=
  pellFiniteCertificateOfLight 6135 (10^275) 78 252 (pellEmptyMatchingCertificate 6135) (by
    change pellLightFiniteCheck 6135 78 (10^275) 252 PellLightProduction.magnitudes_6135 = true
    exact PellLightProduction.checked_6135)

def pellFiniteCertificate_6143 : PellFiniteCertificate 6143 (10^275) :=
  pellFiniteCertificateOfLight 6143 (10^275) 78 519 pellGraphCertificate_6143 (by
    change pellLightFiniteCheck 6143 78 (10^275) 519 PellLightProduction.magnitudes_6143 = true
    exact PellLightProduction.checked_6143)

def pellFiniteCertificate_6151 : PellFiniteCertificate 6151 (10^275) :=
  pellFiniteCertificateOfLight 6151 (10^275) 78 380 pellGraphCertificate_6151 (by
    change pellLightFiniteCheck 6151 78 (10^275) 380 PellLightProduction.magnitudes_6151 = true
    exact PellLightProduction.checked_6151)

def pellFiniteCertificate_6159 : PellFiniteCertificate 6159 (10^275) :=
  pellFiniteCertificateOfLight 6159 (10^275) 78 478 (pellEmptyMatchingCertificate 6159) (by
    change pellLightFiniteCheck 6159 78 (10^275) 478 PellLightProduction.magnitudes_6159 = true
    exact PellLightProduction.checked_6159)

def pellFiniteCertificate_6167 : PellFiniteCertificate 6167 (10^275) :=
  pellFiniteCertificateOfLight 6167 (10^275) 78 488 pellGraphCertificate_6167 (by
    change pellLightFiniteCheck 6167 78 (10^275) 488 PellLightProduction.magnitudes_6167 = true
    exact PellLightProduction.checked_6167)

def pellFiniteCertificate_6191 : PellFiniteCertificate 6191 (10^275) :=
  pellFiniteCertificateOfLight 6191 (10^275) 78 464 pellGraphCertificate_6191 (by
    change pellLightFiniteCheck 6191 78 (10^275) 464 PellLightProduction.magnitudes_6191 = true
    exact PellLightProduction.checked_6191)

def pellFiniteCertificate_6199 : PellFiniteCertificate 6199 (10^275) :=
  pellFiniteCertificateOfLight 6199 (10^275) 78 544 pellGraphCertificate_6199 (by
    change pellLightFiniteCheck 6199 78 (10^275) 544 PellLightProduction.magnitudes_6199 = true
    exact PellLightProduction.checked_6199)

def pellFiniteCertificate_6207 : PellFiniteCertificate 6207 (10^275) :=
  pellFiniteCertificateOfLight 6207 (10^275) 78 753 (pellEmptyMatchingCertificate 6207) (by
    change pellLightFiniteCheck 6207 78 (10^275) 753 PellLightProduction.magnitudes_6207 = true
    exact PellLightProduction.checked_6207)

def pellFiniteCertificate_6215 : PellFiniteCertificate 6215 (10^275) :=
  pellFiniteCertificateOfLight 6215 (10^275) 78 336 (pellEmptyMatchingCertificate 6215) (by
    change pellLightFiniteCheck 6215 78 (10^275) 336 PellLightProduction.magnitudes_6215 = true
    exact PellLightProduction.checked_6215)

def pellFiniteCertificate_6231 : PellFiniteCertificate 6231 (10^275) :=
  pellFiniteCertificateOfLight 6231 (10^275) 78 487 (pellEmptyMatchingCertificate 6231) (by
    change pellLightFiniteCheck 6231 78 (10^275) 487 PellLightProduction.magnitudes_6231 = true
    exact PellLightProduction.checked_6231)

def pellFiniteCertificate_6239 : PellFiniteCertificate 6239 (10^275) :=
  pellFiniteCertificateOfLight 6239 (10^275) 78 268 pellGraphCertificate_6239 (by
    change pellLightFiniteCheck 6239 78 (10^275) 268 PellLightProduction.magnitudes_6239 = true
    exact PellLightProduction.checked_6239)

def pellFiniteCertificate_6247 : PellFiniteCertificate 6247 (10^275) :=
  pellFiniteCertificateOfLight 6247 (10^275) 79 446 pellGraphCertificate_6247 (by
    change pellLightFiniteCheck 6247 79 (10^275) 446 PellLightProduction.magnitudes_6247 = true
    exact PellLightProduction.checked_6247)

def pellFiniteCertificate_6263 : PellFiniteCertificate 6263 (10^275) :=
  pellFiniteCertificateOfLight 6263 (10^275) 79 519 pellGraphCertificate_6263 (by
    change pellLightFiniteCheck 6263 79 (10^275) 519 PellLightProduction.magnitudes_6263 = true
    exact PellLightProduction.checked_6263)

def pellFiniteCertificate_6271 : PellFiniteCertificate 6271 (10^275) :=
  pellFiniteCertificateOfLight 6271 (10^275) 79 519 pellGraphCertificate_6271 (by
    change pellLightFiniteCheck 6271 79 (10^275) 519 PellLightProduction.magnitudes_6271 = true
    exact PellLightProduction.checked_6271)

def pellFiniteCertificate_6279 : PellFiniteCertificate 6279 (10^275) :=
  pellFiniteCertificateOfLight 6279 (10^275) 79 272 (pellEmptyMatchingCertificate 6279) (by
    change pellLightFiniteCheck 6279 79 (10^275) 272 PellLightProduction.magnitudes_6279 = true
    exact PellLightProduction.checked_6279)

def pellFiniteCertificate_6287 : PellFiniteCertificate 6287 (10^275) :=
  pellFiniteCertificateOfLight 6287 (10^275) 79 546 pellGraphCertificate_6287 (by
    change pellLightFiniteCheck 6287 79 (10^275) 546 PellLightProduction.magnitudes_6287 = true
    exact PellLightProduction.checked_6287)

def pellFiniteCertificate_6295 : PellFiniteCertificate 6295 (10^275) :=
  pellFiniteCertificateOfLight 6295 (10^275) 79 531 (pellEmptyMatchingCertificate 6295) (by
    change pellLightFiniteCheck 6295 79 (10^275) 531 PellLightProduction.magnitudes_6295 = true
    exact PellLightProduction.checked_6295)

def pellFiniteCertificate_6303 : PellFiniteCertificate 6303 (10^275) :=
  pellFiniteCertificateOfLight 6303 (10^275) 79 450 (pellEmptyMatchingCertificate 6303) (by
    change pellLightFiniteCheck 6303 79 (10^275) 450 PellLightProduction.magnitudes_6303 = true
    exact PellLightProduction.checked_6303)

def pellFiniteCertificate_6311 : PellFiniteCertificate 6311 (10^275) :=
  pellFiniteCertificateOfLight 6311 (10^275) 79 490 pellGraphCertificate_6311 (by
    change pellLightFiniteCheck 6311 79 (10^275) 490 PellLightProduction.magnitudes_6311 = true
    exact PellLightProduction.checked_6311)

def pellFiniteCertificate_6319 : PellFiniteCertificate 6319 (10^275) :=
  pellFiniteCertificateOfLight 6319 (10^275) 79 414 pellGraphCertificate_6319 (by
    change pellLightFiniteCheck 6319 79 (10^275) 414 PellLightProduction.magnitudes_6319 = true
    exact PellLightProduction.checked_6319)

def pellFiniteCertificate_6335 : PellFiniteCertificate 6335 (10^275) :=
  pellFiniteCertificateOfLight 6335 (10^275) 79 449 (pellEmptyMatchingCertificate 6335) (by
    change pellLightFiniteCheck 6335 79 (10^275) 449 PellLightProduction.magnitudes_6335 = true
    exact PellLightProduction.checked_6335)

def pellFiniteCertificate_6343 : PellFiniteCertificate 6343 (10^275) :=
  pellFiniteCertificateOfLight 6343 (10^275) 79 538 pellGraphCertificate_6343 (by
    change pellLightFiniteCheck 6343 79 (10^275) 538 PellLightProduction.magnitudes_6343 = true
    exact PellLightProduction.checked_6343)

def pellFiniteCertificate_6351 : PellFiniteCertificate 6351 (10^275) :=
  pellFiniteCertificateOfLight 6351 (10^275) 79 544 (pellEmptyMatchingCertificate 6351) (by
    change pellLightFiniteCheck 6351 79 (10^275) 544 PellLightProduction.magnitudes_6351 = true
    exact PellLightProduction.checked_6351)

def pellFiniteCertificate_6359 : PellFiniteCertificate 6359 (10^275) :=
  pellFiniteCertificateOfLight 6359 (10^275) 79 565 pellGraphCertificate_6359 (by
    change pellLightFiniteCheck 6359 79 (10^275) 565 PellLightProduction.magnitudes_6359 = true
    exact PellLightProduction.checked_6359)

def pellFiniteCertificate_6367 : PellFiniteCertificate 6367 (10^275) :=
  pellFiniteCertificateOfLight 6367 (10^275) 79 552 pellGraphCertificate_6367 (by
    change pellLightFiniteCheck 6367 79 (10^275) 552 PellLightProduction.magnitudes_6367 = true
    exact PellLightProduction.checked_6367)

def pellFiniteCertificate_6383 : PellFiniteCertificate 6383 (10^275) :=
  pellFiniteCertificateOfLight 6383 (10^275) 79 437 (pellEmptyMatchingCertificate 6383) (by
    change pellLightFiniteCheck 6383 79 (10^275) 437 PellLightProduction.magnitudes_6383 = true
    exact PellLightProduction.checked_6383)

def pellFiniteCertificate_6391 : PellFiniteCertificate 6391 (10^275) :=
  pellFiniteCertificateOfLight 6391 (10^275) 79 527 (pellEmptyMatchingCertificate 6391) (by
    change pellLightFiniteCheck 6391 79 (10^275) 527 PellLightProduction.magnitudes_6391 = true
    exact PellLightProduction.checked_6391)

def pellFiniteCertificate_6407 : PellFiniteCertificate 6407 (10^275) :=
  pellFiniteCertificateOfLight 6407 (10^275) 80 370 (pellEmptyMatchingCertificate 6407) (by
    change pellLightFiniteCheck 6407 80 (10^275) 370 PellLightProduction.magnitudes_6407 = true
    exact PellLightProduction.checked_6407)

def pellFiniteCertificate_6415 : PellFiniteCertificate 6415 (10^275) :=
  pellFiniteCertificateOfLight 6415 (10^275) 80 380 (pellEmptyMatchingCertificate 6415) (by
    change pellLightFiniteCheck 6415 80 (10^275) 380 PellLightProduction.magnitudes_6415 = true
    exact PellLightProduction.checked_6415)

def pellFiniteCertificate_6423 : PellFiniteCertificate 6423 (10^275) :=
  pellFiniteCertificateOfLight 6423 (10^275) 80 309 (pellEmptyMatchingCertificate 6423) (by
    change pellLightFiniteCheck 6423 80 (10^275) 309 PellLightProduction.magnitudes_6423 = true
    exact PellLightProduction.checked_6423)

def pellFiniteCertificate_6431 : PellFiniteCertificate 6431 (10^275) :=
  pellFiniteCertificateOfLight 6431 (10^275) 80 423 (pellEmptyMatchingCertificate 6431) (by
    change pellLightFiniteCheck 6431 80 (10^275) 423 PellLightProduction.magnitudes_6431 = true
    exact PellLightProduction.checked_6431)

def pellFiniteCertificate_6439 : PellFiniteCertificate 6439 (10^275) :=
  pellFiniteCertificateOfLight 6439 (10^275) 80 490 pellGraphCertificate_6439 (by
    change pellLightFiniteCheck 6439 80 (10^275) 490 PellLightProduction.magnitudes_6439 = true
    exact PellLightProduction.checked_6439)

def pellFiniteCertificate_6447 : PellFiniteCertificate 6447 (10^275) :=
  pellFiniteCertificateOfLight 6447 (10^275) 80 417 (pellEmptyMatchingCertificate 6447) (by
    change pellLightFiniteCheck 6447 80 (10^275) 417 PellLightProduction.magnitudes_6447 = true
    exact PellLightProduction.checked_6447)

def pellFiniteCertificate_6455 : PellFiniteCertificate 6455 (10^275) :=
  pellFiniteCertificateOfLight 6455 (10^275) 80 492 (pellEmptyMatchingCertificate 6455) (by
    change pellLightFiniteCheck 6455 80 (10^275) 492 PellLightProduction.magnitudes_6455 = true
    exact PellLightProduction.checked_6455)

def pellFiniteCertificate_6463 : PellFiniteCertificate 6463 (10^275) :=
  pellFiniteCertificateOfLight 6463 (10^275) 80 486 pellGraphCertificate_6463 (by
    change pellLightFiniteCheck 6463 80 (10^275) 486 PellLightProduction.magnitudes_6463 = true
    exact PellLightProduction.checked_6463)

def pellFiniteCertificate_6479 : PellFiniteCertificate 6479 (10^275) :=
  pellFiniteCertificateOfLight 6479 (10^275) 80 373 (pellEmptyMatchingCertificate 6479) (by
    change pellLightFiniteCheck 6479 80 (10^275) 373 PellLightProduction.magnitudes_6479 = true
    exact PellLightProduction.checked_6479)

def pellFiniteCertificate_6487 : PellFiniteCertificate 6487 (10^275) :=
  pellFiniteCertificateOfLight 6487 (10^275) 80 503 (pellEmptyMatchingCertificate 6487) (by
    change pellLightFiniteCheck 6487 80 (10^275) 503 PellLightProduction.magnitudes_6487 = true
    exact PellLightProduction.checked_6487)

def pellFiniteCertificate_6495 : PellFiniteCertificate 6495 (10^275) :=
  pellFiniteCertificateOfLight 6495 (10^275) 80 511 (pellEmptyMatchingCertificate 6495) (by
    change pellLightFiniteCheck 6495 80 (10^275) 511 PellLightProduction.magnitudes_6495 = true
    exact PellLightProduction.checked_6495)

def pellFiniteCertificate_6503 : PellFiniteCertificate 6503 (10^275) :=
  pellFiniteCertificateOfLight 6503 (10^275) 80 644 pellGraphCertificate_6503 (by
    change pellLightFiniteCheck 6503 80 (10^275) 644 PellLightProduction.magnitudes_6503 = true
    exact PellLightProduction.checked_6503)

def pellFiniteCertificate_6511 : PellFiniteCertificate 6511 (10^275) :=
  pellFiniteCertificateOfLight 6511 (10^275) 80 644 (pellEmptyMatchingCertificate 6511) (by
    change pellLightFiniteCheck 6511 80 (10^275) 644 PellLightProduction.magnitudes_6511 = true
    exact PellLightProduction.checked_6511)

def pellFiniteCertificate_6519 : PellFiniteCertificate 6519 (10^275) :=
  pellFiniteCertificateOfLight 6519 (10^275) 80 580 (pellEmptyMatchingCertificate 6519) (by
    change pellLightFiniteCheck 6519 80 (10^275) 580 PellLightProduction.magnitudes_6519 = true
    exact PellLightProduction.checked_6519)

def pellFiniteCertificate_6527 : PellFiniteCertificate 6527 (10^275) :=
  pellFiniteCertificateOfLight 6527 (10^275) 80 437 (pellEmptyMatchingCertificate 6527) (by
    change pellLightFiniteCheck 6527 80 (10^275) 437 PellLightProduction.magnitudes_6527 = true
    exact PellLightProduction.checked_6527)

def pellFiniteCertificate_6535 : PellFiniteCertificate 6535 (10^275) :=
  pellFiniteCertificateOfLight 6535 (10^275) 80 539 (pellEmptyMatchingCertificate 6535) (by
    change pellLightFiniteCheck 6535 80 (10^275) 539 PellLightProduction.magnitudes_6535 = true
    exact PellLightProduction.checked_6535)

def pellFiniteCertificate_6551 : PellFiniteCertificate 6551 (10^275) :=
  pellFiniteCertificateOfLight 6551 (10^275) 80 538 pellGraphCertificate_6551 (by
    change pellLightFiniteCheck 6551 80 (10^275) 538 PellLightProduction.magnitudes_6551 = true
    exact PellLightProduction.checked_6551)

def pellFiniteCertificate_6559 : PellFiniteCertificate 6559 (10^275) :=
  pellFiniteCertificateOfLight 6559 (10^275) 80 266 pellGraphCertificate_6559 (by
    change pellLightFiniteCheck 6559 80 (10^275) 266 PellLightProduction.magnitudes_6559 = true
    exact PellLightProduction.checked_6559)

def pellFiniteCertificate_6567 : PellFiniteCertificate 6567 (10^275) :=
  pellFiniteCertificateOfLight 6567 (10^275) 81 151 (pellEmptyMatchingCertificate 6567) (by
    change pellLightFiniteCheck 6567 81 (10^275) 151 PellLightProduction.magnitudes_6567 = true
    exact PellLightProduction.checked_6567)

def pellFiniteCertificate_6583 : PellFiniteCertificate 6583 (10^275) :=
  pellFiniteCertificateOfLight 6583 (10^275) 81 578 (pellEmptyMatchingCertificate 6583) (by
    change pellLightFiniteCheck 6583 81 (10^275) 578 PellLightProduction.magnitudes_6583 = true
    exact PellLightProduction.checked_6583)

def pellFiniteCertificate_6599 : PellFiniteCertificate 6599 (10^275) :=
  pellFiniteCertificateOfLight 6599 (10^275) 81 487 pellGraphCertificate_6599 (by
    change pellLightFiniteCheck 6599 81 (10^275) 487 PellLightProduction.magnitudes_6599 = true
    exact PellLightProduction.checked_6599)

def pellFiniteCertificate_6607 : PellFiniteCertificate 6607 (10^275) :=
  pellFiniteCertificateOfLight 6607 (10^275) 81 545 pellGraphCertificate_6607 (by
    change pellLightFiniteCheck 6607 81 (10^275) 545 PellLightProduction.magnitudes_6607 = true
    exact PellLightProduction.checked_6607)

def pellFiniteCertificate_6623 : PellFiniteCertificate 6623 (10^275) :=
  pellFiniteCertificateOfLight 6623 (10^275) 81 554 (pellEmptyMatchingCertificate 6623) (by
    change pellLightFiniteCheck 6623 81 (10^275) 554 PellLightProduction.magnitudes_6623 = true
    exact PellLightProduction.checked_6623)

def pellFiniteCertificate_6631 : PellFiniteCertificate 6631 (10^275) :=
  pellFiniteCertificateOfLight 6631 (10^275) 81 341 (pellEmptyMatchingCertificate 6631) (by
    change pellLightFiniteCheck 6631 81 (10^275) 341 PellLightProduction.magnitudes_6631 = true
    exact PellLightProduction.checked_6631)

def pellFiniteCertificate_6639 : PellFiniteCertificate 6639 (10^275) :=
  pellFiniteCertificateOfLight 6639 (10^275) 81 255 (pellEmptyMatchingCertificate 6639) (by
    change pellLightFiniteCheck 6639 81 (10^275) 255 PellLightProduction.magnitudes_6639 = true
    exact PellLightProduction.checked_6639)

def pellFiniteCertificate_6663 : PellFiniteCertificate 6663 (10^275) :=
  pellFiniteCertificateOfLight 6663 (10^275) 81 648 (pellEmptyMatchingCertificate 6663) (by
    change pellLightFiniteCheck 6663 81 (10^275) 648 PellLightProduction.magnitudes_6663 = true
    exact PellLightProduction.checked_6663)

def pellFiniteCertificate_6671 : PellFiniteCertificate 6671 (10^275) :=
  pellFiniteCertificateOfLight 6671 (10^275) 81 390 (pellEmptyMatchingCertificate 6671) (by
    change pellLightFiniteCheck 6671 81 (10^275) 390 PellLightProduction.magnitudes_6671 = true
    exact PellLightProduction.checked_6671)

def pellFiniteCertificate_6679 : PellFiniteCertificate 6679 (10^275) :=
  pellFiniteCertificateOfLight 6679 (10^275) 81 580 pellGraphCertificate_6679 (by
    change pellLightFiniteCheck 6679 81 (10^275) 580 PellLightProduction.magnitudes_6679 = true
    exact PellLightProduction.checked_6679)

def pellFiniteCertificate_6695 : PellFiniteCertificate 6695 (10^275) :=
  pellFiniteCertificateOfLight 6695 (10^275) 81 600 (pellEmptyMatchingCertificate 6695) (by
    change pellLightFiniteCheck 6695 81 (10^275) 600 PellLightProduction.magnitudes_6695 = true
    exact PellLightProduction.checked_6695)

def pellFiniteCertificate_6703 : PellFiniteCertificate 6703 (10^275) :=
  pellFiniteCertificateOfLight 6703 (10^275) 81 545 pellGraphCertificate_6703 (by
    change pellLightFiniteCheck 6703 81 (10^275) 545 PellLightProduction.magnitudes_6703 = true
    exact PellLightProduction.checked_6703)

def pellFiniteCertificate_6711 : PellFiniteCertificate 6711 (10^275) :=
  pellFiniteCertificateOfLight 6711 (10^275) 81 519 (pellEmptyMatchingCertificate 6711) (by
    change pellLightFiniteCheck 6711 81 (10^275) 519 PellLightProduction.magnitudes_6711 = true
    exact PellLightProduction.checked_6711)

def pellFiniteCertificate_6719 : PellFiniteCertificate 6719 (10^275) :=
  pellFiniteCertificateOfLight 6719 (10^275) 81 576 pellGraphCertificate_6719 (by
    change pellLightFiniteCheck 6719 81 (10^275) 576 PellLightProduction.magnitudes_6719 = true
    exact PellLightProduction.checked_6719)

def pellFiniteCertificate_6735 : PellFiniteCertificate 6735 (10^275) :=
  pellFiniteCertificateOfLight 6735 (10^275) 82 504 (pellEmptyMatchingCertificate 6735) (by
    change pellLightFiniteCheck 6735 82 (10^275) 504 PellLightProduction.magnitudes_6735 = true
    exact PellLightProduction.checked_6735)

def pellFiniteCertificate_6743 : PellFiniteCertificate 6743 (10^275) :=
  pellFiniteCertificateOfLight 6743 (10^275) 82 411 (pellEmptyMatchingCertificate 6743) (by
    change pellLightFiniteCheck 6743 82 (10^275) 411 PellLightProduction.magnitudes_6743 = true
    exact PellLightProduction.checked_6743)

def pellFiniteCertificate_6751 : PellFiniteCertificate 6751 (10^275) :=
  pellFiniteCertificateOfLight 6751 (10^275) 82 351 (pellEmptyMatchingCertificate 6751) (by
    change pellLightFiniteCheck 6751 82 (10^275) 351 PellLightProduction.magnitudes_6751 = true
    exact PellLightProduction.checked_6751)

def pellFiniteCertificate_6767 : PellFiniteCertificate 6767 (10^275) :=
  pellFiniteCertificateOfLight 6767 (10^275) 82 564 (pellEmptyMatchingCertificate 6767) (by
    change pellLightFiniteCheck 6767 82 (10^275) 564 PellLightProduction.magnitudes_6767 = true
    exact PellLightProduction.checked_6767)

def pellFiniteCertificate_6783 : PellFiniteCertificate 6783 (10^275) :=
  pellFiniteCertificateOfLight 6783 (10^275) 82 432 (pellEmptyMatchingCertificate 6783) (by
    change pellLightFiniteCheck 6783 82 (10^275) 432 PellLightProduction.magnitudes_6783 = true
    exact PellLightProduction.checked_6783)

def pellFiniteCertificate_6791 : PellFiniteCertificate 6791 (10^275) :=
  pellFiniteCertificateOfLight 6791 (10^275) 82 520 pellGraphCertificate_6791 (by
    change pellLightFiniteCheck 6791 82 (10^275) 520 PellLightProduction.magnitudes_6791 = true
    exact PellLightProduction.checked_6791)

def pellFiniteCertificate_6799 : PellFiniteCertificate 6799 (10^275) :=
  pellFiniteCertificateOfLight 6799 (10^275) 82 574 (pellEmptyMatchingCertificate 6799) (by
    change pellLightFiniteCheck 6799 82 (10^275) 574 PellLightProduction.magnitudes_6799 = true
    exact PellLightProduction.checked_6799)

def pellFiniteCertificate_6807 : PellFiniteCertificate 6807 (10^275) :=
  pellFiniteCertificateOfLight 6807 (10^275) 82 360 (pellEmptyMatchingCertificate 6807) (by
    change pellLightFiniteCheck 6807 82 (10^275) 360 PellLightProduction.magnitudes_6807 = true
    exact PellLightProduction.checked_6807)

def pellFiniteCertificate_6815 : PellFiniteCertificate 6815 (10^275) :=
  pellFiniteCertificateOfLight 6815 (10^275) 82 652 (pellEmptyMatchingCertificate 6815) (by
    change pellLightFiniteCheck 6815 82 (10^275) 652 PellLightProduction.magnitudes_6815 = true
    exact PellLightProduction.checked_6815)

def pellFiniteCertificate_6823 : PellFiniteCertificate 6823 (10^275) :=
  pellFiniteCertificateOfLight 6823 (10^275) 82 492 pellGraphCertificate_6823 (by
    change pellLightFiniteCheck 6823 82 (10^275) 492 PellLightProduction.magnitudes_6823 = true
    exact PellLightProduction.checked_6823)

def pellFiniteCertificate_6839 : PellFiniteCertificate 6839 (10^275) :=
  pellFiniteCertificateOfLight 6839 (10^275) 82 469 (pellEmptyMatchingCertificate 6839) (by
    change pellLightFiniteCheck 6839 82 (10^275) 469 PellLightProduction.magnitudes_6839 = true
    exact PellLightProduction.checked_6839)

def pellFiniteCertificate_6847 : PellFiniteCertificate 6847 (10^275) :=
  pellFiniteCertificateOfLight 6847 (10^275) 82 649 pellGraphCertificate_6847 (by
    change pellLightFiniteCheck 6847 82 (10^275) 649 PellLightProduction.magnitudes_6847 = true
    exact PellLightProduction.checked_6847)

def pellFiniteCertificate_6855 : PellFiniteCertificate 6855 (10^275) :=
  pellFiniteCertificateOfLight 6855 (10^275) 82 450 (pellEmptyMatchingCertificate 6855) (by
    change pellLightFiniteCheck 6855 82 (10^275) 450 PellLightProduction.magnitudes_6855 = true
    exact PellLightProduction.checked_6855)

def pellFiniteCertificate_6863 : PellFiniteCertificate 6863 (10^275) :=
  pellFiniteCertificateOfLight 6863 (10^275) 82 582 pellGraphCertificate_6863 (by
    change pellLightFiniteCheck 6863 82 (10^275) 582 PellLightProduction.magnitudes_6863 = true
    exact PellLightProduction.checked_6863)

def pellFiniteCertificate_6871 : PellFiniteCertificate 6871 (10^275) :=
  pellFiniteCertificateOfLight 6871 (10^275) 82 532 pellGraphCertificate_6871 (by
    change pellLightFiniteCheck 6871 82 (10^275) 532 PellLightProduction.magnitudes_6871 = true
    exact PellLightProduction.checked_6871)

def pellFiniteCertificate_6879 : PellFiniteCertificate 6879 (10^275) :=
  pellFiniteCertificateOfLight 6879 (10^275) 82 587 (pellEmptyMatchingCertificate 6879) (by
    change pellLightFiniteCheck 6879 82 (10^275) 587 PellLightProduction.magnitudes_6879 = true
    exact PellLightProduction.checked_6879)

def pellFiniteCertificate_6887 : PellFiniteCertificate 6887 (10^275) :=
  pellFiniteCertificateOfLight 6887 (10^275) 82 264 pellGraphCertificate_6887 (by
    change pellLightFiniteCheck 6887 82 (10^275) 264 PellLightProduction.magnitudes_6887 = true
    exact PellLightProduction.checked_6887)

def pellFiniteCertificate_6895 : PellFiniteCertificate 6895 (10^275) :=
  pellFiniteCertificateOfLight 6895 (10^275) 83 422 (pellEmptyMatchingCertificate 6895) (by
    change pellLightFiniteCheck 6895 83 (10^275) 422 PellLightProduction.magnitudes_6895 = true
    exact PellLightProduction.checked_6895)

def pellFiniteCertificate_6911 : PellFiniteCertificate 6911 (10^275) :=
  pellFiniteCertificateOfLight 6911 (10^275) 83 507 pellGraphCertificate_6911 (by
    change pellLightFiniteCheck 6911 83 (10^275) 507 PellLightProduction.magnitudes_6911 = true
    exact PellLightProduction.checked_6911)

def pellFiniteCertificate_6919 : PellFiniteCertificate 6919 (10^275) :=
  pellFiniteCertificateOfLight 6919 (10^275) 83 524 (pellEmptyMatchingCertificate 6919) (by
    change pellLightFiniteCheck 6919 83 (10^275) 524 PellLightProduction.magnitudes_6919 = true
    exact PellLightProduction.checked_6919)

def pellFiniteCertificate_6927 : PellFiniteCertificate 6927 (10^275) :=
  pellFiniteCertificateOfLight 6927 (10^275) 83 405 (pellEmptyMatchingCertificate 6927) (by
    change pellLightFiniteCheck 6927 83 (10^275) 405 PellLightProduction.magnitudes_6927 = true
    exact PellLightProduction.checked_6927)

def pellFiniteCertificate_6935 : PellFiniteCertificate 6935 (10^275) :=
  pellFiniteCertificateOfLight 6935 (10^275) 83 588 (pellEmptyMatchingCertificate 6935) (by
    change pellLightFiniteCheck 6935 83 (10^275) 588 PellLightProduction.magnitudes_6935 = true
    exact PellLightProduction.checked_6935)

def pellFiniteCertificate_6943 : PellFiniteCertificate 6943 (10^275) :=
  pellFiniteCertificateOfLight 6943 (10^275) 83 402 (pellEmptyMatchingCertificate 6943) (by
    change pellLightFiniteCheck 6943 83 (10^275) 402 PellLightProduction.magnitudes_6943 = true
    exact PellLightProduction.checked_6943)

def pellFiniteCertificate_6951 : PellFiniteCertificate 6951 (10^275) :=
  pellFiniteCertificateOfLight 6951 (10^275) 83 568 (pellEmptyMatchingCertificate 6951) (by
    change pellLightFiniteCheck 6951 83 (10^275) 568 PellLightProduction.magnitudes_6951 = true
    exact PellLightProduction.checked_6951)

def pellFiniteCertificate_6959 : PellFiniteCertificate 6959 (10^275) :=
  pellFiniteCertificateOfLight 6959 (10^275) 83 554 pellGraphCertificate_6959 (by
    change pellLightFiniteCheck 6959 83 (10^275) 554 PellLightProduction.magnitudes_6959 = true
    exact PellLightProduction.checked_6959)

def pellFiniteCertificate_6967 : PellFiniteCertificate 6967 (10^275) :=
  pellFiniteCertificateOfLight 6967 (10^275) 83 513 pellGraphCertificate_6967 (by
    change pellLightFiniteCheck 6967 83 (10^275) 513 PellLightProduction.magnitudes_6967 = true
    exact PellLightProduction.checked_6967)

def pellFiniteCertificate_6983 : PellFiniteCertificate 6983 (10^275) :=
  pellFiniteCertificateOfLight 6983 (10^275) 83 558 pellGraphCertificate_6983 (by
    change pellLightFiniteCheck 6983 83 (10^275) 558 PellLightProduction.magnitudes_6983 = true
    exact PellLightProduction.checked_6983)

def pellFiniteCertificate_6991 : PellFiniteCertificate 6991 (10^275) :=
  pellFiniteCertificateOfLight 6991 (10^275) 83 547 pellGraphCertificate_6991 (by
    change pellLightFiniteCheck 6991 83 (10^275) 547 PellLightProduction.magnitudes_6991 = true
    exact PellLightProduction.checked_6991)

def pellFiniteCertificate_6999 : PellFiniteCertificate 6999 (10^275) :=
  pellFiniteCertificateOfLight 6999 (10^275) 83 486 (pellEmptyMatchingCertificate 6999) (by
    change pellLightFiniteCheck 6999 83 (10^275) 486 PellLightProduction.magnitudes_6999 = true
    exact PellLightProduction.checked_6999)

def pellFiniteCertificate_7015 : PellFiniteCertificate 7015 (10^275) :=
  pellFiniteCertificateOfLight 7015 (10^275) 83 423 (pellEmptyMatchingCertificate 7015) (by
    change pellLightFiniteCheck 7015 83 (10^275) 423 PellLightProduction.magnitudes_7015 = true
    exact PellLightProduction.checked_7015)

def pellFiniteCertificate_7023 : PellFiniteCertificate 7023 (10^275) :=
  pellFiniteCertificateOfLight 7023 (10^275) 83 525 (pellEmptyMatchingCertificate 7023) (by
    change pellLightFiniteCheck 7023 83 (10^275) 525 PellLightProduction.magnitudes_7023 = true
    exact PellLightProduction.checked_7023)

def pellFiniteCertificate_7031 : PellFiniteCertificate 7031 (10^275) :=
  pellFiniteCertificateOfLight 7031 (10^275) 83 438 pellGraphCertificate_7031 (by
    change pellLightFiniteCheck 7031 83 (10^275) 438 PellLightProduction.magnitudes_7031 = true
    exact PellLightProduction.checked_7031)

def pellFiniteCertificate_7039 : PellFiniteCertificate 7039 (10^275) :=
  pellFiniteCertificateOfLight 7039 (10^275) 83 539 pellGraphCertificate_7039 (by
    change pellLightFiniteCheck 7039 83 (10^275) 539 PellLightProduction.magnitudes_7039 = true
    exact PellLightProduction.checked_7039)

def pellFiniteCertificate_7055 : PellFiniteCertificate 7055 (10^275) :=
  pellFiniteCertificateOfLight 7055 (10^275) 83 246 (pellEmptyMatchingCertificate 7055) (by
    change pellLightFiniteCheck 7055 83 (10^275) 246 PellLightProduction.magnitudes_7055 = true
    exact PellLightProduction.checked_7055)

def pellFiniteCertificate_7063 : PellFiniteCertificate 7063 (10^275) :=
  pellFiniteCertificateOfLight 7063 (10^275) 84 152 (pellEmptyMatchingCertificate 7063) (by
    change pellLightFiniteCheck 7063 84 (10^275) 152 PellLightProduction.magnitudes_7063 = true
    exact PellLightProduction.checked_7063)

def pellFiniteCertificate_7071 : PellFiniteCertificate 7071 (10^275) :=
  pellFiniteCertificateOfLight 7071 (10^275) 84 486 (pellEmptyMatchingCertificate 7071) (by
    change pellLightFiniteCheck 7071 84 (10^275) 486 PellLightProduction.magnitudes_7071 = true
    exact PellLightProduction.checked_7071)

def pellFiniteCertificate_7079 : PellFiniteCertificate 7079 (10^275) :=
  pellFiniteCertificateOfLight 7079 (10^275) 84 442 pellGraphCertificate_7079 (by
    change pellLightFiniteCheck 7079 84 (10^275) 442 PellLightProduction.magnitudes_7079 = true
    exact PellLightProduction.checked_7079)

def pellFiniteCertificate_7087 : PellFiniteCertificate 7087 (10^275) :=
  pellFiniteCertificateOfLight 7087 (10^275) 84 544 (pellEmptyMatchingCertificate 7087) (by
    change pellLightFiniteCheck 7087 84 (10^275) 544 PellLightProduction.magnitudes_7087 = true
    exact PellLightProduction.checked_7087)

def pellFiniteCertificate_7095 : PellFiniteCertificate 7095 (10^275) :=
  pellFiniteCertificateOfLight 7095 (10^275) 84 317 (pellEmptyMatchingCertificate 7095) (by
    change pellLightFiniteCheck 7095 84 (10^275) 317 PellLightProduction.magnitudes_7095 = true
    exact PellLightProduction.checked_7095)

def pellFiniteCertificate_7103 : PellFiniteCertificate 7103 (10^275) :=
  pellFiniteCertificateOfLight 7103 (10^275) 84 671 pellGraphCertificate_7103 (by
    change pellLightFiniteCheck 7103 84 (10^275) 671 PellLightProduction.magnitudes_7103 = true
    exact PellLightProduction.checked_7103)

def pellFiniteCertificate_7111 : PellFiniteCertificate 7111 (10^275) :=
  pellFiniteCertificateOfLight 7111 (10^275) 84 552 (pellEmptyMatchingCertificate 7111) (by
    change pellLightFiniteCheck 7111 84 (10^275) 552 PellLightProduction.magnitudes_7111 = true
    exact PellLightProduction.checked_7111)

def pellFiniteCertificate_7127 : PellFiniteCertificate 7127 (10^275) :=
  pellFiniteCertificateOfLight 7127 (10^275) 84 484 pellGraphCertificate_7127 (by
    change pellLightFiniteCheck 7127 84 (10^275) 484 PellLightProduction.magnitudes_7127 = true
    exact PellLightProduction.checked_7127)

def pellFiniteCertificate_7135 : PellFiniteCertificate 7135 (10^275) :=
  pellFiniteCertificateOfLight 7135 (10^275) 84 473 (pellEmptyMatchingCertificate 7135) (by
    change pellLightFiniteCheck 7135 84 (10^275) 473 PellLightProduction.magnitudes_7135 = true
    exact PellLightProduction.checked_7135)

def pellFiniteCertificate_7143 : PellFiniteCertificate 7143 (10^275) :=
  pellFiniteCertificateOfLight 7143 (10^275) 84 531 (pellEmptyMatchingCertificate 7143) (by
    change pellLightFiniteCheck 7143 84 (10^275) 531 PellLightProduction.magnitudes_7143 = true
    exact PellLightProduction.checked_7143)

def pellFiniteCertificate_7151 : PellFiniteCertificate 7151 (10^275) :=
  pellFiniteCertificateOfLight 7151 (10^275) 84 567 pellGraphCertificate_7151 (by
    change pellLightFiniteCheck 7151 84 (10^275) 567 PellLightProduction.magnitudes_7151 = true
    exact PellLightProduction.checked_7151)

def pellFiniteCertificate_7159 : PellFiniteCertificate 7159 (10^275) :=
  pellFiniteCertificateOfLight 7159 (10^275) 84 555 pellGraphCertificate_7159 (by
    change pellLightFiniteCheck 7159 84 (10^275) 555 PellLightProduction.magnitudes_7159 = true
    exact PellLightProduction.checked_7159)

def pellFiniteCertificate_7167 : PellFiniteCertificate 7167 (10^275) :=
  pellFiniteCertificateOfLight 7167 (10^275) 84 564 (pellEmptyMatchingCertificate 7167) (by
    change pellLightFiniteCheck 7167 84 (10^275) 564 PellLightProduction.magnitudes_7167 = true
    exact PellLightProduction.checked_7167)

def pellFiniteCertificate_7183 : PellFiniteCertificate 7183 (10^275) :=
  pellFiniteCertificateOfLight 7183 (10^275) 84 545 (pellEmptyMatchingCertificate 7183) (by
    change pellLightFiniteCheck 7183 84 (10^275) 545 PellLightProduction.magnitudes_7183 = true
    exact PellLightProduction.checked_7183)

def pellFiniteCertificate_7199 : PellFiniteCertificate 7199 (10^275) :=
  pellFiniteCertificateOfLight 7199 (10^275) 84 502 pellGraphCertificate_7199 (by
    change pellLightFiniteCheck 7199 84 (10^275) 502 PellLightProduction.magnitudes_7199 = true
    exact PellLightProduction.checked_7199)

def pellFiniteCertificate_7207 : PellFiniteCertificate 7207 (10^275) :=
  pellFiniteCertificateOfLight 7207 (10^275) 84 543 pellGraphCertificate_7207 (by
    change pellLightFiniteCheck 7207 84 (10^275) 543 PellLightProduction.magnitudes_7207 = true
    exact PellLightProduction.checked_7207)

def pellFiniteCertificate_7215 : PellFiniteCertificate 7215 (10^275) :=
  pellFiniteCertificateOfLight 7215 (10^275) 84 316 (pellEmptyMatchingCertificate 7215) (by
    change pellLightFiniteCheck 7215 84 (10^275) 316 PellLightProduction.magnitudes_7215 = true
    exact PellLightProduction.checked_7215)

def pellFiniteCertificate_7223 : PellFiniteCertificate 7223 (10^275) :=
  pellFiniteCertificateOfLight 7223 (10^275) 84 264 pellGraphCertificate_7223 (by
    change pellLightFiniteCheck 7223 84 (10^275) 264 PellLightProduction.magnitudes_7223 = true
    exact PellLightProduction.checked_7223)

def pellFiniteCertificate_7231 : PellFiniteCertificate 7231 (10^275) :=
  pellFiniteCertificateOfLight 7231 (10^275) 85 569 (pellEmptyMatchingCertificate 7231) (by
    change pellLightFiniteCheck 7231 85 (10^275) 569 PellLightProduction.magnitudes_7231 = true
    exact PellLightProduction.checked_7231)

def pellFiniteCertificate_7239 : PellFiniteCertificate 7239 (10^275) :=
  pellFiniteCertificateOfLight 7239 (10^275) 85 534 (pellEmptyMatchingCertificate 7239) (by
    change pellLightFiniteCheck 7239 85 (10^275) 534 PellLightProduction.magnitudes_7239 = true
    exact PellLightProduction.checked_7239)

def pellFiniteCertificate_7247 : PellFiniteCertificate 7247 (10^275) :=
  pellFiniteCertificateOfLight 7247 (10^275) 85 528 pellGraphCertificate_7247 (by
    change pellLightFiniteCheck 7247 85 (10^275) 528 PellLightProduction.magnitudes_7247 = true
    exact PellLightProduction.checked_7247)

def pellFiniteCertificate_7255 : PellFiniteCertificate 7255 (10^275) :=
  pellFiniteCertificateOfLight 7255 (10^275) 85 518 (pellEmptyMatchingCertificate 7255) (by
    change pellLightFiniteCheck 7255 85 (10^275) 518 PellLightProduction.magnitudes_7255 = true
    exact PellLightProduction.checked_7255)

def pellFiniteCertificate_7271 : PellFiniteCertificate 7271 (10^275) :=
  pellFiniteCertificateOfLight 7271 (10^275) 85 504 (pellEmptyMatchingCertificate 7271) (by
    change pellLightFiniteCheck 7271 85 (10^275) 504 PellLightProduction.magnitudes_7271 = true
    exact PellLightProduction.checked_7271)

def pellFiniteCertificate_7279 : PellFiniteCertificate 7279 (10^275) :=
  pellFiniteCertificateOfLight 7279 (10^275) 85 364 (pellEmptyMatchingCertificate 7279) (by
    change pellLightFiniteCheck 7279 85 (10^275) 364 PellLightProduction.magnitudes_7279 = true
    exact PellLightProduction.checked_7279)

def pellFiniteCertificate_7287 : PellFiniteCertificate 7287 (10^275) :=
  pellFiniteCertificateOfLight 7287 (10^275) 85 475 (pellEmptyMatchingCertificate 7287) (by
    change pellLightFiniteCheck 7287 85 (10^275) 475 PellLightProduction.magnitudes_7287 = true
    exact PellLightProduction.checked_7287)

def pellFiniteCertificate_7295 : PellFiniteCertificate 7295 (10^275) :=
  pellFiniteCertificateOfLight 7295 (10^275) 85 396 (pellEmptyMatchingCertificate 7295) (by
    change pellLightFiniteCheck 7295 85 (10^275) 396 PellLightProduction.magnitudes_7295 = true
    exact PellLightProduction.checked_7295)

def pellFiniteCertificate_7303 : PellFiniteCertificate 7303 (10^275) :=
  pellFiniteCertificateOfLight 7303 (10^275) 85 558 (pellEmptyMatchingCertificate 7303) (by
    change pellLightFiniteCheck 7303 85 (10^275) 558 PellLightProduction.magnitudes_7303 = true
    exact PellLightProduction.checked_7303)

def pellFiniteCertificate_7311 : PellFiniteCertificate 7311 (10^275) :=
  pellFiniteCertificateOfLight 7311 (10^275) 85 359 (pellEmptyMatchingCertificate 7311) (by
    change pellLightFiniteCheck 7311 85 (10^275) 359 PellLightProduction.magnitudes_7311 = true
    exact PellLightProduction.checked_7311)

def pellFiniteCertificate_7319 : PellFiniteCertificate 7319 (10^275) :=
  pellFiniteCertificateOfLight 7319 (10^275) 85 660 (pellEmptyMatchingCertificate 7319) (by
    change pellLightFiniteCheck 7319 85 (10^275) 660 PellLightProduction.magnitudes_7319 = true
    exact PellLightProduction.checked_7319)

def pellFiniteCertificate_7327 : PellFiniteCertificate 7327 (10^275) :=
  pellFiniteCertificateOfLight 7327 (10^275) 85 594 pellGraphCertificate_7327 (by
    change pellLightFiniteCheck 7327 85 (10^275) 594 PellLightProduction.magnitudes_7327 = true
    exact PellLightProduction.checked_7327)

def pellFiniteCertificate_7343 : PellFiniteCertificate 7343 (10^275) :=
  pellFiniteCertificateOfLight 7343 (10^275) 85 467 pellGraphCertificate_7343 (by
    change pellLightFiniteCheck 7343 85 (10^275) 467 PellLightProduction.magnitudes_7343 = true
    exact PellLightProduction.checked_7343)

def pellFiniteCertificate_7351 : PellFiniteCertificate 7351 (10^275) :=
  pellFiniteCertificateOfLight 7351 (10^275) 85 532 pellGraphCertificate_7351 (by
    change pellLightFiniteCheck 7351 85 (10^275) 532 PellLightProduction.magnitudes_7351 = true
    exact PellLightProduction.checked_7351)

def pellFiniteCertificate_7359 : PellFiniteCertificate 7359 (10^275) :=
  pellFiniteCertificateOfLight 7359 (10^275) 85 544 (pellEmptyMatchingCertificate 7359) (by
    change pellLightFiniteCheck 7359 85 (10^275) 544 PellLightProduction.magnitudes_7359 = true
    exact PellLightProduction.checked_7359)

def pellFiniteCertificate_7367 : PellFiniteCertificate 7367 (10^275) :=
  pellFiniteCertificateOfLight 7367 (10^275) 85 530 (pellEmptyMatchingCertificate 7367) (by
    change pellLightFiniteCheck 7367 85 (10^275) 530 PellLightProduction.magnitudes_7367 = true
    exact PellLightProduction.checked_7367)

def pellFiniteCertificate_7383 : PellFiniteCertificate 7383 (10^275) :=
  pellFiniteCertificateOfLight 7383 (10^275) 85 360 (pellEmptyMatchingCertificate 7383) (by
    change pellLightFiniteCheck 7383 85 (10^275) 360 PellLightProduction.magnitudes_7383 = true
    exact PellLightProduction.checked_7383)

def pellFiniteCertificate_7391 : PellFiniteCertificate 7391 (10^275) :=
  pellFiniteCertificateOfLight 7391 (10^275) 85 580 (pellEmptyMatchingCertificate 7391) (by
    change pellLightFiniteCheck 7391 85 (10^275) 580 PellLightProduction.magnitudes_7391 = true
    exact PellLightProduction.checked_7391)

def pellFiniteCertificate_7415 : PellFiniteCertificate 7415 (10^275) :=
  pellFiniteCertificateOfLight 7415 (10^275) 86 204 (pellEmptyMatchingCertificate 7415) (by
    change pellLightFiniteCheck 7415 86 (10^275) 204 PellLightProduction.magnitudes_7415 = true
    exact PellLightProduction.checked_7415)

def pellFiniteCertificate_7423 : PellFiniteCertificate 7423 (10^275) :=
  pellFiniteCertificateOfLight 7423 (10^275) 86 486 (pellEmptyMatchingCertificate 7423) (by
    change pellLightFiniteCheck 7423 86 (10^275) 486 PellLightProduction.magnitudes_7423 = true
    exact PellLightProduction.checked_7423)

def pellFiniteCertificate_7431 : PellFiniteCertificate 7431 (10^275) :=
  pellFiniteCertificateOfLight 7431 (10^275) 86 550 (pellEmptyMatchingCertificate 7431) (by
    change pellLightFiniteCheck 7431 86 (10^275) 550 PellLightProduction.magnitudes_7431 = true
    exact PellLightProduction.checked_7431)

def pellFiniteCertificate_7439 : PellFiniteCertificate 7439 (10^275) :=
  pellFiniteCertificateOfLight 7439 (10^275) 86 193 (pellEmptyMatchingCertificate 7439) (by
    change pellLightFiniteCheck 7439 86 (10^275) 193 PellLightProduction.magnitudes_7439 = true
    exact PellLightProduction.checked_7439)

def pellFiniteCertificate_7447 : PellFiniteCertificate 7447 (10^275) :=
  pellFiniteCertificateOfLight 7447 (10^275) 86 582 (pellEmptyMatchingCertificate 7447) (by
    change pellLightFiniteCheck 7447 86 (10^275) 582 PellLightProduction.magnitudes_7447 = true
    exact PellLightProduction.checked_7447)

def pellFiniteCertificate_7455 : PellFiniteCertificate 7455 (10^275) :=
  pellFiniteCertificateOfLight 7455 (10^275) 86 384 (pellEmptyMatchingCertificate 7455) (by
    change pellLightFiniteCheck 7455 86 (10^275) 384 PellLightProduction.magnitudes_7455 = true
    exact PellLightProduction.checked_7455)

def pellFiniteCertificate_7463 : PellFiniteCertificate 7463 (10^275) :=
  pellFiniteCertificateOfLight 7463 (10^275) 86 570 pellGraphCertificate_7463 (by
    change pellLightFiniteCheck 7463 86 (10^275) 570 PellLightProduction.magnitudes_7463 = true
    exact PellLightProduction.checked_7463)

def pellFiniteCertificate_7471 : PellFiniteCertificate 7471 (10^275) :=
  pellFiniteCertificateOfLight 7471 (10^275) 86 555 pellGraphCertificate_7471 (by
    change pellLightFiniteCheck 7471 86 (10^275) 555 PellLightProduction.magnitudes_7471 = true
    exact PellLightProduction.checked_7471)

def pellFiniteCertificate_7487 : PellFiniteCertificate 7487 (10^275) :=
  pellFiniteCertificateOfLight 7487 (10^275) 86 552 pellGraphCertificate_7487 (by
    change pellLightFiniteCheck 7487 86 (10^275) 552 PellLightProduction.magnitudes_7487 = true
    exact PellLightProduction.checked_7487)

def pellFiniteCertificate_7495 : PellFiniteCertificate 7495 (10^275) :=
  pellFiniteCertificateOfLight 7495 (10^275) 86 545 (pellEmptyMatchingCertificate 7495) (by
    change pellLightFiniteCheck 7495 86 (10^275) 545 PellLightProduction.magnitudes_7495 = true
    exact PellLightProduction.checked_7495)

def pellFiniteCertificate_7503 : PellFiniteCertificate 7503 (10^275) :=
  pellFiniteCertificateOfLight 7503 (10^275) 86 720 (pellEmptyMatchingCertificate 7503) (by
    change pellLightFiniteCheck 7503 86 (10^275) 720 PellLightProduction.magnitudes_7503 = true
    exact PellLightProduction.checked_7503)

def pellFiniteCertificate_7511 : PellFiniteCertificate 7511 (10^275) :=
  pellFiniteCertificateOfLight 7511 (10^275) 86 404 (pellEmptyMatchingCertificate 7511) (by
    change pellLightFiniteCheck 7511 86 (10^275) 404 PellLightProduction.magnitudes_7511 = true
    exact PellLightProduction.checked_7511)

def pellFiniteCertificate_7519 : PellFiniteCertificate 7519 (10^275) :=
  pellFiniteCertificateOfLight 7519 (10^275) 86 533 pellGraphCertificate_7519 (by
    change pellLightFiniteCheck 7519 86 (10^275) 533 PellLightProduction.magnitudes_7519 = true
    exact PellLightProduction.checked_7519)

def pellFiniteCertificate_7527 : PellFiniteCertificate 7527 (10^275) :=
  pellFiniteCertificateOfLight 7527 (10^275) 86 425 (pellEmptyMatchingCertificate 7527) (by
    change pellLightFiniteCheck 7527 86 (10^275) 425 PellLightProduction.magnitudes_7527 = true
    exact PellLightProduction.checked_7527)

def pellFiniteCertificate_7535 : PellFiniteCertificate 7535 (10^275) :=
  pellFiniteCertificateOfLight 7535 (10^275) 86 405 (pellEmptyMatchingCertificate 7535) (by
    change pellLightFiniteCheck 7535 86 (10^275) 405 PellLightProduction.magnitudes_7535 = true
    exact PellLightProduction.checked_7535)

def pellFiniteCertificate_7543 : PellFiniteCertificate 7543 (10^275) :=
  pellFiniteCertificateOfLight 7543 (10^275) 86 596 (pellEmptyMatchingCertificate 7543) (by
    change pellLightFiniteCheck 7543 86 (10^275) 596 PellLightProduction.magnitudes_7543 = true
    exact PellLightProduction.checked_7543)

def pellFiniteCertificate_7559 : PellFiniteCertificate 7559 (10^275) :=
  pellFiniteCertificateOfLight 7559 (10^275) 86 538 pellGraphCertificate_7559 (by
    change pellLightFiniteCheck 7559 86 (10^275) 538 PellLightProduction.magnitudes_7559 = true
    exact PellLightProduction.checked_7559)

def pellFiniteCertificate_7567 : PellFiniteCertificate 7567 (10^275) :=
  pellFiniteCertificateOfLight 7567 (10^275) 86 262 pellGraphCertificate_7567 (by
    change pellLightFiniteCheck 7567 86 (10^275) 262 PellLightProduction.magnitudes_7567 = true
    exact PellLightProduction.checked_7567)

def pellFiniteCertificate_7583 : PellFiniteCertificate 7583 (10^275) :=
  pellFiniteCertificateOfLight 7583 (10^275) 87 541 pellGraphCertificate_7583 (by
    change pellLightFiniteCheck 7583 87 (10^275) 541 PellLightProduction.magnitudes_7583 = true
    exact PellLightProduction.checked_7583)

def pellFiniteCertificate_7591 : PellFiniteCertificate 7591 (10^275) :=
  pellFiniteCertificateOfLight 7591 (10^275) 87 437 pellGraphCertificate_7591 (by
    change pellLightFiniteCheck 7591 87 (10^275) 437 PellLightProduction.magnitudes_7591 = true
    exact PellLightProduction.checked_7591)

def pellFiniteCertificate_7599 : PellFiniteCertificate 7599 (10^275) :=
  pellFiniteCertificateOfLight 7599 (10^275) 87 570 (pellEmptyMatchingCertificate 7599) (by
    change pellLightFiniteCheck 7599 87 (10^275) 570 PellLightProduction.magnitudes_7599 = true
    exact PellLightProduction.checked_7599)

def pellFiniteCertificate_7607 : PellFiniteCertificate 7607 (10^275) :=
  pellFiniteCertificateOfLight 7607 (10^275) 87 472 pellGraphCertificate_7607 (by
    change pellLightFiniteCheck 7607 87 (10^275) 472 PellLightProduction.magnitudes_7607 = true
    exact PellLightProduction.checked_7607)

def pellFiniteCertificate_7615 : PellFiniteCertificate 7615 (10^275) :=
  pellFiniteCertificateOfLight 7615 (10^275) 87 572 (pellEmptyMatchingCertificate 7615) (by
    change pellLightFiniteCheck 7615 87 (10^275) 572 PellLightProduction.magnitudes_7615 = true
    exact PellLightProduction.checked_7615)

def pellFiniteCertificate_7631 : PellFiniteCertificate 7631 (10^275) :=
  pellFiniteCertificateOfLight 7631 (10^275) 87 528 (pellEmptyMatchingCertificate 7631) (by
    change pellLightFiniteCheck 7631 87 (10^275) 528 PellLightProduction.magnitudes_7631 = true
    exact PellLightProduction.checked_7631)

def pellFiniteCertificate_7639 : PellFiniteCertificate 7639 (10^275) :=
  pellFiniteCertificateOfLight 7639 (10^275) 87 437 pellGraphCertificate_7639 (by
    change pellLightFiniteCheck 7639 87 (10^275) 437 PellLightProduction.magnitudes_7639 = true
    exact PellLightProduction.checked_7639)

def pellFiniteCertificate_7647 : PellFiniteCertificate 7647 (10^275) :=
  pellFiniteCertificateOfLight 7647 (10^275) 87 552 (pellEmptyMatchingCertificate 7647) (by
    change pellLightFiniteCheck 7647 87 (10^275) 552 PellLightProduction.magnitudes_7647 = true
    exact PellLightProduction.checked_7647)

def pellFiniteCertificate_7655 : PellFiniteCertificate 7655 (10^275) :=
  pellFiniteCertificateOfLight 7655 (10^275) 87 250 (pellEmptyMatchingCertificate 7655) (by
    change pellLightFiniteCheck 7655 87 (10^275) 250 PellLightProduction.magnitudes_7655 = true
    exact PellLightProduction.checked_7655)

def pellFiniteCertificate_7663 : PellFiniteCertificate 7663 (10^275) :=
  pellFiniteCertificateOfLight 7663 (10^275) 87 442 (pellEmptyMatchingCertificate 7663) (by
    change pellLightFiniteCheck 7663 87 (10^275) 442 PellLightProduction.magnitudes_7663 = true
    exact PellLightProduction.checked_7663)

def pellFiniteCertificate_7671 : PellFiniteCertificate 7671 (10^275) :=
  pellFiniteCertificateOfLight 7671 (10^275) 87 412 (pellEmptyMatchingCertificate 7671) (by
    change pellLightFiniteCheck 7671 87 (10^275) 412 PellLightProduction.magnitudes_7671 = true
    exact PellLightProduction.checked_7671)

def pellFiniteCertificate_7679 : PellFiniteCertificate 7679 (10^275) :=
  pellFiniteCertificateOfLight 7679 (10^275) 87 589 pellGraphCertificate_7679 (by
    change pellLightFiniteCheck 7679 87 (10^275) 589 PellLightProduction.magnitudes_7679 = true
    exact PellLightProduction.checked_7679)

def pellFiniteCertificate_7687 : PellFiniteCertificate 7687 (10^275) :=
  pellFiniteCertificateOfLight 7687 (10^275) 87 551 pellGraphCertificate_7687 (by
    change pellLightFiniteCheck 7687 87 (10^275) 551 PellLightProduction.magnitudes_7687 = true
    exact PellLightProduction.checked_7687)

def pellFiniteCertificate_7703 : PellFiniteCertificate 7703 (10^275) :=
  pellFiniteCertificateOfLight 7703 (10^275) 87 544 pellGraphCertificate_7703 (by
    change pellLightFiniteCheck 7703 87 (10^275) 544 PellLightProduction.magnitudes_7703 = true
    exact PellLightProduction.checked_7703)

def pellFiniteCertificate_7711 : PellFiniteCertificate 7711 (10^275) :=
  pellFiniteCertificateOfLight 7711 (10^275) 87 378 (pellEmptyMatchingCertificate 7711) (by
    change pellLightFiniteCheck 7711 87 (10^275) 378 PellLightProduction.magnitudes_7711 = true
    exact PellLightProduction.checked_7711)

def pellFiniteCertificate_7719 : PellFiniteCertificate 7719 (10^275) :=
  pellFiniteCertificateOfLight 7719 (10^275) 87 304 (pellEmptyMatchingCertificate 7719) (by
    change pellLightFiniteCheck 7719 87 (10^275) 304 PellLightProduction.magnitudes_7719 = true
    exact PellLightProduction.checked_7719)

def pellFiniteCertificate_7727 : PellFiniteCertificate 7727 (10^275) :=
  pellFiniteCertificateOfLight 7727 (10^275) 87 520 pellGraphCertificate_7727 (by
    change pellLightFiniteCheck 7727 87 (10^275) 520 PellLightProduction.magnitudes_7727 = true
    exact PellLightProduction.checked_7727)

def pellFiniteCertificate_7735 : PellFiniteCertificate 7735 (10^275) :=
  pellFiniteCertificateOfLight 7735 (10^275) 87 448 (pellEmptyMatchingCertificate 7735) (by
    change pellLightFiniteCheck 7735 87 (10^275) 448 PellLightProduction.magnitudes_7735 = true
    exact PellLightProduction.checked_7735)

def pellFiniteCertificate_7743 : PellFiniteCertificate 7743 (10^275) :=
  pellFiniteCertificateOfLight 7743 (10^275) 87 244 (pellEmptyMatchingCertificate 7743) (by
    change pellLightFiniteCheck 7743 87 (10^275) 244 PellLightProduction.magnitudes_7743 = true
    exact PellLightProduction.checked_7743)

def pellFiniteCertificate_7751 : PellFiniteCertificate 7751 (10^275) :=
  pellFiniteCertificateOfLight 7751 (10^275) 88 499 pellGraphCertificate_7751 (by
    change pellLightFiniteCheck 7751 88 (10^275) 499 PellLightProduction.magnitudes_7751 = true
    exact PellLightProduction.checked_7751)

def pellFiniteCertificate_7759 : PellFiniteCertificate 7759 (10^275) :=
  pellFiniteCertificateOfLight 7759 (10^275) 88 566 pellGraphCertificate_7759 (by
    change pellLightFiniteCheck 7759 88 (10^275) 566 PellLightProduction.magnitudes_7759 = true
    exact PellLightProduction.checked_7759)

def pellFiniteCertificate_7783 : PellFiniteCertificate 7783 (10^275) :=
  pellFiniteCertificateOfLight 7783 (10^275) 88 450 (pellEmptyMatchingCertificate 7783) (by
    change pellLightFiniteCheck 7783 88 (10^275) 450 PellLightProduction.magnitudes_7783 = true
    exact PellLightProduction.checked_7783)

def pellFiniteCertificate_7799 : PellFiniteCertificate 7799 (10^275) :=
  pellFiniteCertificateOfLight 7799 (10^275) 88 455 (pellEmptyMatchingCertificate 7799) (by
    change pellLightFiniteCheck 7799 88 (10^275) 455 PellLightProduction.magnitudes_7799 = true
    exact PellLightProduction.checked_7799)

def pellFiniteCertificate_7807 : PellFiniteCertificate 7807 (10^275) :=
  pellFiniteCertificateOfLight 7807 (10^275) 88 488 (pellEmptyMatchingCertificate 7807) (by
    change pellLightFiniteCheck 7807 88 (10^275) 488 PellLightProduction.magnitudes_7807 = true
    exact PellLightProduction.checked_7807)

def pellFiniteCertificate_7815 : PellFiniteCertificate 7815 (10^275) :=
  pellFiniteCertificateOfLight 7815 (10^275) 88 398 (pellEmptyMatchingCertificate 7815) (by
    change pellLightFiniteCheck 7815 88 (10^275) 398 PellLightProduction.magnitudes_7815 = true
    exact PellLightProduction.checked_7815)

def pellFiniteCertificate_7823 : PellFiniteCertificate 7823 (10^275) :=
  pellFiniteCertificateOfLight 7823 (10^275) 88 579 pellGraphCertificate_7823 (by
    change pellLightFiniteCheck 7823 88 (10^275) 579 PellLightProduction.magnitudes_7823 = true
    exact PellLightProduction.checked_7823)

def pellFiniteCertificate_7831 : PellFiniteCertificate 7831 (10^275) :=
  pellFiniteCertificateOfLight 7831 (10^275) 88 510 pellGraphCertificate_7831 (by
    change pellLightFiniteCheck 7831 88 (10^275) 510 PellLightProduction.magnitudes_7831 = true
    exact PellLightProduction.checked_7831)

def pellFiniteCertificate_7847 : PellFiniteCertificate 7847 (10^275) :=
  pellFiniteCertificateOfLight 7847 (10^275) 88 494 (pellEmptyMatchingCertificate 7847) (by
    change pellLightFiniteCheck 7847 88 (10^275) 494 PellLightProduction.magnitudes_7847 = true
    exact PellLightProduction.checked_7847)

def pellFiniteCertificate_7855 : PellFiniteCertificate 7855 (10^275) :=
  pellFiniteCertificateOfLight 7855 (10^275) 88 591 (pellEmptyMatchingCertificate 7855) (by
    change pellLightFiniteCheck 7855 88 (10^275) 591 PellLightProduction.magnitudes_7855 = true
    exact PellLightProduction.checked_7855)

def pellFiniteCertificate_7863 : PellFiniteCertificate 7863 (10^275) :=
  pellFiniteCertificateOfLight 7863 (10^275) 88 575 (pellEmptyMatchingCertificate 7863) (by
    change pellLightFiniteCheck 7863 88 (10^275) 575 PellLightProduction.magnitudes_7863 = true
    exact PellLightProduction.checked_7863)

def pellFiniteCertificate_7871 : PellFiniteCertificate 7871 (10^275) :=
  pellFiniteCertificateOfLight 7871 (10^275) 88 523 (pellEmptyMatchingCertificate 7871) (by
    change pellLightFiniteCheck 7871 88 (10^275) 523 PellLightProduction.magnitudes_7871 = true
    exact PellLightProduction.checked_7871)

def pellFiniteCertificate_7879 : PellFiniteCertificate 7879 (10^275) :=
  pellFiniteCertificateOfLight 7879 (10^275) 88 542 pellGraphCertificate_7879 (by
    change pellLightFiniteCheck 7879 88 (10^275) 542 PellLightProduction.magnitudes_7879 = true
    exact PellLightProduction.checked_7879)

def pellFiniteCertificate_7887 : PellFiniteCertificate 7887 (10^275) :=
  pellFiniteCertificateOfLight 7887 (10^275) 88 494 (pellEmptyMatchingCertificate 7887) (by
    change pellLightFiniteCheck 7887 88 (10^275) 494 PellLightProduction.magnitudes_7887 = true
    exact PellLightProduction.checked_7887)

def pellFiniteCertificate_7895 : PellFiniteCertificate 7895 (10^275) :=
  pellFiniteCertificateOfLight 7895 (10^275) 88 525 (pellEmptyMatchingCertificate 7895) (by
    change pellLightFiniteCheck 7895 88 (10^275) 525 PellLightProduction.magnitudes_7895 = true
    exact PellLightProduction.checked_7895)

def pellFiniteCertificate_7903 : PellFiniteCertificate 7903 (10^275) :=
  pellFiniteCertificateOfLight 7903 (10^275) 88 484 pellGraphCertificate_7903 (by
    change pellLightFiniteCheck 7903 88 (10^275) 484 PellLightProduction.magnitudes_7903 = true
    exact PellLightProduction.checked_7903)

def pellFiniteCertificate_7919 : PellFiniteCertificate 7919 (10^275) :=
  pellFiniteCertificateOfLight 7919 (10^275) 88 262 pellGraphCertificate_7919 (by
    change pellLightFiniteCheck 7919 88 (10^275) 262 PellLightProduction.magnitudes_7919 = true
    exact PellLightProduction.checked_7919)

def pellFiniteCertificate_7927 : PellFiniteCertificate 7927 (10^275) :=
  pellFiniteCertificateOfLight 7927 (10^275) 89 472 pellGraphCertificate_7927 (by
    change pellLightFiniteCheck 7927 89 (10^275) 472 PellLightProduction.magnitudes_7927 = true
    exact PellLightProduction.checked_7927)

def pellFiniteCertificate_7951 : PellFiniteCertificate 7951 (10^275) :=
  pellFiniteCertificateOfLight 7951 (10^275) 89 544 pellGraphCertificate_7951 (by
    change pellLightFiniteCheck 7951 89 (10^275) 544 PellLightProduction.magnitudes_7951 = true
    exact PellLightProduction.checked_7951)

def pellFiniteCertificate_7959 : PellFiniteCertificate 7959 (10^275) :=
  pellFiniteCertificateOfLight 7959 (10^275) 89 524 (pellEmptyMatchingCertificate 7959) (by
    change pellLightFiniteCheck 7959 89 (10^275) 524 PellLightProduction.magnitudes_7959 = true
    exact PellLightProduction.checked_7959)

def pellFiniteCertificate_7967 : PellFiniteCertificate 7967 (10^275) :=
  pellFiniteCertificateOfLight 7967 (10^275) 89 305 pellGraphCertificate_7967 (by
    change pellLightFiniteCheck 7967 89 (10^275) 305 PellLightProduction.magnitudes_7967 = true
    exact PellLightProduction.checked_7967)

def pellFiniteCertificate_7991 : PellFiniteCertificate 7991 (10^275) :=
  pellFiniteCertificateOfLight 7991 (10^275) 89 600 (pellEmptyMatchingCertificate 7991) (by
    change pellLightFiniteCheck 7991 89 (10^275) 600 PellLightProduction.magnitudes_7991 = true
    exact PellLightProduction.checked_7991)

def pellFiniteCertificate_7999 : PellFiniteCertificate 7999 (10^275) :=
  pellFiniteCertificateOfLight 7999 (10^275) 89 473 (pellEmptyMatchingCertificate 7999) (by
    change pellLightFiniteCheck 7999 89 (10^275) 473 PellLightProduction.magnitudes_7999 = true
    exact PellLightProduction.checked_7999)

def pellFiniteCertificate_8007 : PellFiniteCertificate 8007 (10^275) :=
  pellFiniteCertificateOfLight 8007 (10^275) 89 400 (pellEmptyMatchingCertificate 8007) (by
    change pellLightFiniteCheck 8007 89 (10^275) 400 PellLightProduction.magnitudes_8007 = true
    exact PellLightProduction.checked_8007)

def pellFiniteCertificate_8015 : PellFiniteCertificate 8015 (10^275) :=
  pellFiniteCertificateOfLight 8015 (10^275) 89 463 (pellEmptyMatchingCertificate 8015) (by
    change pellLightFiniteCheck 8015 89 (10^275) 463 PellLightProduction.magnitudes_8015 = true
    exact PellLightProduction.checked_8015)

def pellFiniteCertificate_8023 : PellFiniteCertificate 8023 (10^275) :=
  pellFiniteCertificateOfLight 8023 (10^275) 89 372 pellGraphCertificate_8023 (by
    change pellLightFiniteCheck 8023 89 (10^275) 372 PellLightProduction.magnitudes_8023 = true
    exact PellLightProduction.checked_8023)

def pellFiniteCertificate_8031 : PellFiniteCertificate 8031 (10^275) :=
  pellFiniteCertificateOfLight 8031 (10^275) 89 499 (pellEmptyMatchingCertificate 8031) (by
    change pellLightFiniteCheck 8031 89 (10^275) 499 PellLightProduction.magnitudes_8031 = true
    exact PellLightProduction.checked_8031)

def pellFiniteCertificate_8039 : PellFiniteCertificate 8039 (10^275) :=
  pellFiniteCertificateOfLight 8039 (10^275) 89 545 pellGraphCertificate_8039 (by
    change pellLightFiniteCheck 8039 89 (10^275) 545 PellLightProduction.magnitudes_8039 = true
    exact PellLightProduction.checked_8039)

def pellFiniteCertificate_8047 : PellFiniteCertificate 8047 (10^275) :=
  pellFiniteCertificateOfLight 8047 (10^275) 89 500 (pellEmptyMatchingCertificate 8047) (by
    change pellLightFiniteCheck 8047 89 (10^275) 500 PellLightProduction.magnitudes_8047 = true
    exact PellLightProduction.checked_8047)

def pellFiniteCertificate_8063 : PellFiniteCertificate 8063 (10^275) :=
  pellFiniteCertificateOfLight 8063 (10^275) 89 572 (pellEmptyMatchingCertificate 8063) (by
    change pellLightFiniteCheck 8063 89 (10^275) 572 PellLightProduction.magnitudes_8063 = true
    exact PellLightProduction.checked_8063)

def pellFiniteCertificate_8071 : PellFiniteCertificate 8071 (10^275) :=
  pellFiniteCertificateOfLight 8071 (10^275) 89 499 pellGraphCertificate_8071 (by
    change pellLightFiniteCheck 8071 89 (10^275) 499 PellLightProduction.magnitudes_8071 = true
    exact PellLightProduction.checked_8071)

def pellFiniteCertificate_8079 : PellFiniteCertificate 8079 (10^275) :=
  pellFiniteCertificateOfLight 8079 (10^275) 89 534 (pellEmptyMatchingCertificate 8079) (by
    change pellLightFiniteCheck 8079 89 (10^275) 534 PellLightProduction.magnitudes_8079 = true
    exact PellLightProduction.checked_8079)

def pellFiniteCertificate_8087 : PellFiniteCertificate 8087 (10^275) :=
  pellFiniteCertificateOfLight 8087 (10^275) 89 547 pellGraphCertificate_8087 (by
    change pellLightFiniteCheck 8087 89 (10^275) 547 PellLightProduction.magnitudes_8087 = true
    exact PellLightProduction.checked_8087)

def pellFiniteCertificate_8095 : PellFiniteCertificate 8095 (10^275) :=
  pellFiniteCertificateOfLight 8095 (10^275) 89 288 (pellEmptyMatchingCertificate 8095) (by
    change pellLightFiniteCheck 8095 89 (10^275) 288 PellLightProduction.magnitudes_8095 = true
    exact PellLightProduction.checked_8095)

def pellFiniteCertificate_8103 : PellFiniteCertificate 8103 (10^275) :=
  pellFiniteCertificateOfLight 8103 (10^275) 90 136 (pellEmptyMatchingCertificate 8103) (by
    change pellLightFiniteCheck 8103 90 (10^275) 136 PellLightProduction.magnitudes_8103 = true
    exact PellLightProduction.checked_8103)

def pellFiniteCertificate_8111 : PellFiniteCertificate 8111 (10^275) :=
  pellFiniteCertificateOfLight 8111 (10^275) 90 509 pellGraphCertificate_8111 (by
    change pellLightFiniteCheck 8111 90 (10^275) 509 PellLightProduction.magnitudes_8111 = true
    exact PellLightProduction.checked_8111)

def pellFiniteCertificate_8119 : PellFiniteCertificate 8119 (10^275) :=
  pellFiniteCertificateOfLight 8119 (10^275) 90 483 pellGraphCertificate_8119 (by
    change pellLightFiniteCheck 8119 90 (10^275) 483 PellLightProduction.magnitudes_8119 = true
    exact PellLightProduction.checked_8119)

def pellFiniteCertificate_8135 : PellFiniteCertificate 8135 (10^275) :=
  pellFiniteCertificateOfLight 8135 (10^275) 90 560 (pellEmptyMatchingCertificate 8135) (by
    change pellLightFiniteCheck 8135 90 (10^275) 560 PellLightProduction.magnitudes_8135 = true
    exact PellLightProduction.checked_8135)

def pellFiniteCertificate_8143 : PellFiniteCertificate 8143 (10^275) :=
  pellFiniteCertificateOfLight 8143 (10^275) 90 578 pellGraphCertificate_8143 (by
    change pellLightFiniteCheck 8143 90 (10^275) 578 PellLightProduction.magnitudes_8143 = true
    exact PellLightProduction.checked_8143)

def pellFiniteCertificate_8151 : PellFiniteCertificate 8151 (10^275) :=
  pellFiniteCertificateOfLight 8151 (10^275) 90 536 (pellEmptyMatchingCertificate 8151) (by
    change pellLightFiniteCheck 8151 90 (10^275) 536 PellLightProduction.magnitudes_8151 = true
    exact PellLightProduction.checked_8151)

def pellFiniteCertificate_8159 : PellFiniteCertificate 8159 (10^275) :=
  pellFiniteCertificateOfLight 8159 (10^275) 90 467 pellGraphCertificate_8159 (by
    change pellLightFiniteCheck 8159 90 (10^275) 467 PellLightProduction.magnitudes_8159 = true
    exact PellLightProduction.checked_8159)

def pellFiniteCertificate_8167 : PellFiniteCertificate 8167 (10^275) :=
  pellFiniteCertificateOfLight 8167 (10^275) 90 582 pellGraphCertificate_8167 (by
    change pellLightFiniteCheck 8167 90 (10^275) 582 PellLightProduction.magnitudes_8167 = true
    exact PellLightProduction.checked_8167)

def pellFiniteCertificate_8191 : PellFiniteCertificate 8191 (10^275) :=
  pellFiniteCertificateOfLight 8191 (10^275) 90 543 pellGraphCertificate_8191 (by
    change pellLightFiniteCheck 8191 90 (10^275) 543 PellLightProduction.magnitudes_8191 = true
    exact PellLightProduction.checked_8191)

def pellFiniteCertificate_8207 : PellFiniteCertificate 8207 (10^275) :=
  pellFiniteCertificateOfLight 8207 (10^275) 90 439 (pellEmptyMatchingCertificate 8207) (by
    change pellLightFiniteCheck 8207 90 (10^275) 439 PellLightProduction.magnitudes_8207 = true
    exact PellLightProduction.checked_8207)

def pellFiniteCertificate_8215 : PellFiniteCertificate 8215 (10^275) :=
  pellFiniteCertificateOfLight 8215 (10^275) 90 558 (pellEmptyMatchingCertificate 8215) (by
    change pellLightFiniteCheck 8215 90 (10^275) 558 PellLightProduction.magnitudes_8215 = true
    exact PellLightProduction.checked_8215)

def pellFiniteCertificate_8223 : PellFiniteCertificate 8223 (10^275) :=
  pellFiniteCertificateOfLight 8223 (10^275) 90 654 (pellEmptyMatchingCertificate 8223) (by
    change pellLightFiniteCheck 8223 90 (10^275) 654 PellLightProduction.magnitudes_8223 = true
    exact PellLightProduction.checked_8223)

def pellFiniteCertificate_8231 : PellFiniteCertificate 8231 (10^275) :=
  pellFiniteCertificateOfLight 8231 (10^275) 90 591 pellGraphCertificate_8231 (by
    change pellLightFiniteCheck 8231 90 (10^275) 591 PellLightProduction.magnitudes_8231 = true
    exact PellLightProduction.checked_8231)

def pellFiniteCertificate_8239 : PellFiniteCertificate 8239 (10^275) :=
  pellFiniteCertificateOfLight 8239 (10^275) 90 456 (pellEmptyMatchingCertificate 8239) (by
    change pellLightFiniteCheck 8239 90 (10^275) 456 PellLightProduction.magnitudes_8239 = true
    exact PellLightProduction.checked_8239)

def pellFiniteCertificate_8247 : PellFiniteCertificate 8247 (10^275) :=
  pellFiniteCertificateOfLight 8247 (10^275) 90 538 (pellEmptyMatchingCertificate 8247) (by
    change pellLightFiniteCheck 8247 90 (10^275) 538 PellLightProduction.magnitudes_8247 = true
    exact PellLightProduction.checked_8247)

def pellFiniteCertificate_8255 : PellFiniteCertificate 8255 (10^275) :=
  pellFiniteCertificateOfLight 8255 (10^275) 90 352 (pellEmptyMatchingCertificate 8255) (by
    change pellLightFiniteCheck 8255 90 (10^275) 352 PellLightProduction.magnitudes_8255 = true
    exact PellLightProduction.checked_8255)

def pellFiniteCertificate_8263 : PellFiniteCertificate 8263 (10^275) :=
  pellFiniteCertificateOfLight 8263 (10^275) 90 506 pellGraphCertificate_8263 (by
    change pellLightFiniteCheck 8263 90 (10^275) 506 PellLightProduction.magnitudes_8263 = true
    exact PellLightProduction.checked_8263)

def pellFiniteCertificate_8279 : PellFiniteCertificate 8279 (10^275) :=
  pellFiniteCertificateOfLight 8279 (10^275) 90 260 pellGraphCertificate_8279 (by
    change pellLightFiniteCheck 8279 90 (10^275) 260 PellLightProduction.magnitudes_8279 = true
    exact PellLightProduction.checked_8279)

def pellFiniteCertificate_8287 : PellFiniteCertificate 8287 (10^275) :=
  pellFiniteCertificateOfLight 8287 (10^275) 91 563 pellGraphCertificate_8287 (by
    change pellLightFiniteCheck 8287 91 (10^275) 563 PellLightProduction.magnitudes_8287 = true
    exact PellLightProduction.checked_8287)

def pellFiniteCertificate_8295 : PellFiniteCertificate 8295 (10^275) :=
  pellFiniteCertificateOfLight 8295 (10^275) 91 162 (pellEmptyMatchingCertificate 8295) (by
    change pellLightFiniteCheck 8295 91 (10^275) 162 PellLightProduction.magnitudes_8295 = true
    exact PellLightProduction.checked_8295)

def pellFiniteCertificate_8311 : PellFiniteCertificate 8311 (10^275) :=
  pellFiniteCertificateOfLight 8311 (10^275) 91 276 pellGraphCertificate_8311 (by
    change pellLightFiniteCheck 8311 91 (10^275) 276 PellLightProduction.magnitudes_8311 = true
    exact PellLightProduction.checked_8311)

def pellFiniteCertificate_8319 : PellFiniteCertificate 8319 (10^275) :=
  pellFiniteCertificateOfLight 8319 (10^275) 91 461 (pellEmptyMatchingCertificate 8319) (by
    change pellLightFiniteCheck 8319 91 (10^275) 461 PellLightProduction.magnitudes_8319 = true
    exact PellLightProduction.checked_8319)

def pellFiniteCertificate_8327 : PellFiniteCertificate 8327 (10^275) :=
  pellFiniteCertificateOfLight 8327 (10^275) 91 525 (pellEmptyMatchingCertificate 8327) (by
    change pellLightFiniteCheck 8327 91 (10^275) 525 PellLightProduction.magnitudes_8327 = true
    exact PellLightProduction.checked_8327)

def pellFiniteCertificate_8335 : PellFiniteCertificate 8335 (10^275) :=
  pellFiniteCertificateOfLight 8335 (10^275) 91 516 (pellEmptyMatchingCertificate 8335) (by
    change pellLightFiniteCheck 8335 91 (10^275) 516 PellLightProduction.magnitudes_8335 = true
    exact PellLightProduction.checked_8335)

def pellFiniteCertificate_8351 : PellFiniteCertificate 8351 (10^275) :=
  pellFiniteCertificateOfLight 8351 (10^275) 91 596 pellGraphCertificate_8351 (by
    change pellLightFiniteCheck 8351 91 (10^275) 596 PellLightProduction.magnitudes_8351 = true
    exact PellLightProduction.checked_8351)

def pellFiniteCertificate_8359 : PellFiniteCertificate 8359 (10^275) :=
  pellFiniteCertificateOfLight 8359 (10^275) 91 568 (pellEmptyMatchingCertificate 8359) (by
    change pellLightFiniteCheck 8359 91 (10^275) 568 PellLightProduction.magnitudes_8359 = true
    exact PellLightProduction.checked_8359)

def pellFiniteCertificate_8367 : PellFiniteCertificate 8367 (10^275) :=
  pellFiniteCertificateOfLight 8367 (10^275) 91 527 (pellEmptyMatchingCertificate 8367) (by
    change pellLightFiniteCheck 8367 91 (10^275) 527 PellLightProduction.magnitudes_8367 = true
    exact PellLightProduction.checked_8367)

def pellFiniteCertificate_8383 : PellFiniteCertificate 8383 (10^275) :=
  pellFiniteCertificateOfLight 8383 (10^275) 91 497 (pellEmptyMatchingCertificate 8383) (by
    change pellLightFiniteCheck 8383 91 (10^275) 497 PellLightProduction.magnitudes_8383 = true
    exact PellLightProduction.checked_8383)

def pellFiniteCertificate_8391 : PellFiniteCertificate 8391 (10^275) :=
  pellFiniteCertificateOfLight 8391 (10^275) 91 517 (pellEmptyMatchingCertificate 8391) (by
    change pellLightFiniteCheck 8391 91 (10^275) 517 PellLightProduction.magnitudes_8391 = true
    exact PellLightProduction.checked_8391)

def pellFiniteCertificate_8399 : PellFiniteCertificate 8399 (10^275) :=
  pellFiniteCertificateOfLight 8399 (10^275) 91 700 (pellEmptyMatchingCertificate 8399) (by
    change pellLightFiniteCheck 8399 91 (10^275) 700 PellLightProduction.magnitudes_8399 = true
    exact PellLightProduction.checked_8399)

def pellFiniteCertificate_8407 : PellFiniteCertificate 8407 (10^275) :=
  pellFiniteCertificateOfLight 8407 (10^275) 91 384 (pellEmptyMatchingCertificate 8407) (by
    change pellLightFiniteCheck 8407 91 (10^275) 384 PellLightProduction.magnitudes_8407 = true
    exact PellLightProduction.checked_8407)

def pellFiniteCertificate_8423 : PellFiniteCertificate 8423 (10^275) :=
  pellFiniteCertificateOfLight 8423 (10^275) 91 560 pellGraphCertificate_8423 (by
    change pellLightFiniteCheck 8423 91 (10^275) 560 PellLightProduction.magnitudes_8423 = true
    exact PellLightProduction.checked_8423)

def pellFiniteCertificate_8431 : PellFiniteCertificate 8431 (10^275) :=
  pellFiniteCertificateOfLight 8431 (10^275) 91 534 pellGraphCertificate_8431 (by
    change pellLightFiniteCheck 8431 91 (10^275) 534 PellLightProduction.magnitudes_8431 = true
    exact PellLightProduction.checked_8431)

def pellFiniteCertificate_8439 : PellFiniteCertificate 8439 (10^275) :=
  pellFiniteCertificateOfLight 8439 (10^275) 91 550 (pellEmptyMatchingCertificate 8439) (by
    change pellLightFiniteCheck 8439 91 (10^275) 550 PellLightProduction.magnitudes_8439 = true
    exact PellLightProduction.checked_8439)

def pellFiniteCertificate_8447 : PellFiniteCertificate 8447 (10^275) :=
  pellFiniteCertificateOfLight 8447 (10^275) 91 392 pellGraphCertificate_8447 (by
    change pellLightFiniteCheck 8447 91 (10^275) 392 PellLightProduction.magnitudes_8447 = true
    exact PellLightProduction.checked_8447)

def pellFiniteCertificate_8455 : PellFiniteCertificate 8455 (10^275) :=
  pellFiniteCertificateOfLight 8455 (10^275) 91 452 (pellEmptyMatchingCertificate 8455) (by
    change pellLightFiniteCheck 8455 91 (10^275) 452 PellLightProduction.magnitudes_8455 = true
    exact PellLightProduction.checked_8455)

def pellFiniteCertificate_8463 : PellFiniteCertificate 8463 (10^275) :=
  pellFiniteCertificateOfLight 8463 (10^275) 91 242 (pellEmptyMatchingCertificate 8463) (by
    change pellLightFiniteCheck 8463 91 (10^275) 242 PellLightProduction.magnitudes_8463 = true
    exact PellLightProduction.checked_8463)

def pellFiniteCertificate_8471 : PellFiniteCertificate 8471 (10^275) :=
  pellFiniteCertificateOfLight 8471 (10^275) 92 427 (pellEmptyMatchingCertificate 8471) (by
    change pellLightFiniteCheck 8471 92 (10^275) 427 PellLightProduction.magnitudes_8471 = true
    exact PellLightProduction.checked_8471)

def pellFiniteCertificate_8479 : PellFiniteCertificate 8479 (10^275) :=
  pellFiniteCertificateOfLight 8479 (10^275) 92 432 (pellEmptyMatchingCertificate 8479) (by
    change pellLightFiniteCheck 8479 92 (10^275) 432 PellLightProduction.magnitudes_8479 = true
    exact PellLightProduction.checked_8479)

def pellFiniteCertificate_8495 : PellFiniteCertificate 8495 (10^275) :=
  pellFiniteCertificateOfLight 8495 (10^275) 92 501 (pellEmptyMatchingCertificate 8495) (by
    change pellLightFiniteCheck 8495 92 (10^275) 501 PellLightProduction.magnitudes_8495 = true
    exact PellLightProduction.checked_8495)

def pellFiniteCertificate_8503 : PellFiniteCertificate 8503 (10^275) :=
  pellFiniteCertificateOfLight 8503 (10^275) 92 603 (pellEmptyMatchingCertificate 8503) (by
    change pellLightFiniteCheck 8503 92 (10^275) 603 PellLightProduction.magnitudes_8503 = true
    exact PellLightProduction.checked_8503)

def pellFiniteCertificate_8511 : PellFiniteCertificate 8511 (10^275) :=
  pellFiniteCertificateOfLight 8511 (10^275) 92 432 (pellEmptyMatchingCertificate 8511) (by
    change pellLightFiniteCheck 8511 92 (10^275) 432 PellLightProduction.magnitudes_8511 = true
    exact PellLightProduction.checked_8511)

def pellFiniteCertificate_8519 : PellFiniteCertificate 8519 (10^275) :=
  pellFiniteCertificateOfLight 8519 (10^275) 92 497 pellGraphCertificate_8519 (by
    change pellLightFiniteCheck 8519 92 (10^275) 497 PellLightProduction.magnitudes_8519 = true
    exact PellLightProduction.checked_8519)

def pellFiniteCertificate_8527 : PellFiniteCertificate 8527 (10^275) :=
  pellFiniteCertificateOfLight 8527 (10^275) 92 520 pellGraphCertificate_8527 (by
    change pellLightFiniteCheck 8527 92 (10^275) 520 PellLightProduction.magnitudes_8527 = true
    exact PellLightProduction.checked_8527)

def pellFiniteCertificate_8535 : PellFiniteCertificate 8535 (10^275) :=
  pellFiniteCertificateOfLight 8535 (10^275) 92 588 (pellEmptyMatchingCertificate 8535) (by
    change pellLightFiniteCheck 8535 92 (10^275) 588 PellLightProduction.magnitudes_8535 = true
    exact PellLightProduction.checked_8535)

def pellFiniteCertificate_8543 : PellFiniteCertificate 8543 (10^275) :=
  pellFiniteCertificateOfLight 8543 (10^275) 92 370 pellGraphCertificate_8543 (by
    change pellLightFiniteCheck 8543 92 (10^275) 370 PellLightProduction.magnitudes_8543 = true
    exact PellLightProduction.checked_8543)

def pellFiniteCertificate_8551 : PellFiniteCertificate 8551 (10^275) :=
  pellFiniteCertificateOfLight 8551 (10^275) 92 535 pellGraphCertificate_8551 (by
    change pellLightFiniteCheck 8551 92 (10^275) 535 PellLightProduction.magnitudes_8551 = true
    exact PellLightProduction.checked_8551)

def pellFiniteCertificate_8567 : PellFiniteCertificate 8567 (10^275) :=
  pellFiniteCertificateOfLight 8567 (10^275) 92 474 (pellEmptyMatchingCertificate 8567) (by
    change pellLightFiniteCheck 8567 92 (10^275) 474 PellLightProduction.magnitudes_8567 = true
    exact PellLightProduction.checked_8567)

def pellFiniteCertificate_8583 : PellFiniteCertificate 8583 (10^275) :=
  pellFiniteCertificateOfLight 8583 (10^275) 92 533 (pellEmptyMatchingCertificate 8583) (by
    change pellLightFiniteCheck 8583 92 (10^275) 533 PellLightProduction.magnitudes_8583 = true
    exact PellLightProduction.checked_8583)

def pellFiniteCertificate_8599 : PellFiniteCertificate 8599 (10^275) :=
  pellFiniteCertificateOfLight 8599 (10^275) 92 515 pellGraphCertificate_8599 (by
    change pellLightFiniteCheck 8599 92 (10^275) 515 PellLightProduction.magnitudes_8599 = true
    exact PellLightProduction.checked_8599)

def pellFiniteCertificate_8607 : PellFiniteCertificate 8607 (10^275) :=
  pellFiniteCertificateOfLight 8607 (10^275) 92 474 (pellEmptyMatchingCertificate 8607) (by
    change pellLightFiniteCheck 8607 92 (10^275) 474 PellLightProduction.magnitudes_8607 = true
    exact PellLightProduction.checked_8607)

def pellFiniteCertificate_8615 : PellFiniteCertificate 8615 (10^275) :=
  pellFiniteCertificateOfLight 8615 (10^275) 92 675 (pellEmptyMatchingCertificate 8615) (by
    change pellLightFiniteCheck 8615 92 (10^275) 675 PellLightProduction.magnitudes_8615 = true
    exact PellLightProduction.checked_8615)

def pellFiniteCertificate_8623 : PellFiniteCertificate 8623 (10^275) :=
  pellFiniteCertificateOfLight 8623 (10^275) 92 547 pellGraphCertificate_8623 (by
    change pellLightFiniteCheck 8623 92 (10^275) 547 PellLightProduction.magnitudes_8623 = true
    exact PellLightProduction.checked_8623)

def pellFiniteCertificate_8639 : PellFiniteCertificate 8639 (10^275) :=
  pellFiniteCertificateOfLight 8639 (10^275) 92 499 (pellEmptyMatchingCertificate 8639) (by
    change pellLightFiniteCheck 8639 92 (10^275) 499 PellLightProduction.magnitudes_8639 = true
    exact PellLightProduction.checked_8639)

def pellFiniteCertificate_8647 : PellFiniteCertificate 8647 (10^275) :=
  pellFiniteCertificateOfLight 8647 (10^275) 92 258 pellGraphCertificate_8647 (by
    change pellLightFiniteCheck 8647 92 (10^275) 258 PellLightProduction.magnitudes_8647 = true
    exact PellLightProduction.checked_8647)

def pellFiniteCertificate_8655 : PellFiniteCertificate 8655 (10^275) :=
  pellFiniteCertificateOfLight 8655 (10^275) 93 146 (pellEmptyMatchingCertificate 8655) (by
    change pellLightFiniteCheck 8655 93 (10^275) 146 PellLightProduction.magnitudes_8655 = true
    exact PellLightProduction.checked_8655)

def pellFiniteCertificate_8663 : PellFiniteCertificate 8663 (10^275) :=
  pellFiniteCertificateOfLight 8663 (10^275) 93 478 pellGraphCertificate_8663 (by
    change pellLightFiniteCheck 8663 93 (10^275) 478 PellLightProduction.magnitudes_8663 = true
    exact PellLightProduction.checked_8663)

def pellFiniteCertificate_8671 : PellFiniteCertificate 8671 (10^275) :=
  pellFiniteCertificateOfLight 8671 (10^275) 93 451 (pellEmptyMatchingCertificate 8671) (by
    change pellLightFiniteCheck 8671 93 (10^275) 451 PellLightProduction.magnitudes_8671 = true
    exact PellLightProduction.checked_8671)

def pellFiniteCertificate_8679 : PellFiniteCertificate 8679 (10^275) :=
  pellFiniteCertificateOfLight 8679 (10^275) 93 539 (pellEmptyMatchingCertificate 8679) (by
    change pellLightFiniteCheck 8679 93 (10^275) 539 PellLightProduction.magnitudes_8679 = true
    exact PellLightProduction.checked_8679)

def pellFiniteCertificate_8687 : PellFiniteCertificate 8687 (10^275) :=
  pellFiniteCertificateOfLight 8687 (10^275) 93 288 pellGraphCertificate_8687 (by
    change pellLightFiniteCheck 8687 93 (10^275) 288 PellLightProduction.magnitudes_8687 = true
    exact PellLightProduction.checked_8687)

def pellFiniteCertificate_8695 : PellFiniteCertificate 8695 (10^275) :=
  pellFiniteCertificateOfLight 8695 (10^275) 93 459 (pellEmptyMatchingCertificate 8695) (by
    change pellLightFiniteCheck 8695 93 (10^275) 459 PellLightProduction.magnitudes_8695 = true
    exact PellLightProduction.checked_8695)

def pellFiniteCertificate_8711 : PellFiniteCertificate 8711 (10^275) :=
  pellFiniteCertificateOfLight 8711 (10^275) 93 200 (pellEmptyMatchingCertificate 8711) (by
    change pellLightFiniteCheck 8711 93 (10^275) 200 PellLightProduction.magnitudes_8711 = true
    exact PellLightProduction.checked_8711)

def pellFiniteCertificate_8719 : PellFiniteCertificate 8719 (10^275) :=
  pellFiniteCertificateOfLight 8719 (10^275) 93 562 pellGraphCertificate_8719 (by
    change pellLightFiniteCheck 8719 93 (10^275) 562 PellLightProduction.magnitudes_8719 = true
    exact PellLightProduction.checked_8719)

def pellFiniteCertificate_8727 : PellFiniteCertificate 8727 (10^275) :=
  pellFiniteCertificateOfLight 8727 (10^275) 93 495 (pellEmptyMatchingCertificate 8727) (by
    change pellLightFiniteCheck 8727 93 (10^275) 495 PellLightProduction.magnitudes_8727 = true
    exact PellLightProduction.checked_8727)

def pellFiniteCertificate_8735 : PellFiniteCertificate 8735 (10^275) :=
  pellFiniteCertificateOfLight 8735 (10^275) 93 380 (pellEmptyMatchingCertificate 8735) (by
    change pellLightFiniteCheck 8735 93 (10^275) 380 PellLightProduction.magnitudes_8735 = true
    exact PellLightProduction.checked_8735)

def pellFiniteCertificate_8743 : PellFiniteCertificate 8743 (10^275) :=
  pellFiniteCertificateOfLight 8743 (10^275) 93 496 pellGraphCertificate_8743 (by
    change pellLightFiniteCheck 8743 93 (10^275) 496 PellLightProduction.magnitudes_8743 = true
    exact PellLightProduction.checked_8743)

def pellFiniteCertificate_8751 : PellFiniteCertificate 8751 (10^275) :=
  pellFiniteCertificateOfLight 8751 (10^275) 93 621 (pellEmptyMatchingCertificate 8751) (by
    change pellLightFiniteCheck 8751 93 (10^275) 621 PellLightProduction.magnitudes_8751 = true
    exact PellLightProduction.checked_8751)

def pellFiniteCertificate_8759 : PellFiniteCertificate 8759 (10^275) :=
  pellFiniteCertificateOfLight 8759 (10^275) 93 591 (pellEmptyMatchingCertificate 8759) (by
    change pellLightFiniteCheck 8759 93 (10^275) 591 PellLightProduction.magnitudes_8759 = true
    exact PellLightProduction.checked_8759)

def pellFiniteCertificate_8767 : PellFiniteCertificate 8767 (10^275) :=
  pellFiniteCertificateOfLight 8767 (10^275) 93 592 (pellEmptyMatchingCertificate 8767) (by
    change pellLightFiniteCheck 8767 93 (10^275) 592 PellLightProduction.magnitudes_8767 = true
    exact PellLightProduction.checked_8767)

def pellFiniteCertificate_8783 : PellFiniteCertificate 8783 (10^275) :=
  pellFiniteCertificateOfLight 8783 (10^275) 93 570 pellGraphCertificate_8783 (by
    change pellLightFiniteCheck 8783 93 (10^275) 570 PellLightProduction.magnitudes_8783 = true
    exact PellLightProduction.checked_8783)

def pellFiniteCertificate_8791 : PellFiniteCertificate 8791 (10^275) :=
  pellFiniteCertificateOfLight 8791 (10^275) 93 499 (pellEmptyMatchingCertificate 8791) (by
    change pellLightFiniteCheck 8791 93 (10^275) 499 PellLightProduction.magnitudes_8791 = true
    exact PellLightProduction.checked_8791)

def pellFiniteCertificate_8799 : PellFiniteCertificate 8799 (10^275) :=
  pellFiniteCertificateOfLight 8799 (10^275) 93 342 (pellEmptyMatchingCertificate 8799) (by
    change pellLightFiniteCheck 8799 93 (10^275) 342 PellLightProduction.magnitudes_8799 = true
    exact PellLightProduction.checked_8799)

def pellFiniteCertificate_8807 : PellFiniteCertificate 8807 (10^275) :=
  pellFiniteCertificateOfLight 8807 (10^275) 93 608 pellGraphCertificate_8807 (by
    change pellLightFiniteCheck 8807 93 (10^275) 608 PellLightProduction.magnitudes_8807 = true
    exact PellLightProduction.checked_8807)

def pellFiniteCertificate_8815 : PellFiniteCertificate 8815 (10^275) :=
  pellFiniteCertificateOfLight 8815 (10^275) 93 402 (pellEmptyMatchingCertificate 8815) (by
    change pellLightFiniteCheck 8815 93 (10^275) 402 PellLightProduction.magnitudes_8815 = true
    exact PellLightProduction.checked_8815)

def pellFiniteCertificate_8823 : PellFiniteCertificate 8823 (10^275) :=
  pellFiniteCertificateOfLight 8823 (10^275) 93 437 (pellEmptyMatchingCertificate 8823) (by
    change pellLightFiniteCheck 8823 93 (10^275) 437 PellLightProduction.magnitudes_8823 = true
    exact PellLightProduction.checked_8823)

def pellFiniteCertificate_8831 : PellFiniteCertificate 8831 (10^275) :=
  pellFiniteCertificateOfLight 8831 (10^275) 93 528 pellGraphCertificate_8831 (by
    change pellLightFiniteCheck 8831 93 (10^275) 528 PellLightProduction.magnitudes_8831 = true
    exact PellLightProduction.checked_8831)

def pellFiniteCertificate_8839 : PellFiniteCertificate 8839 (10^275) :=
  pellFiniteCertificateOfLight 8839 (10^275) 94 555 pellGraphCertificate_8839 (by
    change pellLightFiniteCheck 8839 94 (10^275) 555 PellLightProduction.magnitudes_8839 = true
    exact PellLightProduction.checked_8839)

def pellFiniteCertificate_8855 : PellFiniteCertificate 8855 (10^275) :=
  pellFiniteCertificateOfLight 8855 (10^275) 94 256 (pellEmptyMatchingCertificate 8855) (by
    change pellLightFiniteCheck 8855 94 (10^275) 256 PellLightProduction.magnitudes_8855 = true
    exact PellLightProduction.checked_8855)

def pellFiniteCertificate_8863 : PellFiniteCertificate 8863 (10^275) :=
  pellFiniteCertificateOfLight 8863 (10^275) 94 392 pellGraphCertificate_8863 (by
    change pellLightFiniteCheck 8863 94 (10^275) 392 PellLightProduction.magnitudes_8863 = true
    exact PellLightProduction.checked_8863)

def pellFiniteCertificate_8871 : PellFiniteCertificate 8871 (10^275) :=
  pellFiniteCertificateOfLight 8871 (10^275) 94 501 (pellEmptyMatchingCertificate 8871) (by
    change pellLightFiniteCheck 8871 94 (10^275) 501 PellLightProduction.magnitudes_8871 = true
    exact PellLightProduction.checked_8871)

def pellFiniteCertificate_8879 : PellFiniteCertificate 8879 (10^275) :=
  pellFiniteCertificateOfLight 8879 (10^275) 94 581 (pellEmptyMatchingCertificate 8879) (by
    change pellLightFiniteCheck 8879 94 (10^275) 581 PellLightProduction.magnitudes_8879 = true
    exact PellLightProduction.checked_8879)

def pellFiniteCertificate_8887 : PellFiniteCertificate 8887 (10^275) :=
  pellFiniteCertificateOfLight 8887 (10^275) 94 543 pellGraphCertificate_8887 (by
    change pellLightFiniteCheck 8887 94 (10^275) 543 PellLightProduction.magnitudes_8887 = true
    exact PellLightProduction.checked_8887)

def pellFiniteCertificate_8895 : PellFiniteCertificate 8895 (10^275) :=
  pellFiniteCertificateOfLight 8895 (10^275) 94 490 (pellEmptyMatchingCertificate 8895) (by
    change pellLightFiniteCheck 8895 94 (10^275) 490 PellLightProduction.magnitudes_8895 = true
    exact PellLightProduction.checked_8895)

def pellFiniteCertificate_8903 : PellFiniteCertificate 8903 (10^275) :=
  pellFiniteCertificateOfLight 8903 (10^275) 94 507 (pellEmptyMatchingCertificate 8903) (by
    change pellLightFiniteCheck 8903 94 (10^275) 507 PellLightProduction.magnitudes_8903 = true
    exact PellLightProduction.checked_8903)

def pellFiniteCertificate_8911 : PellFiniteCertificate 8911 (10^275) :=
  pellFiniteCertificateOfLight 8911 (10^275) 94 499 (pellEmptyMatchingCertificate 8911) (by
    change pellLightFiniteCheck 8911 94 (10^275) 499 PellLightProduction.magnitudes_8911 = true
    exact PellLightProduction.checked_8911)

def pellFiniteCertificate_8927 : PellFiniteCertificate 8927 (10^275) :=
  pellFiniteCertificateOfLight 8927 (10^275) 94 413 pellGraphCertificate_8927 (by
    change pellLightFiniteCheck 8927 94 (10^275) 413 PellLightProduction.magnitudes_8927 = true
    exact PellLightProduction.checked_8927)

def pellFiniteCertificate_8935 : PellFiniteCertificate 8935 (10^275) :=
  pellFiniteCertificateOfLight 8935 (10^275) 94 524 (pellEmptyMatchingCertificate 8935) (by
    change pellLightFiniteCheck 8935 94 (10^275) 524 PellLightProduction.magnitudes_8935 = true
    exact PellLightProduction.checked_8935)

def pellFiniteCertificate_8943 : PellFiniteCertificate 8943 (10^275) :=
  pellFiniteCertificateOfLight 8943 (10^275) 94 513 (pellEmptyMatchingCertificate 8943) (by
    change pellLightFiniteCheck 8943 94 (10^275) 513 PellLightProduction.magnitudes_8943 = true
    exact PellLightProduction.checked_8943)

def pellFiniteCertificate_8951 : PellFiniteCertificate 8951 (10^275) :=
  pellFiniteCertificateOfLight 8951 (10^275) 94 573 pellGraphCertificate_8951 (by
    change pellLightFiniteCheck 8951 94 (10^275) 573 PellLightProduction.magnitudes_8951 = true
    exact PellLightProduction.checked_8951)

def pellFiniteCertificate_8983 : PellFiniteCertificate 8983 (10^275) :=
  pellFiniteCertificateOfLight 8983 (10^275) 94 579 (pellEmptyMatchingCertificate 8983) (by
    change pellLightFiniteCheck 8983 94 (10^275) 579 PellLightProduction.magnitudes_8983 = true
    exact PellLightProduction.checked_8983)

def pellFiniteCertificate_8999 : PellFiniteCertificate 8999 (10^275) :=
  pellFiniteCertificateOfLight 8999 (10^275) 94 574 pellGraphCertificate_8999 (by
    change pellLightFiniteCheck 8999 94 (10^275) 574 PellLightProduction.magnitudes_8999 = true
    exact PellLightProduction.checked_8999)

def pellFiniteCertificate_9007 : PellFiniteCertificate 9007 (10^275) :=
  pellFiniteCertificateOfLight 9007 (10^275) 94 491 pellGraphCertificate_9007 (by
    change pellLightFiniteCheck 9007 94 (10^275) 491 PellLightProduction.magnitudes_9007 = true
    exact PellLightProduction.checked_9007)

def pellFiniteCertificate_9015 : PellFiniteCertificate 9015 (10^275) :=
  pellFiniteCertificateOfLight 9015 (10^275) 94 308 (pellEmptyMatchingCertificate 9015) (by
    change pellLightFiniteCheck 9015 94 (10^275) 308 PellLightProduction.magnitudes_9015 = true
    exact PellLightProduction.checked_9015)

def pellFiniteCertificate_9023 : PellFiniteCertificate 9023 (10^275) :=
  pellFiniteCertificateOfLight 9023 (10^275) 94 258 pellGraphCertificate_9023 (by
    change pellLightFiniteCheck 9023 94 (10^275) 258 PellLightProduction.magnitudes_9023 = true
    exact PellLightProduction.checked_9023)

def pellFiniteCertificate_9031 : PellFiniteCertificate 9031 (10^275) :=
  pellFiniteCertificateOfLight 9031 (10^275) 95 530 (pellEmptyMatchingCertificate 9031) (by
    change pellLightFiniteCheck 9031 95 (10^275) 530 PellLightProduction.magnitudes_9031 = true
    exact PellLightProduction.checked_9031)

def pellFiniteCertificate_9039 : PellFiniteCertificate 9039 (10^275) :=
  pellFiniteCertificateOfLight 9039 (10^275) 95 414 (pellEmptyMatchingCertificate 9039) (by
    change pellLightFiniteCheck 9039 95 (10^275) 414 PellLightProduction.magnitudes_9039 = true
    exact PellLightProduction.checked_9039)

def pellFiniteCertificate_9047 : PellFiniteCertificate 9047 (10^275) :=
  pellFiniteCertificateOfLight 9047 (10^275) 95 579 (pellEmptyMatchingCertificate 9047) (by
    change pellLightFiniteCheck 9047 95 (10^275) 579 PellLightProduction.magnitudes_9047 = true
    exact PellLightProduction.checked_9047)

def pellFiniteCertificate_9055 : PellFiniteCertificate 9055 (10^275) :=
  pellFiniteCertificateOfLight 9055 (10^275) 95 489 (pellEmptyMatchingCertificate 9055) (by
    change pellLightFiniteCheck 9055 95 (10^275) 489 PellLightProduction.magnitudes_9055 = true
    exact PellLightProduction.checked_9055)

def pellFiniteCertificate_9071 : PellFiniteCertificate 9071 (10^275) :=
  pellFiniteCertificateOfLight 9071 (10^275) 95 506 pellGraphCertificate_9071 (by
    change pellLightFiniteCheck 9071 95 (10^275) 506 PellLightProduction.magnitudes_9071 = true
    exact PellLightProduction.checked_9071)

def pellFiniteCertificate_9079 : PellFiniteCertificate 9079 (10^275) :=
  pellFiniteCertificateOfLight 9079 (10^275) 95 321 pellGraphCertificate_9079 (by
    change pellLightFiniteCheck 9079 95 (10^275) 321 PellLightProduction.magnitudes_9079 = true
    exact PellLightProduction.checked_9079)

def pellFiniteCertificate_9087 : PellFiniteCertificate 9087 (10^275) :=
  pellFiniteCertificateOfLight 9087 (10^275) 95 249 (pellEmptyMatchingCertificate 9087) (by
    change pellLightFiniteCheck 9087 95 (10^275) 249 PellLightProduction.magnitudes_9087 = true
    exact PellLightProduction.checked_9087)

def pellFiniteCertificate_9095 : PellFiniteCertificate 9095 (10^275) :=
  pellFiniteCertificateOfLight 9095 (10^275) 95 568 (pellEmptyMatchingCertificate 9095) (by
    change pellLightFiniteCheck 9095 95 (10^275) 568 PellLightProduction.magnitudes_9095 = true
    exact PellLightProduction.checked_9095)

def pellFiniteCertificate_9103 : PellFiniteCertificate 9103 (10^275) :=
  pellFiniteCertificateOfLight 9103 (10^275) 95 536 pellGraphCertificate_9103 (by
    change pellLightFiniteCheck 9103 95 (10^275) 536 PellLightProduction.magnitudes_9103 = true
    exact PellLightProduction.checked_9103)

def pellFiniteCertificate_9111 : PellFiniteCertificate 9111 (10^275) :=
  pellFiniteCertificateOfLight 9111 (10^275) 95 518 (pellEmptyMatchingCertificate 9111) (by
    change pellLightFiniteCheck 9111 95 (10^275) 518 PellLightProduction.magnitudes_9111 = true
    exact PellLightProduction.checked_9111)

def pellFiniteCertificate_9119 : PellFiniteCertificate 9119 (10^275) :=
  pellFiniteCertificateOfLight 9119 (10^275) 95 412 (pellEmptyMatchingCertificate 9119) (by
    change pellLightFiniteCheck 9119 95 (10^275) 412 PellLightProduction.magnitudes_9119 = true
    exact PellLightProduction.checked_9119)

def pellFiniteCertificate_9127 : PellFiniteCertificate 9127 (10^275) :=
  pellFiniteCertificateOfLight 9127 (10^275) 95 552 pellGraphCertificate_9127 (by
    change pellLightFiniteCheck 9127 95 (10^275) 552 PellLightProduction.magnitudes_9127 = true
    exact PellLightProduction.checked_9127)

def pellFiniteCertificate_9143 : PellFiniteCertificate 9143 (10^275) :=
  pellFiniteCertificateOfLight 9143 (10^275) 95 608 (pellEmptyMatchingCertificate 9143) (by
    change pellLightFiniteCheck 9143 95 (10^275) 608 PellLightProduction.magnitudes_9143 = true
    exact PellLightProduction.checked_9143)

def pellFiniteCertificate_9151 : PellFiniteCertificate 9151 (10^275) :=
  pellFiniteCertificateOfLight 9151 (10^275) 95 518 pellGraphCertificate_9151 (by
    change pellLightFiniteCheck 9151 95 (10^275) 518 PellLightProduction.magnitudes_9151 = true
    exact PellLightProduction.checked_9151)

def pellFiniteCertificate_9159 : PellFiniteCertificate 9159 (10^275) :=
  pellFiniteCertificateOfLight 9159 (10^275) 95 542 (pellEmptyMatchingCertificate 9159) (by
    change pellLightFiniteCheck 9159 95 (10^275) 542 PellLightProduction.magnitudes_9159 = true
    exact PellLightProduction.checked_9159)

def pellFiniteCertificate_9167 : PellFiniteCertificate 9167 (10^275) :=
  pellFiniteCertificateOfLight 9167 (10^275) 95 514 pellGraphCertificate_9167 (by
    change pellLightFiniteCheck 9167 95 (10^275) 514 PellLightProduction.magnitudes_9167 = true
    exact PellLightProduction.checked_9167)

def pellFiniteCertificate_9183 : PellFiniteCertificate 9183 (10^275) :=
  pellFiniteCertificateOfLight 9183 (10^275) 95 581 (pellEmptyMatchingCertificate 9183) (by
    change pellLightFiniteCheck 9183 95 (10^275) 581 PellLightProduction.magnitudes_9183 = true
    exact PellLightProduction.checked_9183)

def pellFiniteCertificate_9191 : PellFiniteCertificate 9191 (10^275) :=
  pellFiniteCertificateOfLight 9191 (10^275) 95 446 (pellEmptyMatchingCertificate 9191) (by
    change pellLightFiniteCheck 9191 95 (10^275) 446 PellLightProduction.magnitudes_9191 = true
    exact PellLightProduction.checked_9191)

def pellFiniteCertificate_9199 : PellFiniteCertificate 9199 (10^275) :=
  pellFiniteCertificateOfLight 9199 (10^275) 95 545 pellGraphCertificate_9199 (by
    change pellLightFiniteCheck 9199 95 (10^275) 545 PellLightProduction.magnitudes_9199 = true
    exact PellLightProduction.checked_9199)

def pellFiniteCertificate_9215 : PellFiniteCertificate 9215 (10^275) :=
  pellFiniteCertificateOfLight 9215 (10^275) 95 240 (pellEmptyMatchingCertificate 9215) (by
    change pellLightFiniteCheck 9215 95 (10^275) 240 PellLightProduction.magnitudes_9215 = true
    exact PellLightProduction.checked_9215)

def pellFiniteCertificate_9223 : PellFiniteCertificate 9223 (10^275) :=
  pellFiniteCertificateOfLight 9223 (10^275) 96 524 pellGraphCertificate_9223 (by
    change pellLightFiniteCheck 9223 96 (10^275) 524 PellLightProduction.magnitudes_9223 = true
    exact PellLightProduction.checked_9223)

def pellFiniteCertificate_9231 : PellFiniteCertificate 9231 (10^275) :=
  pellFiniteCertificateOfLight 9231 (10^275) 96 356 (pellEmptyMatchingCertificate 9231) (by
    change pellLightFiniteCheck 9231 96 (10^275) 356 PellLightProduction.magnitudes_9231 = true
    exact PellLightProduction.checked_9231)

def pellFiniteCertificate_9239 : PellFiniteCertificate 9239 (10^275) :=
  pellFiniteCertificateOfLight 9239 (10^275) 96 566 pellGraphCertificate_9239 (by
    change pellLightFiniteCheck 9239 96 (10^275) 566 PellLightProduction.magnitudes_9239 = true
    exact PellLightProduction.checked_9239)

def pellFiniteCertificate_9247 : PellFiniteCertificate 9247 (10^275) :=
  pellFiniteCertificateOfLight 9247 (10^275) 96 482 pellGraphCertificate_9247 (by
    change pellLightFiniteCheck 9247 96 (10^275) 482 PellLightProduction.magnitudes_9247 = true
    exact PellLightProduction.checked_9247)

def pellFiniteCertificate_9255 : PellFiniteCertificate 9255 (10^275) :=
  pellFiniteCertificateOfLight 9255 (10^275) 96 525 (pellEmptyMatchingCertificate 9255) (by
    change pellLightFiniteCheck 9255 96 (10^275) 525 PellLightProduction.magnitudes_9255 = true
    exact PellLightProduction.checked_9255)

def pellFiniteCertificate_9263 : PellFiniteCertificate 9263 (10^275) :=
  pellFiniteCertificateOfLight 9263 (10^275) 96 428 (pellEmptyMatchingCertificate 9263) (by
    change pellLightFiniteCheck 9263 96 (10^275) 428 PellLightProduction.magnitudes_9263 = true
    exact PellLightProduction.checked_9263)

def pellFiniteCertificate_9271 : PellFiniteCertificate 9271 (10^275) :=
  pellFiniteCertificateOfLight 9271 (10^275) 96 480 (pellEmptyMatchingCertificate 9271) (by
    change pellLightFiniteCheck 9271 96 (10^275) 480 PellLightProduction.magnitudes_9271 = true
    exact PellLightProduction.checked_9271)

def pellFiniteCertificate_9287 : PellFiniteCertificate 9287 (10^275) :=
  pellFiniteCertificateOfLight 9287 (10^275) 96 521 (pellEmptyMatchingCertificate 9287) (by
    change pellLightFiniteCheck 9287 96 (10^275) 521 PellLightProduction.magnitudes_9287 = true
    exact PellLightProduction.checked_9287)

def pellFiniteCertificate_9303 : PellFiniteCertificate 9303 (10^275) :=
  pellFiniteCertificateOfLight 9303 (10^275) 96 511 (pellEmptyMatchingCertificate 9303) (by
    change pellLightFiniteCheck 9303 96 (10^275) 511 PellLightProduction.magnitudes_9303 = true
    exact PellLightProduction.checked_9303)

def pellFiniteCertificate_9311 : PellFiniteCertificate 9311 (10^275) :=
  pellFiniteCertificateOfLight 9311 (10^275) 96 567 pellGraphCertificate_9311 (by
    change pellLightFiniteCheck 9311 96 (10^275) 567 PellLightProduction.magnitudes_9311 = true
    exact PellLightProduction.checked_9311)

def pellFiniteCertificate_9319 : PellFiniteCertificate 9319 (10^275) :=
  pellFiniteCertificateOfLight 9319 (10^275) 96 549 pellGraphCertificate_9319 (by
    change pellLightFiniteCheck 9319 96 (10^275) 549 PellLightProduction.magnitudes_9319 = true
    exact PellLightProduction.checked_9319)

def pellFiniteCertificate_9327 : PellFiniteCertificate 9327 (10^275) :=
  pellFiniteCertificateOfLight 9327 (10^275) 96 546 (pellEmptyMatchingCertificate 9327) (by
    change pellLightFiniteCheck 9327 96 (10^275) 546 PellLightProduction.magnitudes_9327 = true
    exact PellLightProduction.checked_9327)

def pellFiniteCertificate_9335 : PellFiniteCertificate 9335 (10^275) :=
  pellFiniteCertificateOfLight 9335 (10^275) 96 602 (pellEmptyMatchingCertificate 9335) (by
    change pellLightFiniteCheck 9335 96 (10^275) 602 PellLightProduction.magnitudes_9335 = true
    exact PellLightProduction.checked_9335)

def pellFiniteCertificate_9343 : PellFiniteCertificate 9343 (10^275) :=
  pellFiniteCertificateOfLight 9343 (10^275) 96 591 pellGraphCertificate_9343 (by
    change pellLightFiniteCheck 9343 96 (10^275) 591 PellLightProduction.magnitudes_9343 = true
    exact PellLightProduction.checked_9343)

def pellFiniteCertificate_9367 : PellFiniteCertificate 9367 (10^275) :=
  pellFiniteCertificateOfLight 9367 (10^275) 96 570 (pellEmptyMatchingCertificate 9367) (by
    change pellLightFiniteCheck 9367 96 (10^275) 570 PellLightProduction.magnitudes_9367 = true
    exact PellLightProduction.checked_9367)

def pellFiniteCertificate_9383 : PellFiniteCertificate 9383 (10^275) :=
  pellFiniteCertificateOfLight 9383 (10^275) 96 434 (pellEmptyMatchingCertificate 9383) (by
    change pellLightFiniteCheck 9383 96 (10^275) 434 PellLightProduction.magnitudes_9383 = true
    exact PellLightProduction.checked_9383)

def pellFiniteCertificate_9391 : PellFiniteCertificate 9391 (10^275) :=
  pellFiniteCertificateOfLight 9391 (10^275) 96 564 pellGraphCertificate_9391 (by
    change pellLightFiniteCheck 9391 96 (10^275) 564 PellLightProduction.magnitudes_9391 = true
    exact PellLightProduction.checked_9391)

def pellFiniteCertificate_9399 : PellFiniteCertificate 9399 (10^275) :=
  pellFiniteCertificateOfLight 9399 (10^275) 96 398 (pellEmptyMatchingCertificate 9399) (by
    change pellLightFiniteCheck 9399 96 (10^275) 398 PellLightProduction.magnitudes_9399 = true
    exact PellLightProduction.checked_9399)

def pellFiniteCertificate_9407 : PellFiniteCertificate 9407 (10^275) :=
  pellFiniteCertificateOfLight 9407 (10^275) 96 256 pellGraphCertificate_9407 (by
    change pellLightFiniteCheck 9407 96 (10^275) 256 PellLightProduction.magnitudes_9407 = true
    exact PellLightProduction.checked_9407)

def pellFiniteCertificate_9415 : PellFiniteCertificate 9415 (10^275) :=
  pellFiniteCertificateOfLight 9415 (10^275) 97 360 (pellEmptyMatchingCertificate 9415) (by
    change pellLightFiniteCheck 9415 97 (10^275) 360 PellLightProduction.magnitudes_9415 = true
    exact PellLightProduction.checked_9415)

def pellFiniteCertificate_9431 : PellFiniteCertificate 9431 (10^275) :=
  pellFiniteCertificateOfLight 9431 (10^275) 97 393 pellGraphCertificate_9431 (by
    change pellLightFiniteCheck 9431 97 (10^275) 393 PellLightProduction.magnitudes_9431 = true
    exact PellLightProduction.checked_9431)

def pellFiniteCertificate_9439 : PellFiniteCertificate 9439 (10^275) :=
  pellFiniteCertificateOfLight 9439 (10^275) 97 525 pellGraphCertificate_9439 (by
    change pellLightFiniteCheck 9439 97 (10^275) 525 PellLightProduction.magnitudes_9439 = true
    exact PellLightProduction.checked_9439)

def pellFiniteCertificate_9447 : PellFiniteCertificate 9447 (10^275) :=
  pellFiniteCertificateOfLight 9447 (10^275) 97 413 (pellEmptyMatchingCertificate 9447) (by
    change pellLightFiniteCheck 9447 97 (10^275) 413 PellLightProduction.magnitudes_9447 = true
    exact PellLightProduction.checked_9447)

def pellFiniteCertificate_9455 : PellFiniteCertificate 9455 (10^275) :=
  pellFiniteCertificateOfLight 9455 (10^275) 97 312 (pellEmptyMatchingCertificate 9455) (by
    change pellLightFiniteCheck 9455 97 (10^275) 312 PellLightProduction.magnitudes_9455 = true
    exact PellLightProduction.checked_9455)

def pellFiniteCertificate_9463 : PellFiniteCertificate 9463 (10^275) :=
  pellFiniteCertificateOfLight 9463 (10^275) 97 542 pellGraphCertificate_9463 (by
    change pellLightFiniteCheck 9463 97 (10^275) 542 PellLightProduction.magnitudes_9463 = true
    exact PellLightProduction.checked_9463)

def pellFiniteCertificate_9471 : PellFiniteCertificate 9471 (10^275) :=
  pellFiniteCertificateOfLight 9471 (10^275) 97 422 (pellEmptyMatchingCertificate 9471) (by
    change pellLightFiniteCheck 9471 97 (10^275) 422 PellLightProduction.magnitudes_9471 = true
    exact PellLightProduction.checked_9471)

def pellFiniteCertificate_9479 : PellFiniteCertificate 9479 (10^275) :=
  pellFiniteCertificateOfLight 9479 (10^275) 97 472 pellGraphCertificate_9479 (by
    change pellLightFiniteCheck 9479 97 (10^275) 472 PellLightProduction.magnitudes_9479 = true
    exact PellLightProduction.checked_9479)

def pellFiniteCertificate_9487 : PellFiniteCertificate 9487 (10^275) :=
  pellFiniteCertificateOfLight 9487 (10^275) 97 561 (pellEmptyMatchingCertificate 9487) (by
    change pellLightFiniteCheck 9487 97 (10^275) 561 PellLightProduction.magnitudes_9487 = true
    exact PellLightProduction.checked_9487)

def pellFiniteCertificate_9503 : PellFiniteCertificate 9503 (10^275) :=
  pellFiniteCertificateOfLight 9503 (10^275) 97 270 (pellEmptyMatchingCertificate 9503) (by
    change pellLightFiniteCheck 9503 97 (10^275) 270 PellLightProduction.magnitudes_9503 = true
    exact PellLightProduction.checked_9503)

def pellFiniteCertificate_9511 : PellFiniteCertificate 9511 (10^275) :=
  pellFiniteCertificateOfLight 9511 (10^275) 97 549 pellGraphCertificate_9511 (by
    change pellLightFiniteCheck 9511 97 (10^275) 549 PellLightProduction.magnitudes_9511 = true
    exact PellLightProduction.checked_9511)

def pellFiniteCertificate_9519 : PellFiniteCertificate 9519 (10^275) :=
  pellFiniteCertificateOfLight 9519 (10^275) 97 643 (pellEmptyMatchingCertificate 9519) (by
    change pellLightFiniteCheck 9519 97 (10^275) 643 PellLightProduction.magnitudes_9519 = true
    exact PellLightProduction.checked_9519)

def pellFiniteCertificate_9527 : PellFiniteCertificate 9527 (10^275) :=
  pellFiniteCertificateOfLight 9527 (10^275) 97 530 pellGraphCertificate_9527 (by
    change pellLightFiniteCheck 9527 97 (10^275) 530 PellLightProduction.magnitudes_9527 = true
    exact PellLightProduction.checked_9527)

def pellFiniteCertificate_9535 : PellFiniteCertificate 9535 (10^275) :=
  pellFiniteCertificateOfLight 9535 (10^275) 97 536 (pellEmptyMatchingCertificate 9535) (by
    change pellLightFiniteCheck 9535 97 (10^275) 536 PellLightProduction.magnitudes_9535 = true
    exact PellLightProduction.checked_9535)

def pellFiniteCertificate_9543 : PellFiniteCertificate 9543 (10^275) :=
  pellFiniteCertificateOfLight 9543 (10^275) 97 513 (pellEmptyMatchingCertificate 9543) (by
    change pellLightFiniteCheck 9543 97 (10^275) 513 PellLightProduction.magnitudes_9543 = true
    exact PellLightProduction.checked_9543)

def pellFiniteCertificate_9551 : PellFiniteCertificate 9551 (10^275) :=
  pellFiniteCertificateOfLight 9551 (10^275) 97 568 pellGraphCertificate_9551 (by
    change pellLightFiniteCheck 9551 97 (10^275) 568 PellLightProduction.magnitudes_9551 = true
    exact PellLightProduction.checked_9551)

def pellFiniteCertificate_9591 : PellFiniteCertificate 9591 (10^275) :=
  pellFiniteCertificateOfLight 9591 (10^275) 97 378 (pellEmptyMatchingCertificate 9591) (by
    change pellLightFiniteCheck 9591 97 (10^275) 378 PellLightProduction.magnitudes_9591 = true
    exact PellLightProduction.checked_9591)

def pellFiniteCertificate_9599 : PellFiniteCertificate 9599 (10^275) :=
  pellFiniteCertificateOfLight 9599 (10^275) 97 517 (pellEmptyMatchingCertificate 9599) (by
    change pellLightFiniteCheck 9599 97 (10^275) 517 PellLightProduction.magnitudes_9599 = true
    exact PellLightProduction.checked_9599)

def pellFiniteCertificate_9607 : PellFiniteCertificate 9607 (10^275) :=
  pellFiniteCertificateOfLight 9607 (10^275) 98 438 (pellEmptyMatchingCertificate 9607) (by
    change pellLightFiniteCheck 9607 98 (10^275) 438 PellLightProduction.magnitudes_9607 = true
    exact PellLightProduction.checked_9607)

def pellFiniteCertificate_9615 : PellFiniteCertificate 9615 (10^275) :=
  pellFiniteCertificateOfLight 9615 (10^275) 98 472 (pellEmptyMatchingCertificate 9615) (by
    change pellLightFiniteCheck 9615 98 (10^275) 472 PellLightProduction.magnitudes_9615 = true
    exact PellLightProduction.checked_9615)

def pellFiniteCertificate_9623 : PellFiniteCertificate 9623 (10^275) :=
  pellFiniteCertificateOfLight 9623 (10^275) 98 485 pellGraphCertificate_9623 (by
    change pellLightFiniteCheck 9623 98 (10^275) 485 PellLightProduction.magnitudes_9623 = true
    exact PellLightProduction.checked_9623)

def pellFiniteCertificate_9631 : PellFiniteCertificate 9631 (10^275) :=
  pellFiniteCertificateOfLight 9631 (10^275) 98 518 pellGraphCertificate_9631 (by
    change pellLightFiniteCheck 9631 98 (10^275) 518 PellLightProduction.magnitudes_9631 = true
    exact PellLightProduction.checked_9631)

def pellFiniteCertificate_9647 : PellFiniteCertificate 9647 (10^275) :=
  pellFiniteCertificateOfLight 9647 (10^275) 98 521 (pellEmptyMatchingCertificate 9647) (by
    change pellLightFiniteCheck 9647 98 (10^275) 521 PellLightProduction.magnitudes_9647 = true
    exact PellLightProduction.checked_9647)

def pellFiniteCertificate_9655 : PellFiniteCertificate 9655 (10^275) :=
  pellFiniteCertificateOfLight 9655 (10^275) 98 510 (pellEmptyMatchingCertificate 9655) (by
    change pellLightFiniteCheck 9655 98 (10^275) 510 PellLightProduction.magnitudes_9655 = true
    exact PellLightProduction.checked_9655)

def pellFiniteCertificate_9663 : PellFiniteCertificate 9663 (10^275) :=
  pellFiniteCertificateOfLight 9663 (10^275) 98 549 (pellEmptyMatchingCertificate 9663) (by
    change pellLightFiniteCheck 9663 98 (10^275) 549 PellLightProduction.magnitudes_9663 = true
    exact PellLightProduction.checked_9663)

def pellFiniteCertificate_9671 : PellFiniteCertificate 9671 (10^275) :=
  pellFiniteCertificateOfLight 9671 (10^275) 98 552 (pellEmptyMatchingCertificate 9671) (by
    change pellLightFiniteCheck 9671 98 (10^275) 552 PellLightProduction.magnitudes_9671 = true
    exact PellLightProduction.checked_9671)

def pellFiniteCertificate_9679 : PellFiniteCertificate 9679 (10^275) :=
  pellFiniteCertificateOfLight 9679 (10^275) 98 477 pellGraphCertificate_9679 (by
    change pellLightFiniteCheck 9679 98 (10^275) 477 PellLightProduction.magnitudes_9679 = true
    exact PellLightProduction.checked_9679)

def pellFiniteCertificate_9687 : PellFiniteCertificate 9687 (10^275) :=
  pellFiniteCertificateOfLight 9687 (10^275) 98 484 (pellEmptyMatchingCertificate 9687) (by
    change pellLightFiniteCheck 9687 98 (10^275) 484 PellLightProduction.magnitudes_9687 = true
    exact PellLightProduction.checked_9687)

def pellFiniteCertificate_9695 : PellFiniteCertificate 9695 (10^275) :=
  pellFiniteCertificateOfLight 9695 (10^275) 98 504 (pellEmptyMatchingCertificate 9695) (by
    change pellLightFiniteCheck 9695 98 (10^275) 504 PellLightProduction.magnitudes_9695 = true
    exact PellLightProduction.checked_9695)

def pellFiniteCertificate_9703 : PellFiniteCertificate 9703 (10^275) :=
  pellFiniteCertificateOfLight 9703 (10^275) 98 442 pellGraphCertificate_9703 (by
    change pellLightFiniteCheck 9703 98 (10^275) 442 PellLightProduction.magnitudes_9703 = true
    exact PellLightProduction.checked_9703)

def pellFiniteCertificate_9719 : PellFiniteCertificate 9719 (10^275) :=
  pellFiniteCertificateOfLight 9719 (10^275) 98 508 pellGraphCertificate_9719 (by
    change pellLightFiniteCheck 9719 98 (10^275) 508 PellLightProduction.magnitudes_9719 = true
    exact PellLightProduction.checked_9719)

def pellFiniteCertificate_9727 : PellFiniteCertificate 9727 (10^275) :=
  pellFiniteCertificateOfLight 9727 (10^275) 98 531 pellGraphCertificate_9727 (by
    change pellLightFiniteCheck 9727 98 (10^275) 531 PellLightProduction.magnitudes_9727 = true
    exact PellLightProduction.checked_9727)

def pellFiniteCertificate_9735 : PellFiniteCertificate 9735 (10^275) :=
  pellFiniteCertificateOfLight 9735 (10^275) 98 396 (pellEmptyMatchingCertificate 9735) (by
    change pellLightFiniteCheck 9735 98 (10^275) 396 PellLightProduction.magnitudes_9735 = true
    exact PellLightProduction.checked_9735)

def pellFiniteCertificate_9743 : PellFiniteCertificate 9743 (10^275) :=
  pellFiniteCertificateOfLight 9743 (10^275) 98 582 pellGraphCertificate_9743 (by
    change pellLightFiniteCheck 9743 98 (10^275) 582 PellLightProduction.magnitudes_9743 = true
    exact PellLightProduction.checked_9743)

def pellFiniteCertificate_9759 : PellFiniteCertificate 9759 (10^275) :=
  pellFiniteCertificateOfLight 9759 (10^275) 98 559 (pellEmptyMatchingCertificate 9759) (by
    change pellLightFiniteCheck 9759 98 (10^275) 559 PellLightProduction.magnitudes_9759 = true
    exact PellLightProduction.checked_9759)

def pellFiniteCertificate_9767 : PellFiniteCertificate 9767 (10^275) :=
  pellFiniteCertificateOfLight 9767 (10^275) 98 552 pellGraphCertificate_9767 (by
    change pellLightFiniteCheck 9767 98 (10^275) 552 PellLightProduction.magnitudes_9767 = true
    exact PellLightProduction.checked_9767)

def pellFiniteCertificate_9791 : PellFiniteCertificate 9791 (10^275) :=
  pellFiniteCertificateOfLight 9791 (10^275) 98 527 pellGraphCertificate_9791 (by
    change pellLightFiniteCheck 9791 98 (10^275) 527 PellLightProduction.magnitudes_9791 = true
    exact PellLightProduction.checked_9791)

def pellFiniteCertificate_9799 : PellFiniteCertificate 9799 (10^275) :=
  pellFiniteCertificateOfLight 9799 (10^275) 98 256 pellGraphCertificate_9799 (by
    change pellLightFiniteCheck 9799 98 (10^275) 256 PellLightProduction.magnitudes_9799 = true
    exact PellLightProduction.checked_9799)

def pellFiniteCertificate_9807 : PellFiniteCertificate 9807 (10^275) :=
  pellFiniteCertificateOfLight 9807 (10^275) 99 144 (pellEmptyMatchingCertificate 9807) (by
    change pellLightFiniteCheck 9807 99 (10^275) 144 PellLightProduction.magnitudes_9807 = true
    exact PellLightProduction.checked_9807)

def pellFiniteCertificate_9815 : PellFiniteCertificate 9815 (10^275) :=
  pellFiniteCertificateOfLight 9815 (10^275) 99 376 (pellEmptyMatchingCertificate 9815) (by
    change pellLightFiniteCheck 9815 99 (10^275) 376 PellLightProduction.magnitudes_9815 = true
    exact PellLightProduction.checked_9815)

def pellFiniteCertificate_9823 : PellFiniteCertificate 9823 (10^275) :=
  pellFiniteCertificateOfLight 9823 (10^275) 99 168 (pellEmptyMatchingCertificate 9823) (by
    change pellLightFiniteCheck 9823 99 (10^275) 168 PellLightProduction.magnitudes_9823 = true
    exact PellLightProduction.checked_9823)

def pellFiniteCertificate_9831 : PellFiniteCertificate 9831 (10^275) :=
  pellFiniteCertificateOfLight 9831 (10^275) 99 472 (pellEmptyMatchingCertificate 9831) (by
    change pellLightFiniteCheck 9831 99 (10^275) 472 PellLightProduction.magnitudes_9831 = true
    exact PellLightProduction.checked_9831)

def pellFiniteCertificate_9839 : PellFiniteCertificate 9839 (10^275) :=
  pellFiniteCertificateOfLight 9839 (10^275) 99 519 pellGraphCertificate_9839 (by
    change pellLightFiniteCheck 9839 99 (10^275) 519 PellLightProduction.magnitudes_9839 = true
    exact PellLightProduction.checked_9839)

def pellFiniteCertificate_9847 : PellFiniteCertificate 9847 (10^275) :=
  pellFiniteCertificateOfLight 9847 (10^275) 99 318 (pellEmptyMatchingCertificate 9847) (by
    change pellLightFiniteCheck 9847 99 (10^275) 318 PellLightProduction.magnitudes_9847 = true
    exact PellLightProduction.checked_9847)

def pellFiniteCertificate_9863 : PellFiniteCertificate 9863 (10^275) :=
  pellFiniteCertificateOfLight 9863 (10^275) 99 267 (pellEmptyMatchingCertificate 9863) (by
    change pellLightFiniteCheck 9863 99 (10^275) 267 PellLightProduction.magnitudes_9863 = true
    exact PellLightProduction.checked_9863)

def pellFiniteCertificate_9871 : PellFiniteCertificate 9871 (10^275) :=
  pellFiniteCertificateOfLight 9871 (10^275) 99 324 pellGraphCertificate_9871 (by
    change pellLightFiniteCheck 9871 99 (10^275) 324 PellLightProduction.magnitudes_9871 = true
    exact PellLightProduction.checked_9871)

def pellFiniteCertificate_9879 : PellFiniteCertificate 9879 (10^275) :=
  pellFiniteCertificateOfLight 9879 (10^275) 99 523 (pellEmptyMatchingCertificate 9879) (by
    change pellLightFiniteCheck 9879 99 (10^275) 523 PellLightProduction.magnitudes_9879 = true
    exact PellLightProduction.checked_9879)

def pellFiniteCertificate_9887 : PellFiniteCertificate 9887 (10^275) :=
  pellFiniteCertificateOfLight 9887 (10^275) 99 529 pellGraphCertificate_9887 (by
    change pellLightFiniteCheck 9887 99 (10^275) 529 PellLightProduction.magnitudes_9887 = true
    exact PellLightProduction.checked_9887)

def pellFiniteCertificate_9895 : PellFiniteCertificate 9895 (10^275) :=
  pellFiniteCertificateOfLight 9895 (10^275) 99 340 (pellEmptyMatchingCertificate 9895) (by
    change pellLightFiniteCheck 9895 99 (10^275) 340 PellLightProduction.magnitudes_9895 = true
    exact PellLightProduction.checked_9895)

def pellFiniteCertificate_9903 : PellFiniteCertificate 9903 (10^275) :=
  pellFiniteCertificateOfLight 9903 (10^275) 99 491 (pellEmptyMatchingCertificate 9903) (by
    change pellLightFiniteCheck 9903 99 (10^275) 491 PellLightProduction.magnitudes_9903 = true
    exact PellLightProduction.checked_9903)

def pellFiniteCertificate_9911 : PellFiniteCertificate 9911 (10^275) :=
  pellFiniteCertificateOfLight 9911 (10^275) 99 498 (pellEmptyMatchingCertificate 9911) (by
    change pellLightFiniteCheck 9911 99 (10^275) 498 PellLightProduction.magnitudes_9911 = true
    exact PellLightProduction.checked_9911)

def pellFiniteCertificate_9919 : PellFiniteCertificate 9919 (10^275) :=
  pellFiniteCertificateOfLight 9919 (10^275) 99 529 (pellEmptyMatchingCertificate 9919) (by
    change pellLightFiniteCheck 9919 99 (10^275) 529 PellLightProduction.magnitudes_9919 = true
    exact PellLightProduction.checked_9919)

def pellFiniteCertificate_9935 : PellFiniteCertificate 9935 (10^275) :=
  pellFiniteCertificateOfLight 9935 (10^275) 99 504 (pellEmptyMatchingCertificate 9935) (by
    change pellLightFiniteCheck 9935 99 (10^275) 504 PellLightProduction.magnitudes_9935 = true
    exact PellLightProduction.checked_9935)

def pellFiniteCertificate_9943 : PellFiniteCertificate 9943 (10^275) :=
  pellFiniteCertificateOfLight 9943 (10^275) 99 590 (pellEmptyMatchingCertificate 9943) (by
    change pellLightFiniteCheck 9943 99 (10^275) 590 PellLightProduction.magnitudes_9943 = true
    exact PellLightProduction.checked_9943)

def pellFiniteCertificate_9951 : PellFiniteCertificate 9951 (10^275) :=
  pellFiniteCertificateOfLight 9951 (10^275) 99 329 (pellEmptyMatchingCertificate 9951) (by
    change pellLightFiniteCheck 9951 99 (10^275) 329 PellLightProduction.magnitudes_9951 = true
    exact PellLightProduction.checked_9951)

def pellFiniteCertificate_9959 : PellFiniteCertificate 9959 (10^275) :=
  pellFiniteCertificateOfLight 9959 (10^275) 99 470 pellGraphCertificate_9959 (by
    change pellLightFiniteCheck 9959 99 (10^275) 470 PellLightProduction.magnitudes_9959 = true
    exact PellLightProduction.checked_9959)

def pellFiniteCertificate_9967 : PellFiniteCertificate 9967 (10^275) :=
  pellFiniteCertificateOfLight 9967 (10^275) 99 567 pellGraphCertificate_9967 (by
    change pellLightFiniteCheck 9967 99 (10^275) 567 PellLightProduction.magnitudes_9967 = true
    exact PellLightProduction.checked_9967)

def pellFiniteCertificate_9983 : PellFiniteCertificate 9983 (10^275) :=
  pellFiniteCertificateOfLight 9983 (10^275) 99 450 (pellEmptyMatchingCertificate 9983) (by
    change pellLightFiniteCheck 9983 99 (10^275) 450 PellLightProduction.magnitudes_9983 = true
    exact PellLightProduction.checked_9983)

def pellFiniteCertificate_9991 : PellFiniteCertificate 9991 (10^275) :=
  pellFiniteCertificateOfLight 9991 (10^275) 99 440 pellGraphCertificate_9991 (by
    change pellLightFiniteCheck 9991 99 (10^275) 440 PellLightProduction.magnitudes_9991 = true
    exact PellLightProduction.checked_9991)

end D1Bound5
