# Local compiler acquisition probe — 2026-10-18

Result: no verified acquisition path under the tested local/network capabilities.
No toolchain or package was installed, no large file was downloaded, and the Mac
was only read. The single local network probe failed before an HTTP response;
this is a connectivity observation, not proof that the release is unavailable.

## Local executable/cache inspection

The container is Linux x86_64. `lean`, `elan`, and `lake` were absent from PATH;
`curl`, `wget`, Python3, Git, tar, and zstd were present. `/root/.elan` and
`/root/.cache/mathlib` did not exist. No Lean-related executable appeared in
`/usr/local/bin`. No local `lean-toolchain` or `lake-manifest.json` was found in
the current project scratch tree. This was a narrow inspection, not a claim
about every file on the host.

## Exact official release

The approved GitHub connector successfully returned official metadata from
https://api.github.com/repos/leanprover/lean4/releases/tags/v4.33.1 .

- Release: v4.33.1, published 2026-08-21, not prerelease.
- Asset: `lean-4.33.1-linux.tar.zst`, 570,405,234 bytes.
- Asset SHA256:
  `890afd185370f85666025b883914ab4f4b339136f8c96167b69cfb62aecaf235`.
- Official URL:
  https://github.com/leanprover/lean4/releases/download/v4.33.1/lean-4.33.1-linux.tar.zst .

One ordinary local probe was attempted:

```
curl --head --location --max-time 15 --connect-timeout 5 --silent --show-error https://github.com/leanprover/lean4/releases/download/v4.33.1/lean-4.33.1-linux.tar.zst
```

It exited 28 with `Proxy CONNECT aborted due to timeout`; no HTTP headers or
archive bytes were received. No alternative mirror, rewritten domain, proxy
configuration, credential change, or network-restriction workaround was tried.

The GitHub connector's documented `fetch` capability accepts UTF-8 repository
resources but explicitly rejects oversized/non-UTF-8 responses and does not
support binary downloads. Therefore its successful metadata lookup does not
supply the Linux toolchain archive.

## Exact pinned dependencies, read from the existing Mac project

Both project and mathlib `lean-toolchain` files say `leanprover/lean4:v4.33.1`.
The root `lake-manifest.json` supplies these exact revisions:

| Package | Revision |
| --- | --- |
| mathlib | `0df444a360eaa60ab8c11dca51a86af692955474` |
| plausible | `b7eb3304aeae834b12dda98993a37f6a41f6f0bb` |
| LeanSearchClient | `5f4d51b81cbd3f6b32b156bfad9056621a040404` |
| importGraph | `16f02aa7642864af59f1ff0e384a015994db9118` |
| proofwidgets | `4be2e3d5087eeb272cf5a8853b8f9dd025ef5957` |
| aesop | `3448c0bcc5ce01b2d1546e483ec3620e32df3d0e` |
| Qq | `92c15be17b7caf78c2ad767ec40f89052d908d81` |
| batteries | `4488d40d070b9700d4d5a6aa342f0d40c31b2a2d` |
| Cli | `6130a47896ce867c6a4a55373441e59e565bad0f` |

Official pinned mathlib source was readable through the GitHub connector:

- `Cache/Infra.lean` constructs cache URLs under
  `https://lakecache.blob.core.windows.net/`.
- `Cache/IO.lean` uses `leantar` bundled in the Lean sysroot and invokes curl for
  downloads. Thus source-only metadata access is insufficient for ready-to-use
  cached compiled dependencies.

These are public dependency sources only; no private project code was uploaded
or published. Local access to the mathlib binary cache was not probed, because
the toolchain acquisition already lacked a verified path and the task allowed
only a single ordinary network HEAD probe.

## Practical conclusion

Exact versioning is not the blocker: the official Linux asset and all dependency
pins are known. The missing piece is a permitted working binary transfer into
this container, followed by ordinary pinned package/cache acquisition. No local
compiler benchmark or claim of faster verification can be made from this probe.
