class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.71.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.71.0/fink-0.71.0-aarch64-apple-darwin.tar.gz"
      sha256 "ea6fef1fbb38e17dfe4fb42e5eace6f71aee7a1e6200f03afea0558de1b19443"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.71.0/fink-0.71.0-x86_64-apple-darwin.tar.gz"
      sha256 "d8ec6003b5333ee109cfd943cadf8c0b52d27fd287a582c03162f96fdcd47475"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.71.0/fink-0.71.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "287d0d66a765c31dd8341104da0bc1f468813f77f7ae48ecae1f3ca83c90e3ab"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.71.0/fink-0.71.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "af59884da488955a5892d04ca33ad99332c6477e5075f214db25febe0621a2a8"
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
