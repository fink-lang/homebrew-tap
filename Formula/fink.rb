class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.58.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.58.0/fink-0.58.0-aarch64-apple-darwin.tar.gz"
      sha256 "8711c8cb00f1c7a2d8acf10fd26a5e090fb858aeed0d69c614eebac2470217cb"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.58.0/fink-0.58.0-x86_64-apple-darwin.tar.gz"
      sha256 "11a720b9ea61bbf57697a826ced1dfb8c8dfc01a7d26140af0194e58253d0512"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.58.0/fink-0.58.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2a15b4f5662c135d94e8cdd243bc56e3237435b2725e4f5ba083a40e23178f7f"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.58.0/fink-0.58.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "57f8212f134bc2cbff698b308dde5c0c864d4af21d2167c8dc4cdc45ebc3120f"
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
