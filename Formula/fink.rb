class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.51.2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.51.2/fink-0.51.2-aarch64-apple-darwin.tar.gz"
      sha256 "dd37467ce8c587a1fee3935b076f9f0bcd938a73112fff421ce46ae546131fbe"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.51.2/fink-0.51.2-x86_64-apple-darwin.tar.gz"
      sha256 "d03243a9d6755408ca37f722c216b49a245b9f3d21a38906ba77ed74ae491d66"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.51.2/fink-0.51.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a00e0c075e23a90d28d7a272f47870f201a4e236f0bd7081f12ac1083eeff465"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.51.2/fink-0.51.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9c80457d74ee0ea8e03acc2d8f3bf06b5190e1a7a9b63b6046c9897ed1328f29"
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
