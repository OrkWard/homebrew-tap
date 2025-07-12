class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more (OrkWard's fork)"
  homepage "https://vfox.dev/"
  url "https://github.com/OrkWard/vfox/archive/refs/tags/v0.6.11.tar.gz"
  sha256 "6a0ed2c4af15a92015ec4d77fb848662c24919dbbbdb010e9831d604a701f53e"
  license "Apache-2.0"
  head "https://github.com/OrkWard/vfox.git", branch: "feat/parent-tool-version"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output(bin/"vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end