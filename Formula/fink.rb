class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.73.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.73.0/fink-0.73.0-aarch64-apple-darwin.tar.gz"
      sha256 "f354820be8a3359c96d8136fbb07e5ec6acd7173bff73acb327c77bccfa674cc"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.73.0/fink-0.73.0-x86_64-apple-darwin.tar.gz"
      sha256 "8815dc6c6896e2e5a8abd37070570c1e5b63f16ec61d9128ae64876e692d7b99"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.73.0/fink-0.73.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "25260b3d3e4f7b3b0534af21e3b67d111d6e949f851a5298ddc9a58bec5bc6fc"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.73.0/fink-0.73.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "65f70bcb02bca69a5e24d62205a74144c745de7c7758a0874f5c9abe156b81f4"
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
