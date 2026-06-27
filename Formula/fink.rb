class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.92.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.92.0/fink-0.92.0-aarch64-apple-darwin.tar.gz"
      sha256 "7a244ef99e8266635d34682da768eccc15506cdcfc36e910f7f2aa77194dafb0"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.92.0/fink-0.92.0-x86_64-apple-darwin.tar.gz"
      sha256 "0af7df4d3414b192f68f98551f16ea8a2b6accd72e1bc19dc63ea3336e1621ae"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.92.0/fink-0.92.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "e6fedeb2223631ccdfea3873df1e7bb331c25d05c67445468a049daed6f168bc"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.92.0/fink-0.92.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "d0b8ea17627ba28d92bad7606f4d2394084e2e33a925b5c4e578357a27ee3246"
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
