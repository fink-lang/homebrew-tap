class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.78.2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.78.2/fink-0.78.2-aarch64-apple-darwin.tar.gz"
      sha256 "0c7438a22f78ea781f3f4811520f66b9f306857611189ee49478acbbac9bac5a"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.78.2/fink-0.78.2-x86_64-apple-darwin.tar.gz"
      sha256 "fad3c7c0b978f7dc24c81b79720e8e7722b74a3ce72db26ac4681ba78b553ce6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.78.2/fink-0.78.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "832d9180b3eab257ea0e9b50568c3ac209866af6a92594ab21bb8b0507806a77"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.78.2/fink-0.78.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "85be0715c4311952534bdf5c66d6709147f964f4241f9a437dc7812051311084"
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
