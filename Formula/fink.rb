class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.51.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.51.1/fink-0.51.1-aarch64-apple-darwin.tar.gz"
      sha256 "f301f906348375608eb00a7331afd29c19fb8a8e5b99decbe49a24b6b6579dfb"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.51.1/fink-0.51.1-x86_64-apple-darwin.tar.gz"
      sha256 "4ef7585d8675944b46a9ebbee80fb4969dc0b9deebf7790ca24a77690a5a9a54"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.51.1/fink-0.51.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "5b3df76e56071645731da9a8e99d13677879782da12dc8383b0541243ffb3129"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.51.1/fink-0.51.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "82480ee524136056487d2e10c5c6de386f8dc51fb85ec67874c52e1dd12814bb"
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
