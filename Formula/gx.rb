class Gx < Formula
  desc "Coding agent CLI with an inline terminal UI"
  homepage "https://s3.orkward.dev/src/"
  # Private repo, `git archive` of git.lan:gx, served next to the bottles.
  url "https://s3.orkward.dev/src/gx-0.3.0.tar.gz"
  sha256 "b434eb205593e9aae1ec0238334a793405a2aa3636603881bc9b404f746e8295"

  bottle do
    root_url "https://s3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1b6147430568333558f97e67a59aae6af43530093eba52939e327fa87499ae7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X fx/coding.Version=v#{version}")
  end

  test do
    assert_match "continue the latest session", shell_output("#{bin}/gx --help 2>&1")
  end
end
