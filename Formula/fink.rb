class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.49.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.49.1/fink-0.49.1-aarch64-apple-darwin.tar.gz"
      sha256 "92ea69823dd94a2fdb7764145a9f0dbd64295cf03f2eab119b74426f56a80afa"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.49.1/fink-0.49.1-x86_64-apple-darwin.tar.gz"
      sha256 "8647c0d7541cd0f818b153faa7aed54999d9b2409a16779353118a05bc06dfd4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.49.1/fink-0.49.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ce81730a9a72018e168cd4b16020048a1ce5ce21e6402300f651443fe08f5303"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.49.1/fink-0.49.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c63796033539faa918dcaf08a42755c4403413caec528f78e7a4b96be2ae9f6f"
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
