class Selever < Formula
  desc "Install exact toolchains and packages with shell environment updates"
  homepage "https://github.com/orkward/selever"
  url "https://github.com/orkward/selever.git", using: :git, tag: "v1.1.0",
                                                revision: "6db42045084d873008051865a104482a67720864"
  license "MIT"
  head "https://github.com/orkward/selever.git", using: :git, branch: "master"

  bottle do
    root_url "https://video3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0217f3119ec4264bf819df32ac34663cbf1b1b527261a2e1cc55c444a5cf84d1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"selever",  "./cmd/selever"
    system "go", "build", "-o", bin/"fetchver", "./cmd/fetchver"
    system "go", "build", "-o", bin/"globver",  "./cmd/globver"

    generate_completions
  end

  def generate_completions
    # fish
    %w[selever fetchver globver].each do |name|
      (buildpath/"#{name}.fish").write Utils.safe_popen_read(bin/name, "completion", "fish")
      fish_completion.install buildpath/"#{name}.fish"

      # bash
      (buildpath/name).write Utils.safe_popen_read(bin/name, "completion", "bash")
      bash_completion.install buildpath/name

      # zsh
      (buildpath/"_#{name}").write Utils.safe_popen_read(bin/name, "completion", "zsh")
      zsh_completion.install buildpath/"_#{name}"
    end
  end

  test do
    assert_match "selever installs", shell_output("#{bin}/selever --help")
    assert_match "fetchver resolves", shell_output("#{bin}/fetchver --help")
    assert_match "globver installs", shell_output("#{bin}/globver --help")
  end
end
