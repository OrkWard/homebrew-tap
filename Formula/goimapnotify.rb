class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE"
  homepage "https://gitlab.com/shackra/goimapnotify"
  # Private fork, `git archive` of git.lan:goimapnotify. GPL-3 obliges the
  # bottle to come with its source, so it is served next to the bottles.
  url "https://s3.orkward.dev/src/goimapnotify-2.6.2.tar.gz"
  sha256 "6a7c605686bce490b9e91c1de7124f8d37b9d5250c7db696aa887ef42cf77f32"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://s3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "acc9459385486d2c3ffaa01852f494410dd597e76dfdbe7886c4022c091cd6b2"
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
