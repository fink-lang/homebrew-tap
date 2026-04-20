class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.56.2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.56.2/fink-0.56.2-aarch64-apple-darwin.tar.gz"
      sha256 "35742a7c9482c9c2421d131a67466749a38f211a95f987a40c251bac0fdb90cc"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.56.2/fink-0.56.2-x86_64-apple-darwin.tar.gz"
      sha256 "bf49f19db0bce91075a0f7a2afb3bd5df8211eafb4b895a4a910c8669b96db9c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.56.2/fink-0.56.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "523ca21427acf8fb08c06d37c77b74daffb554566582325146eecc0b26cbb931"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.56.2/fink-0.56.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4178460a4db0979b1c7f508dd8df392c20a6af6b1871108a5d027c5bc7ad68b0"
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
