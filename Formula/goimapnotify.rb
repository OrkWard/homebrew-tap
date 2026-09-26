class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE"
  homepage "https://github.com/orkward/goimapnotify"
  url "https://github.com/orkward/goimapnotify.git", using: :git, tag: "2.6.0",
                                                revision: "bba5304d6378a30f1091d864d7400087a3950869"
  license "GPL-3.0-or-later"
  head "https://github.com/orkward/goimapnotify.git", using: :git, branch: "master"

  bottle do
    root_url "https://github.com/OrkWard/homebrew-tap/releases/download/goimapnotify-2.6.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe: "cb37108719fef64984f206d3cd17bb1655e813c3325d5e28195d12bf79b3822d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.gittag=#{version}"), "./cmd/goimapnotify"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/goimapnotify -version").strip
  end
end
