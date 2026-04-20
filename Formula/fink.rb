class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.55.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.55.0/fink-0.55.0-aarch64-apple-darwin.tar.gz"
      sha256 "9f03e8d7f50655aacc0a85bf489857da6cb773d355332ec80f03633c7ff41641"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.55.0/fink-0.55.0-x86_64-apple-darwin.tar.gz"
      sha256 "a34ee003fe5260dca1cd280e6ae15642e66fcd31413b9899b5127d3d78a6013c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.55.0/fink-0.55.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "cd934a1c3341a3b08030d3f5b6244dbb062a0c02a445659b0b56f7d213fa42fb"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.55.0/fink-0.55.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "94e2cdddd1b0c82197beede957c0508df3ddda2824d1b3c50b06465ecee83609"
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
