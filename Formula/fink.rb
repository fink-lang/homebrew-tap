class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.59.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.59.0/fink-0.59.0-aarch64-apple-darwin.tar.gz"
      sha256 "1ca47e3982f9ca2c9807d66799e31279779451d86464c3c0e2cb0d0ad249166d"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.59.0/fink-0.59.0-x86_64-apple-darwin.tar.gz"
      sha256 "54dc0009f5229e466997ac5da8fb3f419a605beb670df30dd94812fd728f2d9a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.59.0/fink-0.59.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6a32defccaeb7283e2cc0fe54939b94f66f80b28c7f77764f9f27cff011b98ee"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.59.0/fink-0.59.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0092d0fb5255b8ecb28ca495b148ed60b10cb6e0082467c8613b5350199eebf0"
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
