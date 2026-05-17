class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.74.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.74.0/fink-0.74.0-aarch64-apple-darwin.tar.gz"
      sha256 "75ee7a83500c9a7dfc888453f854526aa69a2f4600479b2e24a1267cba0b2017"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.74.0/fink-0.74.0-x86_64-apple-darwin.tar.gz"
      sha256 "f30a49191531acb3039b14b804f2b4dbda646af128c777e4d037b5ac6e329cc1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.74.0/fink-0.74.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3205d4091d2aebd43254bbdb45a37ff899b92ada410791a86b276607bcc2582d"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.74.0/fink-0.74.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a2eebe01e100c781891d0eae21c12ae21d9986aa274a0f11ed49e3f989ff0ac5"
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
