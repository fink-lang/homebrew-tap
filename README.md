# fink-lang/homebrew-tap

Homebrew tap for the [ƒink](https://github.com/fink-lang/fink) compiler toolchain.

## Usage

```sh
brew tap fink-lang/tap
brew install fink
```

Or in one step:

```sh
brew install fink-lang/tap/fink
```

## Available formulae

- **fink** — the ƒink compiler (`fink`) bundled with cross-target `finkrt` runtimes for
  `aarch64-apple-darwin`, `x86_64-apple-darwin`, `aarch64-unknown-linux-gnu`, and
  `x86_64-unknown-linux-gnu`. Supported on macOS (Apple Silicon and Intel) and
  Linux (aarch64 and x86_64) via [Linuxbrew](https://docs.brew.sh/Homebrew-on-Linux).

## Releases

Formulae in this tap track releases of [fink-lang/fink](https://github.com/fink-lang/fink).
See the [releases page](https://github.com/fink-lang/fink/releases) for changelogs.

Version bumps are automated: when `fink-lang/fink` publishes a new release,
its release workflow fires a `repository_dispatch` event at this repo
(authenticated via the `fink-release-bot` GitHub App) and the
[`Bump fink formula`](.github/workflows/bump-fink.yml) workflow opens a PR
with the new version and SHA256s. The PR is reviewed and merged manually.

## License

[MIT](LICENSE) © fink-lang
