#!/usr/bin/env python3
"""Build old/current file engines and verify real WebRTC interoperability."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import socket
import subprocess
import tempfile
import time
import urllib.request
import urllib.error

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--legacy-ref', default='2ebc01962397c39be79c05027266f5fd6aa4dcd0', help='Local Git ref for the legacy core (default: 2.11.2)')
args = parser.parse_args()
repo = Path(__file__).resolve().parents[1]
root = Path(tempfile.mkdtemp(prefix='pasteferry-transfer-interop-'))
legacy_sha = subprocess.check_output(['git', 'rev-parse', args.legacy_ref + '^{commit}'], cwd=repo, text=True).strip()
old = root / 'old'
old.mkdir()
with (root / 'baseline.tar').open('wb') as archive:
    subprocess.run(['git', 'archive', '--format=tar', legacy_sha, 'client-core', 'proto', 'server'], cwd=repo, stdout=archive, check=True)
subprocess.run(['tar', '-xf', str(root / 'baseline.tar'), '-C', str(old)], check=True)
fixture = repo / 'client-core/internal/send/testdata/interop_peer.go'
(old / 'client-core/cmd/envcheck/main.go').write_text(fixture.read_text())
overlay = root / 'overlay.json'
overlay.write_text(json.dumps({'Replace': {str((repo / 'client-core/cmd/envcheck/main.go').resolve()): str(fixture)}}))
subprocess.run(['go', 'build', '-o', str(root / 'old-peer'), './cmd/envcheck'], cwd=old / 'client-core', check=True)
subprocess.run(['go', 'build', '-overlay', str(overlay), '-o', str(root / 'new-peer'), './cmd/envcheck'], cwd=repo / 'client-core', check=True)
print('Interoperability artifacts:', root, flush=True)

def port():
    with socket.socket() as s:
        s.bind(('127.0.0.1', 0))
        return s.getsockname()[1]

def api(addr, route, data=None):
    req = urllib.request.Request(f'http://{addr}/{route}',
        data=None if data is None else json.dumps(data).encode(),
        headers={'Content-Type': 'application/json'})
    with urllib.request.urlopen(req, timeout=5) as r:
        body = r.read()
        return json.loads(body) if body else None

def wait(fn, timeout=45):
    deadline = time.monotonic() + timeout
    last = None
    while time.monotonic() < deadline:
        try:
            last = fn()
            if last:
                return last
        except (OSError, urllib.error.URLError):
            pass
        time.sleep(.03)
    raise RuntimeError(f'Timed out: {last!r}')

def status(addr, transfer, want):
    tr = api(addr, 'status?id=' + transfer)
    if tr['Status'] in ('failed', 'declined', 'cancelled'):
        raise RuntimeError(tr)
    return tr if tr['Status'] == want else None

def verify(src, dest):
    count = size = 0
    for p in src.rglob('*'):
        target = dest / p.relative_to(src)
        if p.is_symlink():
            assert target.is_symlink() and os.readlink(p) == os.readlink(target)
        elif p.is_dir():
            assert target.is_dir(), target
        else:
            assert hashlib.sha256(p.read_bytes()).digest() == hashlib.sha256(target.read_bytes()).digest(), target
            count += 1
            size += p.stat().st_size
    return {'files': count, 'bytes': size}

addresses = [f'127.0.0.1:{port()}', f'127.0.0.1:{port()}']
processes = []
logs = []
try:
    for i, kind in enumerate(('new', 'old')):
        folder = root / f'{kind}-state'
        folder.mkdir(exist_ok=True)
        env = dict(os.environ, PF_SELF=('alice' if i == 0 else 'bob'),
            PF_PEER=('bob' if i == 0 else 'alice'), PF_LISTEN=addresses[i],
            PF_REMOTE=addresses[1-i], PF_DATA=str(folder))
        log = open(root / f'{kind}-peer.log', 'w')
        logs.append(log)
        processes.append(subprocess.Popen([str(root / f'{kind}-peer')], env=env, stdout=log, stderr=log))
    for addr in addresses:
        wait(lambda: api(addr, 'ready'))
    api(addresses[0], 'connect', {})
    for addr in addresses:
        wait(lambda: api(addr, 'ready')['ready'])
    readiness = [api(addr, 'ready') for addr in addresses]
    assert readiness[0]['parallel_remote'] is False
    assert readiness[1]['parallel_remote'] is True
    results = []
    for source, target, name in ((0, 1, 'new-to-old'), (1, 0, 'old-to-new')):
        src = root / name
        (src / '中文-emoji-📁').mkdir(parents=True, exist_ok=True)
        (src / '中文-emoji-📁' / 'data.bin').write_bytes(os.urandom(4 * 1024 * 1024 + 19))
        (src / 'empty.txt').write_bytes(b'')
        (src / '空目录').mkdir(exist_ok=True)
        link = src / 'alias'
        if not link.exists():
            link.symlink_to('中文-emoji-📁/data.bin')
        transfer = api(addresses[source], 'send', [str(src)])['id']
        wait(lambda: status(addresses[source], transfer, 'done'))
        received = wait(lambda: status(addresses[target], transfer, 'done'))
        result = verify(src, Path(received['Paths'][0]))
        result.update(direction=name, transfer=transfer, status='PASS')
        results.append(result)
    assert all(api(addr, 'ready')['stripes'] == 0 for addr in addresses)
    output = {'baseline_commit': legacy_sha,
        'capability_exchange': readiness, 'results': results,
        'legacy_protocol_used_in_both_directions': True}
    (root / 'results.json').write_text(json.dumps(output, ensure_ascii=False, indent=2))
    print(json.dumps(output, ensure_ascii=False, indent=2))
finally:
    for p in processes:
        p.terminate()
    for p in processes:
        try:
            p.wait(timeout=5)
        except subprocess.TimeoutExpired:
            p.kill()
            p.wait()
    for log in logs:
        log.close()
