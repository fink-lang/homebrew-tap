class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.74.2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.74.2/fink-0.74.2-aarch64-apple-darwin.tar.gz"
      sha256 "daea62ada705ec2a26963b54b4524a0d32d16087fc890e82abe039ff90b4057e"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.74.2/fink-0.74.2-x86_64-apple-darwin.tar.gz"
      sha256 "58091e50f065c0223e9f9e496dac3e6cb39366a46c7772d4e43d31f04e2480af"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.74.2/fink-0.74.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "be55b3dcccb20e233d1a49242a622a54c9a0bcbe91efc554e232aac466c4056f"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.74.2/fink-0.74.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "241d9609ea88c036281e23cd51f41c65402f6d4a2facd5d49915dd3073ea5a00"
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
