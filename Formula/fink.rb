class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.86.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.86.0/fink-0.86.0-aarch64-apple-darwin.tar.gz"
      sha256 "d615095d62e6d4dbac8ab6b2330e1fc96e1bd8b8a24fef62eeb875487ce82cce"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.86.0/fink-0.86.0-x86_64-apple-darwin.tar.gz"
      sha256 "56de3aae7f2bd9b141fe4dd834c2fa720b46307b6d3b93b2bb72937b7fb2a811"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.86.0/fink-0.86.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "545714e1e5a1f798d66f3683e1663db780ea1265547db514b599929b38dcfbb9"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.86.0/fink-0.86.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9849dd72bc07356f3b90b19d56714880283dbd37cd1c7ace7257f9e67f4bd65b"
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
