class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.66.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.66.0/fink-0.66.0-aarch64-apple-darwin.tar.gz"
      sha256 "ebcdca355a53e3c6c12f995372f90f2dd8c9e8aeba562bbd49155fe2e056f8d5"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.66.0/fink-0.66.0-x86_64-apple-darwin.tar.gz"
      sha256 "51c33282b861fdcc7cb62ddc821beaef36b0191705033dddf230089e307daf9c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.66.0/fink-0.66.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7f35e2273f30253e248f96436daf2b44841788b9153c8b92be42cb73fb2e5100"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.66.0/fink-0.66.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "998bd452965976172d692c2e36abdb3410792105cb47143262d9306163464656"
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
