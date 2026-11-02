class Selever < Formula
  desc "Install exact toolchains and packages with shell environment updates"
  homepage "https://github.com/orkward/selever"
  url "https://github.com/orkward/selever.git", using: :git, tag: "v2.2.3",
                                                revision: "cd112d58201e71dbe4cbb7b047ed2e35c01bea60"
  license "MIT"
  head "https://github.com/orkward/selever.git", using: :git, branch: "master"

  bottle do
    root_url "https://s3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf2e56df9a757684b990885c96b596c64d00b0eeb3b8354c6565c9b11e751390"
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
