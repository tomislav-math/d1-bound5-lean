import D1Bound5.OneSmallThirdData
import D1Bound5.OneSmallFourthData1
import D1Bound5.OneSmallFourthData2
import D1Bound5.OneSmallFourthData3
import D1Bound5.OneSmallFourthData4
import D1Bound5.OneSmallFourthData5
import D1Bound5.OneSmallFourthData6
import D1Bound5.OneSmallFourthData7
import D1Bound5.OneSmallRows
import D1Bound5.OneSmallRowMetadata
import D1Bound5.OneSmallSymmetry
import D1Bound5.OneSmallOrbitRows
import D1Bound5.OneSmallFullRingFinite
import Lean.Elab.Command
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 32768
run_cmd do
  let names : List Lean.Name := [
    `D1Bound5.oneSmallPairA_0,
    `D1Bound5.oneSmallPairB_0,
    `D1Bound5.oneSmallThirds_0,
    `D1Bound5.oneSmallThirds_0_checked,
    `D1Bound5.oneSmallThirds_0_complete,
    `D1Bound5.oneSmallPairA_1,
    `D1Bound5.oneSmallPairB_1,
    `D1Bound5.oneSmallThirds_1,
    `D1Bound5.oneSmallThirds_1_checked,
    `D1Bound5.oneSmallThirds_1_complete,
    `D1Bound5.oneSmallPairA_2,
    `D1Bound5.oneSmallPairB_2,
    `D1Bound5.oneSmallThirds_2,
    `D1Bound5.oneSmallThirds_2_checked,
    `D1Bound5.oneSmallThirds_2_complete,
    `D1Bound5.oneSmallPairA_3,
    `D1Bound5.oneSmallPairB_3,
    `D1Bound5.oneSmallThirds_3,
    `D1Bound5.oneSmallThirds_3_checked,
    `D1Bound5.oneSmallThirds_3_complete,
    `D1Bound5.oneSmallPairA_4,
    `D1Bound5.oneSmallPairB_4,
    `D1Bound5.oneSmallThirds_4,
    `D1Bound5.oneSmallThirds_4_checked,
    `D1Bound5.oneSmallThirds_4_complete,
    `D1Bound5.oneSmallPairA_5,
    `D1Bound5.oneSmallPairB_5,
    `D1Bound5.oneSmallThirds_5,
    `D1Bound5.oneSmallThirds_5_checked,
    `D1Bound5.oneSmallThirds_5_complete,
    `D1Bound5.oneSmallPairA_6,
    `D1Bound5.oneSmallPairB_6,
    `D1Bound5.oneSmallThirds_6,
    `D1Bound5.oneSmallThirds_6_checked,
    `D1Bound5.oneSmallThirds_6_complete,
    `D1Bound5.oneSmallPairA_7,
    `D1Bound5.oneSmallPairB_7,
    `D1Bound5.oneSmallThirds_7,
    `D1Bound5.oneSmallThirds_7_checked,
    `D1Bound5.oneSmallThirds_7_complete,
    `D1Bound5.oneSmallPairA_8,
    `D1Bound5.oneSmallPairB_8,
    `D1Bound5.oneSmallThirds_8,
    `D1Bound5.oneSmallThirds_8_checked,
    `D1Bound5.oneSmallThirds_8_complete,
    `D1Bound5.oneSmallPairA_9,
    `D1Bound5.oneSmallPairB_9,
    `D1Bound5.oneSmallThirds_9,
    `D1Bound5.oneSmallThirds_9_checked,
    `D1Bound5.oneSmallThirds_9_complete,
    `D1Bound5.oneSmallPairA_10,
    `D1Bound5.oneSmallPairB_10,
    `D1Bound5.oneSmallThirds_10,
    `D1Bound5.oneSmallThirds_10_checked,
    `D1Bound5.oneSmallThirds_10_complete,
    `D1Bound5.oneSmallPairA_11,
    `D1Bound5.oneSmallPairB_11,
    `D1Bound5.oneSmallThirds_11,
    `D1Bound5.oneSmallThirds_11_checked,
    `D1Bound5.oneSmallThirds_11_complete,
    `D1Bound5.oneSmallPairA_12,
    `D1Bound5.oneSmallPairB_12,
    `D1Bound5.oneSmallThirds_12,
    `D1Bound5.oneSmallThirds_12_checked,
    `D1Bound5.oneSmallThirds_12_complete,
    `D1Bound5.oneSmallPairA_13,
    `D1Bound5.oneSmallPairB_13,
    `D1Bound5.oneSmallThirds_13,
    `D1Bound5.oneSmallThirds_13_checked,
    `D1Bound5.oneSmallThirds_13_complete,
    `D1Bound5.oneSmallPairA_14,
    `D1Bound5.oneSmallPairB_14,
    `D1Bound5.oneSmallThirds_14,
    `D1Bound5.oneSmallThirds_14_checked,
    `D1Bound5.oneSmallThirds_14_complete,
    `D1Bound5.oneSmallPairA_15,
    `D1Bound5.oneSmallPairB_15,
    `D1Bound5.oneSmallThirds_15,
    `D1Bound5.oneSmallThirds_15_checked,
    `D1Bound5.oneSmallThirds_15_complete,
    `D1Bound5.oneSmallPairA_16,
    `D1Bound5.oneSmallPairB_16,
    `D1Bound5.oneSmallThirds_16,
    `D1Bound5.oneSmallThirds_16_checked,
    `D1Bound5.oneSmallThirds_16_complete,
    `D1Bound5.oneSmallPairA_17,
    `D1Bound5.oneSmallPairB_17,
    `D1Bound5.oneSmallThirds_17,
    `D1Bound5.oneSmallThirds_17_checked,
    `D1Bound5.oneSmallThirds_17_complete,
    `D1Bound5.oneSmallPairA_18,
    `D1Bound5.oneSmallPairB_18,
    `D1Bound5.oneSmallThirds_18,
    `D1Bound5.oneSmallThirds_18_checked,
    `D1Bound5.oneSmallThirds_18_complete,
    `D1Bound5.oneSmallPairA_19,
    `D1Bound5.oneSmallPairB_19,
    `D1Bound5.oneSmallThirds_19,
    `D1Bound5.oneSmallThirds_19_checked,
    `D1Bound5.oneSmallThirds_19_complete,
    `D1Bound5.oneSmallPairA_20,
    `D1Bound5.oneSmallPairB_20,
    `D1Bound5.oneSmallThirds_20,
    `D1Bound5.oneSmallThirds_20_checked,
    `D1Bound5.oneSmallThirds_20_complete,
    `D1Bound5.oneSmallPairA_21,
    `D1Bound5.oneSmallPairB_21,
    `D1Bound5.oneSmallThirds_21,
    `D1Bound5.oneSmallThirds_21_checked,
    `D1Bound5.oneSmallThirds_21_complete,
    `D1Bound5.oneSmallPairA_22,
    `D1Bound5.oneSmallPairB_22,
    `D1Bound5.oneSmallThirds_22,
    `D1Bound5.oneSmallThirds_22_checked,
    `D1Bound5.oneSmallThirds_22_complete,
    `D1Bound5.oneSmallPairA_23,
    `D1Bound5.oneSmallPairB_23,
    `D1Bound5.oneSmallThirds_23,
    `D1Bound5.oneSmallThirds_23_checked,
    `D1Bound5.oneSmallThirds_23_complete,
    `D1Bound5.oneSmallPairA_24,
    `D1Bound5.oneSmallPairB_24,
    `D1Bound5.oneSmallThirds_24,
    `D1Bound5.oneSmallThirds_24_checked,
    `D1Bound5.oneSmallThirds_24_complete,
    `D1Bound5.oneSmallPairA_25,
    `D1Bound5.oneSmallPairB_25,
    `D1Bound5.oneSmallThirds_25,
    `D1Bound5.oneSmallThirds_25_checked,
    `D1Bound5.oneSmallThirds_25_complete,
    `D1Bound5.oneSmallPairA_26,
    `D1Bound5.oneSmallPairB_26,
    `D1Bound5.oneSmallThirds_26,
    `D1Bound5.oneSmallThirds_26_checked,
    `D1Bound5.oneSmallThirds_26_complete,
    `D1Bound5.oneSmallPairA_27,
    `D1Bound5.oneSmallPairB_27,
    `D1Bound5.oneSmallThirds_27,
    `D1Bound5.oneSmallThirds_27_checked,
    `D1Bound5.oneSmallThirds_27_complete,
    `D1Bound5.oneSmallPairA_28,
    `D1Bound5.oneSmallPairB_28,
    `D1Bound5.oneSmallThirds_28,
    `D1Bound5.oneSmallThirds_28_checked,
    `D1Bound5.oneSmallThirds_28_complete,
    `D1Bound5.oneSmallPairA_29,
    `D1Bound5.oneSmallPairB_29,
    `D1Bound5.oneSmallThirds_29,
    `D1Bound5.oneSmallThirds_29_checked,
    `D1Bound5.oneSmallThirds_29_complete,
    `D1Bound5.oneSmallPairA_30,
    `D1Bound5.oneSmallPairB_30,
    `D1Bound5.oneSmallThirds_30,
    `D1Bound5.oneSmallThirds_30_checked,
    `D1Bound5.oneSmallThirds_30_complete,
    `D1Bound5.oneSmallPairA_31,
    `D1Bound5.oneSmallPairB_31,
    `D1Bound5.oneSmallThirds_31,
    `D1Bound5.oneSmallThirds_31_checked,
    `D1Bound5.oneSmallThirds_31_complete,
    `D1Bound5.oneSmallPairA_32,
    `D1Bound5.oneSmallPairB_32,
    `D1Bound5.oneSmallThirds_32,
    `D1Bound5.oneSmallThirds_32_checked,
    `D1Bound5.oneSmallThirds_32_complete,
    `D1Bound5.oneSmallPairA_33,
    `D1Bound5.oneSmallPairB_33,
    `D1Bound5.oneSmallThirds_33,
    `D1Bound5.oneSmallThirds_33_checked,
    `D1Bound5.oneSmallThirds_33_complete,
    `D1Bound5.oneSmallPairA_34,
    `D1Bound5.oneSmallPairB_34,
    `D1Bound5.oneSmallThirds_34,
    `D1Bound5.oneSmallThirds_34_checked,
    `D1Bound5.oneSmallThirds_34_complete,
    `D1Bound5.oneSmallPairA_35,
    `D1Bound5.oneSmallPairB_35,
    `D1Bound5.oneSmallThirds_35,
    `D1Bound5.oneSmallThirds_35_checked,
    `D1Bound5.oneSmallThirds_35_complete,
    `D1Bound5.oneSmallPairA_36,
    `D1Bound5.oneSmallPairB_36,
    `D1Bound5.oneSmallThirds_36,
    `D1Bound5.oneSmallThirds_36_checked,
    `D1Bound5.oneSmallThirds_36_complete,
    `D1Bound5.oneSmallPairA_37,
    `D1Bound5.oneSmallPairB_37,
    `D1Bound5.oneSmallThirds_37,
    `D1Bound5.oneSmallThirds_37_checked,
    `D1Bound5.oneSmallThirds_37_complete,
    `D1Bound5.oneSmallPairA_38,
    `D1Bound5.oneSmallPairB_38,
    `D1Bound5.oneSmallThirds_38,
    `D1Bound5.oneSmallThirds_38_checked,
    `D1Bound5.oneSmallThirds_38_complete,
    `D1Bound5.oneSmallPairA_39,
    `D1Bound5.oneSmallPairB_39,
    `D1Bound5.oneSmallThirds_39,
    `D1Bound5.oneSmallThirds_39_checked,
    `D1Bound5.oneSmallThirds_39_complete,
    `D1Bound5.oneSmallTripleS_0,
    `D1Bound5.oneSmallTripleCutoff_0,
    `D1Bound5.oneSmallFourth_0_checked,
    `D1Bound5.oneSmallFourth_0_growth,
    `D1Bound5.oneSmallTripleS_1,
    `D1Bound5.oneSmallTripleCutoff_1,
    `D1Bound5.oneSmallFourth_1_checked,
    `D1Bound5.oneSmallFourth_1_growth,
    `D1Bound5.oneSmallTripleS_2,
    `D1Bound5.oneSmallTripleCutoff_2,
    `D1Bound5.oneSmallFourth_2_checked,
    `D1Bound5.oneSmallFourth_2_growth,
    `D1Bound5.oneSmallTripleS_3,
    `D1Bound5.oneSmallTripleCutoff_3,
    `D1Bound5.oneSmallFourth_3_checked,
    `D1Bound5.oneSmallFourth_3_growth,
    `D1Bound5.oneSmallTripleS_4,
    `D1Bound5.oneSmallTripleCutoff_4,
    `D1Bound5.oneSmallFourth_4_checked,
    `D1Bound5.oneSmallFourth_4_growth,
    `D1Bound5.oneSmallTripleS_5,
    `D1Bound5.oneSmallTripleCutoff_5,
    `D1Bound5.oneSmallFourth_5_checked,
    `D1Bound5.oneSmallFourth_5_growth,
    `D1Bound5.oneSmallTripleS_6,
    `D1Bound5.oneSmallTripleCutoff_6,
    `D1Bound5.oneSmallFourth_6_checked,
    `D1Bound5.oneSmallFourth_6_growth,
    `D1Bound5.oneSmallTripleS_7,
    `D1Bound5.oneSmallTripleCutoff_7,
    `D1Bound5.oneSmallFourth_7_checked,
    `D1Bound5.oneSmallFourth_7_growth,
    `D1Bound5.oneSmallTripleS_8,
    `D1Bound5.oneSmallTripleCutoff_8,
    `D1Bound5.oneSmallFourth_8_checked,
    `D1Bound5.oneSmallFourth_8_growth,
    `D1Bound5.oneSmallTripleS_9,
    `D1Bound5.oneSmallTripleCutoff_9,
    `D1Bound5.oneSmallFourth_9_checked,
    `D1Bound5.oneSmallFourth_9_growth,
    `D1Bound5.oneSmallTripleS_10,
    `D1Bound5.oneSmallTripleCutoff_10,
    `D1Bound5.oneSmallFourth_10_checked,
    `D1Bound5.oneSmallFourth_10_growth,
    `D1Bound5.oneSmallTripleS_11,
    `D1Bound5.oneSmallTripleCutoff_11,
    `D1Bound5.oneSmallFourth_11_checked,
    `D1Bound5.oneSmallFourth_11_growth,
    `D1Bound5.oneSmallTripleS_12,
    `D1Bound5.oneSmallTripleCutoff_12,
    `D1Bound5.oneSmallFourth_12_checked,
    `D1Bound5.oneSmallFourth_12_growth,
    `D1Bound5.oneSmallTripleS_13,
    `D1Bound5.oneSmallTripleCutoff_13,
    `D1Bound5.oneSmallFourth_13_checked,
    `D1Bound5.oneSmallFourth_13_growth,
    `D1Bound5.oneSmallTripleS_14,
    `D1Bound5.oneSmallTripleCutoff_14,
    `D1Bound5.oneSmallFourth_14_checked,
    `D1Bound5.oneSmallFourth_14_growth,
    `D1Bound5.oneSmallTripleS_15,
    `D1Bound5.oneSmallTripleCutoff_15,
    `D1Bound5.oneSmallFourth_15_checked,
    `D1Bound5.oneSmallFourth_15_growth,
    `D1Bound5.oneSmallTripleS_16,
    `D1Bound5.oneSmallTripleCutoff_16,
    `D1Bound5.oneSmallFourth_16_checked,
    `D1Bound5.oneSmallFourth_16_growth,
    `D1Bound5.oneSmallTripleS_17,
    `D1Bound5.oneSmallTripleCutoff_17,
    `D1Bound5.oneSmallFourth_17_checked,
    `D1Bound5.oneSmallFourth_17_growth,
    `D1Bound5.oneSmallTripleS_18,
    `D1Bound5.oneSmallTripleCutoff_18,
    `D1Bound5.oneSmallFourth_18_checked,
    `D1Bound5.oneSmallFourth_18_growth,
    `D1Bound5.oneSmallTripleS_19,
    `D1Bound5.oneSmallTripleCutoff_19,
    `D1Bound5.oneSmallFourth_19_checked,
    `D1Bound5.oneSmallFourth_19_growth,
    `D1Bound5.oneSmallTripleS_20,
    `D1Bound5.oneSmallTripleCutoff_20,
    `D1Bound5.oneSmallFourth_20_checked,
    `D1Bound5.oneSmallFourth_20_growth,
    `D1Bound5.oneSmallTripleS_21,
    `D1Bound5.oneSmallTripleCutoff_21,
    `D1Bound5.oneSmallFourth_21_checked,
    `D1Bound5.oneSmallFourth_21_growth,
    `D1Bound5.oneSmallTripleS_22,
    `D1Bound5.oneSmallTripleCutoff_22,
    `D1Bound5.oneSmallFourth_22_checked,
    `D1Bound5.oneSmallFourth_22_growth,
    `D1Bound5.oneSmallTripleS_23,
    `D1Bound5.oneSmallTripleCutoff_23,
    `D1Bound5.oneSmallFourth_23_checked,
    `D1Bound5.oneSmallFourth_23_growth,
    `D1Bound5.oneSmallTripleS_24,
    `D1Bound5.oneSmallTripleCutoff_24,
    `D1Bound5.oneSmallFourth_24_checked,
    `D1Bound5.oneSmallFourth_24_growth,
    `D1Bound5.oneSmallTripleS_25,
    `D1Bound5.oneSmallTripleCutoff_25,
    `D1Bound5.oneSmallFourth_25_checked,
    `D1Bound5.oneSmallFourth_25_growth,
    `D1Bound5.oneSmallTripleS_26,
    `D1Bound5.oneSmallTripleCutoff_26,
    `D1Bound5.oneSmallFourth_26_checked,
    `D1Bound5.oneSmallFourth_26_growth,
    `D1Bound5.oneSmallTripleS_27,
    `D1Bound5.oneSmallTripleCutoff_27,
    `D1Bound5.oneSmallFourth_27_checked,
    `D1Bound5.oneSmallFourth_27_growth,
    `D1Bound5.oneSmallTripleS_28,
    `D1Bound5.oneSmallTripleCutoff_28,
    `D1Bound5.oneSmallFourth_28_checked,
    `D1Bound5.oneSmallFourth_28_growth,
    `D1Bound5.oneSmallTripleS_29,
    `D1Bound5.oneSmallTripleCutoff_29,
    `D1Bound5.oneSmallFourth_29_checked,
    `D1Bound5.oneSmallFourth_29_growth,
    `D1Bound5.oneSmallTripleS_30,
    `D1Bound5.oneSmallTripleCutoff_30,
    `D1Bound5.oneSmallFourth_30_checked,
    `D1Bound5.oneSmallFourth_30_growth,
    `D1Bound5.oneSmallTripleS_31,
    `D1Bound5.oneSmallTripleCutoff_31,
    `D1Bound5.oneSmallFourth_31_checked,
    `D1Bound5.oneSmallFourth_31_growth,
    `D1Bound5.oneSmallTripleS_32,
    `D1Bound5.oneSmallTripleCutoff_32,
    `D1Bound5.oneSmallFourth_32_checked,
    `D1Bound5.oneSmallFourth_32_growth,
    `D1Bound5.oneSmallTripleS_33,
    `D1Bound5.oneSmallTripleCutoff_33,
    `D1Bound5.oneSmallFourth_33_checked,
    `D1Bound5.oneSmallFourth_33_growth,
    `D1Bound5.oneSmallTripleS_34,
    `D1Bound5.oneSmallTripleCutoff_34,
    `D1Bound5.oneSmallFourth_34_checked,
    `D1Bound5.oneSmallFourth_34_growth,
    `D1Bound5.oneSmallTripleS_35,
    `D1Bound5.oneSmallTripleCutoff_35,
    `D1Bound5.oneSmallFourth_35_checked,
    `D1Bound5.oneSmallFourth_35_growth,
    `D1Bound5.oneSmallTripleS_36,
    `D1Bound5.oneSmallTripleCutoff_36,
    `D1Bound5.oneSmallFourth_36_checked,
    `D1Bound5.oneSmallFourth_36_growth,
    `D1Bound5.oneSmallTripleS_37,
    `D1Bound5.oneSmallTripleCutoff_37,
    `D1Bound5.oneSmallFourth_37_checked,
    `D1Bound5.oneSmallFourth_37_growth,
    `D1Bound5.oneSmallTripleS_38,
    `D1Bound5.oneSmallTripleCutoff_38,
    `D1Bound5.oneSmallFourth_38_checked,
    `D1Bound5.oneSmallFourth_38_growth,
    `D1Bound5.oneSmallTripleS_39,
    `D1Bound5.oneSmallTripleCutoff_39,
    `D1Bound5.oneSmallFourth_39_checked,
    `D1Bound5.oneSmallFourth_39_growth,
    `D1Bound5.oneSmallTripleS_40,
    `D1Bound5.oneSmallTripleCutoff_40,
    `D1Bound5.oneSmallFourth_40_checked,
    `D1Bound5.oneSmallFourth_40_growth,
    `D1Bound5.oneSmallTripleS_41,
    `D1Bound5.oneSmallTripleCutoff_41,
    `D1Bound5.oneSmallFourth_41_checked,
    `D1Bound5.oneSmallFourth_41_growth,
    `D1Bound5.oneSmallTripleS_42,
    `D1Bound5.oneSmallTripleCutoff_42,
    `D1Bound5.oneSmallFourth_42_checked,
    `D1Bound5.oneSmallFourth_42_growth,
    `D1Bound5.oneSmallTripleS_43,
    `D1Bound5.oneSmallTripleCutoff_43,
    `D1Bound5.oneSmallFourth_43_checked,
    `D1Bound5.oneSmallFourth_43_growth,
    `D1Bound5.oneSmallTripleS_44,
    `D1Bound5.oneSmallTripleCutoff_44,
    `D1Bound5.oneSmallFourth_44_checked,
    `D1Bound5.oneSmallFourth_44_growth,
    `D1Bound5.oneSmallTripleS_45,
    `D1Bound5.oneSmallTripleCutoff_45,
    `D1Bound5.oneSmallFourth_45_checked,
    `D1Bound5.oneSmallFourth_45_growth,
    `D1Bound5.oneSmallTripleS_46,
    `D1Bound5.oneSmallTripleCutoff_46,
    `D1Bound5.oneSmallFourth_46_checked,
    `D1Bound5.oneSmallFourth_46_growth,
    `D1Bound5.oneSmallTripleS_47,
    `D1Bound5.oneSmallTripleCutoff_47,
    `D1Bound5.oneSmallFourth_47_checked,
    `D1Bound5.oneSmallFourth_47_growth,
    `D1Bound5.oneSmallTripleS_48,
    `D1Bound5.oneSmallTripleCutoff_48,
    `D1Bound5.oneSmallFourth_48_checked,
    `D1Bound5.oneSmallFourth_48_growth,
    `D1Bound5.oneSmallTripleS_49,
    `D1Bound5.oneSmallTripleCutoff_49,
    `D1Bound5.oneSmallFourth_49_checked,
    `D1Bound5.oneSmallFourth_49_growth,
    `D1Bound5.oneSmallTripleS_50,
    `D1Bound5.oneSmallTripleCutoff_50,
    `D1Bound5.oneSmallFourth_50_checked,
    `D1Bound5.oneSmallFourth_50_growth,
    `D1Bound5.oneSmallTripleS_51,
    `D1Bound5.oneSmallTripleCutoff_51,
    `D1Bound5.oneSmallFourth_51_checked,
    `D1Bound5.oneSmallFourth_51_growth,
    `D1Bound5.oneSmallTripleS_52,
    `D1Bound5.oneSmallTripleCutoff_52,
    `D1Bound5.oneSmallFourth_52_checked,
    `D1Bound5.oneSmallFourth_52_growth,
    `D1Bound5.oneSmallTripleS_53,
    `D1Bound5.oneSmallTripleCutoff_53,
    `D1Bound5.oneSmallFourth_53_checked,
    `D1Bound5.oneSmallFourth_53_growth,
    `D1Bound5.oneSmallTripleS_54,
    `D1Bound5.oneSmallTripleCutoff_54,
    `D1Bound5.oneSmallFourth_54_checked,
    `D1Bound5.oneSmallFourth_54_growth,
    `D1Bound5.oneSmallTripleS_55,
    `D1Bound5.oneSmallTripleCutoff_55,
    `D1Bound5.oneSmallFourth_55_checked,
    `D1Bound5.oneSmallFourth_55_growth,
    `D1Bound5.OneSmallTripleRow,
    `D1Bound5.OneSmallTripleRow.mk,
    `D1Bound5.OneSmallTripleRow.tau,
    `D1Bound5.OneSmallTripleRow.nu,
    `D1Bound5.OneSmallTripleRow.a,
    `D1Bound5.OneSmallTripleRow.b,
    `D1Bound5.OneSmallTripleRow.s,
    `D1Bound5.OneSmallTripleRow.cutoff,
    `D1Bound5.oneSmallFixedRows,
    `D1Bound5.OneSmallTripleRow.anchorA,
    `D1Bound5.OneSmallTripleRow.anchorB,
    `D1Bound5.OneSmallTripleRow.anchorS,
    `D1Bound5.oneSmallFixedRows_bounded_growth,
    `D1Bound5.OneSmallRowMembership,
    `D1Bound5.OneSmallThirdRowProperty,
    `D1Bound5.oneSmallThirdRows_0_complete,
    `D1Bound5.oneSmallThirdRows_1_complete,
    `D1Bound5.oneSmallThirdRows_2_complete,
    `D1Bound5.oneSmallThirdRows_3_complete,
    `D1Bound5.oneSmallThirdRows_4_complete,
    `D1Bound5.oneSmallThirdRows_5_complete,
    `D1Bound5.oneSmallThirdRows_6_complete,
    `D1Bound5.oneSmallThirdRows_7_complete,
    `D1Bound5.oneSmallThirdRows_8_complete,
    `D1Bound5.oneSmallThirdRows_9_complete,
    `D1Bound5.oneSmallThirdRows_10_complete,
    `D1Bound5.oneSmallThirdRows_11_complete,
    `D1Bound5.oneSmallThirdRows_12_complete,
    `D1Bound5.oneSmallThirdRows_13_complete,
    `D1Bound5.oneSmallThirdRows_14_complete,
    `D1Bound5.oneSmallThirdRows_15_complete,
    `D1Bound5.oneSmallThirdRows_16_complete,
    `D1Bound5.oneSmallThirdRows_17_complete,
    `D1Bound5.oneSmallThirdRows_18_complete,
    `D1Bound5.oneSmallThirdRows_19_complete,
    `D1Bound5.oneSmallThirdRows_20_complete,
    `D1Bound5.oneSmallThirdRows_21_complete,
    `D1Bound5.oneSmallThirdRows_22_complete,
    `D1Bound5.oneSmallThirdRows_23_complete,
    `D1Bound5.oneSmallThirdRows_24_complete,
    `D1Bound5.oneSmallThirdRows_25_complete,
    `D1Bound5.oneSmallThirdRows_26_complete,
    `D1Bound5.oneSmallThirdRows_27_complete,
    `D1Bound5.oneSmallThirdRows_28_complete,
    `D1Bound5.oneSmallThirdRows_29_complete,
    `D1Bound5.oneSmallThirdRows_30_complete,
    `D1Bound5.oneSmallThirdRows_31_complete,
    `D1Bound5.oneSmallThirdRows_32_complete,
    `D1Bound5.oneSmallThirdRows_33_complete,
    `D1Bound5.oneSmallThirdRows_34_complete,
    `D1Bound5.oneSmallThirdRows_35_complete,
    `D1Bound5.oneSmallThirdRows_36_complete,
    `D1Bound5.oneSmallThirdRows_37_complete,
    `D1Bound5.oneSmallThirdRows_38_complete,
    `D1Bound5.oneSmallThirdRows_39_complete,
    `D1Bound5.oneSmallFixedRows_metadata,
    `D1Bound5.firstPairRowA,
    `D1Bound5.firstPairRowB,
    `D1Bound5.firstPairCoordinates_eq,
    `D1Bound5.firstPairOrbit_normalize,
    `D1Bound5.oneSmallSymmetry_square,
    `D1Bound5.OneSmallNormalizedThirdRows,
    `D1Bound5.oneSmallThirdRows_of_table_orbits,
    `D1Bound5.firstPairTable_0_1_third_rows,
    `D1Bound5.firstPairTable_0_2_third_rows,
    `D1Bound5.firstPairTable_0_5_third_rows,
    `D1Bound5.firstPairTable_0_6_third_rows,
    `D1Bound5.firstPairTable_1_1_third_rows,
    `D1Bound5.firstPairTable_1_2_third_rows,
    `D1Bound5.firstPairTable_1_3_third_rows,
    `D1Bound5.firstPairTable_1_4_third_rows,
    `D1Bound5.firstPairTable_1_5_third_rows,
    `D1Bound5.firstPairTable_1_6_third_rows,
    `D1Bound5.firstPairTable_third_rows,
    `D1Bound5.IsD1Tuple.one_small_first_triple_classification,
    `D1Bound5.oneSmallRowMembership_full_ring_bound,
    `D1Bound5.oneSmallRowMembership_full_ring_excludes_irregular_bound]
  for name in names do
    let ax ← Lean.collectAxioms name
    let bad := ax.filter fun n => !([`propext, `Classical.choice, `Quot.sound] : List Lean.Name).contains n
    unless bad.isEmpty do
      Lean.throwError "Unexpected axioms in {name}: {bad}"
    Lean.logInfo m!"ANALYTIC_AXIOMS_PASS {name}: {ax}"
#check @_root_.D1Bound5.oneSmallPairA_0
#check @_root_.D1Bound5.oneSmallPairB_0
#check @_root_.D1Bound5.oneSmallThirds_0
#check @_root_.D1Bound5.oneSmallThirds_0_checked
#check @_root_.D1Bound5.oneSmallThirds_0_complete
#check @_root_.D1Bound5.oneSmallPairA_1
#check @_root_.D1Bound5.oneSmallPairB_1
#check @_root_.D1Bound5.oneSmallThirds_1
#check @_root_.D1Bound5.oneSmallThirds_1_checked
#check @_root_.D1Bound5.oneSmallThirds_1_complete
#check @_root_.D1Bound5.oneSmallPairA_2
#check @_root_.D1Bound5.oneSmallPairB_2
#check @_root_.D1Bound5.oneSmallThirds_2
#check @_root_.D1Bound5.oneSmallThirds_2_checked
#check @_root_.D1Bound5.oneSmallThirds_2_complete
#check @_root_.D1Bound5.oneSmallPairA_3
#check @_root_.D1Bound5.oneSmallPairB_3
#check @_root_.D1Bound5.oneSmallThirds_3
#check @_root_.D1Bound5.oneSmallThirds_3_checked
#check @_root_.D1Bound5.oneSmallThirds_3_complete
#check @_root_.D1Bound5.oneSmallPairA_4
#check @_root_.D1Bound5.oneSmallPairB_4
#check @_root_.D1Bound5.oneSmallThirds_4
#check @_root_.D1Bound5.oneSmallThirds_4_checked
#check @_root_.D1Bound5.oneSmallThirds_4_complete
#check @_root_.D1Bound5.oneSmallPairA_5
#check @_root_.D1Bound5.oneSmallPairB_5
#check @_root_.D1Bound5.oneSmallThirds_5
#check @_root_.D1Bound5.oneSmallThirds_5_checked
#check @_root_.D1Bound5.oneSmallThirds_5_complete
#check @_root_.D1Bound5.oneSmallPairA_6
#check @_root_.D1Bound5.oneSmallPairB_6
#check @_root_.D1Bound5.oneSmallThirds_6
#check @_root_.D1Bound5.oneSmallThirds_6_checked
#check @_root_.D1Bound5.oneSmallThirds_6_complete
#check @_root_.D1Bound5.oneSmallPairA_7
#check @_root_.D1Bound5.oneSmallPairB_7
#check @_root_.D1Bound5.oneSmallThirds_7
#check @_root_.D1Bound5.oneSmallThirds_7_checked
#check @_root_.D1Bound5.oneSmallThirds_7_complete
#check @_root_.D1Bound5.oneSmallPairA_8
#check @_root_.D1Bound5.oneSmallPairB_8
#check @_root_.D1Bound5.oneSmallThirds_8
#check @_root_.D1Bound5.oneSmallThirds_8_checked
#check @_root_.D1Bound5.oneSmallThirds_8_complete
#check @_root_.D1Bound5.oneSmallPairA_9
#check @_root_.D1Bound5.oneSmallPairB_9
#check @_root_.D1Bound5.oneSmallThirds_9
#check @_root_.D1Bound5.oneSmallThirds_9_checked
#check @_root_.D1Bound5.oneSmallThirds_9_complete
#check @_root_.D1Bound5.oneSmallPairA_10
#check @_root_.D1Bound5.oneSmallPairB_10
#check @_root_.D1Bound5.oneSmallThirds_10
#check @_root_.D1Bound5.oneSmallThirds_10_checked
#check @_root_.D1Bound5.oneSmallThirds_10_complete
#check @_root_.D1Bound5.oneSmallPairA_11
#check @_root_.D1Bound5.oneSmallPairB_11
#check @_root_.D1Bound5.oneSmallThirds_11
#check @_root_.D1Bound5.oneSmallThirds_11_checked
#check @_root_.D1Bound5.oneSmallThirds_11_complete
#check @_root_.D1Bound5.oneSmallPairA_12
#check @_root_.D1Bound5.oneSmallPairB_12
#check @_root_.D1Bound5.oneSmallThirds_12
#check @_root_.D1Bound5.oneSmallThirds_12_checked
#check @_root_.D1Bound5.oneSmallThirds_12_complete
#check @_root_.D1Bound5.oneSmallPairA_13
#check @_root_.D1Bound5.oneSmallPairB_13
#check @_root_.D1Bound5.oneSmallThirds_13
#check @_root_.D1Bound5.oneSmallThirds_13_checked
#check @_root_.D1Bound5.oneSmallThirds_13_complete
#check @_root_.D1Bound5.oneSmallPairA_14
#check @_root_.D1Bound5.oneSmallPairB_14
#check @_root_.D1Bound5.oneSmallThirds_14
#check @_root_.D1Bound5.oneSmallThirds_14_checked
#check @_root_.D1Bound5.oneSmallThirds_14_complete
#check @_root_.D1Bound5.oneSmallPairA_15
#check @_root_.D1Bound5.oneSmallPairB_15
#check @_root_.D1Bound5.oneSmallThirds_15
#check @_root_.D1Bound5.oneSmallThirds_15_checked
#check @_root_.D1Bound5.oneSmallThirds_15_complete
#check @_root_.D1Bound5.oneSmallPairA_16
#check @_root_.D1Bound5.oneSmallPairB_16
#check @_root_.D1Bound5.oneSmallThirds_16
#check @_root_.D1Bound5.oneSmallThirds_16_checked
#check @_root_.D1Bound5.oneSmallThirds_16_complete
#check @_root_.D1Bound5.oneSmallPairA_17
#check @_root_.D1Bound5.oneSmallPairB_17
#check @_root_.D1Bound5.oneSmallThirds_17
#check @_root_.D1Bound5.oneSmallThirds_17_checked
#check @_root_.D1Bound5.oneSmallThirds_17_complete
#check @_root_.D1Bound5.oneSmallPairA_18
#check @_root_.D1Bound5.oneSmallPairB_18
#check @_root_.D1Bound5.oneSmallThirds_18
#check @_root_.D1Bound5.oneSmallThirds_18_checked
#check @_root_.D1Bound5.oneSmallThirds_18_complete
#check @_root_.D1Bound5.oneSmallPairA_19
#check @_root_.D1Bound5.oneSmallPairB_19
#check @_root_.D1Bound5.oneSmallThirds_19
#check @_root_.D1Bound5.oneSmallThirds_19_checked
#check @_root_.D1Bound5.oneSmallThirds_19_complete
#check @_root_.D1Bound5.oneSmallPairA_20
#check @_root_.D1Bound5.oneSmallPairB_20
#check @_root_.D1Bound5.oneSmallThirds_20
#check @_root_.D1Bound5.oneSmallThirds_20_checked
#check @_root_.D1Bound5.oneSmallThirds_20_complete
#check @_root_.D1Bound5.oneSmallPairA_21
#check @_root_.D1Bound5.oneSmallPairB_21
#check @_root_.D1Bound5.oneSmallThirds_21
#check @_root_.D1Bound5.oneSmallThirds_21_checked
#check @_root_.D1Bound5.oneSmallThirds_21_complete
#check @_root_.D1Bound5.oneSmallPairA_22
#check @_root_.D1Bound5.oneSmallPairB_22
#check @_root_.D1Bound5.oneSmallThirds_22
#check @_root_.D1Bound5.oneSmallThirds_22_checked
#check @_root_.D1Bound5.oneSmallThirds_22_complete
#check @_root_.D1Bound5.oneSmallPairA_23
#check @_root_.D1Bound5.oneSmallPairB_23
#check @_root_.D1Bound5.oneSmallThirds_23
#check @_root_.D1Bound5.oneSmallThirds_23_checked
#check @_root_.D1Bound5.oneSmallThirds_23_complete
#check @_root_.D1Bound5.oneSmallPairA_24
#check @_root_.D1Bound5.oneSmallPairB_24
#check @_root_.D1Bound5.oneSmallThirds_24
#check @_root_.D1Bound5.oneSmallThirds_24_checked
#check @_root_.D1Bound5.oneSmallThirds_24_complete
#check @_root_.D1Bound5.oneSmallPairA_25
#check @_root_.D1Bound5.oneSmallPairB_25
#check @_root_.D1Bound5.oneSmallThirds_25
#check @_root_.D1Bound5.oneSmallThirds_25_checked
#check @_root_.D1Bound5.oneSmallThirds_25_complete
#check @_root_.D1Bound5.oneSmallPairA_26
#check @_root_.D1Bound5.oneSmallPairB_26
#check @_root_.D1Bound5.oneSmallThirds_26
#check @_root_.D1Bound5.oneSmallThirds_26_checked
#check @_root_.D1Bound5.oneSmallThirds_26_complete
#check @_root_.D1Bound5.oneSmallPairA_27
#check @_root_.D1Bound5.oneSmallPairB_27
#check @_root_.D1Bound5.oneSmallThirds_27
#check @_root_.D1Bound5.oneSmallThirds_27_checked
#check @_root_.D1Bound5.oneSmallThirds_27_complete
#check @_root_.D1Bound5.oneSmallPairA_28
#check @_root_.D1Bound5.oneSmallPairB_28
#check @_root_.D1Bound5.oneSmallThirds_28
#check @_root_.D1Bound5.oneSmallThirds_28_checked
#check @_root_.D1Bound5.oneSmallThirds_28_complete
#check @_root_.D1Bound5.oneSmallPairA_29
#check @_root_.D1Bound5.oneSmallPairB_29
#check @_root_.D1Bound5.oneSmallThirds_29
#check @_root_.D1Bound5.oneSmallThirds_29_checked
#check @_root_.D1Bound5.oneSmallThirds_29_complete
#check @_root_.D1Bound5.oneSmallPairA_30
#check @_root_.D1Bound5.oneSmallPairB_30
#check @_root_.D1Bound5.oneSmallThirds_30
#check @_root_.D1Bound5.oneSmallThirds_30_checked
#check @_root_.D1Bound5.oneSmallThirds_30_complete
#check @_root_.D1Bound5.oneSmallPairA_31
#check @_root_.D1Bound5.oneSmallPairB_31
#check @_root_.D1Bound5.oneSmallThirds_31
#check @_root_.D1Bound5.oneSmallThirds_31_checked
#check @_root_.D1Bound5.oneSmallThirds_31_complete
#check @_root_.D1Bound5.oneSmallPairA_32
#check @_root_.D1Bound5.oneSmallPairB_32
#check @_root_.D1Bound5.oneSmallThirds_32
#check @_root_.D1Bound5.oneSmallThirds_32_checked
#check @_root_.D1Bound5.oneSmallThirds_32_complete
#check @_root_.D1Bound5.oneSmallPairA_33
#check @_root_.D1Bound5.oneSmallPairB_33
#check @_root_.D1Bound5.oneSmallThirds_33
#check @_root_.D1Bound5.oneSmallThirds_33_checked
#check @_root_.D1Bound5.oneSmallThirds_33_complete
#check @_root_.D1Bound5.oneSmallPairA_34
#check @_root_.D1Bound5.oneSmallPairB_34
#check @_root_.D1Bound5.oneSmallThirds_34
#check @_root_.D1Bound5.oneSmallThirds_34_checked
#check @_root_.D1Bound5.oneSmallThirds_34_complete
#check @_root_.D1Bound5.oneSmallPairA_35
#check @_root_.D1Bound5.oneSmallPairB_35
#check @_root_.D1Bound5.oneSmallThirds_35
#check @_root_.D1Bound5.oneSmallThirds_35_checked
#check @_root_.D1Bound5.oneSmallThirds_35_complete
#check @_root_.D1Bound5.oneSmallPairA_36
#check @_root_.D1Bound5.oneSmallPairB_36
#check @_root_.D1Bound5.oneSmallThirds_36
#check @_root_.D1Bound5.oneSmallThirds_36_checked
#check @_root_.D1Bound5.oneSmallThirds_36_complete
#check @_root_.D1Bound5.oneSmallPairA_37
#check @_root_.D1Bound5.oneSmallPairB_37
#check @_root_.D1Bound5.oneSmallThirds_37
#check @_root_.D1Bound5.oneSmallThirds_37_checked
#check @_root_.D1Bound5.oneSmallThirds_37_complete
#check @_root_.D1Bound5.oneSmallPairA_38
#check @_root_.D1Bound5.oneSmallPairB_38
#check @_root_.D1Bound5.oneSmallThirds_38
#check @_root_.D1Bound5.oneSmallThirds_38_checked
#check @_root_.D1Bound5.oneSmallThirds_38_complete
#check @_root_.D1Bound5.oneSmallPairA_39
#check @_root_.D1Bound5.oneSmallPairB_39
#check @_root_.D1Bound5.oneSmallThirds_39
#check @_root_.D1Bound5.oneSmallThirds_39_checked
#check @_root_.D1Bound5.oneSmallThirds_39_complete
#check @_root_.D1Bound5.oneSmallTripleS_0
#check @_root_.D1Bound5.oneSmallTripleCutoff_0
#check @_root_.D1Bound5.oneSmallFourth_0_checked
#check @_root_.D1Bound5.oneSmallFourth_0_growth
#check @_root_.D1Bound5.oneSmallTripleS_1
#check @_root_.D1Bound5.oneSmallTripleCutoff_1
#check @_root_.D1Bound5.oneSmallFourth_1_checked
#check @_root_.D1Bound5.oneSmallFourth_1_growth
#check @_root_.D1Bound5.oneSmallTripleS_2
#check @_root_.D1Bound5.oneSmallTripleCutoff_2
#check @_root_.D1Bound5.oneSmallFourth_2_checked
#check @_root_.D1Bound5.oneSmallFourth_2_growth
#check @_root_.D1Bound5.oneSmallTripleS_3
#check @_root_.D1Bound5.oneSmallTripleCutoff_3
#check @_root_.D1Bound5.oneSmallFourth_3_checked
#check @_root_.D1Bound5.oneSmallFourth_3_growth
#check @_root_.D1Bound5.oneSmallTripleS_4
#check @_root_.D1Bound5.oneSmallTripleCutoff_4
#check @_root_.D1Bound5.oneSmallFourth_4_checked
#check @_root_.D1Bound5.oneSmallFourth_4_growth
#check @_root_.D1Bound5.oneSmallTripleS_5
#check @_root_.D1Bound5.oneSmallTripleCutoff_5
#check @_root_.D1Bound5.oneSmallFourth_5_checked
#check @_root_.D1Bound5.oneSmallFourth_5_growth
#check @_root_.D1Bound5.oneSmallTripleS_6
#check @_root_.D1Bound5.oneSmallTripleCutoff_6
#check @_root_.D1Bound5.oneSmallFourth_6_checked
#check @_root_.D1Bound5.oneSmallFourth_6_growth
#check @_root_.D1Bound5.oneSmallTripleS_7
#check @_root_.D1Bound5.oneSmallTripleCutoff_7
#check @_root_.D1Bound5.oneSmallFourth_7_checked
#check @_root_.D1Bound5.oneSmallFourth_7_growth
#check @_root_.D1Bound5.oneSmallTripleS_8
#check @_root_.D1Bound5.oneSmallTripleCutoff_8
#check @_root_.D1Bound5.oneSmallFourth_8_checked
#check @_root_.D1Bound5.oneSmallFourth_8_growth
#check @_root_.D1Bound5.oneSmallTripleS_9
#check @_root_.D1Bound5.oneSmallTripleCutoff_9
#check @_root_.D1Bound5.oneSmallFourth_9_checked
#check @_root_.D1Bound5.oneSmallFourth_9_growth
#check @_root_.D1Bound5.oneSmallTripleS_10
#check @_root_.D1Bound5.oneSmallTripleCutoff_10
#check @_root_.D1Bound5.oneSmallFourth_10_checked
#check @_root_.D1Bound5.oneSmallFourth_10_growth
#check @_root_.D1Bound5.oneSmallTripleS_11
#check @_root_.D1Bound5.oneSmallTripleCutoff_11
#check @_root_.D1Bound5.oneSmallFourth_11_checked
#check @_root_.D1Bound5.oneSmallFourth_11_growth
#check @_root_.D1Bound5.oneSmallTripleS_12
#check @_root_.D1Bound5.oneSmallTripleCutoff_12
#check @_root_.D1Bound5.oneSmallFourth_12_checked
#check @_root_.D1Bound5.oneSmallFourth_12_growth
#check @_root_.D1Bound5.oneSmallTripleS_13
#check @_root_.D1Bound5.oneSmallTripleCutoff_13
#check @_root_.D1Bound5.oneSmallFourth_13_checked
#check @_root_.D1Bound5.oneSmallFourth_13_growth
#check @_root_.D1Bound5.oneSmallTripleS_14
#check @_root_.D1Bound5.oneSmallTripleCutoff_14
#check @_root_.D1Bound5.oneSmallFourth_14_checked
#check @_root_.D1Bound5.oneSmallFourth_14_growth
#check @_root_.D1Bound5.oneSmallTripleS_15
#check @_root_.D1Bound5.oneSmallTripleCutoff_15
#check @_root_.D1Bound5.oneSmallFourth_15_checked
#check @_root_.D1Bound5.oneSmallFourth_15_growth
#check @_root_.D1Bound5.oneSmallTripleS_16
#check @_root_.D1Bound5.oneSmallTripleCutoff_16
#check @_root_.D1Bound5.oneSmallFourth_16_checked
#check @_root_.D1Bound5.oneSmallFourth_16_growth
#check @_root_.D1Bound5.oneSmallTripleS_17
#check @_root_.D1Bound5.oneSmallTripleCutoff_17
#check @_root_.D1Bound5.oneSmallFourth_17_checked
#check @_root_.D1Bound5.oneSmallFourth_17_growth
#check @_root_.D1Bound5.oneSmallTripleS_18
#check @_root_.D1Bound5.oneSmallTripleCutoff_18
#check @_root_.D1Bound5.oneSmallFourth_18_checked
#check @_root_.D1Bound5.oneSmallFourth_18_growth
#check @_root_.D1Bound5.oneSmallTripleS_19
#check @_root_.D1Bound5.oneSmallTripleCutoff_19
#check @_root_.D1Bound5.oneSmallFourth_19_checked
#check @_root_.D1Bound5.oneSmallFourth_19_growth
#check @_root_.D1Bound5.oneSmallTripleS_20
#check @_root_.D1Bound5.oneSmallTripleCutoff_20
#check @_root_.D1Bound5.oneSmallFourth_20_checked
#check @_root_.D1Bound5.oneSmallFourth_20_growth
#check @_root_.D1Bound5.oneSmallTripleS_21
#check @_root_.D1Bound5.oneSmallTripleCutoff_21
#check @_root_.D1Bound5.oneSmallFourth_21_checked
#check @_root_.D1Bound5.oneSmallFourth_21_growth
#check @_root_.D1Bound5.oneSmallTripleS_22
#check @_root_.D1Bound5.oneSmallTripleCutoff_22
#check @_root_.D1Bound5.oneSmallFourth_22_checked
#check @_root_.D1Bound5.oneSmallFourth_22_growth
#check @_root_.D1Bound5.oneSmallTripleS_23
#check @_root_.D1Bound5.oneSmallTripleCutoff_23
#check @_root_.D1Bound5.oneSmallFourth_23_checked
#check @_root_.D1Bound5.oneSmallFourth_23_growth
#check @_root_.D1Bound5.oneSmallTripleS_24
#check @_root_.D1Bound5.oneSmallTripleCutoff_24
#check @_root_.D1Bound5.oneSmallFourth_24_checked
#check @_root_.D1Bound5.oneSmallFourth_24_growth
#check @_root_.D1Bound5.oneSmallTripleS_25
#check @_root_.D1Bound5.oneSmallTripleCutoff_25
#check @_root_.D1Bound5.oneSmallFourth_25_checked
#check @_root_.D1Bound5.oneSmallFourth_25_growth
#check @_root_.D1Bound5.oneSmallTripleS_26
#check @_root_.D1Bound5.oneSmallTripleCutoff_26
#check @_root_.D1Bound5.oneSmallFourth_26_checked
#check @_root_.D1Bound5.oneSmallFourth_26_growth
#check @_root_.D1Bound5.oneSmallTripleS_27
#check @_root_.D1Bound5.oneSmallTripleCutoff_27
#check @_root_.D1Bound5.oneSmallFourth_27_checked
#check @_root_.D1Bound5.oneSmallFourth_27_growth
#check @_root_.D1Bound5.oneSmallTripleS_28
#check @_root_.D1Bound5.oneSmallTripleCutoff_28
#check @_root_.D1Bound5.oneSmallFourth_28_checked
#check @_root_.D1Bound5.oneSmallFourth_28_growth
#check @_root_.D1Bound5.oneSmallTripleS_29
#check @_root_.D1Bound5.oneSmallTripleCutoff_29
#check @_root_.D1Bound5.oneSmallFourth_29_checked
#check @_root_.D1Bound5.oneSmallFourth_29_growth
#check @_root_.D1Bound5.oneSmallTripleS_30
#check @_root_.D1Bound5.oneSmallTripleCutoff_30
#check @_root_.D1Bound5.oneSmallFourth_30_checked
#check @_root_.D1Bound5.oneSmallFourth_30_growth
#check @_root_.D1Bound5.oneSmallTripleS_31
#check @_root_.D1Bound5.oneSmallTripleCutoff_31
#check @_root_.D1Bound5.oneSmallFourth_31_checked
#check @_root_.D1Bound5.oneSmallFourth_31_growth
#check @_root_.D1Bound5.oneSmallTripleS_32
#check @_root_.D1Bound5.oneSmallTripleCutoff_32
#check @_root_.D1Bound5.oneSmallFourth_32_checked
#check @_root_.D1Bound5.oneSmallFourth_32_growth
#check @_root_.D1Bound5.oneSmallTripleS_33
#check @_root_.D1Bound5.oneSmallTripleCutoff_33
#check @_root_.D1Bound5.oneSmallFourth_33_checked
#check @_root_.D1Bound5.oneSmallFourth_33_growth
#check @_root_.D1Bound5.oneSmallTripleS_34
#check @_root_.D1Bound5.oneSmallTripleCutoff_34
#check @_root_.D1Bound5.oneSmallFourth_34_checked
#check @_root_.D1Bound5.oneSmallFourth_34_growth
#check @_root_.D1Bound5.oneSmallTripleS_35
#check @_root_.D1Bound5.oneSmallTripleCutoff_35
#check @_root_.D1Bound5.oneSmallFourth_35_checked
#check @_root_.D1Bound5.oneSmallFourth_35_growth
#check @_root_.D1Bound5.oneSmallTripleS_36
#check @_root_.D1Bound5.oneSmallTripleCutoff_36
#check @_root_.D1Bound5.oneSmallFourth_36_checked
#check @_root_.D1Bound5.oneSmallFourth_36_growth
#check @_root_.D1Bound5.oneSmallTripleS_37
#check @_root_.D1Bound5.oneSmallTripleCutoff_37
#check @_root_.D1Bound5.oneSmallFourth_37_checked
#check @_root_.D1Bound5.oneSmallFourth_37_growth
#check @_root_.D1Bound5.oneSmallTripleS_38
#check @_root_.D1Bound5.oneSmallTripleCutoff_38
#check @_root_.D1Bound5.oneSmallFourth_38_checked
#check @_root_.D1Bound5.oneSmallFourth_38_growth
#check @_root_.D1Bound5.oneSmallTripleS_39
#check @_root_.D1Bound5.oneSmallTripleCutoff_39
#check @_root_.D1Bound5.oneSmallFourth_39_checked
#check @_root_.D1Bound5.oneSmallFourth_39_growth
#check @_root_.D1Bound5.oneSmallTripleS_40
#check @_root_.D1Bound5.oneSmallTripleCutoff_40
#check @_root_.D1Bound5.oneSmallFourth_40_checked
#check @_root_.D1Bound5.oneSmallFourth_40_growth
#check @_root_.D1Bound5.oneSmallTripleS_41
#check @_root_.D1Bound5.oneSmallTripleCutoff_41
#check @_root_.D1Bound5.oneSmallFourth_41_checked
#check @_root_.D1Bound5.oneSmallFourth_41_growth
#check @_root_.D1Bound5.oneSmallTripleS_42
#check @_root_.D1Bound5.oneSmallTripleCutoff_42
#check @_root_.D1Bound5.oneSmallFourth_42_checked
#check @_root_.D1Bound5.oneSmallFourth_42_growth
#check @_root_.D1Bound5.oneSmallTripleS_43
#check @_root_.D1Bound5.oneSmallTripleCutoff_43
#check @_root_.D1Bound5.oneSmallFourth_43_checked
#check @_root_.D1Bound5.oneSmallFourth_43_growth
#check @_root_.D1Bound5.oneSmallTripleS_44
#check @_root_.D1Bound5.oneSmallTripleCutoff_44
#check @_root_.D1Bound5.oneSmallFourth_44_checked
#check @_root_.D1Bound5.oneSmallFourth_44_growth
#check @_root_.D1Bound5.oneSmallTripleS_45
#check @_root_.D1Bound5.oneSmallTripleCutoff_45
#check @_root_.D1Bound5.oneSmallFourth_45_checked
#check @_root_.D1Bound5.oneSmallFourth_45_growth
#check @_root_.D1Bound5.oneSmallTripleS_46
#check @_root_.D1Bound5.oneSmallTripleCutoff_46
#check @_root_.D1Bound5.oneSmallFourth_46_checked
#check @_root_.D1Bound5.oneSmallFourth_46_growth
#check @_root_.D1Bound5.oneSmallTripleS_47
#check @_root_.D1Bound5.oneSmallTripleCutoff_47
#check @_root_.D1Bound5.oneSmallFourth_47_checked
#check @_root_.D1Bound5.oneSmallFourth_47_growth
#check @_root_.D1Bound5.oneSmallTripleS_48
#check @_root_.D1Bound5.oneSmallTripleCutoff_48
#check @_root_.D1Bound5.oneSmallFourth_48_checked
#check @_root_.D1Bound5.oneSmallFourth_48_growth
#check @_root_.D1Bound5.oneSmallTripleS_49
#check @_root_.D1Bound5.oneSmallTripleCutoff_49
#check @_root_.D1Bound5.oneSmallFourth_49_checked
#check @_root_.D1Bound5.oneSmallFourth_49_growth
#check @_root_.D1Bound5.oneSmallTripleS_50
#check @_root_.D1Bound5.oneSmallTripleCutoff_50
#check @_root_.D1Bound5.oneSmallFourth_50_checked
#check @_root_.D1Bound5.oneSmallFourth_50_growth
#check @_root_.D1Bound5.oneSmallTripleS_51
#check @_root_.D1Bound5.oneSmallTripleCutoff_51
#check @_root_.D1Bound5.oneSmallFourth_51_checked
#check @_root_.D1Bound5.oneSmallFourth_51_growth
#check @_root_.D1Bound5.oneSmallTripleS_52
#check @_root_.D1Bound5.oneSmallTripleCutoff_52
#check @_root_.D1Bound5.oneSmallFourth_52_checked
#check @_root_.D1Bound5.oneSmallFourth_52_growth
#check @_root_.D1Bound5.oneSmallTripleS_53
#check @_root_.D1Bound5.oneSmallTripleCutoff_53
#check @_root_.D1Bound5.oneSmallFourth_53_checked
#check @_root_.D1Bound5.oneSmallFourth_53_growth
#check @_root_.D1Bound5.oneSmallTripleS_54
#check @_root_.D1Bound5.oneSmallTripleCutoff_54
#check @_root_.D1Bound5.oneSmallFourth_54_checked
#check @_root_.D1Bound5.oneSmallFourth_54_growth
#check @_root_.D1Bound5.oneSmallTripleS_55
#check @_root_.D1Bound5.oneSmallTripleCutoff_55
#check @_root_.D1Bound5.oneSmallFourth_55_checked
#check @_root_.D1Bound5.oneSmallFourth_55_growth
#check @_root_.D1Bound5.OneSmallTripleRow
#check @_root_.D1Bound5.OneSmallTripleRow.mk
#check @_root_.D1Bound5.OneSmallTripleRow.tau
#check @_root_.D1Bound5.OneSmallTripleRow.nu
#check @_root_.D1Bound5.OneSmallTripleRow.a
#check @_root_.D1Bound5.OneSmallTripleRow.b
#check @_root_.D1Bound5.OneSmallTripleRow.s
#check @_root_.D1Bound5.OneSmallTripleRow.cutoff
#check @_root_.D1Bound5.oneSmallFixedRows
#check @_root_.D1Bound5.OneSmallTripleRow.anchorA
#check @_root_.D1Bound5.OneSmallTripleRow.anchorB
#check @_root_.D1Bound5.OneSmallTripleRow.anchorS
#check @_root_.D1Bound5.oneSmallFixedRows_bounded_growth
#check @_root_.D1Bound5.OneSmallRowMembership
#check @_root_.D1Bound5.OneSmallThirdRowProperty
#check @_root_.D1Bound5.oneSmallThirdRows_0_complete
#check @_root_.D1Bound5.oneSmallThirdRows_1_complete
#check @_root_.D1Bound5.oneSmallThirdRows_2_complete
#check @_root_.D1Bound5.oneSmallThirdRows_3_complete
#check @_root_.D1Bound5.oneSmallThirdRows_4_complete
#check @_root_.D1Bound5.oneSmallThirdRows_5_complete
#check @_root_.D1Bound5.oneSmallThirdRows_6_complete
#check @_root_.D1Bound5.oneSmallThirdRows_7_complete
#check @_root_.D1Bound5.oneSmallThirdRows_8_complete
#check @_root_.D1Bound5.oneSmallThirdRows_9_complete
#check @_root_.D1Bound5.oneSmallThirdRows_10_complete
#check @_root_.D1Bound5.oneSmallThirdRows_11_complete
#check @_root_.D1Bound5.oneSmallThirdRows_12_complete
#check @_root_.D1Bound5.oneSmallThirdRows_13_complete
#check @_root_.D1Bound5.oneSmallThirdRows_14_complete
#check @_root_.D1Bound5.oneSmallThirdRows_15_complete
#check @_root_.D1Bound5.oneSmallThirdRows_16_complete
#check @_root_.D1Bound5.oneSmallThirdRows_17_complete
#check @_root_.D1Bound5.oneSmallThirdRows_18_complete
#check @_root_.D1Bound5.oneSmallThirdRows_19_complete
#check @_root_.D1Bound5.oneSmallThirdRows_20_complete
#check @_root_.D1Bound5.oneSmallThirdRows_21_complete
#check @_root_.D1Bound5.oneSmallThirdRows_22_complete
#check @_root_.D1Bound5.oneSmallThirdRows_23_complete
#check @_root_.D1Bound5.oneSmallThirdRows_24_complete
#check @_root_.D1Bound5.oneSmallThirdRows_25_complete
#check @_root_.D1Bound5.oneSmallThirdRows_26_complete
#check @_root_.D1Bound5.oneSmallThirdRows_27_complete
#check @_root_.D1Bound5.oneSmallThirdRows_28_complete
#check @_root_.D1Bound5.oneSmallThirdRows_29_complete
#check @_root_.D1Bound5.oneSmallThirdRows_30_complete
#check @_root_.D1Bound5.oneSmallThirdRows_31_complete
#check @_root_.D1Bound5.oneSmallThirdRows_32_complete
#check @_root_.D1Bound5.oneSmallThirdRows_33_complete
#check @_root_.D1Bound5.oneSmallThirdRows_34_complete
#check @_root_.D1Bound5.oneSmallThirdRows_35_complete
#check @_root_.D1Bound5.oneSmallThirdRows_36_complete
#check @_root_.D1Bound5.oneSmallThirdRows_37_complete
#check @_root_.D1Bound5.oneSmallThirdRows_38_complete
#check @_root_.D1Bound5.oneSmallThirdRows_39_complete
#check @_root_.D1Bound5.oneSmallFixedRows_metadata
#check @_root_.D1Bound5.firstPairRowA
#check @_root_.D1Bound5.firstPairRowB
#check @_root_.D1Bound5.firstPairCoordinates_eq
#check @_root_.D1Bound5.firstPairOrbit_normalize
#check @_root_.D1Bound5.oneSmallSymmetry_square
#check @_root_.D1Bound5.OneSmallNormalizedThirdRows
#check @_root_.D1Bound5.oneSmallThirdRows_of_table_orbits
#check @_root_.D1Bound5.firstPairTable_0_1_third_rows
#check @_root_.D1Bound5.firstPairTable_0_2_third_rows
#check @_root_.D1Bound5.firstPairTable_0_5_third_rows
#check @_root_.D1Bound5.firstPairTable_0_6_third_rows
#check @_root_.D1Bound5.firstPairTable_1_1_third_rows
#check @_root_.D1Bound5.firstPairTable_1_2_third_rows
#check @_root_.D1Bound5.firstPairTable_1_3_third_rows
#check @_root_.D1Bound5.firstPairTable_1_4_third_rows
#check @_root_.D1Bound5.firstPairTable_1_5_third_rows
#check @_root_.D1Bound5.firstPairTable_1_6_third_rows
#check @_root_.D1Bound5.firstPairTable_third_rows
#check @_root_.D1Bound5.IsD1Tuple.one_small_first_triple_classification
#check @_root_.D1Bound5.oneSmallRowMembership_full_ring_bound
#check @_root_.D1Bound5.oneSmallRowMembership_full_ring_excludes_irregular_bound

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_0 oneSmallPairB_0
      oneSmallDisk_224_0_1 oneSmallThirds_0 = true := by
  exact _root_.D1Bound5.oneSmallThirds_0_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_0.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_0) (hb : s ≠ oneSmallPairB_0)
    (hpair : PairExtension oneSmallPairA_0 oneSmallPairB_0 s) : s ∈ oneSmallThirds_0 := by
  exact _root_.D1Bound5.oneSmallThirds_0_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_1 oneSmallPairB_1
      oneSmallDisk_224_0_1 oneSmallThirds_1 = true := by
  exact _root_.D1Bound5.oneSmallThirds_1_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_1.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_1) (hb : s ≠ oneSmallPairB_1)
    (hpair : PairExtension oneSmallPairA_1 oneSmallPairB_1 s) : s ∈ oneSmallThirds_1 := by
  exact _root_.D1Bound5.oneSmallThirds_1_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_2 oneSmallPairB_2
      oneSmallDisk_224_0_1 oneSmallThirds_2 = true := by
  exact _root_.D1Bound5.oneSmallThirds_2_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_2.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_2) (hb : s ≠ oneSmallPairB_2)
    (hpair : PairExtension oneSmallPairA_2 oneSmallPairB_2 s) : s ∈ oneSmallThirds_2 := by
  exact _root_.D1Bound5.oneSmallThirds_2_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_3 oneSmallPairB_3
      oneSmallDisk_224_0_1 oneSmallThirds_3 = true := by
  exact _root_.D1Bound5.oneSmallThirds_3_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_3.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_3) (hb : s ≠ oneSmallPairB_3)
    (hpair : PairExtension oneSmallPairA_3 oneSmallPairB_3 s) : s ∈ oneSmallThirds_3 := by
  exact _root_.D1Bound5.oneSmallThirds_3_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_4 oneSmallPairB_4
      oneSmallDisk_224_0_1 oneSmallThirds_4 = true := by
  exact _root_.D1Bound5.oneSmallThirds_4_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_4.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_4) (hb : s ≠ oneSmallPairB_4)
    (hpair : PairExtension oneSmallPairA_4 oneSmallPairB_4 s) : s ∈ oneSmallThirds_4 := by
  exact _root_.D1Bound5.oneSmallThirds_4_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_5 oneSmallPairB_5
      oneSmallDisk_224_0_1 oneSmallThirds_5 = true := by
  exact _root_.D1Bound5.oneSmallThirds_5_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_5.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_5) (hb : s ≠ oneSmallPairB_5)
    (hpair : PairExtension oneSmallPairA_5 oneSmallPairB_5 s) : s ∈ oneSmallThirds_5 := by
  exact _root_.D1Bound5.oneSmallThirds_5_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_6 oneSmallPairB_6
      oneSmallDisk_224_0_1 oneSmallThirds_6 = true := by
  exact _root_.D1Bound5.oneSmallThirds_6_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_6.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_6) (hb : s ≠ oneSmallPairB_6)
    (hpair : PairExtension oneSmallPairA_6 oneSmallPairB_6 s) : s ∈ oneSmallThirds_6 := by
  exact _root_.D1Bound5.oneSmallThirds_6_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_7 oneSmallPairB_7
      oneSmallDisk_224_0_2 oneSmallThirds_7 = true := by
  exact _root_.D1Bound5.oneSmallThirds_7_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 2) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_7.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_7) (hb : s ≠ oneSmallPairB_7)
    (hpair : PairExtension oneSmallPairA_7 oneSmallPairB_7 s) : s ∈ oneSmallThirds_7 := by
  exact _root_.D1Bound5.oneSmallThirds_7_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_8 oneSmallPairB_8
      oneSmallDisk_224_0_2 oneSmallThirds_8 = true := by
  exact _root_.D1Bound5.oneSmallThirds_8_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 2) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_8.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_8) (hb : s ≠ oneSmallPairB_8)
    (hpair : PairExtension oneSmallPairA_8 oneSmallPairB_8 s) : s ∈ oneSmallThirds_8 := by
  exact _root_.D1Bound5.oneSmallThirds_8_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_9 oneSmallPairB_9
      oneSmallDisk_224_0_2 oneSmallThirds_9 = true := by
  exact _root_.D1Bound5.oneSmallThirds_9_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 2) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_9.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_9) (hb : s ≠ oneSmallPairB_9)
    (hpair : PairExtension oneSmallPairA_9 oneSmallPairB_9 s) : s ∈ oneSmallThirds_9 := by
  exact _root_.D1Bound5.oneSmallThirds_9_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_10 oneSmallPairB_10
      oneSmallDisk_224_1_1 oneSmallThirds_10 = true := by
  exact _root_.D1Bound5.oneSmallThirds_10_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_10.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_10) (hb : s ≠ oneSmallPairB_10)
    (hpair : PairExtension oneSmallPairA_10 oneSmallPairB_10 s) : s ∈ oneSmallThirds_10 := by
  exact _root_.D1Bound5.oneSmallThirds_10_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_11 oneSmallPairB_11
      oneSmallDisk_224_1_1 oneSmallThirds_11 = true := by
  exact _root_.D1Bound5.oneSmallThirds_11_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_11.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_11) (hb : s ≠ oneSmallPairB_11)
    (hpair : PairExtension oneSmallPairA_11 oneSmallPairB_11 s) : s ∈ oneSmallThirds_11 := by
  exact _root_.D1Bound5.oneSmallThirds_11_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_12 oneSmallPairB_12
      oneSmallDisk_224_1_1 oneSmallThirds_12 = true := by
  exact _root_.D1Bound5.oneSmallThirds_12_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_12.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_12) (hb : s ≠ oneSmallPairB_12)
    (hpair : PairExtension oneSmallPairA_12 oneSmallPairB_12 s) : s ∈ oneSmallThirds_12 := by
  exact _root_.D1Bound5.oneSmallThirds_12_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_13 oneSmallPairB_13
      oneSmallDisk_224_1_1 oneSmallThirds_13 = true := by
  exact _root_.D1Bound5.oneSmallThirds_13_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_13.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_13) (hb : s ≠ oneSmallPairB_13)
    (hpair : PairExtension oneSmallPairA_13 oneSmallPairB_13 s) : s ∈ oneSmallThirds_13 := by
  exact _root_.D1Bound5.oneSmallThirds_13_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_14 oneSmallPairB_14
      oneSmallDisk_224_1_1 oneSmallThirds_14 = true := by
  exact _root_.D1Bound5.oneSmallThirds_14_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_14.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_14) (hb : s ≠ oneSmallPairB_14)
    (hpair : PairExtension oneSmallPairA_14 oneSmallPairB_14 s) : s ∈ oneSmallThirds_14 := by
  exact _root_.D1Bound5.oneSmallThirds_14_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_15 oneSmallPairB_15
      oneSmallDisk_224_1_1 oneSmallThirds_15 = true := by
  exact _root_.D1Bound5.oneSmallThirds_15_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_15.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_15) (hb : s ≠ oneSmallPairB_15)
    (hpair : PairExtension oneSmallPairA_15 oneSmallPairB_15 s) : s ∈ oneSmallThirds_15 := by
  exact _root_.D1Bound5.oneSmallThirds_15_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_16 oneSmallPairB_16
      oneSmallDisk_224_1_1 oneSmallThirds_16 = true := by
  exact _root_.D1Bound5.oneSmallThirds_16_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_16.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_16) (hb : s ≠ oneSmallPairB_16)
    (hpair : PairExtension oneSmallPairA_16 oneSmallPairB_16 s) : s ∈ oneSmallThirds_16 := by
  exact _root_.D1Bound5.oneSmallThirds_16_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_17 oneSmallPairB_17
      oneSmallDisk_224_1_1 oneSmallThirds_17 = true := by
  exact _root_.D1Bound5.oneSmallThirds_17_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_17.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_17) (hb : s ≠ oneSmallPairB_17)
    (hpair : PairExtension oneSmallPairA_17 oneSmallPairB_17 s) : s ∈ oneSmallThirds_17 := by
  exact _root_.D1Bound5.oneSmallThirds_17_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_18 oneSmallPairB_18
      oneSmallDisk_224_1_1 oneSmallThirds_18 = true := by
  exact _root_.D1Bound5.oneSmallThirds_18_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_18.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_18) (hb : s ≠ oneSmallPairB_18)
    (hpair : PairExtension oneSmallPairA_18 oneSmallPairB_18 s) : s ∈ oneSmallThirds_18 := by
  exact _root_.D1Bound5.oneSmallThirds_18_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_19 oneSmallPairB_19
      oneSmallDisk_224_1_1 oneSmallThirds_19 = true := by
  exact _root_.D1Bound5.oneSmallThirds_19_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_19.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_19) (hb : s ≠ oneSmallPairB_19)
    (hpair : PairExtension oneSmallPairA_19 oneSmallPairB_19 s) : s ∈ oneSmallThirds_19 := by
  exact _root_.D1Bound5.oneSmallThirds_19_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_20 oneSmallPairB_20
      oneSmallDisk_224_1_1 oneSmallThirds_20 = true := by
  exact _root_.D1Bound5.oneSmallThirds_20_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_20.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_20) (hb : s ≠ oneSmallPairB_20)
    (hpair : PairExtension oneSmallPairA_20 oneSmallPairB_20 s) : s ∈ oneSmallThirds_20 := by
  exact _root_.D1Bound5.oneSmallThirds_20_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_21 oneSmallPairB_21
      oneSmallDisk_224_1_1 oneSmallThirds_21 = true := by
  exact _root_.D1Bound5.oneSmallThirds_21_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_21.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_21) (hb : s ≠ oneSmallPairB_21)
    (hpair : PairExtension oneSmallPairA_21 oneSmallPairB_21 s) : s ∈ oneSmallThirds_21 := by
  exact _root_.D1Bound5.oneSmallThirds_21_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_22 oneSmallPairB_22
      oneSmallDisk_224_1_1 oneSmallThirds_22 = true := by
  exact _root_.D1Bound5.oneSmallThirds_22_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_22.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_22) (hb : s ≠ oneSmallPairB_22)
    (hpair : PairExtension oneSmallPairA_22 oneSmallPairB_22 s) : s ∈ oneSmallThirds_22 := by
  exact _root_.D1Bound5.oneSmallThirds_22_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_23 oneSmallPairB_23
      oneSmallDisk_224_1_1 oneSmallThirds_23 = true := by
  exact _root_.D1Bound5.oneSmallThirds_23_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_23.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_23) (hb : s ≠ oneSmallPairB_23)
    (hpair : PairExtension oneSmallPairA_23 oneSmallPairB_23 s) : s ∈ oneSmallThirds_23 := by
  exact _root_.D1Bound5.oneSmallThirds_23_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_24 oneSmallPairB_24
      oneSmallDisk_224_1_1 oneSmallThirds_24 = true := by
  exact _root_.D1Bound5.oneSmallThirds_24_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_24.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_24) (hb : s ≠ oneSmallPairB_24)
    (hpair : PairExtension oneSmallPairA_24 oneSmallPairB_24 s) : s ∈ oneSmallThirds_24 := by
  exact _root_.D1Bound5.oneSmallThirds_24_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_25 oneSmallPairB_25
      oneSmallDisk_224_0_5 oneSmallThirds_25 = true := by
  exact _root_.D1Bound5.oneSmallThirds_25_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 5) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_25.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_25) (hb : s ≠ oneSmallPairB_25)
    (hpair : PairExtension oneSmallPairA_25 oneSmallPairB_25 s) : s ∈ oneSmallThirds_25 := by
  exact _root_.D1Bound5.oneSmallThirds_25_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_26 oneSmallPairB_26
      oneSmallDisk_224_0_5 oneSmallThirds_26 = true := by
  exact _root_.D1Bound5.oneSmallThirds_26_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 5) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_26.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_26) (hb : s ≠ oneSmallPairB_26)
    (hpair : PairExtension oneSmallPairA_26 oneSmallPairB_26 s) : s ∈ oneSmallThirds_26 := by
  exact _root_.D1Bound5.oneSmallThirds_26_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_27 oneSmallPairB_27
      oneSmallDisk_224_0_6 oneSmallThirds_27 = true := by
  exact _root_.D1Bound5.oneSmallThirds_27_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 6) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_27.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_27) (hb : s ≠ oneSmallPairB_27)
    (hpair : PairExtension oneSmallPairA_27 oneSmallPairB_27 s) : s ∈ oneSmallThirds_27 := by
  exact _root_.D1Bound5.oneSmallThirds_27_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_28 oneSmallPairB_28
      oneSmallDisk_224_0_6 oneSmallThirds_28 = true := by
  exact _root_.D1Bound5.oneSmallThirds_28_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 6) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_28.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_28) (hb : s ≠ oneSmallPairB_28)
    (hpair : PairExtension oneSmallPairA_28 oneSmallPairB_28 s) : s ∈ oneSmallThirds_28 := by
  exact _root_.D1Bound5.oneSmallThirds_28_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_29 oneSmallPairB_29
      oneSmallDisk_224_1_2 oneSmallThirds_29 = true := by
  exact _root_.D1Bound5.oneSmallThirds_29_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 2) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_29.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_29) (hb : s ≠ oneSmallPairB_29)
    (hpair : PairExtension oneSmallPairA_29 oneSmallPairB_29 s) : s ∈ oneSmallThirds_29 := by
  exact _root_.D1Bound5.oneSmallThirds_29_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_30 oneSmallPairB_30
      oneSmallDisk_224_1_2 oneSmallThirds_30 = true := by
  exact _root_.D1Bound5.oneSmallThirds_30_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 2) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_30.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_30) (hb : s ≠ oneSmallPairB_30)
    (hpair : PairExtension oneSmallPairA_30 oneSmallPairB_30 s) : s ∈ oneSmallThirds_30 := by
  exact _root_.D1Bound5.oneSmallThirds_30_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_31 oneSmallPairB_31
      oneSmallDisk_224_1_3 oneSmallThirds_31 = true := by
  exact _root_.D1Bound5.oneSmallThirds_31_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 3) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_31.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_31) (hb : s ≠ oneSmallPairB_31)
    (hpair : PairExtension oneSmallPairA_31 oneSmallPairB_31 s) : s ∈ oneSmallThirds_31 := by
  exact _root_.D1Bound5.oneSmallThirds_31_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_32 oneSmallPairB_32
      oneSmallDisk_224_1_3 oneSmallThirds_32 = true := by
  exact _root_.D1Bound5.oneSmallThirds_32_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 3) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_32.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_32) (hb : s ≠ oneSmallPairB_32)
    (hpair : PairExtension oneSmallPairA_32 oneSmallPairB_32 s) : s ∈ oneSmallThirds_32 := by
  exact _root_.D1Bound5.oneSmallThirds_32_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_33 oneSmallPairB_33
      oneSmallDisk_224_1_4 oneSmallThirds_33 = true := by
  exact _root_.D1Bound5.oneSmallThirds_33_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 4) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_33.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_33) (hb : s ≠ oneSmallPairB_33)
    (hpair : PairExtension oneSmallPairA_33 oneSmallPairB_33 s) : s ∈ oneSmallThirds_33 := by
  exact _root_.D1Bound5.oneSmallThirds_33_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_34 oneSmallPairB_34
      oneSmallDisk_224_1_4 oneSmallThirds_34 = true := by
  exact _root_.D1Bound5.oneSmallThirds_34_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 4) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_34.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_34) (hb : s ≠ oneSmallPairB_34)
    (hpair : PairExtension oneSmallPairA_34 oneSmallPairB_34 s) : s ∈ oneSmallThirds_34 := by
  exact _root_.D1Bound5.oneSmallThirds_34_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_35 oneSmallPairB_35
      oneSmallDisk_224_1_5 oneSmallThirds_35 = true := by
  exact _root_.D1Bound5.oneSmallThirds_35_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 5) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_35.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_35) (hb : s ≠ oneSmallPairB_35)
    (hpair : PairExtension oneSmallPairA_35 oneSmallPairB_35 s) : s ∈ oneSmallThirds_35 := by
  exact _root_.D1Bound5.oneSmallThirds_35_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_36 oneSmallPairB_36
      oneSmallDisk_224_1_5 oneSmallThirds_36 = true := by
  exact _root_.D1Bound5.oneSmallThirds_36_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 5) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_36.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_36) (hb : s ≠ oneSmallPairB_36)
    (hpair : PairExtension oneSmallPairA_36 oneSmallPairB_36 s) : s ∈ oneSmallThirds_36 := by
  exact _root_.D1Bound5.oneSmallThirds_36_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_37 oneSmallPairB_37
      oneSmallDisk_224_1_6 oneSmallThirds_37 = true := by
  exact _root_.D1Bound5.oneSmallThirds_37_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 1 6) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_37.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_37) (hb : s ≠ oneSmallPairB_37)
    (hpair : PairExtension oneSmallPairA_37 oneSmallPairB_37 s) : s ∈ oneSmallThirds_37 := by
  exact _root_.D1Bound5.oneSmallThirds_37_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_38 oneSmallPairB_38
      oneSmallDisk_224_0_1 oneSmallThirds_38 = true := by
  exact _root_.D1Bound5.oneSmallThirds_38_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_38.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_38) (hb : s ≠ oneSmallPairB_38)
    (hpair : PairExtension oneSmallPairA_38 oneSmallPairB_38 s) : s ∈ oneSmallThirds_38 := by
  exact _root_.D1Bound5.oneSmallThirds_38_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallThirdCoveredBool oneSmallPairA_39 oneSmallPairB_39
      oneSmallDisk_224_0_1 oneSmallThirds_39 = true := by
  exact _root_.D1Bound5.oneSmallThirds_39_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (s : QuadInt 0 1) (hbound : s.norm ≤ 224)
    (horder : oneSmallPairB_39.norm ≤ s.norm)
    (ha : s ≠ oneSmallPairA_39) (hb : s ≠ oneSmallPairB_39)
    (hpair : PairExtension oneSmallPairA_39 oneSmallPairB_39 s) : s ∈ oneSmallThirds_39 := by
  exact _root_.D1Bound5.oneSmallThirds_39_complete (s := s) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_0 oneSmallPairB_0 oneSmallTripleS_0
      oneSmallTripleCutoff_0 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_0_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_0)
    (ha : ∃ q, q*q = oneSmallPairA_0*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_0*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_0*z+1) :
    z.norm ≤ 4*oneSmallPairB_0.norm*oneSmallTripleS_0.norm := by
  exact _root_.D1Bound5.oneSmallFourth_0_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_0 oneSmallPairB_0 oneSmallTripleS_1
      oneSmallTripleCutoff_1 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_1_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_1)
    (ha : ∃ q, q*q = oneSmallPairA_0*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_0*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_1*z+1) :
    z.norm ≤ 4*oneSmallPairB_0.norm*oneSmallTripleS_1.norm := by
  exact _root_.D1Bound5.oneSmallFourth_1_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_0 oneSmallPairB_0 oneSmallTripleS_2
      oneSmallTripleCutoff_2 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_2_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_2)
    (ha : ∃ q, q*q = oneSmallPairA_0*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_0*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_2*z+1) :
    z.norm ≤ 4*oneSmallPairB_0.norm*oneSmallTripleS_2.norm := by
  exact _root_.D1Bound5.oneSmallFourth_2_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_1 oneSmallPairB_1 oneSmallTripleS_3
      oneSmallTripleCutoff_3 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_3_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_3)
    (ha : ∃ q, q*q = oneSmallPairA_1*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_1*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_3*z+1) :
    z.norm ≤ 4*oneSmallPairB_1.norm*oneSmallTripleS_3.norm := by
  exact _root_.D1Bound5.oneSmallFourth_3_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_2 oneSmallPairB_2 oneSmallTripleS_4
      oneSmallTripleCutoff_4 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_4_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_4)
    (ha : ∃ q, q*q = oneSmallPairA_2*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_2*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_4*z+1) :
    z.norm ≤ 4*oneSmallPairB_2.norm*oneSmallTripleS_4.norm := by
  exact _root_.D1Bound5.oneSmallFourth_4_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_2 oneSmallPairB_2 oneSmallTripleS_5
      oneSmallTripleCutoff_5 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_5_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_5)
    (ha : ∃ q, q*q = oneSmallPairA_2*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_2*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_5*z+1) :
    z.norm ≤ 4*oneSmallPairB_2.norm*oneSmallTripleS_5.norm := by
  exact _root_.D1Bound5.oneSmallFourth_5_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_3 oneSmallPairB_3 oneSmallTripleS_6
      oneSmallTripleCutoff_6 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_6_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_6)
    (ha : ∃ q, q*q = oneSmallPairA_3*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_3*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_6*z+1) :
    z.norm ≤ 4*oneSmallPairB_3.norm*oneSmallTripleS_6.norm := by
  exact _root_.D1Bound5.oneSmallFourth_6_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_4 oneSmallPairB_4 oneSmallTripleS_7
      oneSmallTripleCutoff_7 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_7_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_7)
    (ha : ∃ q, q*q = oneSmallPairA_4*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_4*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_7*z+1) :
    z.norm ≤ 4*oneSmallPairB_4.norm*oneSmallTripleS_7.norm := by
  exact _root_.D1Bound5.oneSmallFourth_7_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_4 oneSmallPairB_4 oneSmallTripleS_8
      oneSmallTripleCutoff_8 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_8_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_8)
    (ha : ∃ q, q*q = oneSmallPairA_4*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_4*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_8*z+1) :
    z.norm ≤ 4*oneSmallPairB_4.norm*oneSmallTripleS_8.norm := by
  exact _root_.D1Bound5.oneSmallFourth_8_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_5 oneSmallPairB_5 oneSmallTripleS_9
      oneSmallTripleCutoff_9 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_9_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_9)
    (ha : ∃ q, q*q = oneSmallPairA_5*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_5*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_9*z+1) :
    z.norm ≤ 4*oneSmallPairB_5.norm*oneSmallTripleS_9.norm := by
  exact _root_.D1Bound5.oneSmallFourth_9_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_6 oneSmallPairB_6 oneSmallTripleS_10
      oneSmallTripleCutoff_10 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_10_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_10)
    (ha : ∃ q, q*q = oneSmallPairA_6*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_6*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_10*z+1) :
    z.norm ≤ 4*oneSmallPairB_6.norm*oneSmallTripleS_10.norm := by
  exact _root_.D1Bound5.oneSmallFourth_10_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_7 oneSmallPairB_7 oneSmallTripleS_11
      oneSmallTripleCutoff_11 oneSmallDisk_300_0_2 = true := by
  exact _root_.D1Bound5.oneSmallFourth_11_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 2)
    (hz : z.norm < oneSmallTripleCutoff_11)
    (ha : ∃ q, q*q = oneSmallPairA_7*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_7*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_11*z+1) :
    z.norm ≤ 4*oneSmallPairB_7.norm*oneSmallTripleS_11.norm := by
  exact _root_.D1Bound5.oneSmallFourth_11_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_7 oneSmallPairB_7 oneSmallTripleS_12
      oneSmallTripleCutoff_12 oneSmallDisk_300_0_2 = true := by
  exact _root_.D1Bound5.oneSmallFourth_12_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 2)
    (hz : z.norm < oneSmallTripleCutoff_12)
    (ha : ∃ q, q*q = oneSmallPairA_7*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_7*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_12*z+1) :
    z.norm ≤ 4*oneSmallPairB_7.norm*oneSmallTripleS_12.norm := by
  exact _root_.D1Bound5.oneSmallFourth_12_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_8 oneSmallPairB_8 oneSmallTripleS_13
      oneSmallTripleCutoff_13 oneSmallDisk_300_0_2 = true := by
  exact _root_.D1Bound5.oneSmallFourth_13_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 2)
    (hz : z.norm < oneSmallTripleCutoff_13)
    (ha : ∃ q, q*q = oneSmallPairA_8*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_8*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_13*z+1) :
    z.norm ≤ 4*oneSmallPairB_8.norm*oneSmallTripleS_13.norm := by
  exact _root_.D1Bound5.oneSmallFourth_13_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_9 oneSmallPairB_9 oneSmallTripleS_14
      oneSmallTripleCutoff_14 oneSmallDisk_300_0_2 = true := by
  exact _root_.D1Bound5.oneSmallFourth_14_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 2)
    (hz : z.norm < oneSmallTripleCutoff_14)
    (ha : ∃ q, q*q = oneSmallPairA_9*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_9*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_14*z+1) :
    z.norm ≤ 4*oneSmallPairB_9.norm*oneSmallTripleS_14.norm := by
  exact _root_.D1Bound5.oneSmallFourth_14_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_10 oneSmallPairB_10 oneSmallTripleS_15
      oneSmallTripleCutoff_15 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_15_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_15)
    (ha : ∃ q, q*q = oneSmallPairA_10*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_10*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_15*z+1) :
    z.norm ≤ 4*oneSmallPairB_10.norm*oneSmallTripleS_15.norm := by
  exact _root_.D1Bound5.oneSmallFourth_15_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_11 oneSmallPairB_11 oneSmallTripleS_16
      oneSmallTripleCutoff_16 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_16_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_16)
    (ha : ∃ q, q*q = oneSmallPairA_11*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_11*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_16*z+1) :
    z.norm ≤ 4*oneSmallPairB_11.norm*oneSmallTripleS_16.norm := by
  exact _root_.D1Bound5.oneSmallFourth_16_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_12 oneSmallPairB_12 oneSmallTripleS_17
      oneSmallTripleCutoff_17 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_17_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_17)
    (ha : ∃ q, q*q = oneSmallPairA_12*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_12*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_17*z+1) :
    z.norm ≤ 4*oneSmallPairB_12.norm*oneSmallTripleS_17.norm := by
  exact _root_.D1Bound5.oneSmallFourth_17_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_13 oneSmallPairB_13 oneSmallTripleS_18
      oneSmallTripleCutoff_18 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_18_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_18)
    (ha : ∃ q, q*q = oneSmallPairA_13*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_13*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_18*z+1) :
    z.norm ≤ 4*oneSmallPairB_13.norm*oneSmallTripleS_18.norm := by
  exact _root_.D1Bound5.oneSmallFourth_18_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_14 oneSmallPairB_14 oneSmallTripleS_19
      oneSmallTripleCutoff_19 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_19_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_19)
    (ha : ∃ q, q*q = oneSmallPairA_14*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_14*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_19*z+1) :
    z.norm ≤ 4*oneSmallPairB_14.norm*oneSmallTripleS_19.norm := by
  exact _root_.D1Bound5.oneSmallFourth_19_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_15 oneSmallPairB_15 oneSmallTripleS_20
      oneSmallTripleCutoff_20 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_20_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_20)
    (ha : ∃ q, q*q = oneSmallPairA_15*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_15*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_20*z+1) :
    z.norm ≤ 4*oneSmallPairB_15.norm*oneSmallTripleS_20.norm := by
  exact _root_.D1Bound5.oneSmallFourth_20_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_16 oneSmallPairB_16 oneSmallTripleS_21
      oneSmallTripleCutoff_21 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_21_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_21)
    (ha : ∃ q, q*q = oneSmallPairA_16*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_16*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_21*z+1) :
    z.norm ≤ 4*oneSmallPairB_16.norm*oneSmallTripleS_21.norm := by
  exact _root_.D1Bound5.oneSmallFourth_21_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_16 oneSmallPairB_16 oneSmallTripleS_22
      oneSmallTripleCutoff_22 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_22_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_22)
    (ha : ∃ q, q*q = oneSmallPairA_16*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_16*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_22*z+1) :
    z.norm ≤ 4*oneSmallPairB_16.norm*oneSmallTripleS_22.norm := by
  exact _root_.D1Bound5.oneSmallFourth_22_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_17 oneSmallPairB_17 oneSmallTripleS_23
      oneSmallTripleCutoff_23 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_23_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_23)
    (ha : ∃ q, q*q = oneSmallPairA_17*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_17*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_23*z+1) :
    z.norm ≤ 4*oneSmallPairB_17.norm*oneSmallTripleS_23.norm := by
  exact _root_.D1Bound5.oneSmallFourth_23_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_18 oneSmallPairB_18 oneSmallTripleS_24
      oneSmallTripleCutoff_24 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_24_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_24)
    (ha : ∃ q, q*q = oneSmallPairA_18*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_18*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_24*z+1) :
    z.norm ≤ 4*oneSmallPairB_18.norm*oneSmallTripleS_24.norm := by
  exact _root_.D1Bound5.oneSmallFourth_24_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_19 oneSmallPairB_19 oneSmallTripleS_25
      oneSmallTripleCutoff_25 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_25_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_25)
    (ha : ∃ q, q*q = oneSmallPairA_19*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_19*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_25*z+1) :
    z.norm ≤ 4*oneSmallPairB_19.norm*oneSmallTripleS_25.norm := by
  exact _root_.D1Bound5.oneSmallFourth_25_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_20 oneSmallPairB_20 oneSmallTripleS_26
      oneSmallTripleCutoff_26 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_26_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_26)
    (ha : ∃ q, q*q = oneSmallPairA_20*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_20*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_26*z+1) :
    z.norm ≤ 4*oneSmallPairB_20.norm*oneSmallTripleS_26.norm := by
  exact _root_.D1Bound5.oneSmallFourth_26_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_20 oneSmallPairB_20 oneSmallTripleS_27
      oneSmallTripleCutoff_27 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_27_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_27)
    (ha : ∃ q, q*q = oneSmallPairA_20*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_20*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_27*z+1) :
    z.norm ≤ 4*oneSmallPairB_20.norm*oneSmallTripleS_27.norm := by
  exact _root_.D1Bound5.oneSmallFourth_27_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_21 oneSmallPairB_21 oneSmallTripleS_28
      oneSmallTripleCutoff_28 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_28_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_28)
    (ha : ∃ q, q*q = oneSmallPairA_21*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_21*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_28*z+1) :
    z.norm ≤ 4*oneSmallPairB_21.norm*oneSmallTripleS_28.norm := by
  exact _root_.D1Bound5.oneSmallFourth_28_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_22 oneSmallPairB_22 oneSmallTripleS_29
      oneSmallTripleCutoff_29 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_29_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_29)
    (ha : ∃ q, q*q = oneSmallPairA_22*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_22*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_29*z+1) :
    z.norm ≤ 4*oneSmallPairB_22.norm*oneSmallTripleS_29.norm := by
  exact _root_.D1Bound5.oneSmallFourth_29_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_22 oneSmallPairB_22 oneSmallTripleS_30
      oneSmallTripleCutoff_30 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_30_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_30)
    (ha : ∃ q, q*q = oneSmallPairA_22*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_22*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_30*z+1) :
    z.norm ≤ 4*oneSmallPairB_22.norm*oneSmallTripleS_30.norm := by
  exact _root_.D1Bound5.oneSmallFourth_30_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_23 oneSmallPairB_23 oneSmallTripleS_31
      oneSmallTripleCutoff_31 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_31_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_31)
    (ha : ∃ q, q*q = oneSmallPairA_23*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_23*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_31*z+1) :
    z.norm ≤ 4*oneSmallPairB_23.norm*oneSmallTripleS_31.norm := by
  exact _root_.D1Bound5.oneSmallFourth_31_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_23 oneSmallPairB_23 oneSmallTripleS_32
      oneSmallTripleCutoff_32 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_32_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_32)
    (ha : ∃ q, q*q = oneSmallPairA_23*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_23*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_32*z+1) :
    z.norm ≤ 4*oneSmallPairB_23.norm*oneSmallTripleS_32.norm := by
  exact _root_.D1Bound5.oneSmallFourth_32_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_24 oneSmallPairB_24 oneSmallTripleS_33
      oneSmallTripleCutoff_33 oneSmallDisk_300_1_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_33_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 1)
    (hz : z.norm < oneSmallTripleCutoff_33)
    (ha : ∃ q, q*q = oneSmallPairA_24*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_24*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_33*z+1) :
    z.norm ≤ 4*oneSmallPairB_24.norm*oneSmallTripleS_33.norm := by
  exact _root_.D1Bound5.oneSmallFourth_33_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_25 oneSmallPairB_25 oneSmallTripleS_34
      oneSmallTripleCutoff_34 oneSmallDisk_300_0_5 = true := by
  exact _root_.D1Bound5.oneSmallFourth_34_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 5)
    (hz : z.norm < oneSmallTripleCutoff_34)
    (ha : ∃ q, q*q = oneSmallPairA_25*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_25*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_34*z+1) :
    z.norm ≤ 4*oneSmallPairB_25.norm*oneSmallTripleS_34.norm := by
  exact _root_.D1Bound5.oneSmallFourth_34_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_25 oneSmallPairB_25 oneSmallTripleS_35
      oneSmallTripleCutoff_35 oneSmallDisk_300_0_5 = true := by
  exact _root_.D1Bound5.oneSmallFourth_35_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 5)
    (hz : z.norm < oneSmallTripleCutoff_35)
    (ha : ∃ q, q*q = oneSmallPairA_25*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_25*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_35*z+1) :
    z.norm ≤ 4*oneSmallPairB_25.norm*oneSmallTripleS_35.norm := by
  exact _root_.D1Bound5.oneSmallFourth_35_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_26 oneSmallPairB_26 oneSmallTripleS_36
      oneSmallTripleCutoff_36 oneSmallDisk_300_0_5 = true := by
  exact _root_.D1Bound5.oneSmallFourth_36_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 5)
    (hz : z.norm < oneSmallTripleCutoff_36)
    (ha : ∃ q, q*q = oneSmallPairA_26*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_26*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_36*z+1) :
    z.norm ≤ 4*oneSmallPairB_26.norm*oneSmallTripleS_36.norm := by
  exact _root_.D1Bound5.oneSmallFourth_36_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_27 oneSmallPairB_27 oneSmallTripleS_37
      oneSmallTripleCutoff_37 oneSmallDisk_300_0_6 = true := by
  exact _root_.D1Bound5.oneSmallFourth_37_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 6)
    (hz : z.norm < oneSmallTripleCutoff_37)
    (ha : ∃ q, q*q = oneSmallPairA_27*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_27*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_37*z+1) :
    z.norm ≤ 4*oneSmallPairB_27.norm*oneSmallTripleS_37.norm := by
  exact _root_.D1Bound5.oneSmallFourth_37_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_27 oneSmallPairB_27 oneSmallTripleS_38
      oneSmallTripleCutoff_38 oneSmallDisk_300_0_6 = true := by
  exact _root_.D1Bound5.oneSmallFourth_38_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 6)
    (hz : z.norm < oneSmallTripleCutoff_38)
    (ha : ∃ q, q*q = oneSmallPairA_27*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_27*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_38*z+1) :
    z.norm ≤ 4*oneSmallPairB_27.norm*oneSmallTripleS_38.norm := by
  exact _root_.D1Bound5.oneSmallFourth_38_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_28 oneSmallPairB_28 oneSmallTripleS_39
      oneSmallTripleCutoff_39 oneSmallDisk_300_0_6 = true := by
  exact _root_.D1Bound5.oneSmallFourth_39_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 6)
    (hz : z.norm < oneSmallTripleCutoff_39)
    (ha : ∃ q, q*q = oneSmallPairA_28*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_28*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_39*z+1) :
    z.norm ≤ 4*oneSmallPairB_28.norm*oneSmallTripleS_39.norm := by
  exact _root_.D1Bound5.oneSmallFourth_39_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_29 oneSmallPairB_29 oneSmallTripleS_40
      oneSmallTripleCutoff_40 oneSmallDisk_300_1_2 = true := by
  exact _root_.D1Bound5.oneSmallFourth_40_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 2)
    (hz : z.norm < oneSmallTripleCutoff_40)
    (ha : ∃ q, q*q = oneSmallPairA_29*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_29*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_40*z+1) :
    z.norm ≤ 4*oneSmallPairB_29.norm*oneSmallTripleS_40.norm := by
  exact _root_.D1Bound5.oneSmallFourth_40_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_30 oneSmallPairB_30 oneSmallTripleS_41
      oneSmallTripleCutoff_41 oneSmallDisk_300_1_2 = true := by
  exact _root_.D1Bound5.oneSmallFourth_41_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 2)
    (hz : z.norm < oneSmallTripleCutoff_41)
    (ha : ∃ q, q*q = oneSmallPairA_30*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_30*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_41*z+1) :
    z.norm ≤ 4*oneSmallPairB_30.norm*oneSmallTripleS_41.norm := by
  exact _root_.D1Bound5.oneSmallFourth_41_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_31 oneSmallPairB_31 oneSmallTripleS_42
      oneSmallTripleCutoff_42 oneSmallDisk_300_1_3 = true := by
  exact _root_.D1Bound5.oneSmallFourth_42_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 3)
    (hz : z.norm < oneSmallTripleCutoff_42)
    (ha : ∃ q, q*q = oneSmallPairA_31*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_31*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_42*z+1) :
    z.norm ≤ 4*oneSmallPairB_31.norm*oneSmallTripleS_42.norm := by
  exact _root_.D1Bound5.oneSmallFourth_42_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_31 oneSmallPairB_31 oneSmallTripleS_43
      oneSmallTripleCutoff_43 oneSmallDisk_300_1_3 = true := by
  exact _root_.D1Bound5.oneSmallFourth_43_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 3)
    (hz : z.norm < oneSmallTripleCutoff_43)
    (ha : ∃ q, q*q = oneSmallPairA_31*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_31*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_43*z+1) :
    z.norm ≤ 4*oneSmallPairB_31.norm*oneSmallTripleS_43.norm := by
  exact _root_.D1Bound5.oneSmallFourth_43_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_32 oneSmallPairB_32 oneSmallTripleS_44
      oneSmallTripleCutoff_44 oneSmallDisk_300_1_3 = true := by
  exact _root_.D1Bound5.oneSmallFourth_44_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 3)
    (hz : z.norm < oneSmallTripleCutoff_44)
    (ha : ∃ q, q*q = oneSmallPairA_32*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_32*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_44*z+1) :
    z.norm ≤ 4*oneSmallPairB_32.norm*oneSmallTripleS_44.norm := by
  exact _root_.D1Bound5.oneSmallFourth_44_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_33 oneSmallPairB_33 oneSmallTripleS_45
      oneSmallTripleCutoff_45 oneSmallDisk_300_1_4 = true := by
  exact _root_.D1Bound5.oneSmallFourth_45_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 4)
    (hz : z.norm < oneSmallTripleCutoff_45)
    (ha : ∃ q, q*q = oneSmallPairA_33*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_33*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_45*z+1) :
    z.norm ≤ 4*oneSmallPairB_33.norm*oneSmallTripleS_45.norm := by
  exact _root_.D1Bound5.oneSmallFourth_45_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_33 oneSmallPairB_33 oneSmallTripleS_46
      oneSmallTripleCutoff_46 oneSmallDisk_300_1_4 = true := by
  exact _root_.D1Bound5.oneSmallFourth_46_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 4)
    (hz : z.norm < oneSmallTripleCutoff_46)
    (ha : ∃ q, q*q = oneSmallPairA_33*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_33*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_46*z+1) :
    z.norm ≤ 4*oneSmallPairB_33.norm*oneSmallTripleS_46.norm := by
  exact _root_.D1Bound5.oneSmallFourth_46_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_34 oneSmallPairB_34 oneSmallTripleS_47
      oneSmallTripleCutoff_47 oneSmallDisk_300_1_4 = true := by
  exact _root_.D1Bound5.oneSmallFourth_47_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 4)
    (hz : z.norm < oneSmallTripleCutoff_47)
    (ha : ∃ q, q*q = oneSmallPairA_34*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_34*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_47*z+1) :
    z.norm ≤ 4*oneSmallPairB_34.norm*oneSmallTripleS_47.norm := by
  exact _root_.D1Bound5.oneSmallFourth_47_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_35 oneSmallPairB_35 oneSmallTripleS_48
      oneSmallTripleCutoff_48 oneSmallDisk_300_1_5 = true := by
  exact _root_.D1Bound5.oneSmallFourth_48_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 5)
    (hz : z.norm < oneSmallTripleCutoff_48)
    (ha : ∃ q, q*q = oneSmallPairA_35*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_35*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_48*z+1) :
    z.norm ≤ 4*oneSmallPairB_35.norm*oneSmallTripleS_48.norm := by
  exact _root_.D1Bound5.oneSmallFourth_48_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_35 oneSmallPairB_35 oneSmallTripleS_49
      oneSmallTripleCutoff_49 oneSmallDisk_300_1_5 = true := by
  exact _root_.D1Bound5.oneSmallFourth_49_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 5)
    (hz : z.norm < oneSmallTripleCutoff_49)
    (ha : ∃ q, q*q = oneSmallPairA_35*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_35*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_49*z+1) :
    z.norm ≤ 4*oneSmallPairB_35.norm*oneSmallTripleS_49.norm := by
  exact _root_.D1Bound5.oneSmallFourth_49_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_36 oneSmallPairB_36 oneSmallTripleS_50
      oneSmallTripleCutoff_50 oneSmallDisk_300_1_5 = true := by
  exact _root_.D1Bound5.oneSmallFourth_50_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 5)
    (hz : z.norm < oneSmallTripleCutoff_50)
    (ha : ∃ q, q*q = oneSmallPairA_36*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_36*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_50*z+1) :
    z.norm ≤ 4*oneSmallPairB_36.norm*oneSmallTripleS_50.norm := by
  exact _root_.D1Bound5.oneSmallFourth_50_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_37 oneSmallPairB_37 oneSmallTripleS_51
      oneSmallTripleCutoff_51 oneSmallDisk_300_1_6 = true := by
  exact _root_.D1Bound5.oneSmallFourth_51_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 6)
    (hz : z.norm < oneSmallTripleCutoff_51)
    (ha : ∃ q, q*q = oneSmallPairA_37*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_37*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_51*z+1) :
    z.norm ≤ 4*oneSmallPairB_37.norm*oneSmallTripleS_51.norm := by
  exact _root_.D1Bound5.oneSmallFourth_51_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_37 oneSmallPairB_37 oneSmallTripleS_52
      oneSmallTripleCutoff_52 oneSmallDisk_300_1_6 = true := by
  exact _root_.D1Bound5.oneSmallFourth_52_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 1 6)
    (hz : z.norm < oneSmallTripleCutoff_52)
    (ha : ∃ q, q*q = oneSmallPairA_37*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_37*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_52*z+1) :
    z.norm ≤ 4*oneSmallPairB_37.norm*oneSmallTripleS_52.norm := by
  exact _root_.D1Bound5.oneSmallFourth_52_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_38 oneSmallPairB_38 oneSmallTripleS_53
      oneSmallTripleCutoff_53 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_53_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_53)
    (ha : ∃ q, q*q = oneSmallPairA_38*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_38*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_53*z+1) :
    z.norm ≤ 4*oneSmallPairB_38.norm*oneSmallTripleS_53.norm := by
  exact _root_.D1Bound5.oneSmallFourth_53_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_38 oneSmallPairB_38 oneSmallTripleS_54
      oneSmallTripleCutoff_54 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_54_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_54)
    (ha : ∃ q, q*q = oneSmallPairA_38*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_38*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_54*z+1) :
    z.norm ≤ 4*oneSmallPairB_38.norm*oneSmallTripleS_54.norm := by
  exact _root_.D1Bound5.oneSmallFourth_54_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    oneSmallFourthGrowthBool oneSmallPairA_39 oneSmallPairB_39 oneSmallTripleS_55
      oneSmallTripleCutoff_55 oneSmallDisk_300_0_1 = true := by
  exact _root_.D1Bound5.oneSmallFourth_55_checked
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (z : QuadInt 0 1)
    (hz : z.norm < oneSmallTripleCutoff_55)
    (ha : ∃ q, q*q = oneSmallPairA_39*z+1)
    (hb : ∃ q, q*q = oneSmallPairB_39*z+1)
    (hs : ∃ q, q*q = oneSmallTripleS_55*z+1) :
    z.norm ≤ 4*oneSmallPairB_39.norm*oneSmallTripleS_55.norm := by
  exact _root_.D1Bound5.oneSmallFourth_55_growth (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example : (ℤ) → (ℤ) → (ℤ × ℤ) → (ℤ × ℤ) → (ℤ × ℤ) → (ℤ) → _root_.D1Bound5.OneSmallTripleRow := @_root_.D1Bound5.OneSmallTripleRow.mk
example (tau : ℤ) (nu : ℤ) (a : ℤ × ℤ) (b : ℤ × ℤ) (s : ℤ × ℤ) (cutoff : ℤ) : _root_.D1Bound5.OneSmallTripleRow :=
  _root_.D1Bound5.OneSmallTripleRow.mk (tau := tau) (nu := nu) (a := a) (b := b) (s := s) (cutoff := cutoff)
example (r : _root_.D1Bound5.OneSmallTripleRow) : ℤ := r.tau
example (tau : ℤ) (nu : ℤ) (a : ℤ × ℤ) (b : ℤ × ℤ) (s : ℤ × ℤ) (cutoff : ℤ) : (_root_.D1Bound5.OneSmallTripleRow.mk tau nu a b s cutoff).tau = tau := rfl
example (r : _root_.D1Bound5.OneSmallTripleRow) : ℤ := r.nu
example (tau : ℤ) (nu : ℤ) (a : ℤ × ℤ) (b : ℤ × ℤ) (s : ℤ × ℤ) (cutoff : ℤ) : (_root_.D1Bound5.OneSmallTripleRow.mk tau nu a b s cutoff).nu = nu := rfl
example (r : _root_.D1Bound5.OneSmallTripleRow) : ℤ × ℤ := r.a
example (tau : ℤ) (nu : ℤ) (a : ℤ × ℤ) (b : ℤ × ℤ) (s : ℤ × ℤ) (cutoff : ℤ) : (_root_.D1Bound5.OneSmallTripleRow.mk tau nu a b s cutoff).a = a := rfl
example (r : _root_.D1Bound5.OneSmallTripleRow) : ℤ × ℤ := r.b
example (tau : ℤ) (nu : ℤ) (a : ℤ × ℤ) (b : ℤ × ℤ) (s : ℤ × ℤ) (cutoff : ℤ) : (_root_.D1Bound5.OneSmallTripleRow.mk tau nu a b s cutoff).b = b := rfl
example (r : _root_.D1Bound5.OneSmallTripleRow) : ℤ × ℤ := r.s
example (tau : ℤ) (nu : ℤ) (a : ℤ × ℤ) (b : ℤ × ℤ) (s : ℤ × ℤ) (cutoff : ℤ) : (_root_.D1Bound5.OneSmallTripleRow.mk tau nu a b s cutoff).s = s := rfl
example (r : _root_.D1Bound5.OneSmallTripleRow) : ℤ := r.cutoff
example (tau : ℤ) (nu : ℤ) (a : ℤ × ℤ) (b : ℤ × ℤ) (s : ℤ × ℤ) (cutoff : ℤ) : (_root_.D1Bound5.OneSmallTripleRow.mk tau nu a b s cutoff).cutoff = cutoff := rfl
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (r : OneSmallTripleRow)
    (hr : r ∈ oneSmallFixedRows) (z : QuadInt r.tau r.nu) (hz : z.norm < r.cutoff)
    (ha : ∃ q, q*q = r.anchorA*z+1) (hb : ∃ q, q*q = r.anchorB*z+1)
    (hs : ∃ q, q*q = r.anchorS*z+1) : z.norm ≤ 4*r.anchorB.norm*r.anchorS.norm := by
  exact _root_.D1Bound5.oneSmallFixedRows_bounded_growth (r := r) (hr := hr) (z := z) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_0 oneSmallPairB_0 := by
  exact _root_.D1Bound5.oneSmallThirdRows_0_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_1 oneSmallPairB_1 := by
  exact _root_.D1Bound5.oneSmallThirdRows_1_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_2 oneSmallPairB_2 := by
  exact _root_.D1Bound5.oneSmallThirdRows_2_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_3 oneSmallPairB_3 := by
  exact _root_.D1Bound5.oneSmallThirdRows_3_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_4 oneSmallPairB_4 := by
  exact _root_.D1Bound5.oneSmallThirdRows_4_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_5 oneSmallPairB_5 := by
  exact _root_.D1Bound5.oneSmallThirdRows_5_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_6 oneSmallPairB_6 := by
  exact _root_.D1Bound5.oneSmallThirdRows_6_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_7 oneSmallPairB_7 := by
  exact _root_.D1Bound5.oneSmallThirdRows_7_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_8 oneSmallPairB_8 := by
  exact _root_.D1Bound5.oneSmallThirdRows_8_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_9 oneSmallPairB_9 := by
  exact _root_.D1Bound5.oneSmallThirdRows_9_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_10 oneSmallPairB_10 := by
  exact _root_.D1Bound5.oneSmallThirdRows_10_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_11 oneSmallPairB_11 := by
  exact _root_.D1Bound5.oneSmallThirdRows_11_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_12 oneSmallPairB_12 := by
  exact _root_.D1Bound5.oneSmallThirdRows_12_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_13 oneSmallPairB_13 := by
  exact _root_.D1Bound5.oneSmallThirdRows_13_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_14 oneSmallPairB_14 := by
  exact _root_.D1Bound5.oneSmallThirdRows_14_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_15 oneSmallPairB_15 := by
  exact _root_.D1Bound5.oneSmallThirdRows_15_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_16 oneSmallPairB_16 := by
  exact _root_.D1Bound5.oneSmallThirdRows_16_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_17 oneSmallPairB_17 := by
  exact _root_.D1Bound5.oneSmallThirdRows_17_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_18 oneSmallPairB_18 := by
  exact _root_.D1Bound5.oneSmallThirdRows_18_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_19 oneSmallPairB_19 := by
  exact _root_.D1Bound5.oneSmallThirdRows_19_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_20 oneSmallPairB_20 := by
  exact _root_.D1Bound5.oneSmallThirdRows_20_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_21 oneSmallPairB_21 := by
  exact _root_.D1Bound5.oneSmallThirdRows_21_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_22 oneSmallPairB_22 := by
  exact _root_.D1Bound5.oneSmallThirdRows_22_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_23 oneSmallPairB_23 := by
  exact _root_.D1Bound5.oneSmallThirdRows_23_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_24 oneSmallPairB_24 := by
  exact _root_.D1Bound5.oneSmallThirdRows_24_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_25 oneSmallPairB_25 := by
  exact _root_.D1Bound5.oneSmallThirdRows_25_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_26 oneSmallPairB_26 := by
  exact _root_.D1Bound5.oneSmallThirdRows_26_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_27 oneSmallPairB_27 := by
  exact _root_.D1Bound5.oneSmallThirdRows_27_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_28 oneSmallPairB_28 := by
  exact _root_.D1Bound5.oneSmallThirdRows_28_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_29 oneSmallPairB_29 := by
  exact _root_.D1Bound5.oneSmallThirdRows_29_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_30 oneSmallPairB_30 := by
  exact _root_.D1Bound5.oneSmallThirdRows_30_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_31 oneSmallPairB_31 := by
  exact _root_.D1Bound5.oneSmallThirdRows_31_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_32 oneSmallPairB_32 := by
  exact _root_.D1Bound5.oneSmallThirdRows_32_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_33 oneSmallPairB_33 := by
  exact _root_.D1Bound5.oneSmallThirdRows_33_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_34 oneSmallPairB_34 := by
  exact _root_.D1Bound5.oneSmallThirdRows_34_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_35 oneSmallPairB_35 := by
  exact _root_.D1Bound5.oneSmallThirdRows_35_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_36 oneSmallPairB_36 := by
  exact _root_.D1Bound5.oneSmallThirdRows_36_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_37 oneSmallPairB_37 := by
  exact _root_.D1Bound5.oneSmallThirdRows_37_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_38 oneSmallPairB_38 := by
  exact _root_.D1Bound5.oneSmallThirdRows_38_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    OneSmallThirdRowProperty oneSmallPairA_39 oneSmallPairB_39 := by
  exact _root_.D1Bound5.oneSmallThirdRows_39_complete
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example :
    ∀ r ∈ oneSmallFixedRows,
      1024 ≤ r.cutoff ∧
      (r.anchorA.norm = 1 ∨ r.anchorA.norm = 2) ∧
      9 ≤ r.anchorB.norm ∧
      (r.anchorA.norm = 2 →
        4*r.anchorA.norm*r.anchorB.norm*r.anchorS.norm < r.cutoff) := by
  exact _root_.D1Bound5.oneSmallFixedRows_metadata
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example {tau nu : ℤ} (a b a' b' : QuadInt tau nu)
    (h : firstPairCoordinates a b = firstPairCoordinates a' b') : a = a' ∧ b = b' := by
  exact _root_.D1Bound5.firstPairCoordinates_eq (a := a) (b := b) (a' := a') (b' := b') (h := h)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example {tau nu : ℤ}
    (a b : QuadInt tau nu) (row : (ℤ × ℤ) × (ℤ × ℤ))
    (horbit : firstPairCoordinates a b ∈ firstPairOrbit tau row) :
    ∃ sgn conj : Bool,
      smallExtensionSymmetry sgn conj a = firstPairRowA tau nu row ∧
      smallExtensionSymmetry sgn conj b = firstPairRowB tau nu row := by
  exact _root_.D1Bound5.firstPairOrbit_normalize (a := a) (b := b) (row := row) (horbit := horbit)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example {tau nu : ℤ} (sgn conj : Bool)
    (a z : QuadInt tau nu) (h : ∃ r : QuadInt tau nu, r*r = a*z+1) :
    ∃ r : QuadInt tau nu, r*r =
      smallExtensionSymmetry sgn conj a*smallExtensionSymmetry sgn conj z+1 := by
  exact _root_.D1Bound5.oneSmallSymmetry_square (sgn := sgn) (conj := conj) (a := a) (z := z) (h := h)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example {tau nu : ℤ}
    (table : List ((ℤ × ℤ) × (ℤ × ℤ)))
    (reps : Finset ((ℤ × ℤ) × (ℤ × ℤ)))
    (horbits : table.toFinset = reps.biUnion (firstPairOrbit tau))
    (hreps : ∀ row ∈ reps,
      OneSmallThirdRowProperty (firstPairRowA tau nu row) (firstPairRowB tau nu row))
    (a b s : QuadInt tau nu) (hrow : firstPairCoordinates a b ∈ table)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  exact _root_.D1Bound5.oneSmallThirdRows_of_table_orbits (table := table) (reps := reps) (horbits := horbits) (hreps := hreps) (a := a) (b := b) (s := s) (hrow := hrow) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (a b s : QuadInt 0 1)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 0 1)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  exact _root_.D1Bound5.firstPairTable_0_1_third_rows (a := a) (b := b) (s := s) (hrow := hrow) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (a b s : QuadInt 0 2)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 0 2)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  exact _root_.D1Bound5.firstPairTable_0_2_third_rows (a := a) (b := b) (s := s) (hrow := hrow) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (a b s : QuadInt 0 5)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 0 5)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  exact _root_.D1Bound5.firstPairTable_0_5_third_rows (a := a) (b := b) (s := s) (hrow := hrow) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (a b s : QuadInt 0 6)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 0 6)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  exact _root_.D1Bound5.firstPairTable_0_6_third_rows (a := a) (b := b) (s := s) (hrow := hrow) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (a b s : QuadInt 1 1)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 1 1)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  exact _root_.D1Bound5.firstPairTable_1_1_third_rows (a := a) (b := b) (s := s) (hrow := hrow) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (a b s : QuadInt 1 2)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 1 2)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  exact _root_.D1Bound5.firstPairTable_1_2_third_rows (a := a) (b := b) (s := s) (hrow := hrow) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (a b s : QuadInt 1 3)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 1 3)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  exact _root_.D1Bound5.firstPairTable_1_3_third_rows (a := a) (b := b) (s := s) (hrow := hrow) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (a b s : QuadInt 1 4)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 1 4)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  exact _root_.D1Bound5.firstPairTable_1_4_third_rows (a := a) (b := b) (s := s) (hrow := hrow) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (a b s : QuadInt 1 5)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 1 5)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  exact _root_.D1Bound5.firstPairTable_1_5_third_rows (a := a) (b := b) (s := s) (hrow := hrow) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example (a b s : QuadInt 1 6)
    (hrow : firstPairCoordinates a b ∈ firstPairTable 1 6)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  exact _root_.D1Bound5.firstPairTable_1_6_third_rows (a := a) (b := b) (s := s) (hrow := hrow) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example {tau nu : ℤ}
    (hmodel : (tau,nu) ∈ smallPairModels) (a b s : QuadInt tau nu)
    (hrow : firstPairCoordinates a b ∈ firstPairTable tau nu)
    (hbound : s.norm ≤ 224) (horder : b.norm ≤ s.norm)
    (ha : s ≠ a) (hb : s ≠ b) (hpair : PairExtension a b s) :
    OneSmallNormalizedThirdRows a b s := by
  exact _root_.D1Bound5.firstPairTable_third_rows (hmodel := hmodel) (a := a) (b := b) (s := s) (hrow := hrow) (hbound := hbound) (horder := horder) (ha := ha) (hb := hb) (hpair := hpair)
end D1Bound5
end

section
open scoped NumberField Classical
open Module
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    (hK : finrank ℚ K = 2) (phi : K →+* ℂ)
    (t : Fin 3 → 𝓞 K) (ht : IsD1Tuple t)
    (hsize :
      (‖phi (t 0 : K)‖^2 = 1 ∧ 9 ≤ ‖phi (t 1 : K)‖^2 ∧ ‖phi (t 1 : K)‖^2 < 64) ∨
      (‖phi (t 0 : K)‖^2 = 2 ∧ 9 ≤ ‖phi (t 1 : K)‖^2 ∧ ‖phi (t 1 : K)‖^2 < 16))
    (hbound : ‖phi (t 2 : K)‖^2 < 225)
    (horder : ‖phi (t 1 : K)‖^2 ≤ ‖phi (t 2 : K)‖^2) :
    (t 0 = 1 ∧ t 1 = 3) ∨ (t 0 = -1 ∧ t 1 = -3) ∨
      ∃ (tau nu : ℤ) (e : QuadInt tau nu ≃+* 𝓞 K),
        (tau,nu) ∈ smallPairModels ∧
        OneSmallNormalizedThirdRows (e.symm (t 0)) (e.symm (t 1)) (e.symm (t 2)) := by
  exact _root_.D1Bound5.IsD1Tuple.one_small_first_triple_classification (hK := hK) (phi := phi) (t := t) (ht := ht) (hsize := hsize) (hbound := hbound) (horder := horder)
end D1Bound5
end

section
open scoped NumberField Classical
open Module
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K) (phi : K →+* ℂ)
    (sgn conj : Bool) (a b s z : 𝓞 K) (cutoff : ℤ)
    (hrow : OneSmallRowMembership
      (smallExtensionSymmetry sgn conj (e.symm a))
      (smallExtensionSymmetry sgn conj (e.symm b))
      (smallExtensionSymmetry sgn conj (e.symm s)) cutoff)
    (hz : ‖phi (z : K)‖^2 < (cutoff : ℝ))
    (ha : ∃ q : 𝓞 K, q*q = a*z+1) (hb : ∃ q : 𝓞 K, q*q = b*z+1)
    (hs : ∃ q : 𝓞 K, q*q = s*z+1) :
    ‖phi (z : K)‖^2 ≤ 4*‖phi (b : K)‖^2*‖phi (s : K)‖^2 := by
  exact _root_.D1Bound5.oneSmallRowMembership_full_ring_bound (e := e) (phi := phi) (sgn := sgn) (conj := conj) (a := a) (b := b) (s := s) (z := z) (cutoff := cutoff) (hrow := hrow) (hz := hz) (ha := ha) (hb := hb) (hs := hs)
end D1Bound5
end

section
open scoped NumberField Classical
open Module
namespace D1Bound5
open QuadInt
set_option autoImplicit false
example
    {K : Type*} [Field K] [NumberField K] [NumberField.IsTotallyComplex K]
    {tau nu : ℤ} (e : QuadInt tau nu ≃+* 𝓞 K) (phi : K →+* ℂ)
    (sgn conj : Bool) (a b s z : 𝓞 K) (cutoff : ℤ)
    (hrow : OneSmallRowMembership
      (smallExtensionSymmetry sgn conj (e.symm a))
      (smallExtensionSymmetry sgn conj (e.symm b))
      (smallExtensionSymmetry sgn conj (e.symm s)) cutoff)
    (hz : ‖phi (z : K)‖^2 < (cutoff : ℝ))
    (ha : ∃ q : 𝓞 K, q*q = a*z+1) (hb : ∃ q : 𝓞 K, q*q = b*z+1)
    (hs : ∃ q : 𝓞 K, q*q = s*z+1)
    (hgrowth : 4*‖phi (b : K)‖^2*‖phi (s : K)‖^2 < ‖phi (z : K)‖^2) : False := by
  exact _root_.D1Bound5.oneSmallRowMembership_full_ring_excludes_irregular_bound (e := e) (phi := phi) (sgn := sgn) (conj := conj) (a := a) (b := b) (s := s) (z := z) (cutoff := cutoff) (hrow := hrow) (hz := hz) (ha := ha) (hb := hb) (hs := hs) (hgrowth := hgrowth)
end D1Bound5
end
