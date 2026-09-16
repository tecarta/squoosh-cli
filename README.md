# Tecarta fork

This is [Tecarta](https://github.com/tecarta)'s fork of
[Frostoven's Squoosh-with-CLI](https://github.com/frostoven/Squoosh-with-CLI),
itself a fork of Google's [Squoosh](https://github.com/GoogleChromeLabs/squoosh)
that kept the CLI alive after Google removed it.

What is different here:

- **Runs on current Node (20, 22, 24 and later).** `libsquoosh` now reads each
  wasm codec from disk and hands the bytes to Emscripten directly. Previously it
  let Emscripten's loader find them, which on Node 18+ meant calling the global
  `fetch()` on a filesystem path and failing. The old workaround, launching node
  with `--no-experimental-fetch`, stopped working when Node 22 removed the flag.
- **`--jxl` works again.** libsquoosh's default JPEG XL options were from an
  older encoder build (`speed`, `nearLossless`) and lacked the `effort` field the
  bundled encoder requires, so every JXL encode failed. The CLI then logged the
  rejection but never exited. Defaults now match the encoder, and the CLI exits
  non-zero on an unhandled failure.
- **Packages renamed** to `@tecarta/squoosh-cli` and `@tecarta/libsquoosh`, and
  the child-process launcher (`prod.js` / `debug.js`) is gone; the CLI is a plain
  bin again.
- **Self-contained builds.** `scripts/build-cli.sh` produces a tarball with
  libsquoosh bundled, published as a GitHub release asset. See
  [cli/README.md](cli/README.md) for install instructions.
- **CI** builds and smoke-tests every codec on Node 20/22/24, Linux and macOS.

Only `cli/`, `libsquoosh/` and the build plumbing were touched. The web app under
`src/` is as upstream left it.

---

# Fork details

Google has removed all CLI features from their
[Squoosh](https://github.com/GoogleChromeLabs/squoosh) project.

This fork merges newer Squoosh browser features with the old removed CLI stuff.
It does not aim to strictly retain compatibility with the original project, but
does aim to preserve old CLI functionality, including the
[UI CLI command generator](https://squoosh.frostoven.com/cli/preview.png).

**Usage:**

- This fork currently runs over at https://squoosh.frostoven.com
- Installation and usage details here: https://squoosh.frostoven.com/cli

### Maintenance info

For now, the core purpose of this fork is to fix bugs in the CLI portion of the
code. The CLI portion had quite a few problems when it was retired from the
original project, many of which are now fixed in this fork.

I maintain these features and fix bugs in my spare time, and generally have my
hands full with an
[indie game I'm making](https://github.com/frostoven/Cosmosis).
Please consider
[supporting my work](https://www.patreon.com/frostoven)
to get more hands on deck; I would like to hire someone to work on this project
full-time so that it may reach its full potential.

### Change from the original

First off, I'd like to give a huge thank you to everyone who has contributed to
this fork!

Major changes:
* Fixes an issue where the original Squoosh CLI would attempt to consume all
  target images at once, causing Node to crash when dealing with data exceeding
  ~500MB (the max concurrent image limit is now automatically set to your CPU
  core count, override with `-c your_number`). This fork has been confirmed to
  work with datasets exceeding 10GB containing thousands of images.
* Fixes an issue where the CLI terminal output would corrupt when processing a
  large amount of images.
* The original CLI tool ignored almost all custom user options. This is
  (hopefully) completely fixed now.
* This fork adds Node 18+ support.

### Build info

**Important:** Always delete `.tmp` and `build` before doing a prod build, and
delete `.tmp` if you're experiencing weird bugs during development. It appears
to occasionally get corrupted by some process duplication.

This fork introduces additional pages as static HTML. I didn't have the time to
figure out how to correctly hook this up into the dev process (though it's
integrated into prod); for now, static pages can be tested in dev with
`npx http-server staticPages`.

<br>

_The original README follows below._

---

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

[squoosh]: https://squoosh.frostoven.com
