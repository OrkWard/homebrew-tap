class Czmod < Formula
  desc "Native C module to boost z.lua performance"
  homepage "https://github.com/OrkWard/czmod"
  version "1.0.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/OrkWard/czmod/releases/download/v1.0.1/czmod-darwin-arm64"
      sha256 "414def656598c7a9549b53cede6c44fa118e868203c8f344186eb7f60ddb3707"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/OrkWard/czmod/releases/download/v1.0.1/czmod-linux-musl"
      sha256 "6632e95985808094bc89760f97df46f47a9cec89c3590ac8ef446ad97f2ab3b6"
    end
  end

  resource "scripts" do
    url "https://github.com/OrkWard/czmod/archive/refs/tags/v1.0.1.tar.gz"
    sha256 "6d2bab299f8e000e4e8c51c6fbd4ecbc12fe2a828330da663c7fea6b62786262"
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "czmod-darwin-arm64" => "czmod"
    elsif OS.linux? && Hardware::CPU.intel?
      bin.install "czmod-linux-musl" => "czmod"
    end

    resource("scripts").stage do
      prefix.install "czmod.bash", "czmod.zsh", "czmod.fish"
    end
  end

  def caveats
    <<~EOS
      czmod must be initialized after z.lua.

      For bash, add to ~/.bashrc:
        eval "$(lua ~/path/to/z.lua --init bash enhanced once echo)"
        source #{prefix}/czmod.bash

      For zsh, add to ~/.zshrc:
        eval "$(lua ~/path/to/z.lua --init zsh enhanced once echo)"
        source #{prefix}/czmod.zsh

      For fish, add to ~/.config/fish/config.fish:
        source #{prefix}/czmod.fish
    EOS
  end

  test do
    system bin/"czmod", "--add", testpath
  end
end
