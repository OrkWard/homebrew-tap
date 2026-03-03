class Crush < Formula
  desc "A powerful AI assistant that runs in the CLI"
  homepage "https://github.com/OrkWard/crush"
  version "0.46.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/OrkWard/crush/releases/download/v0.46.3/crush_Darwin_arm64.tar.gz"
      sha256 "be387f27ace59eea4d780a88563f55f79fbbb2655530e2bd0be1113601e68046"
    end
  end

  def install
    bin.install "crush"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")
  end
end
