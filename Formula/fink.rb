class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.69.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.69.0/fink-0.69.0-aarch64-apple-darwin.tar.gz"
      sha256 "9345a486e798f77f272478a8278c80c256aac2e614fcdd0820da4438738ff2e5"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.69.0/fink-0.69.0-x86_64-apple-darwin.tar.gz"
      sha256 "98cf71606401111e33dc7a0685929e20f9703184158e3e94d2795649967e1f8c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.69.0/fink-0.69.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "fc21bf87d1f8ba2abf4d552a1aff659fd2314565f9936a81ac13bbe6563ee7cc"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.69.0/fink-0.69.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "811a244fc9eed1d44d670134c0bd585fb66872bdcc2bc166bd4c87f1e7bf56b7"
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
