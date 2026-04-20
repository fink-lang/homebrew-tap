class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.56.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.56.1/fink-0.56.1-aarch64-apple-darwin.tar.gz"
      sha256 "b53f310ec984a453598a7eb88373da7c38d9bf6a0238a35076684fc5cbaacf94"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.56.1/fink-0.56.1-x86_64-apple-darwin.tar.gz"
      sha256 "8797d6ec72d5654add9bccf17af1de77f61676d714d23166bb680774cfb9503a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.56.1/fink-0.56.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3c6452d3671fcd09d16f6ab0e1b80f0dc5c1d8c8100b7446dd34e3779638964a"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.56.1/fink-0.56.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "0f6c02923d9791535afc6bafbe38746cfc0833502f6c07848a828d559716eef5"
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
