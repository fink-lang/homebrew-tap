class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.56.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.56.0/fink-0.56.0-aarch64-apple-darwin.tar.gz"
      sha256 "48e569c30f80d1132d9a100f1662fc0bc1503be26b78c9efee68894ecb706b48"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.56.0/fink-0.56.0-x86_64-apple-darwin.tar.gz"
      sha256 "1a09fed3f660f6c397c7d31c741ece605b8b3ed4bf9927b235aaec5d7a622647"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.56.0/fink-0.56.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "05e97fe0743470f488783353133ae63bba384343cd33fd5332d2dda243b721b3"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.56.0/fink-0.56.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b7eb565c5d7156ba9f4db3d87cf11575e6dac0b32007adc5ac24b214af6c89eb"
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
