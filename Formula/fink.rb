class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.63.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.63.0/fink-0.63.0-aarch64-apple-darwin.tar.gz"
      sha256 "2ec35d292be493d86710cbd87a5c87a472ee8aff2e3c77f4c1294da3234c3c41"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.63.0/fink-0.63.0-x86_64-apple-darwin.tar.gz"
      sha256 "8c1ace6a10938dbeaa684e3c9916160b3ec623ba06f91222cc92fa42a3e265a5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.63.0/fink-0.63.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "69f6893635df9298cbddc360ddbcfd12d7355de0a9ce3436510bec59a6be1b48"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.63.0/fink-0.63.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "901490524ca22572131ffc8a98a4e84946b35daae097e6fa7f505141c776d181"
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
