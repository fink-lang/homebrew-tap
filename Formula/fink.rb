class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.54.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.54.0/fink-0.54.0-aarch64-apple-darwin.tar.gz"
      sha256 "bda2d1cf768e07a4a4a09ab5e741199c6e07392cdddcc6cadcb0ea119bd802fd"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.54.0/fink-0.54.0-x86_64-apple-darwin.tar.gz"
      sha256 "fe7bd28df0d9cdb9825964dceb23e87f281d84c0ea13a7f46671b89ab1312b0f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.54.0/fink-0.54.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b1569956d3fd1c8ef8ec9eb87f40badbabe9e165d512a41945b3f226a14f5a34"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.54.0/fink-0.54.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cfa35afb2e1a3dd39b049f7e2b8fdff788f5311439f83517850051c8044cd22a"
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
