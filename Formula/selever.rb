class Selever < Formula
  desc "Install exact toolchains and packages with shell environment updates"
  homepage "https://github.com/orkward/selever"
  url "https://github.com/orkward/selever.git", using: :git, tag: "v1.4.2",
                                                revision: "903cbf8fda9ca205655eedfa7fe98ffa6af2131a"
  license "MIT"
  head "https://github.com/orkward/selever.git", using: :git, branch: "master"

  bottle do
    root_url "https://video3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d054f853a6289c9969d83e96ddb2bcc921bb8af6c9b12966ac075a13cdc72f0"
  end

  depends_on "go" => :build

  def install
    # -s -w drops the symbol table and DWARF, a third of each binary.
    ldflags = "-s -w -X github.com/orkward/selever/pkg/config.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"selever",  ldflags:), "./cmd/selever"
    system "go", "build", *std_go_args(output: bin/"fetchver", ldflags:), "./cmd/fetchver"
    system "go", "build", *std_go_args(output: bin/"globver",  ldflags:), "./cmd/globver"

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
