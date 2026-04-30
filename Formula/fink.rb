class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.63.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.63.1/fink-0.63.1-aarch64-apple-darwin.tar.gz"
      sha256 "f66c3b76f978fa6aa7d971771d745a19445120b7c43e167ad9630672d515f3c1"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.63.1/fink-0.63.1-x86_64-apple-darwin.tar.gz"
      sha256 "b2fd9da2cc2d6d112d5a047fcf0336d52a7d43d1d65a3fe65754b9f225f5408b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.63.1/fink-0.63.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "36084e6f90e49aa69846699f5a2b9d54c3eb9e4702098eb6cc8c399669f8e945"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.63.1/fink-0.63.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fbde35e61474c0553808651d6bb67841cf5dbe939f8c673d1d9e8855ae60563c"
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
