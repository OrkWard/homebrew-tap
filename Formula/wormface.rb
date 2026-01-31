class Wormface < Formula
  desc "Scraper SDK collection (CLI)"
  homepage "https://github.com/orkward/wormface"
  version "2.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/OrkWard/wormface/releases/download/v2.0.0/wormface_Darwin_arm64.tar.gz"
      sha256 "074edaf06a72b9586d97ad4799eae68f7c55dd745f11cd42753ddf8d0d2a2d5b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/OrkWard/wormface/releases/download/v2.0.0/wormface_Linux_arm64.tar.gz"
      sha256 "12b2d5cc2b3cbc72c9d974a43d81bad8bc33a503d5574ad46ac11cf10b0e7a68"
    end

    on_intel do
      url "https://github.com/OrkWard/wormface/releases/download/v2.0.0/wormface_Linux_x86_64.tar.gz"
      sha256 "15a1da50e1d595449dd889728c4e4d6948c1c01d279d9c30b023ebb69c6f6b3f"
    end
  end

  def install
    bin.install "wormface-cli" => "wormface"
  end

  test do
    assert_match "wormface-cli", shell_output("#{bin}/wormface 2>&1", 1)
  end
end
