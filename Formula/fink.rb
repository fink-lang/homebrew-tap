class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.72.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.72.1/fink-0.72.1-aarch64-apple-darwin.tar.gz"
      sha256 "42f62a41d9a9a4a6998952228183d6b751d61c7c9f8d45bfc6e6c3aabf8002cc"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.72.1/fink-0.72.1-x86_64-apple-darwin.tar.gz"
      sha256 "29a7d9de680570220bf9dc8aeb17097f8a0a6520bd333d63521f0949f0acc443"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.72.1/fink-0.72.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1ce5d5d6670dec47d1bc31abd32e33873d9fbc65d034d8412a1f0c23b40c8a31"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.72.1/fink-0.72.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6cef7051619476d7812aa367bd3260cde71800934a76ab3570bcc5f125481e10"
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
