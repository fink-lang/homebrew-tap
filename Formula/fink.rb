class Fink < Formula
  desc "ƒink — a functional programming language and compiler toolchain"
  homepage "https://github.com/fink-lang/fink"
  version "0.74.1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.74.1/fink-0.74.1-aarch64-apple-darwin.tar.gz"
      sha256 "9633a24e8a88a370d0694eebf27393442aca41a41384e8bba97c4f94be90bc7c"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.74.1/fink-0.74.1-x86_64-apple-darwin.tar.gz"
      sha256 "7e28ad49f5ae31b5462a49d309e6ee93622af9bed4751c9266f12fa8c369b2a1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/fink-lang/fink/releases/download/v0.74.1/fink-0.74.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "200c2550950af135f47397cb84fc699edc168ab4e7dd5ba5504e4d3e7e6b93c9"
    end
    on_intel do
      url "https://github.com/fink-lang/fink/releases/download/v0.74.1/fink-0.74.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5b9cbab2bbec8dbea49a36238498b68d93e8ed929a17243d9601292cc6f781c0"
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
