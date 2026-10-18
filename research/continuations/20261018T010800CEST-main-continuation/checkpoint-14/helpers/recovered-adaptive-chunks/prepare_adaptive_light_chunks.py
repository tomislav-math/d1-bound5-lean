#!/usr/bin/env python3
"""Optional adaptive full-tail chunk delta for frozen light converter 67e224.
Default writes a dry manifest only. --emit writes only new/replacement SMALL
proof modules to a fresh directory. Original data and scaffold are referenced,
never copied or edited. This script does not run Lean or change a build queue.
"""
import argparse, ast, hashlib, json, os, re, stat, sys
from pathlib import Path

CONVERTER = '67e22402774fe51120cd22ac20826b4bd3f1c44a8bb5c401465f023c3f220dde'
HELPERS = {
    'PairLightArithmeticChunks.lean': 'f6567fcbc7792894e8607b67148594c393fe089550470cc632f4beffbdcfaca7',
    'PairLightArithmeticChunkProofs.lean': '658b9d78aa5789e1a26cdcfc58f5960c552bb3ae7fdeda34961f362a081828a4',
}
sha = lambda b: hashlib.sha256(b).hexdigest()
OPTIONS = 'set_option maxRecDepth 100000\nset_option maxHeartbeats 0\n\n'

def need(ok, message):
    if not ok:
        raise ValueError(message)

def regular(path):
    path = Path(os.path.abspath(path))
    need(all(not p.is_symlink() for p in [path, *path.parents]), 'symlink source')
    before = path.stat()
    need(stat.S_ISREG(before.st_mode), 'nonregular source')
    data = path.read_bytes()
    after = path.stat()
    stamp = lambda s: (s.st_dev, s.st_ino, s.st_size, s.st_mtime_ns, s.st_ctime_ns)
    need(stamp(before) == stamp(after) and len(data) == after.st_size, 'source changed during read')
    return data

def chunks(n, budget):
    need(n >= 0 and budget > 0, 'invalid size or pair budget')
    need(n <= budget + 1, 'one head exceeds budget; a separate within-row checker would be required')
    out, start = [], 0
    while start < n:
        end, pairs = start, 0
        while end < n and pairs + n - 1 - end <= budget:
            pairs += n - 1 - end
            end += 1
        need(end > start, 'empty nonterminal chunk')
        out.append(dict(start=start, end=end, heads=end-start, pairs=pairs))
        start = end
    need(sum(c['heads'] for c in out) == n, 'head partition')
    need(sum(c['pairs'] for c in out) == n*(n-1)//2, 'pair partition')
    need(all(c['pairs'] <= budget for c in out), 'pair budget exceeded')
    return out

def literal_length(source, name):
    matches = re.findall(rf'^def {name}\b.*? := (\[.*?\n\])', source, re.M | re.S)
    need(len(matches) == 1, 'missing or repeated literal ' + name)
    tree = ast.parse(matches[0], mode='eval').body
    need(isinstance(tree, ast.List), 'not a literal list ' + name)
    return len(tree.elts)

def header(source, name):
    found = re.findall(rf'^(theorem {name}\b.*? :=)', source, re.M | re.S)
    need(len(found) == 1, 'missing or repeated theorem ' + name)
    return found[0]

def namespace_start(k):
    return f'namespace D1Bound5.PairLightAdaptivePrepared{k}\n' + OPTIONS

def namespace_end(k):
    return f'\nend D1Bound5.PairLightAdaptivePrepared{k}\n'

def render_row(k, report, inputs, budget):
    tau, nu = report['tau'], report['nu']
    need(type(tau) is int and type(nu) is int, 'invalid model parameters')
    oldns, ns = f'PairLightPrepared{k}', f'PairLightAdaptivePrepared{k}'
    data_name = f'D1Bound5/SmallPairLightData{k}.lean'
    data = inputs[data_name]
    need(re.findall(r'^import (.+)$', data, re.M) == ['D1Bound5.PairLightArithmetic'], 'pure data imports changed')
    plans = {}
    for side, cls in zip(('left', 'right'), report['classes']):
        n = cls['vertices']
        need(type(n) is int and n >= 0, 'invalid class size')
        need(cls['pairs'] == n*(n-1)//2, 'class pair count')
        need(all(literal_length(data, side+suffix) == n for suffix in ('Vertices', 'Cached', 'Rows')), 'data length mismatch')
        plans[side] = chunks(n, budget)
    need(len(report['classes']) == 2, 'expected exactly two color classes')

    output = {}
    common_name = f'D1Bound5/SmallPairLightAdaptiveData{k}.lean'
    common = f'import D1Bound5.SmallPairLightData{k}\nimport D1Bound5.PairLightArithmeticChunks\n\n' + namespace_start(k)
    for side in ('left', 'right'):
        common += f'def {side}Cached000 : List PairLightCachedVertex := {oldns}.{side}Cached\n'
        common += f'def {side}Rows000 : List (Nat × List Nat) := {oldns}.{side}Rows\n\n'
        for j, cut in enumerate(plans[side]):
            common += f'def {side}Cached{j+1:03} : List PairLightCachedVertex := {side}Cached{j:03}.drop {cut["heads"]}\n'
            common += f'def {side}Rows{j+1:03} : List (Nat × List Nat) := {side}Rows{j:03}.drop {cut["heads"]}\n\n'
    output[common_name] = common + namespace_end(k)

    validation_name = f'D1Bound5/SmallPairLightAdaptiveValidation{k}.lean'
    validation = f'import D1Bound5.SmallPairLightAdaptiveData{k}\n\n' + namespace_start(k)
    for side in ('left', 'right'):
        validation += f'''theorem {side}_coverage_checked :
    decide ({oldns}.{side}Cached.map Prod.fst = {oldns}.{side}Vertices) = true := by
  decide +kernel

theorem {side}_signatures_checked :
    ({oldns}.{side}Cached.all fun x =>
      decide (x.2 = pairLightCoordinateSignature {oldns}.sieve x.1)) = true := by
  decide +kernel

'''
    output[validation_name] = validation + namespace_end(k)

    replacements = []
    for side in ('left', 'right'):
        capital = side.capitalize()
        names = []
        for j, cut in enumerate(plans[side]):
            stem = f'SmallPairLightAdaptive{capital}{k}_{j:03}'
            names.append(stem)
            output[f'D1Bound5/{stem}.lean'] = (
                f'import D1Bound5.SmallPairLightAdaptiveData{k}\n\n' + namespace_start(k) +
                f'/-- Heads {cut["start"]} through {cut["end"]-1}; every head retains its entire tail. -/\n'
                f'theorem {side}_prefix_{j:03}_checked :\n'
                f'    pairLightSelectedFloorPrefixBool {tau} {nu} {oldns}.sieve {cut["heads"]}\n'
                f'      {side}Cached{j:03} {side}Rows{j:03} = true := by\n'
                '  decide +kernel\n' + namespace_end(k))
        side_name = f'D1Bound5/SmallPairLight{capital}{k}.lean'
        old = inputs[side_name]
        public = [f'{side}_{s}_checked' for s in ('coverage', 'signatures', 'independent', 'certificate')]
        need(re.findall(r'^theorem (\w+)', old, re.M) == public, 'old side declarations changed')
        need(re.findall(r'^import (.+)$', old, re.M) == [f'D1Bound5.SmallPairLightData{k}'], 'old side imports changed')
        heads = {name: header(old, name) for name in public}
        code = ('import D1Bound5.PairLightArithmeticChunkProofs\n'
                f'import D1Bound5.SmallPairLightAdaptiveValidation{k}\n')
        code += ''.join(f'import D1Bound5.{name}\n' for name in names)
        code += f'\nnamespace D1Bound5.{oldns}\n' + OPTIONS
        code += heads[public[0]] + f'\n  {ns}.{side}_coverage_checked\n\n'
        code += heads[public[1]] + f'\n  {ns}.{side}_signatures_checked\n\n'
        code += heads[public[2]] + ' by\n'
        last = len(plans[side])
        code += (f'  have h{last:03} : pairLightSelectedFloorIndependentBool {tau} {nu} sieve\n'
                 f'      {ns}.{side}Cached{last:03} {ns}.{side}Rows{last:03} = true := by\n'
                 '    rfl\n')
        for j in reversed(range(last)):
            width = plans[side][j]['heads']
            code += (f'  have h{j:03} : pairLightSelectedFloorIndependentBool {tau} {nu} sieve\n'
                     f'      {ns}.{side}Cached{j:03} {ns}.{side}Rows{j:03} = true :=\n'
                     f'    pairLightSelectedFloorIndependentBool_of_prefix_drop {tau} {nu} sieve {width}\n'
                     f'      {ns}.{side}Cached{j:03} {ns}.{side}Rows{j:03}\n'
                     f'      {ns}.{side}_prefix_{j:03}_checked h{j+1:03}\n')
        code += '  exact h000\n\n'
        code += heads[public[3]] + f''' by
  unfold pairLightSelectedFloorIndependentCertificateBool
  exact Bool.and_eq_true_iff.mpr ⟨{side}_coverage_checked,
    Bool.and_eq_true_iff.mpr ⟨{side}_signatures_checked, {side}_independent_checked⟩⟩

end D1Bound5.{oldns}
'''
        need(all(header(code, name) == heads[name] for name in public), 'public theorem type changed')
        output[side_name] = code
        replacements.append(side_name)

    # No original data, raw input, four-equality assembly, triangle, or graph
    # endpoint is emitted by this delta; they remain exact existing dependencies.
    need(set(output) & set(inputs) == set(replacements), 'unexpected original source replacement')
    pure = set(output) - set(replacements)
    for name in pure:
        need(all(i in ('D1Bound5.PairLightArithmeticChunks', f'D1Bound5.SmallPairLightData{k}',
                       f'D1Bound5.SmallPairLightAdaptiveData{k}')
                 for i in re.findall(r'^import (.+)$', output[name], re.M)), 'heavy import in computation')
    return output, dict(row=k, tau=tau, nu=nu, plans=plans, replacement_sources=replacements,
        unchanged_assembly=f'D1Bound5/SmallPairLightAssembly{k}.lean',
        original_four_side_types_preserved=True, full_coverage_and_signatures_retained=True,
        all_cross_cut_pairs_preserved=True, copied_coordinate_signature_or_word_records=0)

def main():
    if hasattr(sys, 'set_int_max_str_digits'):
        sys.set_int_max_str_digits(0)
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--input-dir', type=Path, required=True)
    ap.add_argument('--input-manifest-sha', required=True)
    ap.add_argument('--helper-dir', type=Path, required=True)
    ap.add_argument('--rows', required=True, help='Explicit comma-separated nonstructural rows; no default rollout')
    ap.add_argument('--pair-budget', type=int, default=8000)
    ap.add_argument('--output-dir', type=Path, required=True)
    ap.add_argument('--emit', action='store_true')
    ap.add_argument('--expected-manifest', type=Path)
    a = ap.parse_args()
    need(re.fullmatch('[0-9a-f]{64}', a.input_manifest_sha), 'invalid manifest pin')
    mb = regular(a.input_dir/'manifest.json')
    need(sha(mb) == a.input_manifest_sha, 'input manifest SHA mismatch')
    manifest = json.loads(mb)
    need(manifest['generator_sha256'] == CONVERTER, 'not frozen light converter67 output')
    for name, pin in HELPERS.items():
        need(sha(regular(a.helper_dir/name)) == pin, 'chunk helper SHA mismatch')
    selected = [int(x) for x in a.rows.split(',')]
    need(selected and len(selected) == len(set(selected)) and set(selected) <= set(range(1,49)), 'invalid row selection')
    need(a.pair_budget > 0, 'nonpositive pair budget')
    reports = {r['row']: r for r in manifest['results']}
    need(set(selected) <= set(manifest['staged_rows']), 'requested source was not staged')
    out = Path(os.path.abspath(a.output_dir))
    need(not os.path.lexists(out), 'output already exists')
    need(out.parent.is_dir() and all(not p.is_symlink() for p in [out.parent,*out.parent.parents]), 'invalid output parent')
    pending, row_reports, reference = {}, [], {}
    for k in sorted(selected):
        report = reports[k]
        need(not report['structural'], 'structural rows retain their dedicated backend')
        inputs = {}
        for name, metadata in report['files'].items():
            p = Path(name)
            need(not p.is_absolute() and '..' not in p.parts and p.parts[0] == 'D1Bound5', 'unsafe source name')
            raw = regular(a.input_dir/p)
            need(len(raw) == metadata['bytes'] and sha(raw) == metadata['sha256'], 'input source mismatch ' + name)
            inputs[name] = raw.decode()
            reference[name] = metadata
        rendered, facts = render_row(k, report, inputs, a.pair_budget)
        need(not (set(pending) & set(rendered)), 'duplicate generated module')
        pending.update(rendered)
        row_reports.append(facts)
    result = dict(status='Optional uncompiled adaptive proof delta; no timing or theorem acceptance claim',
        generator_sha256=sha(regular(__file__)), input_manifest_sha256=sha(mb),
        input_converter_sha256=CONVERTER, helper_sha256=HELPERS, rows=sorted(selected),
        pair_budget=a.pair_budget, results=row_reports, referenced_original_sources=reference,
        existing_data_and_four_equality_assemblies_not_emitted=True,
        files={name:dict(sha256=sha(text.encode()),bytes=len(text.encode())) for name,text in sorted(pending.items())})
    if a.expected_manifest:
        need(result == json.loads(regular(a.expected_manifest)), 'exact replay mismatch')
    out.mkdir(mode=0o700)
    if a.emit:
        (out/'D1Bound5').mkdir(mode=0o700)
        for name, source in sorted(pending.items()):
            with (out/name).open('xb') as f:
                f.write(source.encode())
    with (out/'manifest.json').open('x') as f:
        json.dump(result,f,indent=2)
        f.write('\n')
    print(json.dumps(dict(emitted=a.emit, rows=sorted(selected), files=len(pending),
        manifest_sha256=sha(regular(out/'manifest.json'))),indent=2))

if __name__ == '__main__':
    main()
