class Gx < Formula
  desc "Coding agent CLI with an inline terminal UI"
  homepage "https://s3.orkward.dev/src/"
  # Private repo, `git archive` of git.lan:gx, served next to the bottles.
  url "https://s3.orkward.dev/src/gx-0.3.3.tar.gz"
  sha256 "5cc5ef2d05395549d1987d5e53b33e6df04f668be57c5fce90d82880b4074916"

  bottle do
    root_url "https://s3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54372e1fb513b000079d6ef19aee4a65df3e01688e9175d5ef9d984225091a9c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X fx/coding.Version=v#{version}")
  end

  test do
    assert_match "continue the latest session", shell_output("#{bin}/gx --help 2>&1")
  end
end
