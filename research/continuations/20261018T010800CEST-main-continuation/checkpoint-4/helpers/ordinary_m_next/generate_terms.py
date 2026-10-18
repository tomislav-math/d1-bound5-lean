exec(open('ordinary_m_next/compute_rows.py').read().split('rows=[]')[0])
terms=[]
for i in range(4):
 row=[]
 for j in range(4):
  values=[]
  for h in product(range(3),repeat=4):
   if sum(h)!=1+(i==j):continue
   coeff=16*choose(Fraction(5,2),h[j]);ex=[4,4,4];dx=[4,4,4];power=2-h[j]
   if j==0:ex=[x+power for x in ex]
   else:
    for q in range(3):
     if q!=j-1:ex[q]+=power
   for l in range(4):
    if l==j:continue
    p=2+(i==l);coeff*=choose(-p,h[l]);e=p+h[l]
    sign,mons,idx=factors[j,l];coeff*=sign**e
    ex=[x-e*m for x,m in zip(ex,mons)]
    if idx is not None:dx[idx]-=e
   if i==0:dx=[x-1 for x in dx]
   else:ex[i-1]-=1;dx[{1:2,2:1,3:0}[i]]-=1
   if j>0:ex[j-1]-=1
   assert min(ex+dx)>=0 and coeff.denominator==1
   values.append([int(coeff)]+ex+dx+[power])
  row.append(values)
 terms.append(row)
Path('ordinary_m_next/terms.json').write_text(json.dumps(terms,indent=2))
for i,row in enumerate(terms):
 print(i,[(sum(abs(t[0])*2**sum(t[4:]) for t in col), max(t[3]+t[5]+t[6]+t[7] for t in col)) for col in row[1:]])
