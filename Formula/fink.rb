class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.60.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.60.0/fink-0.60.0-aarch64-apple-darwin.tar.gz"
      sha256 "0f9e51678ac1a5dc637fafab82008744938f33fbcb156950318e908fd8501d05"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.60.0/fink-0.60.0-x86_64-apple-darwin.tar.gz"
      sha256 "c28c27120020111dc2bfe9b2e6d5b00dbd9082f506bf03ad4ddf16a9ed6f6f6f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.60.0/fink-0.60.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5c2f2a6fa6d3cda067e13fa25e91c8dc60d6ae1ec43a6be98c41f47b5d6dbd5c"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.60.0/fink-0.60.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "f076b6d4c6671f7a13571e111af17eed6c2495f0e8c43dd6cde719f7843e92bb"
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
