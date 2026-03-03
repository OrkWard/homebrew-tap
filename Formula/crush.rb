class Crush < Formula
  desc "A powerful AI assistant that runs in the CLI"
  homepage "https://github.com/OrkWard/crush"
  version "0.46.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/OrkWard/crush/releases/download/v0.46.3/crush_Darwin_arm64.tar.gz"
      sha256 "4b3082c30a4a4448098a07ad4e067aff392d2e1a2b0be7a555371cfca3d3da1f"
    end
  end

  def install
    bin.install "crush"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")
  end
end
