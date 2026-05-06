class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.68.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.68.0/fink-0.68.0-aarch64-apple-darwin.tar.gz"
      sha256 "9d2c79c1a4b8a141782177011230bdf27cb91be7d6a26a40029b9f13c6a8f930"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.68.0/fink-0.68.0-x86_64-apple-darwin.tar.gz"
      sha256 "58f5676c0cef89be4e754895470d074240eb7c9ca26996106a10633cf8be2b54"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.68.0/fink-0.68.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2258148e4b2dd3d2c229ce70140a5d877c09dc07ff3887edf25fe865a4c323a1"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.68.0/fink-0.68.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "22bc672cf81e3520543368ef00153cc8f1c68f9e6b5922de22bcec1b5a02a96f"
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
