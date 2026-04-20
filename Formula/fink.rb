class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.57.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.57.0/fink-0.57.0-aarch64-apple-darwin.tar.gz"
      sha256 "d4c77b3714caae98d9f18fbe63e8cf209e964917beca7697c3abe615905e8ac2"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.57.0/fink-0.57.0-x86_64-apple-darwin.tar.gz"
      sha256 "ba8bffa9e5e799e3ac4fa328a084024bf454dcb451e95ff0922914d528258a4e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.57.0/fink-0.57.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c032adaa109260979d5ab9001fd9ea5f3930da88ad09dda6090093c47338d4ac"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.57.0/fink-0.57.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e929affe165f3040631522211078d1816676260a63474071fcc836ef1af98167"
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
