class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.65.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.65.1/fink-0.65.1-aarch64-apple-darwin.tar.gz"
      sha256 "65585b3aae88e6d53319eddf5ea7f6f86b09d11dc5bc6d2fa5f73f83de55b3fa"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.65.1/fink-0.65.1-x86_64-apple-darwin.tar.gz"
      sha256 "90c35d9abab16b484a8f8d24a87aad6520fd70d0f0cdb2c1bd108a552d440637"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.65.1/fink-0.65.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6204bbd9f86bbd8725feaaaaeeff825ca3bdd6d19bdc7dd074bef68275b211d6"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.65.1/fink-0.65.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a189f872c6f49dd712c11942c8931ebb507b954d8cf0ebbc1da6037d2308094f"
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
