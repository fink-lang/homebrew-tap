class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.88.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.88.0/fink-0.88.0-aarch64-apple-darwin.tar.gz"
      sha256 "e067817fc999888e4b17b15fe9226f810e556a82cf3ad2124bbdcc8e580276fe"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.88.0/fink-0.88.0-x86_64-apple-darwin.tar.gz"
      sha256 "f2a299d12db7e4e1092f2abaa725d3ae6edf9d69db7596e7421e912acacdc6b2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.88.0/fink-0.88.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "65574435afa35a52f2963b6d32de1b7329bf3df8a41acc036d15ba6a6fdc4e16"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.88.0/fink-0.88.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2df5f0645f2ec2fbc00c99c2ab3026a5e5dbce2bf43535b0c1f7efa22d234c35"
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
