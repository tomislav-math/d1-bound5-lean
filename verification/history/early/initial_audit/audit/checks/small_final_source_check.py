"""Bind the final small-entry review to exact source and computation hashes.

This checks the changed interval algebraically from its actual LaTeX,
accounts for every changed displayed formula in the section, and ties
all unchanged finite tables to the previously completed exact runs.
"""
from pathlib import Path
from fractions import Fraction as F
from collections import Counter
import re,json,hashlib

ROOT=Path(__file__).resolve().parents[2]
BASE=ROOT/'audit/checks'
old_path=ROOT/'upload/D1_bound5_complete.tex'
new_path=ROOT/'output/D1_bound5_complete.tex'
old_text=old_path.read_text()
new_text=new_path.read_text()
sha=lambda s:hashlib.sha256(s.encode()).hexdigest()
norm=lambda s:re.sub(r'\s+','',s)

def section(text):
    marker=r'\section{Tuples with at least two small entries}'
    start=text.index(marker)
    end=text.index(r'\section',start+len(marker))
    return text[start:end]

old=section(old_text);new=section(new_text)

def displays(text):
    pat=re.compile(r'\\\[(.*?)\\\]|\\begin\{(?P<env>equation\*?|align\*?)\}(?P<body>.*?)\\end\{(?P=env)\}',re.S)
    return Counter(norm(re.sub(r'\\label\{[^}]*\}','',m.group(1) or m.group('body'))) for m in pat.finditer(text))

removed=displays(old)-displays(new)
added=displays(new)-displays(old)
old_logs=norm(r'(a_0,b_0,s_0,t_0,c_0,d_0)=(\log A,\log B,\log S,\log T,\log C,\log D).')
old_window=norm(r'3c_0+4b_0+8s_0+12t_0+\log(2\cdot10300^2)&\le d_0\nonumber\\ &\le7c_0+2a_0-2b_0-6s_0-10t_0-\log(2\cdot193^2)')
old_square=norm(r'\frac{A^2+dB^2}{4}=L^2,\qquad U^2=2L+A,\qquad dV^2=2L-A,\qquad UV=|B|\,,')
old_envelope=norm(r'\log_{10}D<f(\log_{10}P),\qquad f(x)=7x+\frac{212}{5}+\frac{4047/25}{x-4}.')
new_envelope=norm(r'\log_{10}D<g(\log_{10}P),\qquad g(x)=7x+\frac{212}{5}+\frac{4047/25}{x-4}.')
new_window=norm(r'2\cdot10300^2B^4S^8T^{12}C^3\le D\le\frac{A^2C^7}{2\cdot193^2B^2S^6T^{10}}')
new_square=old_square.replace('A','u').replace('B','v')
modulus=norm(r'|G-J|+|G+J|\le|G-J||G+J|+1.')
assert removed==Counter([old_logs,old_window,old_square,old_envelope]),removed
assert added==Counter([new_window,new_square,modulus,new_envelope]),added
# This is an exact check of one named display, not a broad f/g mask.
assert new_envelope.replace('g(','f(')==old_envelope
cutoff_start=new.index(r'\begin{lemma}\label{sm:bs7-cutoff}')
cutoff_end=new.index(r'\begin{lemma}\label{sm:bs7-descent}',cutoff_start)
cutoff=new[cutoff_start:cutoff_end]
assert re.findall(r'f\([^\n]*',cutoff)==[r'f(1/(tc))|>\frac1{3TC},\qquad']
assert cutoff.count('g(')==5
assert 'The function $g$ is convex on $(4,\\infty)$.' in cutoff
assert '$g(8)<139$ and $g(49)=389-1/375$' in cutoff
assert '$g(72)<549$' in cutoff
assert 'the function $x-347/5-(4047/25)/(x-4)$ is increasing for $x\\ge72$ and positive at $x=72$.' in cutoff

variables='ABSTC'
def monomial(s):
    s=norm(s).replace(r'\cdot','*')
    coeff=F(1);exps={v:0 for v in variables};i=0
    while i<len(s):
        if s[i]=='*':i+=1;continue
        m=re.match(r'(\d+|[ABSTC])(?:\^(?:\{(-?\d+)\}|(-?\d+)))?',s[i:])
        assert m,(s,i)
        factor=m[1];power=int(m[2] or m[3] or 1)
        if factor in variables:exps[factor]+=power
        else:coeff*=F(int(factor))**power
        i+=len(m[0])
    return coeff,exps

def quotient(x,y):
    return x[0]/y[0],{v:x[1][v]-y[1][v] for v in variables}

def times(x,y):
    return x[0]*y[0],{v:x[1][v]+y[1][v] for v in variables}

def brace(s,start):
    assert s[start]=='{';level=1;i=start+1
    while level:
        level+=(s[i]=='{')-(s[i]=='}');i+=1
    return s[start+1:i-1],i

def log_monomial(part):
    const=re.search(r'([+-])\\log\(([^)]*)\)',part)
    assert const
    numeric=monomial(const[2])[0]
    if const[1]=='-':numeric=1/numeric
    exps={v:0 for v in variables}
    for match in re.finditer(r'([+-]?\d+)([abstc])_0',part):
        exps[match[2].upper()]+=int(match[1])
    return numeric,exps

# Both source strings above have been extracted as actual changed displays.
old_parts=old_window.split(r'&\le')
old_lower=log_monomial(old_parts[0])
old_upper=log_monomial(old_parts[2])
final_lower_text,final_upper_text=new_window.split(r'\leD\le')
final_lower=monomial(final_lower_text)
assert final_upper_text.startswith(r'\frac')
num,p=brace(final_upper_text,len(r'\frac'))
den,p=brace(final_upper_text,p)
assert p==len(final_upper_text)
final_upper=quotient(monomial(num),monomial(den))
assert final_lower==old_lower
assert final_upper==old_upper

# The new endpoints reproduce exactly the two squared Z thresholds.
assert quotient(times(final_lower,monomial('C')),monomial('2'))==monomial(r'10300^2B^4S^8T^{12}C^4')
assert times(times(final_upper,monomial('C')),monomial('2'))==quotient(monomial(r'A^2C^8'),monomial(r'193^2B^2S^6T^{10}'))

# Exact polynomial identity used in the clarified symmetric configuration.
def padd(a,b):
    c=a.copy()
    for k,v in b.items():c[k]=c.get(k,0)+v
    return {k:v for k,v in c.items() if v}
def pscale(a,k):return {i:k*v for i,v in a.items() if k*v}
def pmul(a,b):
    c={}
    for (i,j),x in a.items():
        for (k,l),y in b.items():c[i+k,j+l]=c.get((i+k,j+l),0)+x*y
    return {k:v for k,v in c.items() if v}
one={(0,0):1};X={(1,0):1};Y={(0,1):1}
G=padd(padd(pscale(pmul(X,Y),2),pscale(X,-1)),pscale(one,-1))
J2=pscale(pmul(X,pmul(padd(one,pscale(Y,-1)),padd(one,pscale(pmul(X,Y),-1)))),4)
assert padd(pmul(G,G),pscale(J2,-1))==pmul(padd(X,pscale(one,-1)),padd(X,pscale(one,-1)))

reviewed_phrases=[
    'Both products are squares in $\\OK$, so $u,v$, and hence $L$, lie in $\\OK$.',
    'The element $-b$ may also be adjoined. Indeed, $1-b^2=(1-b)(1+b)$ is a square, and its other compatibility conditions follow by changing signs.',
    'The argument excluding $\\{-1,1,a,-a,b\\}$ shows that the four real extensions have distinct absolute values.',
    'The upper bound for $D$ when $L_4=0$ therefore implies $L_4\\ne0$.',
    'We recall a short proof of the criterion used here.',
    'If the extension of modulus at most $R$ exists, use it as a fourth',
    'and suppose $r_0\\in\\OK$ satisfies $r_0^2=ab+1\\ne0$. Every integral common extension',
    'If it is one, one root is rational and the other purely imaginary.',
    'With $v=\\log_{10}V\\ge40$, that corollary consequently gives',
]
for phrase in reviewed_phrases:assert phrase in new,phrase

def tables(text):
    pat=re.compile(r'\\begin\{(?P<env>longtable|tabular)\}.*?\\end\{(?P=env)\}',re.S)
    return [m[0] for m in pat.finditer(text)]
old_tables=tables(old);new_tables=tables(new)
assert len(old_tables)==len(new_tables)==3
assert [norm(t) for t in old_tables]==[norm(t) for t in new_tables]

# Bind all table results to the completed independent computation outputs.
pair_results=json.loads((BASE/'small_pairs_results.json').read_text())
pat=r'^(\d+) & \$\((-?\d+),(-?\d+)\)\$ & \$\((-?\d+),(-?\d+)\)\$ & (\d+) & (\d+)'
final_pairs={(d,((a,b),(c,e))):(nv,ne) for d,a,b,c,e,nv,ne in (tuple(map(int,m)) for m in re.findall(pat,new,re.M))}
assert len(final_pairs)==len(pair_results)==48
for row in pair_results:
    key=row['d'],tuple(tuple(z) for z in row['pair'])
    assert final_pairs[key]==(row['vertices'],row['edges'])
    assert row['triangles']==0
triple_results=json.loads((BASE/'small_triples_results.json').read_text())
assert len(triple_results)==10
assert sum(r['orbit_size'] for r in triple_results)==24
assert [r['closed_count'] for r in triple_results]==[61,89,64,105,71,112,112,57,83,55]
pell_results=json.loads((BASE/'small_pell_results.json').read_text())
assert pell_results['totals']=={'fields':1016,'nonempty':409,'vertices':19612,'edges':9806,'triangles':0}
assert re.search(r'1016\s*&\s*409\s*&\s*19612\s*&\s*9806\s*&\s*0',new)

report={
    'original_source_sha256':sha(old_text),
    'final_source_sha256':sha(new_text),
    'original_small_section_sha256':sha(old),
    'final_small_section_sha256':sha(new),
    'displayed_formula_delta':{'removed':list(removed.elements()),'added':list(added.elements()),'all_changes_accounted_for':True},
    'four_root_interval':{'lower_equivalent':True,'upper_equivalent':True,'squared_Z_thresholds_verified':True},
    'height_envelope_rename':{'exact_named_display_equivalent':True,'g_function_uses':5,'analytic_f_use_preserved':True,'undefined_t_in_growth_comparison_removed':True},
    'descent_statement':{'integral_r0_hypothesis_explicit':True,'all_applications_reviewed_in_small_reverse_pass_report':True},
    'symmetric_configuration_polynomial_identity':True,
    'reviewed_integrality_and_sign_symmetry_text_present':True,
    'unchanged_tables':[
        {'index':i+1,'normalized_sha256':sha(norm(t))} for i,t in enumerate(new_tables)
    ],
    'pair_graph_totals':{k:sum(r[k] for r in pair_results) for k in ['vertices','edges','triangles']},
    'triple_rows':len(triple_results),
    'pell_totals':pell_results['totals'],
    'input_result_sha256':{
        n:hashlib.sha256((BASE/n).read_bytes()).hexdigest() for n in [
            'small_pairs_results.json','small_triples_results.json','small_pell_results.json',
            'small_constants_results.json','small_seed_crosscheck_results.json']
    },
    'status':'PASS: final-source changes and unchanged tables checked; independent large enumerations were not redundantly rerun.'
}
(BASE/'small_final_source_results.json').write_text(json.dumps(report,indent=2))
print(json.dumps(report,indent=2))
