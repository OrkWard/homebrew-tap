class Selever < Formula
  desc "Install exact toolchains and packages with shell environment updates"
  homepage "https://github.com/orkward/selever"
  url "https://github.com/orkward/selever.git", using: :git, tag: "v1.1.0",
                                                revision: "6db42045084d873008051865a104482a67720864"
  license "MIT"
  head "https://github.com/orkward/selever.git", using: :git, branch: "master"

  bottle do
    root_url "https://github.com/orkward/selever/releases/download/v1.1.0"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7dd0a4274017920f86baee11d58bf992f09f556d1783f63d094e5285716f9cba"
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
