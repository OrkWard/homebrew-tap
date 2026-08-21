class DotnetInstall < Formula
  desc "Script used to install the .NET SDK and the shared runtime"
  homepage "https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script"
  url "https://github.com/dotnet/install-scripts.git", using: :git, tag: "v2026.07.21", revision: "da3ce11ba63f3dbb0fb835d41bda2665d5c48e84"
  license "MIT"
  head "https://github.com/orkward/selever.git", using: :git, branch: "main"

  def install
    bin.install "src/dotnet-install.sh"
  end

  test do
    assert_match ".NET Tools Installer", shell_output("#{bin}/dotnet-install.sh --help")
  end
end
