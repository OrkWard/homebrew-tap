class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE"
  homepage "https://github.com/orkward/goimapnotify"
  url "https://github.com/orkward/goimapnotify.git", using: :git, tag: "2.6.0",
                                                revision: "bba5304d6378a30f1091d864d7400087a3950869"
  license "GPL-3.0-or-later"
  head "https://github.com/orkward/goimapnotify.git", using: :git, branch: "master"

  bottle do
    root_url "https://video3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f8729c88ba39417601c74d234e807fa58f835dedf2e58993711c3694eeff9a5f"
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
