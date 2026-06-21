class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.89.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.89.0/fink-0.89.0-aarch64-apple-darwin.tar.gz"
      sha256 "4440b7906cbc8212302af797927df51997816138c0c8bf88244acc29aa0923f3"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.89.0/fink-0.89.0-x86_64-apple-darwin.tar.gz"
      sha256 "1f34d39a502a22d1256465a525f9c0451cc67b8bdeff992dad1e0134098d0880"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.89.0/fink-0.89.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "eb764077741b1b1910657d38fa3eb773f7b6529de5c3076ab6faea7754d24504"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.89.0/fink-0.89.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "aa9583a482157c27a7bd26c2b18b8526c83fc8fb6d1b75a920d5b086d80f0257"
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
