class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.53.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.53.0/fink-0.53.0-aarch64-apple-darwin.tar.gz"
      sha256 "faa2f2fdd95ecf7c87550ff5e9f39597f7d749e1748bbbf9c801ff730687a925"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.53.0/fink-0.53.0-x86_64-apple-darwin.tar.gz"
      sha256 "2b93a52c124a345beaab9c65c525347079cb5cdf36313b74d458d9f16879e983"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.53.0/fink-0.53.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0dc2eda3c2093ed422d0040c81d5d0b1443707a7ee8895b1a768918ccd053852"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.53.0/fink-0.53.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f4b55a5d8cefd70dc698ba31bb3b8ddf4e95f60b313d4316eff905202672ce01"
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
