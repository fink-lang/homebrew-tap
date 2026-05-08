class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.72.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.72.0/fink-0.72.0-aarch64-apple-darwin.tar.gz"
      sha256 "5777e89c7304533a4ac02991f5b63357ce26bc5b03decfc95bc053dc04fd4109"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.72.0/fink-0.72.0-x86_64-apple-darwin.tar.gz"
      sha256 "1b11bcef4729ebd04f61b621ae0450748d876a9bd082ec48d6aeb49874310c37"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.72.0/fink-0.72.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "23bcfacc285657f3a89fac032e9af61eed905b94ed30aa1cfa30b3b531acd862"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.72.0/fink-0.72.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "db271281d9a124784e0eb8f065339263b1be2c9bd5abd01619b76d13c75d80da"
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
