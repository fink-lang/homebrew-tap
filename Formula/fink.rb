class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.62.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.62.0/fink-0.62.0-aarch64-apple-darwin.tar.gz"
      sha256 "2d779d7533db66bff3b8e3f278a3df417e7c9df30691ffab80c92667e4dadd36"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.62.0/fink-0.62.0-x86_64-apple-darwin.tar.gz"
      sha256 "f0689004145d42b4f36aa446c639d2f1911b5db20d5bf3d442e1875f8c7101b6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.62.0/fink-0.62.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dc8dac45c8b87765507abdec710363b371c9991c5058971916fda9392ca366d3"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.62.0/fink-0.62.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b105920d073348cc3aa11e359463a238f6049e198643f4c1b88cc61cda389596"
    end
  end

  def install
    # The tarball layout is:
    #   fink                          — compiler driver
    #   targets/<triple>/finkrt       — per-target runtimes (host + cross-targets)
    #
    # `find_finkrt` locates runtimes relative to the `fink` binary's own
    # directory (see src/compile/mod.rs), so the `fink` binary and the
    # `targets/` tree must stay siblings. We install both into libexec and
    # expose `fink` on PATH via a symlink in bin — `std::env::current_exe`
    # resolves symlinks on both macOS and Linux, so runtime discovery still
    # lands in libexec.
    libexec.install "fink", "targets"
    bin.install_symlink libexec/"fink"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fink --version")
  end
end
