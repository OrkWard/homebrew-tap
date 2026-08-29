class Selever < Formula
  desc "Install exact toolchains and packages with shell environment updates"
  homepage "https://github.com/orkward/selever"
  url "https://github.com/orkward/selever.git", using: :git, tag: "v1.0.1",
                                                revision: "fd7c9db4b2c9b734660805e9ff748767d1135a7b"
  license "MIT"
  head "https://github.com/orkward/selever.git", using: :git, branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfee53d46808fc2836e19bff605b2837d3a9d423e7f883ec1c41eaff9d9d5b9b"
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
