class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.53.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.53.1/fink-0.53.1-aarch64-apple-darwin.tar.gz"
      sha256 "8f34d3307a7a875566c0d1c5360ebb6911cb33349a8876c66c9458b371eebbc3"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.53.1/fink-0.53.1-x86_64-apple-darwin.tar.gz"
      sha256 "3f4775273862b1d88c3e8875d33029c812a3a1e5f9782cc2f79eea1782c62feb"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.53.1/fink-0.53.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c655343f2c546ab707a678ee9d88476034ce31a398877935985cd02ec838ad30"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.53.1/fink-0.53.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "938f028083ff0417ee26421ab7714806bb25c2be14bb79d6bc12c8dea8d196d1"
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
