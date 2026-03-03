class Crush < Formula
  desc "A powerful AI assistant that runs in the CLI"
  homepage "https://github.com/OrkWard/crush"
  version "0.47.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/OrkWard/crush/releases/download/v0.47.0/crush_Darwin_arm64.tar.gz"
      sha256 "01c738da22f5f6465b0f1207f22688674d74d1b4e8446ea919d1c24eb1fa4b5e"
    end
  end

  def install
    bin.install "crush"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")
  end
end
