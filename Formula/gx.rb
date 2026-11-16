class Gx < Formula
  desc "Coding agent CLI with an inline terminal UI"
  homepage "https://s3.orkward.dev/src/"
  # Private repo, `git archive` of git.lan:gx, served next to the bottles.
  url "https://s3.orkward.dev/src/gx-0.3.12.tar.gz"
  sha256 "6da79f1af6d5617fa1ea948e614527cc656dee273981d9093d015afed68db2a9"

  bottle do
    root_url "https://s3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be214b58791fc2cd7aa55ab051b400be6fd148ba10f302824b6138241759a7c6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X fx/coding.Version=v#{version}")
  end

  test do
    assert_match "continue the latest session", shell_output("#{bin}/gx --help 2>&1")
  end
end
