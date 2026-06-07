class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.83.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.83.0/fink-0.83.0-aarch64-apple-darwin.tar.gz"
      sha256 "325129b77791f4cfd5c2c8109f49876eddbd7b2014df7968d7f6982de9630929"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.83.0/fink-0.83.0-x86_64-apple-darwin.tar.gz"
      sha256 "5a07f673117ce90dda343f066a8c090e745bdf1bd74520dfb38c20129d44d690"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.83.0/fink-0.83.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "55b73f064106437de3faad1bd923b0713f7a8871cda725d2927b1b99c5539ca2"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.83.0/fink-0.83.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f807d95c9add2510d4741122bb90d2e411ca97efcd68bb9b5ff42fac2f6d88a5"
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
