class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.53.2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.53.2/fink-0.53.2-aarch64-apple-darwin.tar.gz"
      sha256 "e6e2ca385bdbe7c52c4aaace5c6143129e901b98bfc6061320568dabac76c7a5"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.53.2/fink-0.53.2-x86_64-apple-darwin.tar.gz"
      sha256 "e43285a593c2fdad902c44bce45c151581bb8e7b3656423cdeb793cb70b7e6a7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.53.2/fink-0.53.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f70a03945f1257e710be7173d7bcf48eec5a43e0e3c8d3c55001dabbee3551f1"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.53.2/fink-0.53.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4c08276001ea5a237cebeacd5b31a5c49c651adaafc2843349c404ef8228907c"
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
