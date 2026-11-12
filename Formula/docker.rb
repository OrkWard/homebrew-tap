class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  # Private fork, `git archive` of git.lan:docker-cli, served next to the bottles.
  url "https://s3.orkward.dev/src/docker-29.9.3.tar.gz"
  sha256 "e4294abfec64f6b9afbc9d4b334425575de1d5766d9be16090ffc3fdcd8f791d"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://s3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "480e2ef1b3e00b7183cc46d74761d8ae6102aef78c416694763df833375c0d07"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  deny_network_access!

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    # TODO: Drop GOPATH when merged/released: https://github.com/docker/cli/pull/4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"

    ldflags = [
      "-X", "github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}",
      "-X", "github.com/docker/cli/cli/version.Version=#{version}",
      "-X", "\"github.com/docker/cli/cli/version.PlatformName=Docker Engine - Community\""
    ]

    system "go", "build", *std_go_args(ldflags:), "github.com/docker/cli/cmd/docker"

    Pathname.glob("man/*.[1-8].md") do |md|
      section = md.to_s[/\.(\d+)\.md\Z/, 1]
      (man/"man#{section}").mkpath
      system "go-md2man", "-in=#{md}", "-out=#{man}/man#{section}/#{md.stem}"
    end

    generate_completions_from_executable(bin/"docker", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  def caveats
    on_linux do
      <<~EOS
        The daemon component is provided in a separate formula:
          brew install docker-engine
      EOS
    end
  end

  test do
    assert_match "Docker version #{version}", shell_output("#{bin}/docker --version")

    expected = "Client: Docker Engine - Community\n Version:    #{version}\n Context:    default\n Debug Mode: false\n\nServer:"
    assert_match expected, shell_output("#{bin}/docker info", 1)
  end
end
