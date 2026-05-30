class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.81.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.81.0/fink-0.81.0-aarch64-apple-darwin.tar.gz"
      sha256 "152d99ec772ca651c1db4306f84be96296a28fdbc6e3fed2ddfe635c0a346205"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.81.0/fink-0.81.0-x86_64-apple-darwin.tar.gz"
      sha256 "6dc51e9219698b8bac69730225efbdfb17d6f5b973cfd6f3eb9a3926c56dad60"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.81.0/fink-0.81.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bbbacd717f94bf5ee33c8c767fd14fe059350297ccf5bcd96c00ba31e376c4a7"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.81.0/fink-0.81.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8e6992f2e6d8fa9a9a5dafd38a07087dbefce4da89db2c192b4f8aecf74510f9"
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
