class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.66.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.66.1/fink-0.66.1-aarch64-apple-darwin.tar.gz"
      sha256 "504221205dccc32bc523dfb971abe8fd7b8f25b7bf2740799eb646fc0ef6c28e"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.66.1/fink-0.66.1-x86_64-apple-darwin.tar.gz"
      sha256 "262b7d4b8816bd444e3e50c128f80224f5bedfaa247007815ff219bf931cec8a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.66.1/fink-0.66.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8c60312e8851c1bfb48e46e0af37a25ed726b0f5426ead8ac0e386df228ffe78"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.66.1/fink-0.66.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4c51f613e144c750e336c0c935b8117e6e8363bb6ebea12bdaf79f502aca4e3f"
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
