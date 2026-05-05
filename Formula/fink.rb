class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.67.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.67.0/fink-0.67.0-aarch64-apple-darwin.tar.gz"
      sha256 "640ec04c9ef52e2f0e74f3c4f6a5a8e0a68883d849d7a0dc15374c8eadf45adb"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.67.0/fink-0.67.0-x86_64-apple-darwin.tar.gz"
      sha256 "385e76907546103ff29e5855805a70f3d0c5b2ed7db3615bb3b3243d0af53129"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.67.0/fink-0.67.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6e446dfa33c6767533605b9775bdf5fc2227b2fdaa18b6a0e980cf508f7e01d9"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.67.0/fink-0.67.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "28c4ef50f1fb65f77f2eafe3bc87f56d0a6df53e51765b15c8e15713d5a03be4"
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
