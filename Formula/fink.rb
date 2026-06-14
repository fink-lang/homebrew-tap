class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.86.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.86.1/fink-0.86.1-aarch64-apple-darwin.tar.gz"
      sha256 "5e804a1efe1bfeed9d8f85a3ebd0205a5002f8455a6742ac68c871ba32f73ac1"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.86.1/fink-0.86.1-x86_64-apple-darwin.tar.gz"
      sha256 "5898cbf2d0bcefcfd8240f12df196cdd717406be957c5f629b4c93022c3bd271"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.86.1/fink-0.86.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "899567571c329890e672fe671b57351761a64ea31a19f44653e2d45c5748e7bc"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.86.1/fink-0.86.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "050e662bfcdce035dc1c18d6f01db0565a120b9f24b18a10029ec3dced73ff7d"
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
