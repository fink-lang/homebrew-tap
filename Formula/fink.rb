class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.80.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.80.0/fink-0.80.0-aarch64-apple-darwin.tar.gz"
      sha256 "ed941a2b46d7abe289277596c79f9ea4b2e107af48c0dc24266ae56d874c800c"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.80.0/fink-0.80.0-x86_64-apple-darwin.tar.gz"
      sha256 "5407231e045991d399a550e304f8264af5bf4d3908d2bc1986ac1a52086f32a6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.80.0/fink-0.80.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5f00bca6896500d64a2ba9cfd0094459ffe15f92536289d24f418993a755882e"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.80.0/fink-0.80.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "804f4afb7ef03e3d1ac057847d47258b8e8d71732fd8d02bafb0c480670b0f66"
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
