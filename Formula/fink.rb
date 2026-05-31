class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.82.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.82.0/fink-0.82.0-aarch64-apple-darwin.tar.gz"
      sha256 "d0415e65bf29e2f7a5a1daaa79737c3aee2ee3e262add7f12d759e75aca18b47"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.82.0/fink-0.82.0-x86_64-apple-darwin.tar.gz"
      sha256 "f7d393e42d9c6ba5f54c62388022c736a6cb1f943fab4f001d7eb370e2639c7f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.82.0/fink-0.82.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "81825a86430b4a91de2a29e5f5114463c115a50090e94235efb82ab2386c4046"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.82.0/fink-0.82.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "901dbfc70fa7d8882694343ad42160187d0fda815436d5152a97c15e7276a337"
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
