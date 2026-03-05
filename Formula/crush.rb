class Crush < Formula
  desc "A powerful AI assistant that runs in the CLI"
  homepage "https://github.com/OrkWard/crush"
  version "0.48.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/OrkWard/crush/releases/download/v0.48.0/crush_0.48.0_Darwin_arm64.tar.gz"
      sha256 "d92c81613fc76a057353101a687333379145c52a9add1477e6756b695f1b3f42"
    end
  end

  def install
    bin.install "crush"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")
  end
end
