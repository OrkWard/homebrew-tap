class Oama < Formula
  desc "OAuth credential manager for IMAP/SMTP mail clients"
  homepage "https://github.com/orkward/oama"
  # Built from a clone, not a tarball: the githash dependency runs
  # `git rev-parse` at compile time and fails without a .git directory.
  url "https://github.com/orkward/oama.git", using: :git, tag: "0.22.1",
                                            revision: "c30544d22c3459839e755957cd466b6f04daa6be"
  license "BSD-3-Clause"
  head "https://github.com/orkward/oama.git", using: :git, branch: "main"

  bottle do
    root_url "https://video3.orkward.dev/bottles"
    sha256 cellar: :any, arm64_golden_gate: "3d02947ba4d53922f0097e2dafb826d1625efdc24ea9c29fcffbaea5c3963f42"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    # `cabal v2-install` builds from a source distribution, which drops the
    # .git directory that githash reads at compile time. Build in place and
    # copy the executable out, the way upstream's justfile does.
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
