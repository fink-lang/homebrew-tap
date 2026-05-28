class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.78.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.78.0/fink-0.78.0-aarch64-apple-darwin.tar.gz"
      sha256 "2581f31ed0f4a08cd882ba84277408942405a1cd2c3fd439870b6703dc57a18c"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.78.0/fink-0.78.0-x86_64-apple-darwin.tar.gz"
      sha256 "b9a1ec85684d8a3bae24815e987d4bf06057067d8eb43777832f463131df5c19"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.78.0/fink-0.78.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "92bcc5054cf8167ac1091b4d421e0d5ecb6db2e3b2d0b52b4ced1bdc09d71155"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.78.0/fink-0.78.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "75c81b0437bfdd8bcbe23f7c7fdefaefc92e0a917a3e03bddddc2531f280dd5f"
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
