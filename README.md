# Squoosh CLI (Tecarta fork)

Command-line image compression with the Squoosh codecs (MozJPEG, WebP, AVIF,
JPEG XL, WebP2, OxiPNG) on current Node: 20, 22, 24 and later.

This is [Tecarta](https://github.com/tecarta)'s fork of
[Frostoven's Squoosh-with-CLI](https://github.com/frostoven/Squoosh-with-CLI),
itself a fork of Google's [Squoosh](https://github.com/GoogleChromeLabs/squoosh)
that kept the CLI alive after Google removed it in 2023. Neither upstream runs
on Node 22 or later. This one does.

## Install

```sh
npm i -g --allow-remote=all https://github.com/tecarta/squoosh-cli/releases/latest/download/tecarta-squoosh-cli.tgz
```

`--allow-remote=all` is needed on npm 12 and later, which refuse tarball URLs
by default. npm 11 and older ignore the flag. The tarball bundles
`@tecarta/libsquoosh`, so nothing else is required. Versioned tarballs are on
the [releases page](https://github.com/tecarta/squoosh-cli/releases). The
packages are not on npm, so `npx @tecarta/squoosh-cli` does not work.

## Usage

```
squoosh-cli [options] <files...>
```

```sh
# WebP and AVIF at auto-tuned quality, into ./out
squoosh-cli --webp auto --avif auto -d out photo.png

# Resize to 1600px wide, then MozJPEG at quality 75, for every JPEG here
squoosh-cli --resize '{"width":1600}' --mozjpeg '{"quality":75}' -d out *.jpg

# Lossless PNG optimisation after reducing to a 256-colour palette
squoosh-cli --quant '{"numColors":256}' --oxipng '{"level":2}' -d out icons/
```

Each codec flag takes `auto` or a JSON5 config object. The full option list,
the auto optimizer and its Butteraugli target are documented in
[cli/README.md](cli/README.md). Per-codec defaults live in
[libsquoosh/src/codecs.ts](libsquoosh/src/codecs.ts) under
`defaultEncoderOptions`.

## Build from source

Requires Node 20 or newer.

```sh
git clone https://github.com/tecarta/squoosh-cli.git
cd squoosh-cli
./scripts/build-cli.sh
npm i -g ./dist/tecarta-squoosh-cli-*.tgz
```

The script builds `libsquoosh`, packs it, installs that tarball into `cli/`,
and packs the CLI with it bundled. A bare `npm install` inside `cli/` fails by
design: it depends on `@tecarta/libsquoosh`, which is not on any registry.
Write the install path as `./dist/...`; npm reads a bare `dist/...` as a
GitHub `owner/repo` shorthand.

To cut a release: bump the versions in `cli/package.json` and
`libsquoosh/package.json`, run the build script, then

```sh
cp dist/tecarta-squoosh-cli-<version>.tgz dist/tecarta-squoosh-cli.tgz
gh release create v<version> --target main dist/*.tgz
```

The unversioned copy is what the install URL above resolves to.

## What changed in this fork

- **Runs on current Node.** `libsquoosh` now reads each wasm codec from disk
  and hands the bytes to Emscripten as `wasmBinary`. Previously it let
  Emscripten's loader find them, which on Node 18+ meant calling the global
  `fetch()` on a filesystem path and failing. Frostoven's workaround, a
  child-process launcher that started node with `--no-experimental-fetch`,
  stopped working when Node 22 removed the flag. The launcher is gone and the
  CLI is a plain bin again.
- **`--jxl` works.** The default JPEG XL options came from an older encoder
  build and lacked the `effort` field the bundled encoder requires, so every
  JXL encode failed and the CLI hung. Defaults now match the encoder.
- **Failures exit non-zero** instead of leaving idle worker threads holding the
  process open.
- **Packages renamed** to `@tecarta/squoosh-cli` and `@tecarta/libsquoosh`,
  engines set to Node 20+.
- **Self-contained tarball** via `scripts/build-cli.sh`, distributed as a
  GitHub release asset.
- **CI** builds and runs every codec on Node 20/22/24, Linux and macOS.

Codec output is byte-identical to `@frostoven/squoosh-cli` 0.9.1.

## Lineage and credits

- **Google's Squoosh** built the web app, the codecs and the original
  `@squoosh/cli`, then removed the CLI and `libsquoosh` from the project in 2023.
- **Frostoven's Squoosh-with-CLI** kept the CLI going: it fixed the CLI trying
  to load every input image at once (concurrency now defaults to your core
  count, override with `-c`), fixed terminal output corrupting on large
  batches, made custom codec options actually apply, and added Node 18 support.
  Frostoven hosts their variant of the web app at squoosh.frostoven.com.
- **This fork** adds Node 20+ support without the removed flag, the JXL fix,
  and the packaging above.

## Repository layout

- `cli/` is the CLI, `@tecarta/squoosh-cli`.
- `libsquoosh/` is the Node library that wraps the wasm codecs,
  `@tecarta/libsquoosh`.
- `codecs/` holds the codec sources and their prebuilt wasm.
- `scripts/build-cli.sh` builds both packages and produces the release tarball.
- `src/` and `staticPages/` are the Squoosh web app, untouched from upstream.
  Tecarta does not build or host it. If you work on it, Frostoven's notes
  apply: delete `.tmp` and `build` before a production build, and test the
  static pages with `npx http-server staticPages`.

---

_The original Squoosh README follows._

# [Squoosh]!

[Squoosh] is an image compression web app that reduces image sizes through numerous formats.

# Privacy

Squoosh does not send your image to a server. All image compression processes locally.

However, Squoosh utilizes Google Analytics to collect the following:

- [Basic visitor data](https://support.google.com/analytics/answer/6004245?ref_topic=2919631).
- The before and after image size value.
- If Squoosh PWA, the type of Squoosh installation.
- If Squoosh PWA, the installation time and date.

# Developing

To develop for Squoosh:

1. Clone the repository
1. To install node packages, run:
   ```sh
   npm install
   ```
1. Then build the app by running:
   ```sh
   npm run build
   ```
1. After building, start the development server by running:
   ```sh
   npm run dev
   ```

# Contributing

Squoosh is an open-source project that appreciates all community involvement. To contribute to the project, follow the [contribute guide](/CONTRIBUTING.md).

[squoosh]: https://squoosh.app
