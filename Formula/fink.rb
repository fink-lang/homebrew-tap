class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.85.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.85.0/fink-0.85.0-aarch64-apple-darwin.tar.gz"
      sha256 "29e5f4f83ddf5bae68d3cdd66118b56d5a5e9b6a660a824ead2f772492585b0d"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.85.0/fink-0.85.0-x86_64-apple-darwin.tar.gz"
      sha256 "f68f499a293ad94ad73050c565bb8c9f6011e22eac92ec7ee4c7771f7397d59b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.85.0/fink-0.85.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a03120c563e9ad10547ae0f0145c354bc1241ba82bd8cc6dd713ae9346cf7926"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.85.0/fink-0.85.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "841eb01e33a1ac5d859ddcdd1c861b60a35026535a4e6116ab8017d68124b0de"
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
