class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.90.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.90.0/fink-0.90.0-aarch64-apple-darwin.tar.gz"
      sha256 "26a63f5520417b92ce74df489bf409f32c7d935c4f126bfd554a425faf8ff3de"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.90.0/fink-0.90.0-x86_64-apple-darwin.tar.gz"
      sha256 "dea130425285f7a93b42936c4258a3d7a53cb7433efbd43867880ccb90317a31"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.90.0/fink-0.90.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "522036538313079646cdafc3ea678e7082503cffa6208fb31a61a1a9602469da"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.90.0/fink-0.90.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a88c461b4455466bc0d734bfabddb6288d5dc8ec4331ee6c0966467b0177281e"
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
