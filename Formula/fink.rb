class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.94.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.94.0/fink-0.94.0-aarch64-apple-darwin.tar.gz"
      sha256 "2e61a2491bb3fd792880c578a2a660bf6fe48d8767127356ccff913e975b7327"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.94.0/fink-0.94.0-x86_64-apple-darwin.tar.gz"
      sha256 "5df99bfb9d1416f3db144be3b4745e942fb55d2f00a57c9ab08f3f34daadc23a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.94.0/fink-0.94.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f68c71eaa80596ca790f98f738163067e1b72ac5140fb814b40f267a33814c66"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.94.0/fink-0.94.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3509fdd3612365f3ed6c4748758354efb5ab3babf1b27f1a2ff7216735535a5d"
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
