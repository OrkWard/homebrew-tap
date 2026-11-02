class Selever < Formula
  desc "Install exact toolchains and packages with shell environment updates"
  homepage "https://github.com/orkward/selever"
  url "https://github.com/orkward/selever.git", using: :git, tag: "v2.2.2",
                                                revision: "c82f564e447eb51ee61e9466235f6deea24ca92f"
  license "MIT"
  head "https://github.com/orkward/selever.git", using: :git, branch: "master"

  bottle do
    root_url "https://s3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58186fd24f7e2835bca76a44507ebf907727dd5040caf03576349da89bd20d23"
  end

  depends_on "nim" => :build

  def install
    # Call nim directly: nimble would try to fetch the Nim pinned in nimble.lock.
    system "nim", "c", "-d:release", "--hints:off",
           "--nimcache:#{buildpath}/nimcache",
           "--out:#{bin}/selever", "src/selever.nim"
  end

  test do
    assert_match "selever install", shell_output("#{bin}/selever --help")
  end
end
