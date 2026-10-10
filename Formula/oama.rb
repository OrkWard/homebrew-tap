class Oama < Formula
  desc "OAuth credential manager for IMAP/SMTP mail clients"
  homepage "https://github.com/pdobsan/oama"
  # Private fork, `git archive` of git.lan:oama. The commit is stamped into
  # the tarball by export-subst, so the build needs no git repository.
  url "https://video3.orkward.dev/src/oama-0.22.2.tar.gz"
  sha256 "9c3d19d768720d749916c82c3943dc1e46151b7a0eee1d29a8c83b54bf6f6f67"
  license "BSD-3-Clause"

  bottle do
    root_url "https://video3.orkward.dev/bottles"
    sha256 cellar: :any, arm64_golden_gate: "97e0d0acc363fc468ce94c184d18c415684373dda25317d2fef3a4756c79e617"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-build", "--jobs=#{ENV.make_jobs}"
    bin.install Utils.safe_popen_read("cabal", "list-bin", "-v0", "oama").chomp => "oama"

    # GHC leaves ~626k symbols in __LINKEDIT, a third of the binary, that
    # nothing needs at runtime. Stripping invalidates the signature, so
    # re-sign ad-hoc afterwards.
    system "strip", bin/"oama"
    system "codesign", "--sign", "-", "--force", bin/"oama"

    bash_completion.install "completions/oama.bash" => "oama"
    fish_completion.install "completions/oama.fish"
    zsh_completion.install "completions/oama.zsh" => "_oama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oama --version")
  end
end
