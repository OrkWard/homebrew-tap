class Oama < Formula
  desc "OAuth credential manager for IMAP/SMTP mail clients"
  homepage "https://github.com/pdobsan/oama"
  url "https://github.com/pdobsan/oama/archive/refs/tags/0.22.0.tar.gz"
  sha256 "10866f90ec8adf227708fc3abe8d25a7d94c136ee9f5b43e6b91b504bf11e6de"
  license "BSD-3-Clause"
  head "https://github.com/pdobsan/oama.git", using: :git, branch: "main"

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    bash_completion.install "completions/oama.bash" => "oama"
    fish_completion.install "completions/oama.fish"
    zsh_completion.install "completions/oama.zsh" => "_oama"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oama --version")
  end
end
