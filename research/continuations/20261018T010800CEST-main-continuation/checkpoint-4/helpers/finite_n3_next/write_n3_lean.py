from pathlib import Path
import runpy, contextlib, io

with contextlib.redirect_stdout(io.StringIO()):
    g = runpy.run_path('finite_n3_next/generate_n3.py')
Q, fmt, divide, pw, diff, cn, x, y = [g[k] for k in ['Q','fmt','divide','pw','diff','cn','x','y']]

def grouped(p):
    out = []
    for n in range(4):
        q = {(e[0],e[1],0):a for e,a in p.items() if e[2] == n}
        if q:
            out.append('('+fmt(q)+')'+('' if n == 0 else '*c' if n == 1 else f'*c^{n}'))
    return ' +\n      '.join(out) or '0'

const = []
for i in range(3):
    deg = 5 if i == 0 else 6
    const.append(f'(x-y)^{deg}*('+grouped(divide(Q[i][0],pw(diff,deg)))+')')
left = [grouped(divide(Q[i][1],x)) for i in range(3)]
right = [grouped(divide(Q[i][2],y)) for i in range(3)]
text = Path('finite_n2_next/FiniteN2Matrix.lean').read_text().replace('N2','N3').replace('factor2','factor4')
start = text.index('def finiteN3Constant')
end = text.index('/-- The polynomial matrix',start)
defn = 'def finiteN3Constant (x y c : R) : Fin 3 → R :=\n  !['+',\n    '.join(const)+']\n\n'
defn += 'def finiteN3Left (x y c : R) : Fin 3 → R :=\n  !['+',\n    '.join(left)+']\n\n'
defn += 'def finiteN3Right (x y c : R) : Fin 3 → R :=\n  !['+',\n    '.join(right)+']\n\n'
text = text[:start]+defn+text[end:]
text = text.replace('constant -1800 is divided by g^3=8','constant235200 is divided by g^3=64')
text = text.replace('-225*(x-y)^7','3675*x*y*(x-y)^11').replace('-225*x*y*(x-y)^7','3675*x^2*y^2*(x-y)^11')
text = text.replace('(x y c : F) (hxy : x ≠ y)', '(x y c : F) (hx : x ≠ 0) (hy : y ≠ 0) (hxy : x ≠ y)')
text = text.replace('norm_num [mul_eq_zero, sub_eq_zero, hxy]','norm_num [mul_eq_zero, sub_eq_zero, hx, hy, hxy]')
text = text.replace('set_option maxHeartbeats 1000000','set_option maxHeartbeats 4000000')
Path('finite_n3_next/FiniteN3Matrix.lean').write_text(text)

text = Path('finite_n2_next/FiniteN2BennettIdentity.lean').read_text().replace('FiniteN2','FiniteN3').replace('finiteN2','finiteN3').replace('finite_choose_two','finiteN3_choose_two')
pos = text.index('set_option maxHeartbeats')
three = '''theorem finiteN3_choose_three (r : F) : Ring.choose r 3 = r*(r-1)*(r-2)/6 := by
  have h := Ring.choose_smul_choose (r := r) (n := 3) (k := 1) (by decide)
  norm_num [nsmul_eq_mul, Ring.choose_one_right, finiteN3_choose_two] at h
  apply (eq_div_iff (by norm_num : (6 : F) ≠ 0)).mpr
  linear_combination 2*h

'''
text = text[:pos]+three+text[pos:]
text = text.replace('N2','N3').replace('k=2','k=3').replace('2(x-y),2x,2y','4(x-y),4x,4y')
text = text.replace('Entry x y c 2 i j','Entry x y c 3 i j').replace('2 * finiteN3RowFactor','4 * finiteN3RowFactor')
text = text.replace('  have hd :', '  have hanti3 : Finset.antidiagonal 3 = {(0,3),(1,2),(2,1),(3,0)} := by decide\n  have hd :')
text = text.replace('[hanti1, hanti2,','[hanti1, hanti2, hanti3,').replace('Ring.choose_one_right, finiteN3_choose_two,\n','Ring.choose_one_right, finiteN3_choose_two, finiteN3_choose_three,\n')
text = text.replace('maxHeartbeats 2000000','maxHeartbeats 4000000')
Path('finite_n3_next/FiniteN3BennettIdentity.lean').write_text(text)
print('Wrote actual N3 matrix and ordinary k3 identity draft.')
for i in range(3):
    sums = [sum(abs(a) for p in [divide(Q[i][1],x),divide(Q[i][2],y)] for e,a in p.items() if e[2] == n) for n in range(4)]
    print('Row',i,'combined divided-column absolute coefficient sums:',sums)
