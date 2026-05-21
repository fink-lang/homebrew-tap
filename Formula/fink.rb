class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.76.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.76.0/fink-0.76.0-aarch64-apple-darwin.tar.gz"
      sha256 "3698eb5ad57979c7bf92da1ab63c1789cca82f3a8fa1124ba94d6cfa793289f2"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.76.0/fink-0.76.0-x86_64-apple-darwin.tar.gz"
      sha256 "0b305158e69b19eb11c6baabe2fd14bf2c9018a3d3b3af754efa8d29c0679aed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.76.0/fink-0.76.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "95feefbe0030bd07a84d485a4c27148b181f85844cf1d774977a558a889d48aa"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.76.0/fink-0.76.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a8e2b10fcc2b1cd40580ee39e782100ce0694a30e8f72302dc9a62d1180e3d3a"
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
