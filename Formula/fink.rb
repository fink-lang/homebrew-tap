class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.52.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.52.0/fink-0.52.0-aarch64-apple-darwin.tar.gz"
      sha256 "8657f8114467c01cea8f1cc0a8cbbffa9068cb45b2628b224402df9a813b3b8d"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.52.0/fink-0.52.0-x86_64-apple-darwin.tar.gz"
      sha256 "6040104487e9ca05926aa492f95d0acfd4763c2d778ba48fa103f53bde207626"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.52.0/fink-0.52.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4d934ad686723404790d2979e46e39a087544923d3cf9df150626136a1796a0a"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.52.0/fink-0.52.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3f80e66100a30ea73236827cc67593d2323dada623a440643d902b0e90f75483"
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
