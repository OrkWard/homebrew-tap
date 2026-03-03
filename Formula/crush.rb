class Crush < Formula
  desc "A powerful AI assistant that runs in the CLI"
  homepage "https://github.com/OrkWard/crush"
  version "0.46.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/OrkWard/crush/releases/download/v0.46.3/crush_Darwin_arm64.tar.gz"
      sha256 "c2b122bef10a5fb4d716d4cd55b5c8bd368ded32b643ffbed0d80d6658497f2f"
    end
  end

  def install
    bin.install "crush"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")
  end
end
