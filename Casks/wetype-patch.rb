cask "wetype-patch" do
  version "2.2.3,657"
  sha256 "a4998fb6efe45fa5cd50ee98acb41a87b20aaeac596cb58350adc24069027c7c"

  url "https://github.com/OrkWard/wetype-patch/releases/download/v#{version.csv.first}-#{version.csv.second}/WeType_#{version.csv.first}_#{version.csv.second}_arm64.zip"
  name "WeType Patch"
  name "微信输入法补丁版"
  desc "WeType with per-app Chinese and English mode management"
  homepage "https://github.com/OrkWard/wetype-patch"

  conflicts_with cask: "wetype"
  depends_on arch: :arm64
  depends_on macos: :big_sur

  binary "WeType.app/Contents/MacOS/wetype-cli"
  input_method "WeType.app", target: "/Library/Input Methods/WeType.app"

  caveats <<~EOS
    This is an ad-hoc signed, non-notarized patched build of WeType.
    You may need to allow it in System Settings and log out and back in.
    Disable WeType's built-in updater; updates from Tencent replace the patch.
  EOS
end
