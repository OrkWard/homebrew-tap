class BashPinyinCompletionRs < Formula
  desc "Bash completion script for pinyin, matcher based on IbPinyinLib"
  homepage "https://github.com/AOSC-Dev/bash-pinyin-completion-rs"
  url "https://github.com/AOSC-Dev/bash-pinyin-completion-rs/archive/refs/heads/master.tar.gz"
  version "0.1.0"
  sha256 "0c5df7816b8cb7d7ca79d42d5b5c4577e7779dbc23a8d088113167cdac4c6107"
  license "GPL-3.0"

  depends_on "rust" => :build
  depends_on "bash-completion@2"

  def install
    system "cargo", "build", "--release"
    
    bin.install "target/release/bash-pinyin-completion-rs"
    
    # Install completion script
    bash_completion.install "scripts/bash_pinyin_completion"
  end

  def caveats
    <<~EOS
      To enable bash-pinyin-completion-rs, add this to your .bashrc:
        source #{bash_completion}/bash_pinyin_completion

      For better experience, add these to your inputrc:
        set show-all-if-ambiguous on
        set menu-complete-display-prefix on
        TAB: menu-complete
        set colored-completion-prefix on
        set colored-stats on
        "\\e[Z": menu-complete-backward

      You may configure the pinyin schema with PINYIN_COMP_MODE:
        export PINYIN_COMP_MODE="ShuangpinXiaohe"
    EOS
  end

  test do
    assert_match "bash-pinyin-completion-rs", shell_output("#{bin}/bash-pinyin-completion-rs --help")
  end
end
