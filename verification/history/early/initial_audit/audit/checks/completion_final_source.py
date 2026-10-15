#!/usr/bin/env python3
"""Verify the integrated manuscript against independent completion calculations.

Does not import any audit script with side effects or overwrite the original
source-audit computations. Reads exact witnesses saved by the independently
executed scripts and separately recomputes the rational q1 and K here.
"""
from pathlib import Path
from fractions import Fraction as F
from math import isqrt
import hashlib,json,re
BASE=Path(__file__).resolve().parents[2]
source_path=BASE/'output/D1_bound5_complete.tex'
original_path=BASE/'upload/D1_bound5_complete.tex'
text=source_path.read_text();original=original_path.read_text()
fixed=json.loads((BASE/'audit/checks/completion_results.json').read_text())
htz=json.loads((BASE/'audit/checks/completion_htz_free_results.json').read_text())
common=json.loads((BASE/'audit/checks/completion_common_tau_results.json').read_text())
assert fixed['source_sha256']==hashlib.sha256(original.encode()).hexdigest()

def block(src,label):
 assert src.count('\\label{'+label+'}')==1,label
 return src.split('\\label{'+label+'}',1)[1].split('\\end{longtable}',1)[0]
def integer_rows(src,label,columns,allow_dash=False):
 rows=[]
 for line in block(src,label).splitlines():
  if not re.match(r'^\s*\d+\s*&',line):continue
  line=re.sub(r'\\\\\s*$','',line.strip())
  fields=[v.strip() for v in line.split('&')]
  assert len(fields)==columns,(label,'column count',line)
  assert all(re.fullmatch(r'-?\d+',v) or (allow_dash and v=='--') for v in fields),(label,line)
  rows.append(tuple(None if v=='--' else int(v) for v in fields))
 return rows
final_rows=integer_rows(text,'tab:fixed56',7,True)
expected=[]
for row in fixed['witnesses']:
 norms=row['fourth_norms'];assert len(norms)<=1
 expected.append((row['pair'],*row['s'],row['norm_s'],row['Mbs'],row['N0'],norms[0] if norms else None))
assert len(final_rows)==56 and final_rows==expected,'Integrated 56-row table differs from exact independent computation.'
old_coeff=integer_rows(original,'tab:pr-forty-coefficients',8)
new_coeff=integer_rows(text,'tab:pr-forty-coefficients',6)
assert len(old_coeff)==len(new_coeff)==40
assert new_coeff==[row[:6] for row in old_coeff],'Five approximation coefficients changed or row order altered.'
# Verify that the new universal determinant proof is present, along with its exact constants.
assert r'\frac{59}{20}' in text or r'59/20' in text,'The common tau replacement is not present.'
assert r'\frac{59}{50}' in text or r'59/50' in text,'The common overlap margin is not present.'
assert F(common['tau'])==F(59,20)
assert all(F(row['minimum'])>F(59,50) for row in common['rows'])
assert len(common['rows'])==41
# Identify the additional rational-triple calculation, rather than matching unrelated constants.
marker=r'For $(a,b,s)=(1,3,8)$ the formulas give'
assert marker in text,'The integrated rational-case calculation is not present yet.'
rational=text.split(marker,1)[1].split('\\subsection{The finite complement}',1)[0]
qm=re.search(r'q_1\s*=\s*\\frac\{(\d+)\}\{(\d+)\}',rational)
assert qm,'Rational q1 not found.'
q_print=F(int(qm[1]),int(qm[2]))
L=10**10;v=F(4*49*25,9*64**2)
n=isqrt(v.numerator*L*L//v.denominator)
if n*n*v.denominator!=v.numerator*L*L:n+=1
q_exact=F(n,L)
assert q_exact==q_print==F(1822916667,5000000000)
mu=F(51051,400000);K=F(9999,100)*(1/q_exact-mu/9)**2
assert K>744 and re.search(r'K\s*>\s*744\b',rational)
mb=re.search(r'M_\{bs\}\s*=\s*(\d+)',rational);nn=re.search(r'N_0\s*=\s*(\d+)',rational)
assert mb and nn and int(mb[1])==htz['Mbs']==34 and int(nn[1])==htz['N0']==1024
witness_intro='thirteen integers'
assert witness_intro in rational
witness_display=re.search(r'\\\[(.*?)\\\]',rational.split(witness_intro,1)[1],re.S)
assert witness_display
witnesses=[int(x) for x in re.findall(r'\d+',witness_display[1])]
threshold_names=['start-Q','Q-N2','N2-P-1','N2-P-2','P-A3','A3-M','M-N3','N3-N3bs','N3bs-A4','A4-O4','O4-A5','A5-O5','O5-O6']
expected_witnesses=[htz['thresholds'][name] for name in threshold_names]
assert witnesses==expected_witnesses==[3,23,96,101,108,179,131,9,34,76,123,29,438]
nt=re.search(r'n_\\infty\s*=\s*(\d+)',rational)
assert nt and int(nt[1])==htz['thresholds']['tail']==14
# The inserted conclusion must have the correct fourth-entry cutoff and no retained HTZ appeal.
assert '$t<32$' in rational
assert r'\ref{lem:tail-irregular}' in rational and r'$t>2\cdot3\cdot8=48$' in rational
assert 32 < 2*3*8
assert r'\cite{HTZ}' not in text and r'\bibitem{HTZ}' not in text
results={
 'final_source_sha256':hashlib.sha256(text.encode()).hexdigest(),
 'original_source_sha256':fixed['source_sha256'],
 'final_table_rows_verified':len(final_rows),
 'coefficient_rows_verified':len(new_coeff),
 'coefficient_columns_retained':5,
 'removed_columns':2,
 'rational_q1':str(q_exact),
 'rational_K':str(K),
 'rational_Mbs':int(mb[1]),
 'rational_N0':int(nn[1]),
 'rational_overlap_thresholds':witnesses,
 'rational_tail_threshold':int(nt[1]),
 'common_tau_rows_verified_from_exact_witnesses':len(common['rows']),
 'status':'PASS'
}
(BASE/'audit/checks/completion_final_source_results.json').write_text(json.dumps(results,indent=2))
print('PASS: integrated 56-row final table exactly matches independently regenerated entries, coefficients, cutoffs and fourth-norm lists.')
print('PASS: all40 rows retain precisely their original five approximation constants; only the two superseded columns are removed.')
print('PASS: the additional rational q1,K,Mbs,N0,13 overlap thresholds and tail threshold agree with the independent exact calculation.')
print('PASS: common tau witnesses cover all41 pairs and the final source contains no HTZ citation or bibliography entry.')
print('Final source SHA256:',results['final_source_sha256'])
