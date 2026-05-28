class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.78.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.78.1/fink-0.78.1-aarch64-apple-darwin.tar.gz"
      sha256 "60bd8d240632d143ffc7dffa2346061cea0529a68ceb911245d26d67f4c3ec6c"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.78.1/fink-0.78.1-x86_64-apple-darwin.tar.gz"
      sha256 "03e6d14656d83086b2112caa80546fdb30ac831d97775556787390a15c6a5930"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.78.1/fink-0.78.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "be028cb6639a55943fa07557ba98767136a1dd62d693075ba61ed239fb8e5ee5"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.78.1/fink-0.78.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e6f2c548b1a52a274ef003336ebda788a0d5d555f09080047f89fe3a72387348"
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
