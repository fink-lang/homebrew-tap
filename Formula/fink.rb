class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.77.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.77.0/fink-0.77.0-aarch64-apple-darwin.tar.gz"
      sha256 "75cdf43556aefdd0df4e528142ff7507a313e03ee7510b196ad04af83334384c"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.77.0/fink-0.77.0-x86_64-apple-darwin.tar.gz"
      sha256 "f38ce80c00d9711929f228af197ab15a71d9c748ce99aff579964eabc17e666c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.77.0/fink-0.77.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dc0f4e35edc633c377cdb1f6d367411cf6fcfdaf9f2c0ebff9bc155eda2da460"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.77.0/fink-0.77.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "99a91e2e24db57c728415d332feaccf6087c2a82d8de214a23d80bca27c1f2e1"
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
