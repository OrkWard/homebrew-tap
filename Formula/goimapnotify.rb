class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE"
  homepage "https://gitlab.com/shackra/goimapnotify"
  # Private fork, `git archive` of git.lan:goimapnotify. GPL-3 obliges the
  # bottle to come with its source, so it is served next to the bottles.
  url "https://s3.orkward.dev/src/goimapnotify-2.6.5.tar.gz"
  sha256 "43b3f858672633103d2311b0b59f14b932580eff238b745d86d0fe7d99ddabed"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://s3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7a66908e741a737dce2ba40bfcbaa500d2a0f3a164699e46d190e94f2d95b366"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.gittag=#{version}"), "./cmd/goimapnotify"
  end

  service do
    run [opt_bin/"goimapnotify"]
    keep_alive true
    log_path var/"log/goimapnotify.log"
    error_log_path var/"log/goimapnotify.log"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/goimapnotify -version").strip
  end
end
