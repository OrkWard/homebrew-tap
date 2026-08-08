class Selever < Formula
  desc "Install exact toolchains and packages with shell environment updates"
  homepage "https://github.com/orkward/selever"
  license "MIT"

  head "https://github.com/orkward/selever.git", using: :git, branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"selever",  "./cmd/selever"
    system "go", "build", "-o", bin/"fetchver", "./cmd/fetchver"
    system "go", "build", "-o", bin/"globver",  "./cmd/globver"
  end

  test do
    assert_match "selever installs", shell_output("#{bin}/selever --help")
    assert_match "fetchver resolves", shell_output("#{bin}/fetchver --help")
    assert_match "globver installs", shell_output("#{bin}/globver --help")
  end
end
