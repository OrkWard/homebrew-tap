class Gx < Formula
  desc "Coding agent CLI with an inline terminal UI"
  homepage "https://s3.orkward.dev/src/"
  # Private repo, `git archive` of git.lan:gx, served next to the bottles.
  url "https://s3.orkward.dev/src/gx-0.3.1.tar.gz"
  sha256 "6730efad27dd3fd5523f7379575c4a762cf2c957a566d0c8fc08c3398394f3b1"

  bottle do
    root_url "https://s3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3be375a5c6ec302a1c4367729e60e079e17336abcb84f0228a8c0ef7f034a47f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X fx/coding.Version=v#{version}")
  end

  test do
    assert_match "continue the latest session", shell_output("#{bin}/gx --help 2>&1")
  end
end
