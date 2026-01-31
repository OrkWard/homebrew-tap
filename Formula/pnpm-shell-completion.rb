class PnpmShellCompletion < Formula
  desc "Shell completion for pnpm"
  homepage "https://github.com/g-plane/pnpm-shell-completion"
  version "0.5.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/g-plane/pnpm-shell-completion/releases/download/v0.5.5/pnpm-shell-completion_aarch64-apple-darwin.tar.gz"
      sha256 "852d2922291b460c151352799c4a7f3cb34133c6b094913ec9d904d64d85b83e"
    end

    on_intel do
      url "https://github.com/g-plane/pnpm-shell-completion/releases/download/v0.5.5/pnpm-shell-completion_x86_64-apple-darwin.tar.gz"
      sha256 "fc93ab7e8410892b29d0f2f4905c89d67a41b9ef86c3c5716370e68b4a207b7e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/g-plane/pnpm-shell-completion/releases/download/v0.5.5/pnpm-shell-completion_aarch64-unknown-linux-gnu.tar.gz"
      sha256 "87fec87f0f52a6bea2344440fd25d2a7498c4a225bcbcbe10fd36186a38a0ba0"
    end

    on_intel do
      url "https://github.com/g-plane/pnpm-shell-completion/releases/download/v0.5.5/pnpm-shell-completion_x86_64-unknown-linux-gnu.tar.gz"
      sha256 "eae0a5ab8dc26e296a9735753cfb569e7e2bcd9f29a686294ac6f68871b0e712"
    end
  end

  def install
    bin.install "pnpm-shell-completion"
  end

  def caveats
    <<~EOS
      The pnpm-shell-completion binary has been installed.
      
      To enable shell completion, you'll need to manually configure your shell.
      See: https://github.com/g-plane/pnpm-shell-completion#installation
    EOS
  end

  test do
    system "#{bin}/pnpm-shell-completion", "--help"
  end
end
