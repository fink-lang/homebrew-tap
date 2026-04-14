class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.51.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.51.0/fink-0.51.0-aarch64-apple-darwin.tar.gz"
      sha256 "e8ed9fd86e3f848989329b7bc7b16c621426eaa8c4f0942600fb8e69619ce04e"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.51.0/fink-0.51.0-x86_64-apple-darwin.tar.gz"
      sha256 "0875f5ae9a5a21a19ab46f9509142ecfef21355f3b48a216ccd04f9d5297ef15"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.51.0/fink-0.51.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "78253ba757bfee87a996fb34800b80ef74a42a318eb71e1408f649ff2fa0acb7"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.51.0/fink-0.51.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "858333942b3181dff58e6d4a76a6db9d68f1296837e2924ca3736de5e05ddded"
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
