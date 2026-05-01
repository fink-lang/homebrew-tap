class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.65.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.65.0/fink-0.65.0-aarch64-apple-darwin.tar.gz"
      sha256 "d16c5433e40b13e485ceec4b6a8932bcf86738d692c6d1db7a55cef792d63685"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.65.0/fink-0.65.0-x86_64-apple-darwin.tar.gz"
      sha256 "14864dcddb3cd2a99eb341fee4425d5c58fe5ec7a138fa925e7ec107dafca257"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.65.0/fink-0.65.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ca880462af6d32c0ecb74997d83e3120fdbc0f99bd5de746fe1d68414f24d7e7"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.65.0/fink-0.65.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c85159b4182144647fe2fcedbd4d6fbbe708e90a1b2c7f4cccbce6bfef2804bf"
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
