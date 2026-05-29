class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.79.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.79.0/fink-0.79.0-aarch64-apple-darwin.tar.gz"
      sha256 "2d3b11aa6babc7f55760bfa6ca73b744d29a951284321c21df0c642f19d4e674"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.79.0/fink-0.79.0-x86_64-apple-darwin.tar.gz"
      sha256 "d0cfb035641a60cdc716672594eaf857aa076c31c8bf865d5176e58a7171a790"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.79.0/fink-0.79.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "89a32ccb113610a4540430d013f73b56f10656e597014f744d0b23225cc8f129"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.79.0/fink-0.79.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4918f078fb322810485ff687aec5bbd759076ebd24b16aa8eba6d9ef4d836a7f"
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
