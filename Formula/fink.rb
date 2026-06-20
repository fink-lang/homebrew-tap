class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.87.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.87.0/fink-0.87.0-aarch64-apple-darwin.tar.gz"
      sha256 "525edbf434c84f6da94112d56bf72087c195ac297e857e46573167a2284243cf"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.87.0/fink-0.87.0-x86_64-apple-darwin.tar.gz"
      sha256 "87336f6db92e2437a5ad0e4a30582a92d967eab62e839e71cbf0cebb94659606"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.87.0/fink-0.87.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2bfe1d36ecd6ed3cd869e338b2ba54be040341a44b80764889dde328be5b8718"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.87.0/fink-0.87.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "708c2a02d2707354c50265a27745c8e42166934e9a14df9ec7f45909ce084e30"
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
