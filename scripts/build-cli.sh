#!/bin/sh -e
# Builds libsquoosh, then packs the CLI with libsquoosh bundled inside it.
# Output: dist/tecarta-squoosh-cli-<version>.tgz, installable with
#   npm i -g dist/tecarta-squoosh-cli-<version>.tgz
# No npm registry account is needed; the tarball is self-contained.
cd "$(dirname "$0")/.."
rm -rf dist && mkdir -p dist

echo "==> libsquoosh: install, build, pack"
( cd libsquoosh && npm ci --no-audit --no-fund && npm run build && npm pack --pack-destination ../dist )

echo "==> cli: install deps (libsquoosh from the local tarball), pack with it bundled"
( cd cli && rm -rf node_modules \
  && npm install --no-save --no-audit --no-fund ../dist/tecarta-libsquoosh-*.tgz \
  && npm pack --pack-destination ../dist )

echo "==> done"
ls -l dist
