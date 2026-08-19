class Selever < Formula
  desc "Install exact toolchains and packages with shell environment updates"
  homepage "https://github.com/orkward/selever"
  license "MIT"

  url "https://github.com/orkward/selever.git", using: :git, tag: "v1.0.0"
  head "https://github.com/orkward/selever.git", using: :git, branch: "master"

  depends_on "go" => :build

  bottle do
    root_url "https://github.com/orkward/selever/releases/download/v1.0.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e335abbc1f26e01ee612e553dc436e5cbdb5a9a2efd49e6fbdb762a94a126daa"
  end

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
    end

    # bash
    %w[selever fetchver globver].each do |name|
      (buildpath/name).write Utils.safe_popen_read(bin/name, "completion", "bash")
      bash_completion.install buildpath/name
    end

    # zsh
    %w[selever fetchver globver].each do |name|
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
