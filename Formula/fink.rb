class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.49.2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.49.2/fink-0.49.2-aarch64-apple-darwin.tar.gz"
      sha256 "f9257dca484432f10c6a18d8fcbe322c0476597a9714e4066d8790a688b3d569"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.49.2/fink-0.49.2-x86_64-apple-darwin.tar.gz"
      sha256 "0f5dee15a7ad1383bfb0a349b34ef1e6edebc3b4b3585719728bc62e766e4fd8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.49.2/fink-0.49.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8bceaed3beddbe16bd05987d7a19303f9c660de40981df1b0b0645e4e2efbe05"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.49.2/fink-0.49.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7cc3abfeb28b070482e7ec49e6c7e2d90c62e5ec758c03c8724bf1072942074f"
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
