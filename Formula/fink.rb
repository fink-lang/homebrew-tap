class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.54.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.54.1/fink-0.54.1-aarch64-apple-darwin.tar.gz"
      sha256 "648b636904b8e2d0d69e787570f9d77bb7c9ecc645c786fd484a09ba5fb227a6"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.54.1/fink-0.54.1-x86_64-apple-darwin.tar.gz"
      sha256 "bddac199623330810b7c7cc5fa6165bbb805697d90ef0e247077a711f9f208bc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.54.1/fink-0.54.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6bf8b77551fc7259d5c55cd3834aa27e1c11df2758872e53c1d1d1511b7d3da8"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.54.1/fink-0.54.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "1ad5691ed632eea678351c5739b6efe8f8b30b3909b356401f46c0b28d2acdab"
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
