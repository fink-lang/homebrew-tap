class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.91.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.91.0/fink-0.91.0-aarch64-apple-darwin.tar.gz"
      sha256 "aa380a4fc8b365d70690ae74f9954dec0caeae7ed89d02516c1fe8af2fe29229"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.91.0/fink-0.91.0-x86_64-apple-darwin.tar.gz"
      sha256 "49699983303036c8be3514b6dc73081b5e6f595972ed93a61a36d76f60f620b8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.91.0/fink-0.91.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7e6c7f0f0f13de3d9b169decae96b921aa1852cda2f240883423b2e8b65bbe9c"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.91.0/fink-0.91.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6c8b57aaa152888bc88fc4b9ca25af62d6770fc20962fd07eb6e37eb2dffa32d"
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
