class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.75.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.75.0/fink-0.75.0-aarch64-apple-darwin.tar.gz"
      sha256 "f1dc84aa832af4553aed6d58d717a6d3a4ae9332f6ff6e00ef1e1fd5bc4bf832"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.75.0/fink-0.75.0-x86_64-apple-darwin.tar.gz"
      sha256 "7d8b86a1bd7bf21b8f550363af1fb6f31476813a88dec4440bb1a9e8d3b305f5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.75.0/fink-0.75.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3ac13f25fe961535174123c42f06d4962112b76b4aecb5a98acf31811525c550"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.75.0/fink-0.75.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6f43481248afc85b24be6725a4a86ff0e6621cdea42ebb19053db666883710be"
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
