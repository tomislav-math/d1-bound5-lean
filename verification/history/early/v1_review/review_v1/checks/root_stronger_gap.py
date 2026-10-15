"""Independent exact checks of the proposed stronger all-large gap."""
from pathlib import Path
from fractions import Fraction as F
import hashlib,json
ROOT=Path(__file__).resolve().parents[2]
source=ROOT/'upload/D1_bound5-v1(1).tex'
assert hashlib.sha256(source.read_bytes()).hexdigest()=='74582db5fd0ad43195a3ea235cfd324813f04e3d0cb82387a9930b7c4f26c228'
k=F(1,2)+F(1,63)
K=k**3
L=6*K-F(1,2)
Q=9*k**4
P=F(1,3)
J=2*K*F(1,27)+L*F(1,27)+Q*F(1,729)
f=lambda t:2*K*t+L*P+J/t
mu=F(51051,400000)
c=F(9999,10000)*F(200,19)**2
gap=c*3**5*(F(1,8)-mu/81)**2
h=F(4001,3999)
junction=F(400)**2*3**14/(16*F(35,32)**2*166000**2*h)
assert f(F(2))<F(7,10) and f(F(3))<F(19,20)
assert gap>400 and junction>1
r={'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),
   'F2':str(f(F(2))),'F3':str(f(F(3))),
   'all_large_gap_coefficient':str(gap),'clean_gap_constant':400,
   'coarse_bs_to_A4_overlap':str(junction),
   'decimal_orientation_only':{'gap':float(gap),'overlap':float(junction)},
   'scope':'Exact rational comparisons for the proposed T>3ABS consequence of the existing determinant expansion, its retained C gap, and the coarse bs-to-A4 junction. Other comparisons and proof dependencies are reviewed separately.'}
out=Path(__file__).with_suffix('.json')
out.write_text(json.dumps(r,indent=2)+'\n')
print(json.dumps(r,indent=2))
