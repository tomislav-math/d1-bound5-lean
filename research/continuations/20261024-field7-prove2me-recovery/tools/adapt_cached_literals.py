"""Narrow source-preserving list split for confirmed 300-second compilation-timeout cached literals.

Only explicit --targets are changed. There are no API or ledger writes. The
coordinator must select only failed/unsubmitted targets under its ledger lock.
"""
from __future__ import annotations
import argparse
import ast
import copy
import json
from pathlib import Path
import re

from adapt_large_data import AdaptationError, atomic_json, canonical, digest, literal_rows, topological_order

BYTE_BUDGET = 100_000
TOKEN_BUDGET = 4_000
CACHED_TARGETS = {
    'D1Bound5_SmallPairLightData29Right_Definitions_002': 'rightCached',
    'D1Bound5_SmallPairLightData5LeftCached_Definitions': 'leftCached',
}
CACHED_STRUCTURAL_TYPE = 'List ((Int × Int) × List (Nat × Nat))'


def token_count(text):
    # Exact lexical units for our strictly numeric/bracket/tuple literal grammar.
    return len(re.findall(r'\d+|[^\s\d]', text))


def list_info(source, name, lean_type):
    pattern = r'(?P<modifier>noncomputable\s+)?def\s+' + re.escape(name) + r'\s*:\s*' + re.escape(lean_type) + r'\s*:=\s*'
    matches = list(re.finditer(pattern, source))
    if len(matches) != 1:
        raise AdaptationError('Expected exactly one known list declaration: ' + name)
    match = matches[0]
    start = match.end()
    if source[start:start+1] != '[':
        raise AdaptationError('Expected an unsplit literal list: ' + name)
    depth, end = 0, None
    for offset in range(start, len(source)):
        if source[offset] == '[':
            depth += 1
        elif source[offset] == ']':
            depth -= 1
            if not depth:
                end = offset+1
                break
    if end is None:
        raise AdaptationError('Unterminated list')
    literal = source[start:end]
    if not literal.isascii() or re.search(r'[^0-9\s,\[\]()-]', literal):
        raise AdaptationError('Unsupported token in literal list')
    expression = ast.parse(literal, mode='eval').body
    def natural(expr):
        return isinstance(expr, ast.Constant) and type(expr.value) is int and expr.value >= 0
    def integer(expr):
        return natural(expr) or (isinstance(expr, ast.UnaryOp) and isinstance(expr.op, ast.USub) and natural(expr.operand))
    def pair(expr):
        return isinstance(expr, ast.Tuple) and len(expr.elts) == 2 and all(natural(x) for x in expr.elts)
    def row_valid(expr):
        return (isinstance(expr, ast.Tuple) and len(expr.elts) == 2 and
                isinstance(expr.elts[0], ast.Tuple) and len(expr.elts[0].elts) == 2 and all(integer(x) for x in expr.elts[0].elts) and
                isinstance(expr.elts[1], ast.List) and all(pair(x) for x in expr.elts[1].elts))
    if not isinstance(expression, ast.List) or not expression.elts or not all(row_valid(x) for x in expression.elts):
        raise AdaptationError('Literal has unexpected list element shape')
    offsets = [0]
    for line in literal.splitlines(keepends=True):
        offsets.append(offsets[-1]+len(line))
    rows = [literal[offsets[x.lineno-1]+x.col_offset:offsets[x.end_lineno-1]+x.end_col_offset] for x in expression.elts]
    return dict(start=start, end=end, literal=literal, rows=rows, values=ast.literal_eval(expression),
                lean_type=lean_type, noncomputable=bool(match.group('modifier')),
                literal_sha256=digest(re.sub(r'\s+', '', literal).encode()))


def split_rows(rows, byte_budget=BYTE_BUDGET, token_budget=TOKEN_BUDGET):
    chunks, current, size, tokens = [], [], 4, 2
    for row in rows:
        row_bytes, row_tokens = len(row.encode())+4, token_count(row)+1
        if row_bytes+4 > byte_budget or row_tokens+2 > token_budget:
            raise AdaptationError('One atomic row exceeds the requested chunk budget')
        if current and (size+row_bytes > byte_budget or tokens+row_tokens > token_budget):
            chunks.append(current)
            current, size, tokens = [], 4, 2
        current.append(row)
        size += row_bytes
        tokens += row_tokens
    if current:
        chunks.append(current)
    return chunks


def append_expression(names):
    result = '_root_.' + names[-1]
    for name in reversed(names[:-1]):
        result = '(_root_.List.append _root_.' + name + ' ' + result + ')'
    return result


def discover_tables(source, byte_budget=BYTE_BUDGET, token_budget=TOKEN_BUDGET):
    """Find validated cached-list declarations that exceed either slice budget."""
    pattern = r'(?m)^[ \t]*(?:private[ \t]+)?(?:noncomputable[ \t]+)?def[ \t]+([A-Za-z_][A-Za-z0-9_\'.]*)[ \t]*:[ \t]*List PairLightCachedVertex[ \t]*:=[ \t\r\n]*\['
    names = re.findall(pattern, source)
    if len(names) != len(set(names)):
        raise AdaptationError('Duplicate cached-list binding name in one source')
    tables = []
    for name in names:
        table = list_info(source, name, 'List PairLightCachedVertex')
        table['name'] = name
        if len(table['literal'].encode()) > byte_budget or token_count(table['literal']) > token_budget:
            tables.append(table)
    return tables


def helper_identity(rows, noncomputable):
    identifier = digest((CACHED_STRUCTURAL_TYPE+'\n'+str(noncomputable)+'\n'+literal_rows(rows)).encode())[:20]
    constant = 'cachedSlice_'+identifier
    return 'D1Bound5_Prove2MeTransfer_'+constant, 'D1Bound5.Prove2MeTransfer.'+constant, 'cached_slice_'+identifier


def helper_body(rows, noncomputable):
    name, lean_name, uid = helper_identity(rows, noncomputable)
    constant = lean_name.rsplit('.',1)[1]
    return ('import Init\n\nnamespace D1Bound5.Prove2MeTransfer\n'
            'set_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n' +
            ('noncomputable ' if noncomputable else '')+'def '+constant+' : '+CACHED_STRUCTURAL_TYPE+' :=\n'+
            literal_rows(rows)+'\n\nend D1Bound5.Prove2MeTransfer\n')


def declaration_record(table, chunks):
    first = 0
    slices = []
    for rows in chunks:
        name, lean_name, uid = helper_identity(rows, table['noncomputable'])
        slices.append(dict(name=name,rows=[first,first+len(rows)],ordered_rows_sha256=digest(canonical(rows)),
                           source_sha256=digest(helper_body(rows,table['noncomputable']).encode())))
        first += len(rows)
    return dict(declaration=table['name'],declared_type='List PairLightCachedVertex',
                helper_type=CACHED_STRUCTURAL_TYPE,noncomputable=table['noncomputable'],
                old_literal_bytes=len(table['literal'].encode()),old_literal_tokens=token_count(table['literal']),
                literal_sha256=digest(table['literal'].encode()),normalized_literal_sha256=table['literal_sha256'],
                ordered_rows_sha256=digest(canonical(table['rows'])),rows=len(table['rows']),slices=slices,
                chunk_rows=[len(x) for x in chunks],max_chunk_literal_bytes=max(len(literal_rows(x).encode()) for x in chunks),
                max_chunk_literal_tokens=max(token_count(literal_rows(x)) for x in chunks),
                exact_row_recomposition=True,original_computability_preserved=True,
                definitional_equality_reason='The original PairLightCachedVertex abbreviation unfolds to the helper pair type, and nested List.append unfolds to the identical original List.cons sequence.')


def replace_source(old_source,tables,chunk_lists):
    body=old_source
    helper_names=[]
    for table,chunks in zip(tables,chunk_lists):
        helper_names.extend(helper_identity(rows,table['noncomputable'])[0] for rows in chunks)
    for table,chunks in reversed(list(zip(tables,chunk_lists))):
        names=[helper_identity(rows,table['noncomputable'])[1] for rows in chunks]
        body=body[:table['start']]+append_expression(names)+body[table['end']:]
    helper_names=list(dict.fromkeys(helper_names))
    body=''.join('import Definitions.Def_'+name+'\n' for name in helper_names)+body
    return body,helper_names


def expected_changed_node(old_node,source,helper_names):
    node=copy.deepcopy(old_node)
    node['payload']['definition']=source
    node['definition_file']='adaptations/cached-literals-v3/Definitions/Def_'+node['name']+'.lean'
    node['definition_sha256']=digest(source.encode())
    for key in ('publish_dependencies','proof_dependencies'):
        node[key]=sorted(set(node.get(key,[]))|set(helper_names))
    return node


def verify_adaptation(old_node,new_node,all_new_nodes,provenance):
    """Independently reconstruct every changed source byte and helper literal.

    Raises AdaptationError on mismatch; returns {helper_names, declarations,
    exact_source_reconstruction: True}. No files, network, or state mutations.
    """
    if provenance.get('shape') != 'exact-cached-literal-split-v1':
        raise AdaptationError('Missing exact cached-literal adaptation marker')
    old_source=old_node['payload']['definition']
    if provenance.get('old_source_sha256') != digest(old_source.encode()):
        raise AdaptationError('Original source hash mismatch')
    byte_budget,token_budget=provenance.get('byte_budget'),provenance.get('token_budget')
    if not isinstance(byte_budget,int) or not 1<=byte_budget<=BYTE_BUDGET or not isinstance(token_budget,int) or not 1<=token_budget<=TOKEN_BUDGET:
        raise AdaptationError('Invalid adaptation budgets')
    tables=discover_tables(old_source,byte_budget,token_budget)
    if not tables:
        raise AdaptationError('No eligible cached literals')
    chunks=[split_rows(t['rows'],byte_budget,token_budget) for t in tables]
    records=[declaration_record(t,c) for t,c in zip(tables,chunks)]
    if provenance.get('declarations') != records:
        raise AdaptationError('Cached row/chunk provenance differs from original source')
    registry=all_new_nodes if isinstance(all_new_nodes,dict) else {n['name']:n for n in all_new_nodes}
    for table,parts in zip(tables,chunks):
        flat=[row for part in parts for row in part]
        if flat!=table['rows'] or ast.literal_eval(literal_rows(flat))!=table['values']:
            raise AdaptationError('Original cached rows were changed')
        for rows in parts:
            name,lean_name,uid=helper_identity(rows,table['noncomputable'])
            helper=registry.get(name)
            body=helper_body(rows,table['noncomputable'])
            if not helper or helper.get('kind')!='definition' or helper.get('unit_id')!=uid or helper.get('payload',{}).get('definition')!=body or helper.get('definition_sha256')!=digest(body.encode()):
                raise AdaptationError('Helper does not exactly reproduce cached rows: '+name)
            if helper.get('publish_dependencies') or helper.get('proof_dependencies'):
                raise AdaptationError('Init-only helper has unexpected dependencies')
    expected_source,helper_names=replace_source(old_source,tables,chunks)
    if provenance.get('new_source_sha256')!=digest(expected_source.encode()):
        raise AdaptationError('Reconstructed source hash mismatch')
    if canonical(new_node)!=canonical(expected_changed_node(old_node,expected_source,helper_names)):
        raise AdaptationError('Unexpected source or metadata change outside literal replacement')
    return dict(helper_names=helper_names,declarations=len(records),exact_source_reconstruction=True)


def patch_manifest(manifest, plan, targets, byte_budget=BYTE_BUDGET, token_budget=TOKEN_BUDGET):
    if not targets or len(targets)!=len(set(targets)):
        raise AdaptationError('Provide a nonempty unique explicit audited target list')
    old_nodes={n['name']:n for n in manifest['nodes']}
    if len(old_nodes)!=len(manifest['nodes']) or any(n not in old_nodes for n in targets):
        raise AdaptationError('Duplicate or missing manifest target')
    new,new_plan=copy.deepcopy(manifest),copy.deepcopy(plan)
    nodes={n['name']:n for n in new['nodes']}
    units=new_plan['units']
    artifacts,added,checks,parent_helpers,provenance_by_name={},{},[],{},{}
    for name in targets:
        parent=nodes[name]
        if parent['kind']!='definition' or parent.get('existing_binding'):
            raise AdaptationError('Cannot change an existing published binding')
        old_source=parent['payload']['definition']
        tables=discover_tables(old_source,byte_budget,token_budget)
        if not tables:
            raise AdaptationError('Target has no validated cached-list literal over budget: '+name)
        chunk_lists=[split_rows(t['rows'],byte_budget,token_budget) for t in tables]
        helpers=[]
        records=[]
        for table,chunks in zip(tables,chunk_lists):
            if len(chunks)<2:
                raise AdaptationError('Target literal cannot be reduced with these budgets')
            record=declaration_record(table,chunks)
            records.append(record)
            checks.append(dict(name=name,**record))
            first_row=0
            for rows in chunks:
                helper_name,lean_name,uid=helper_identity(rows,table['noncomputable'])
                body=helper_body(rows,table['noncomputable'])
                if helper_name in nodes:
                    helper=nodes[helper_name]
                    if helper.get('kind')!='definition' or helper.get('payload',{}).get('definition')!=body or helper.get('unit_id')!=uid:
                        raise AdaptationError('Helper identity collision')
                else:
                    if uid in units or lean_name in plan.get('declarations',{}):
                        raise AdaptationError('Helper declaration or unit collision')
                    relative='adaptations/cached-literals-v3/Definitions/Def_'+helper_name+'.lean'
                    artifacts[relative]=body
                    derived=dict(parent=name,declaration=table['name'],rows=[first_row,first_row+len(rows)],original_literal_sha256=table['literal_sha256'])
                    payload=dict(definition_name=helper_name,definition_title='Finite cached-vertex data slice '+uid.removeprefix('cached_slice_'),
                                 definition=body,env=manifest['env'],private=True,
                                 natural_language_statement=f"Exact consecutive rows {first_row+1}–{first_row+len(rows)} of {table['name']}. Ordered slices concatenate to the unchanged original cached-vertex list.",
                                 source=parent['payload']['source']+f". Exact row slice {first_row+1}-{first_row+len(rows)}; normalized original literal SHA-256 {table['literal_sha256']}.",tags=list(parent['payload'].get('tags',[])))
                    helper=dict(name=helper_name,kind='definition',unit_id=uid,payload=payload,
                                publish_dependencies=[],proof_dependencies=[],source_blocks=[],definition_file=relative,
                                definition_sha256=digest(body.encode()),metadata_status='EXACT_LITERAL_DATA_SLICE',source_derived_from=derived)
                    nodes[helper_name]=helper
                    added[helper_name]=helper
                    helpers.append(helper)
                    units[uid]=dict(kind='definition',platform_name=helper_name,primary_declaration=None,
                                    source_blocks=[],inline_source_blocks=[],publication_inline_source_blocks=[],
                                    publication_dependencies=[],proof_dependencies=[],source_modules=[],source_bytes=len(body.encode()),
                                    payload_status='SOURCE_DERIVED_LITERAL_SPLIT',source_derived_from=derived)
                first_row+=len(rows)
        body,helper_names=replace_source(old_source,tables,chunk_lists)
        if len(body.encode())>=len(old_source.encode()):
            raise AdaptationError('Changed target must be strictly shorter')
        changed=expected_changed_node(parent,body,helper_names)
        parent.clear();parent.update(changed)
        artifacts[parent['definition_file']]=body
        unit=units[parent['unit_id']]
        helper_ids={nodes[n]['unit_id'] for n in helper_names}
        for key in ('publication_dependencies','proof_dependencies'):
            unit[key]=sorted(set(unit.get(key,[]))|helper_ids)
        unit['source_bytes']=len(body.encode())
        unit['payload_status']='SOURCE_DERIVED_LITERAL_SPLIT'
        parent_helpers[name]=helpers
        provenance_by_name[name]=dict(shape='exact-cached-literal-split-v1',old_source_sha256=digest(old_source.encode()),
                                     new_source_sha256=digest(body.encode()),byte_budget=byte_budget,token_budget=token_budget,declarations=records)
    new['nodes']=[item for node in new['nodes'] for item in parent_helpers.get(node['name'],[])+[node]]
    new_plan['publication_topological_order']=topological_order(units)
    untouched=set(old_nodes)-set(targets)
    if any(canonical(old_nodes[n])!=canonical(nodes[n]) for n in untouched):
        raise AdaptationError('An unrelated node changed')
    for name in targets:
        verify_adaptation(old_nodes[name],nodes[name],nodes,provenance_by_name[name])
    if any(len(s.encode())>1048576 for s in artifacts.values()):
        raise AdaptationError('An adaptation artifact exceeds scanner byte limit')
    report=dict(reason='Split audited cached-vertex literal definitions into exact bounded row slices after confirmed family compilation timeouts',
                schema='p2m-cached-literal-adaptation-v3',byte_budget=byte_budget,token_budget=token_budget,
                changed_nodes=[dict(name=n,reason='Exact cached literal split for compilation budget',
                                    old_source_bytes=len(old_nodes[n]['payload']['definition'].encode()),new_source_bytes=len(nodes[n]['payload']['definition'].encode()),
                                    old_node_sha256=digest(canonical(old_nodes[n])),new_node_sha256=digest(canonical(nodes[n])),
                                    adaptation_provenance=provenance_by_name[n]) for n in sorted(targets)],
                added_nodes=list(added),unchanged_node_count=len(untouched),unchanged_nodes_identical=True,original_source_files_modified=0,
                proof_data_checks=checks,dependency_graph_acyclic=True,
                artifacts={p:dict(bytes=len(s.encode()),sha256=digest(s.encode())) for p,s in artifacts.items()})
    new['export_adaptations']=list(new.get('export_adaptations',[]))+[{k:v for k,v in report.items() if k!='artifacts'}]
    new['ready_for_upload']=False
    new['preparation_validation']='CACHED_LITERAL_ADAPTATION_REQUIRES_MANIFEST_REVALIDATION'
    new_plan['export_adaptations']=list(new_plan.get('export_adaptations',[]))+[report]
    new_plan['summary']['platform_units']=len(units)
    new_plan['summary']['unit_kinds']['definition']+=len(added)
    return new,new_plan,artifacts,report

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for flag in ('manifest','plan','targets','output-manifest','output-plan','changes'):
        parser.add_argument('--'+flag, type=Path, required=True)
    args = parser.parse_args()
    inputs = {args.manifest.resolve(),args.plan.resolve(),args.targets.resolve()}
    outputs = [args.output_manifest.resolve(),args.output_plan.resolve(),args.changes.resolve()]
    if inputs & set(outputs) or len(set(outputs)) != len(outputs):
        raise AdaptationError('Inputs are immutable and outputs must be distinct')
    if args.manifest.parent.resolve() != args.output_manifest.parent.resolve():
        raise AdaptationError('New manifest must share original artifact base directory')
    old_manifest, old_plan = args.manifest.read_bytes(), args.plan.read_bytes()
    new, plan, artifacts, report = patch_manifest(json.loads(old_manifest),json.loads(old_plan),json.loads(args.targets.read_text()))
    for relative, body in artifacts.items():
        path = args.manifest.parent/relative
        if path.exists() and path.read_text() != body:
            raise AdaptationError('Conflicting existing adaptation artifact: '+str(path))
        path.parent.mkdir(parents=True,exist_ok=True)
        path.write_text(body)
    atomic_json(args.output_manifest,new)
    atomic_json(args.output_plan,plan)
    report.update(old_manifest_sha256=digest(old_manifest),new_manifest_sha256=digest(args.output_manifest.read_bytes()),
                  old_plan_sha256=digest(old_plan),new_plan_sha256=digest(args.output_plan.read_bytes()))
    atomic_json(args.changes,report)
    print(json.dumps(dict(changed_nodes=len(report['changed_nodes']),added_nodes=len(report['added_nodes']),
                          unchanged_node_count=report['unchanged_node_count'],dependency_graph_acyclic=True,
                          max_new_artifact_bytes=max(x['bytes'] for x in report['artifacts'].values()))),flush=True)

if __name__ == '__main__':
    main()
