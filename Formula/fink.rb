class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.64.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.64.0/fink-0.64.0-aarch64-apple-darwin.tar.gz"
      sha256 "d5798da0601269aa60a7d69370ac043af551c0c0748495d41203b11cc3f25adb"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.64.0/fink-0.64.0-x86_64-apple-darwin.tar.gz"
      sha256 "6b1606e4cabb6414360f2b7b97e14b2d9aec3c38f324ea770d7a09f07d11892d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.64.0/fink-0.64.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "05fd289139be94661213b2bc6babdcfcdf90934a5ccfd33ecf49fba8f9eea97e"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.64.0/fink-0.64.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "55fd3e1f661ce620f63d2e78a902e2833eac14cf2c262537fbd1f116a929bea1"
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
