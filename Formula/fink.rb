class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.57.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.57.1/fink-0.57.1-aarch64-apple-darwin.tar.gz"
      sha256 "400add369109e3af3bfc26e5ba688e6ad253ce37db2d5ab3f9b8e935fc90be7c"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.57.1/fink-0.57.1-x86_64-apple-darwin.tar.gz"
      sha256 "2327e317f7fcf8437e5cdb313062050457c902035e2edf97c6ef92437c741727"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.57.1/fink-0.57.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9f1d33e4c1ddc5e3b33bd368a8b98539226f7f44537ad93305752c04feb3ab8f"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.57.1/fink-0.57.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3776341a4e63f83c9c530c7a39fdeae8ff670d35c443bd5c8df5e2a0d5f7c4cc"
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
