class Docker < Formula
  desc "Pack, ship and run any application as a lightweight container"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git", using: :git, tag: "v29.9.3",
                                           revision: "5457199aa57c45e990c59c89cab5f02b817238d7"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", using: :git, branch: "master"

  bottle do
    root_url "https://s3.orkward.dev/bottles"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9fe381be1c8cdf1e32387b19180c7f23bffce51147f5d29c7d7f99cd9dd44e0"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  # Look up per-host proxies in config.json by the context's endpoint
  # (e.g. ssh://user@host) rather than the client's dummy host
  # http://docker.example.com used for SSH connections.
  # See docker/cli#7046.
  patch :DATA

  deny_network_access!

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    # TODO: Drop GOPATH when merged/released: https://github.com/docker/cli/pull/4116
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker").install_symlink buildpath => "cli"

    ldflags = [
      "-X", "github.com/docker/cli/cli/version.BuildTime=#{time.iso8601}",
      "-X", "github.com/docker/cli/cli/version.GitCommit=#{Utils.git_short_head}",
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

__END__
diff --git a/cli/command/container/create.go b/cli/command/container/create.go
--- a/cli/command/container/create.go
+++ b/cli/command/container/create.go
@@ -102,7 +102,7 @@ func runCreate(ctx context.Context, dockerCLI command.Cli, flags *pflag.FlagSet,
 			StatusCode: 125,
 		}
 	}
-	proxyConfig := dockerCLI.ConfigFile().ParseProxyConfig(dockerCLI.Client().DaemonHost(), opts.ConvertKVStringsToMapWithNil(copts.env.GetSlice()))
+	proxyConfig := dockerCLI.ConfigFile().ParseProxyConfig(dockerCLI.DockerEndpoint().Host, opts.ConvertKVStringsToMapWithNil(copts.env.GetSlice()))
 	newEnv := make([]string, 0, len(proxyConfig))
 	for k, v := range proxyConfig {
 		if v == nil {
diff --git a/cli/command/container/run.go b/cli/command/container/run.go
--- a/cli/command/container/run.go
+++ b/cli/command/container/run.go
@@ -91,7 +91,7 @@ func runRun(ctx context.Context, dockerCLI command.Cli, flags *pflag.FlagSet, ro
 			StatusCode: 125,
 		}
 	}
-	proxyConfig := dockerCLI.ConfigFile().ParseProxyConfig(dockerCLI.Client().DaemonHost(), opts.ConvertKVStringsToMapWithNil(copts.env.GetSlice()))
+	proxyConfig := dockerCLI.ConfigFile().ParseProxyConfig(dockerCLI.DockerEndpoint().Host, opts.ConvertKVStringsToMapWithNil(copts.env.GetSlice()))
 	newEnv := []string{}
 	for k, v := range proxyConfig {
 		if v == nil {
diff --git a/cli/command/image/build.go b/cli/command/image/build.go
--- a/cli/command/image/build.go
+++ b/cli/command/image/build.go
@@ -439,7 +439,7 @@ func imageBuildOptions(dockerCli command.Cli, options buildOptions) client.Image
 		CgroupParent:   options.cgroupParent,
 		ShmSize:        options.shmSize.Value(),
 		Ulimits:        options.ulimits.GetList(),
-		BuildArgs:      configFile.ParseProxyConfig(dockerCli.Client().DaemonHost(), opts.ConvertKVStringsToMapWithNil(options.buildArgs.GetSlice())),
+		BuildArgs:      configFile.ParseProxyConfig(dockerCli.DockerEndpoint().Host, opts.ConvertKVStringsToMapWithNil(options.buildArgs.GetSlice())),
 		Labels:         opts.ConvertKVStringsToMap(options.labels.GetSlice()),
 		CacheFrom:      options.cacheFrom,
 		SecurityOpt:    options.securityOpt,
