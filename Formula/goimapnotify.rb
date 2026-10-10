class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE"
  homepage "https://gitlab.com/shackra/goimapnotify"
  # Private fork, `git archive` of git.lan:goimapnotify. GPL-3 obliges the
  # bottle to come with its source, so it is served next to the bottles.
  url "https://video3.orkward.dev/src/goimapnotify-2.6.1.tar.gz"
  sha256 "3572c862aa54453120c63643af11e29f3fd2c9d8dd70a69af3c645d242ed0788"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://video3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4fc1d817b46170afa7dc08601c7a75c857f68dbe1ec2a48de0ef33d9c65b9d2b"
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
