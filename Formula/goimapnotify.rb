class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE"
  homepage "https://gitlab.com/shackra/goimapnotify"
  # Private fork, `git archive` of git.lan:goimapnotify. GPL-3 obliges the
  # bottle to come with its source, so it is served next to the bottles.
  url "https://s3.orkward.dev/src/goimapnotify-2.6.3.tar.gz"
  sha256 "57173b05965946f83168f45d308ac883f215c009fb5201401fbc4de0aba15dc6"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://s3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b3a20c9553c1eeee0832d2320f48aaa84e24a4e4f86577b857276816458f2365"
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
