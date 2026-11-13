class Gx < Formula
  desc "Coding agent CLI with an inline terminal UI"
  homepage "https://s3.orkward.dev/src/"
  # Private repo, `git archive` of git.lan:gx, served next to the bottles.
  url "https://s3.orkward.dev/src/gx-0.3.7.tar.gz"
  sha256 "6474d4b0e1526dbedb0b7037fdb4517f50dc16476c7a7810de1d26e4ad11100d"

  bottle do
    root_url "https://s3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e226b41b564cf85419d647c339320000d198a3f4ed8d768054ba72efbe8331f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X fx/coding.Version=v#{version}")
  end

  test do
    assert_match "continue the latest session", shell_output("#{bin}/gx --help 2>&1")
  end
end
