class Oama < Formula
  desc "OAuth credential manager for IMAP/SMTP mail clients"
  homepage "https://github.com/pdobsan/oama"
  # Built from a clone, not a tarball: the githash dependency runs
  # `git rev-parse` at compile time and fails without a .git directory.
  url "https://github.com/pdobsan/oama.git", using: :git, tag: "0.22.0",
                                             revision: "e419ef10ca4feacf4818c5cd9bd5e617f7ee2ee7"
  license "BSD-3-Clause"
  head "https://github.com/pdobsan/oama.git", using: :git, branch: "main"

  bottle do
    root_url "https://video3.orkward.dev/bottles"
    sha256 cellar: :any, arm64_golden_gate: "6a86c0182745b03c6e4013feff50a588049f3c766f53d53feb03bf991e716456"
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

    bash_completion.install "completions/oama.bash" => "oama"
    fish_completion.install "completions/oama.fish"
    zsh_completion.install "completions/oama.zsh" => "_oama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oama --version")
  end
end
