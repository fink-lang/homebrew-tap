class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.93.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.93.0/fink-0.93.0-aarch64-apple-darwin.tar.gz"
      sha256 "01a8c71af1d6148f70b3be3cd2b3df3059d7bc9165d3a062a56afae8aed641e7"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.93.0/fink-0.93.0-x86_64-apple-darwin.tar.gz"
      sha256 "554f1087c4b1113a6d4e08eaf343c44038fdeb7fb8d40222a81f1c4a1e18e909"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.93.0/fink-0.93.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d8380172a0b8df6416234273502ba0a547a70d7c39228e75cb4f68e3a693677c"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.93.0/fink-0.93.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bec90ece98f66110ede77295ce55b8ad59fa38af01609f4805c72e4e4d3f1745"
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
