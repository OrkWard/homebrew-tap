class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE"
  homepage "https://gitlab.com/shackra/goimapnotify"
  # Private fork, `git archive` of git.lan:goimapnotify. GPL-3 obliges the
  # bottle to come with its source, so it is served next to the bottles.
  url "https://s3.orkward.dev/src/goimapnotify-2.6.6.tar.gz"
  sha256 "faee0a4315cd71c6703ad924e6a6d8403561a240e8a4e8bf59b14025a04f6af3"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://s3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb98f9abc286370d543d1f1363e311bb5b15c5ee27a6e223579a62d7a2f5d07b"
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
