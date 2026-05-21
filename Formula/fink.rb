class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.75.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.75.1/fink-0.75.1-aarch64-apple-darwin.tar.gz"
      sha256 "d55fdfc94f9f60b513a5b9859751be7a8bcdf81ed07fe1b8accdd16b2189d144"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.75.1/fink-0.75.1-x86_64-apple-darwin.tar.gz"
      sha256 "52b75d7b63ee3b95362153c9286e7ae858ad6515fb81ecf47f1e0695b56f87c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.75.1/fink-0.75.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a95c4d59f315e4aa8059e13d55676579e0a622f608c80e2a441eb1ce3a7f3c97"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.75.1/fink-0.75.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "836ca4759c75a57f7b0422788b06626a08a64dd1da2994c8ae058a6fa5f28541"
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
