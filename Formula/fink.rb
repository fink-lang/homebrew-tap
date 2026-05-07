class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.70.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.70.0/fink-0.70.0-aarch64-apple-darwin.tar.gz"
      sha256 "8dc260e0b52354b69711c1bc23b88003e4d29525247f41fd6f9884f158b3e7fc"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.70.0/fink-0.70.0-x86_64-apple-darwin.tar.gz"
      sha256 "a2241e722188a22b1661c8882884140d9f4b12e658356f366e7e5ca384bea2ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.70.0/fink-0.70.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "8ae3d70a64d3c61e1574d93f9c32f7eeb6d837e1a4742e1c5f4040991667af60"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.70.0/fink-0.70.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5386732b22d2f473ae91acd8e8fc6a9ae5a01c8b5c7bf830b6dd097188947f40"
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
