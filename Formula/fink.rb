class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.50.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.50.0/fink-0.50.0-aarch64-apple-darwin.tar.gz"
      sha256 "15f643c5b23892d845be83064bb719cecccabbe891427e0ee53fe968cc42999f"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.50.0/fink-0.50.0-x86_64-apple-darwin.tar.gz"
      sha256 "0b7a8aeef26ecb1d62ae001af27669cb22a089d1b883821a1fae2d3d594efaa3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.50.0/fink-0.50.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1d13bc199ee192efb42e02aec455f23bc07afa9a74273b3dc946b8b7203dd463"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.50.0/fink-0.50.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bc445b4a971747da92c1cfedeb6ada3b0fedc784e6770d778336ffdb07718e86"
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
