"""Specialize the reviewed finite-family root/closed-window joins.
The A-family determinant, height and residual inputs are independently proved.
"""
from pathlib import Path
from fractions import Fraction
import re
BASE=Path('finite_a_next')
for k,m,M,R in [(3,2,2265,Fraction(35,16)),(4,3,165763,Fraction(63,8)),(5,4,3113013,Fraction(495,64))]:
 P=m+2*k
 approx=Path('finite_n3_next/FiniteN3Approximation.lean').read_text()
 approx=approx.replace('FiniteN3',f'FiniteA{k}').replace('finiteN3',f'finiteA{k}').replace('N3',f'A{k}')
 approx=approx.replace('4143',str(M)).replace('35/32',f'{R.numerator}/{R.denominator}')
 powmap={('x',4):k+1,('y',7):P-2,('y',3):k,('c',4):k+1,('c',6):m+k}
 def apow(match):
  var=match[1] or match[2];power=int(match[3])
  new=powmap.get((var,power),power)
  return match[0].rsplit('^',1)[0]+'^'+str(new)
 approx=re.sub(r'‖(?:phi \(([xyc]) : K\)|([xyc]))‖\^(\d+)',apow,approx)
 approx=approx.replace('hK phi x y c z sX sY hx hy hxy hz','hK phi x y c z sX sY hx hy hc hxy hz')
 (BASE/f'FiniteA{k}Approximation.lean').write_text(approx)
 interval=Path('finite_n3_next/FiniteN3Interval.lean').read_text()
 interval=interval.replace('FiniteN3',f'FiniteA{k}').replace('finiteN3',f'finiteA{k}').replace('N3bs',f'A{k}').replace('N3',f'A{k}')
 interval=interval.replace('4143',str(M)).replace('35/32',f'{R.numerator}/{R.denominator}')
 hi=1/(4*R*R)
 interval=interval.replace('256',str(hi.numerator)).replace('1225',str(hi.denominator))
 maps={'X':{4:k+1,8:2*k+2},'Y':{7:P-2,3:k,14:2*P-4,6:2*k},'C':{4:k+1,6:m+k,7:2*k+1,11:2*m+2*k-1}}
 def ipow(match):
  var=match[1] or {'0':'X','1':'Y','2':'C'}[match[2]];power=int(match[3])
  new=maps[var].get(power,power)
  return match[0].rsplit('^',1)[0]+'^'+str(new)
 interval=re.sub(r'([XYC]|‖phi \(t ([012]) : K\)‖)\^(\d+)',lambda m:m[0],interval) if False else interval
 # Separate locals and actual tuple norms to avoid overlap with newly written powers.
 pattern=r'(?:([XYC])|‖phi \(t ([012]) : K\)‖)\^(\d+)'
 interval=re.sub(pattern,ipow,interval)
 interval=interval.replace('In particular the\nanchors may be the original b,s, giving the manuscript\'s A'+str(k)+' family.',
                            'The matrix uses the unequal pole orders specified in the article.')
 (BASE/f'FiniteA{k}Interval.lean').write_text(interval)
 print(f'A{k} actual full-ring inequality and closed interval endpoints written')
