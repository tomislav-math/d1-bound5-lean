#!/usr/bin/env python3
"""Two independent graph pipelines; each compiles, preserves closure types, and audits one endpoint."""
from pathlib import Path
import argparse,concurrent.futures,json,subprocess,time
R=Path(__file__).resolve().parent
def run_graph(g):
 O=R/f'results-graphs-b-pipeline{g}';O.mkdir(exist_ok=True)
 def step(label,cmd,summary=None):
  t=time.time();print('GRAPH',g,label,'START',flush=True)
  with (O/(label+'.log')).open('w') as log:q=subprocess.run(cmd,cwd=R.parent,stdout=log,stderr=subprocess.STDOUT)
  row={'graph':g,'phase':label,'command':cmd,'exit_code':q.returncode,'seconds':time.time()-t}
  if summary:
   s=json.loads((R/summary/'SUMMARY.json').read_text());row.update(failed=s['failed'],uncompiled=s.get('uncompiled',[]))
   assert not row['failed'] and not row['uncompiled'],row
  (O/(label+'-stage.json')).write_text(json.dumps(row,indent=2,sort_keys=True)+'\n')
  assert q.returncode==0,row
  print('GRAPH',g,label,'PASS',round(row['seconds'],2),flush=True)
 join=f'results-graphs-b-join{g}';endpoint=f'results-graphs-b-endpoint{g}'
 step('joins',['python',str(R/'guarded_general_b.py'),'--out',join,'--jobs','1','--targets',f'SmallPairPureClosureAdapter{g}',f'SmallPairLightLeft{g}',f'SmallPairLightRight{g}',f'SmallPairGraphArithmetic{g}',f'SmallPairRawSelectedData{g}',f'SmallPairLightAssembly{g}'],join)
 step('closure-successor',['python',str(R/'install_graphs_b_closure.py'),str(g)])
 step('endpoint',['python',str(R/'guarded_general_b.py'),'--out',endpoint,'--jobs','1','--targets',f'SmallPairGraphData{g}'],endpoint)
 step('audit',['python',str(R/'audit_graphs_b.py'),str(g)])
 (O/'PIPELINE_SUMMARY.json').write_text(json.dumps({'graph':g,'status':'SCOPED_ENDPOINT_VERIFICATION_PASS','remote_successor_installation_pending':True,'main_theorem_complete':False},indent=2)+'\n')
 return g
def main():
 p=argparse.ArgumentParser();p.add_argument('--graphs',nargs='+',type=int,default=[14,21,28,36]);p.add_argument('--jobs',type=int,default=2);a=p.parse_args();assert set(a.graphs)<=set([14,21,28,36]);assert 1<=a.jobs<=2
 errors=[]
 with concurrent.futures.ThreadPoolExecutor(max_workers=a.jobs) as ex:
  futs={ex.submit(run_graph,g):g for g in a.graphs}
  for f in concurrent.futures.as_completed(futs):
   g=futs[f]
   try:f.result()
   except Exception as e:errors.append({'graph':g,'error':str(e)});print('GRAPH',g,'FAILED',str(e),flush=True)
 if errors:
  (R/'graphs-b-pipeline-errors.json').write_text(json.dumps(errors,indent=2)+'\n');raise SystemExit(1)
if __name__=='__main__':main()
