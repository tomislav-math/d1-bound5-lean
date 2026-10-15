import re,cmath,json,math
from pathlib import Path
root=Path(__file__).resolve().parents[2]; src=(root/'upload/D1_bound5-v1(1).tex').read_text()
P={}
pat=r'^(\d+)&(\d+)&\$\((-?\d+),(-?\d+)\)\$&\$\((-?\d+),(-?\d+)\)\$&(\d+)&(\d+)\\\\$'
for m in re.finditer(pat,src,re.M):
 i,d,ax,ay,bx,by,na,nb=map(int,m.groups());w=(1+cmath.sqrt(-d))/2 if d%4==3 else cmath.sqrt(-d)
 P[i]=(d,ax+ay*w,bx+by*w)
triples=[]
for m in re.finditer(r'^(\d+) & (-?\d+) & (-?\d+) & (\d+) & (\d+) & (\d+) & (\d+|--) \\\\$',src,re.M):
 i,u,v,s0,M,N0,last=m.groups();i=int(i);d,a,b=P[i];w=(1+cmath.sqrt(-d))/2 if d%4==3 else cmath.sqrt(-d)
 triples.append((i,(int(u),int(v)),a,b,int(u)+int(v)*w,int(N0)))
triples.append(('rat',(8,0),1+0j,3+0j,8+0j,1024))
fail=[]
for ix,coords,a,b,s,N0 in triples:
 A,B,S=map(abs,(a,b,s));T0=2*B*S;Tu=math.sqrt(N0)
 if T0>=Tu: continue
 al,be,ga=[cmath.sqrt(1+1/(v*w))-1 for v,w in ((a,b),(a,s),(b,s))]
 p0=2*al*be*ga
 L=[-2*ga*(al+be-ga),-2*be*(al-be+ga),2*al*(al-be-ga)]
 Q=[[ga*(ga+2),2*(al-be*ga-be-ga),-2*(al*ga+al-be+ga)],[0,be*(be+2),-2*(al*be+al+be-ga)],[0,0,al*(al+2)]]
 mods=(A,B,S); k=[.5+1/(7*ai*T0) for ai in mods]
 c1=A*B*S*abs(p0); c0=A*B*S*abs(sum(L[i]/(2*v) for i,v in enumerate((a,b,s))))
 cm=A*B*S*(sum(abs(L[i])*k[i]**2/(2*mods[i]**2) for i in range(3))+sum(abs(Q[i][j])*k[i]*k[j]/(mods[i]*mods[j]) for i in range(3) for j in range(i,3)))
 ff=lambda T:c1*T+c0+cm/T
 vals=[ff(T0),ff(Tu)]
 # larger solution of bound ==1
 disc=(1-c0)**2-4*c1*cm
 upper=((1-c0)+math.sqrt(disc))/(2*c1) if disc>=0 else None
 if max(vals)>=1: fail.append((ix,coords,N0,T0,upper,vals))
 print(ix,coords,'N0',N0,'T0',round(T0,4),'gap',round(upper,5) if upper else None,'Fupper',round(vals[1],8))
print('FAIL',fail,'taildone',sum(4*abs(b)**2*abs(s)**2>=N0-1e-6 for _,_,a,b,s,N0 in triples))
