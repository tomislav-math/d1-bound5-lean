import Mathlib.Tactic
import Definitions.Def_D1Bound5_PellFiniteCertificate_Definitions
import Definitions.Def_D1Bound5_Prove2MeTransfer_pellCertifiedFieldsSlice01_20261024

section
namespace D1Bound5
set_option maxRecDepth 32768
set_option maxHeartbeats 12000000

theorem _root_.solution (d : ℤ) (hd : d ∈ ([615,623,631,647,655,663,671,679,687,695,703,719,727,743,751,759,767,791,799,807,815,823,831,839,863,871,879,887,895,903,911,919,935,943,951,959,967,983,991,1007,1015,1023,1031,1039,1047,1055,1063,1079,1087,1095,1103,1111,1119,1135,1151,1159,1167,1191,1199,1207,1223,1231,1239,1247] : List ℤ)) : Nonempty (PellFiniteCertificate d (10^275)) := by
  have he : D1Bound5.Prove2MeTransfer.pellCertifiedFieldsSlice01_20261024.map Sigma.fst = ([615,623,631,647,655,663,671,679,687,695,703,719,727,743,751,759,767,791,799,807,815,823,831,839,863,871,879,887,895,903,911,919,935,943,951,959,967,983,991,1007,1015,1023,1031,1039,1047,1055,1063,1079,1087,1095,1103,1111,1119,1135,1151,1159,1167,1191,1199,1207,1223,1231,1239,1247] : List ℤ) := by rfl
  rw [← he] at hd
  obtain ⟨r, _, hr⟩ := List.mem_map.mp hd
  cases hr
  exact ⟨r.2⟩

end D1Bound5
end
