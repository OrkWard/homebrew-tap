class Wormface < Formula
  desc "Scraper SDK collection (CLI)"
  homepage "https://github.com/orkward/wormface"
  url "https://github.com/orkward/wormface.git", using: :git, tag: "v2.0.0",
                                                revision: "29f9b94cff560c1d2ed93b3d46612abe5be51bdd"
  license "MIT"
  head "https://github.com/orkward/wormface.git", using: :git, branch: "master"

  bottle do
    root_url "https://github.com/orkward/wormface/releases/download/v2.0.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce8bd9ba1fca2fccf011e7ad1276d749c8fed9a58e67cabab56fb05511b7a7d9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"wormface", "./cmd/wormface-cli"
  end

  test do
    assert_match "wormface-cli", shell_output("#{bin}/wormface 2>&1", 1)
  end
end
