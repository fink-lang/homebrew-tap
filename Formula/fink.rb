class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.61.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.61.0/fink-0.61.0-aarch64-apple-darwin.tar.gz"
      sha256 "673adc2eaec3cd83c2a982878a181f067f5cce75e195b1b04a7e4ca23a1ed62f"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.61.0/fink-0.61.0-x86_64-apple-darwin.tar.gz"
      sha256 "89e9d0b8c7a6c6d02e0784f888f04dea26ba73bc53eb472880909eaeb65273f4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.61.0/fink-0.61.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6d07d72a65998d93655058156dcba3839a1f263fd0a52d38879579050435be80"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.61.0/fink-0.61.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "63606e541d07a098a7be7584c8807b20fbedf93cc7555bdda70d6e38bf550989"
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
