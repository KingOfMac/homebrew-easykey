class Easykey < Formula
  desc "Secure replacement for environment variables on macOS using keychain and biometric auth"
  homepage "https://github.com/kingofmac/easykey"
  url "https://github.com/kingofmac/easykey.git", branch: "main"
  version "0.1.0"
  head "https://github.com/kingofmac/easykey.git", branch: "main"

  depends_on :macos
  depends_on xcode: ["12.0", :build]

  def install
    # Build the CLI using Swift Package Manager
    cd "cli" do
      system "swift", "build", "-c", "release", "--disable-sandbox"
      bin.install ".build/release/easykey"
    end
  end

  def caveats
    <<~EOS
      EasyKey CLI has been installed successfully!

      The CLI tool stores secrets securely in the macOS keychain and uses
      biometric authentication (Touch ID/Face ID) when available.

      Quick start:
        easykey set API_KEY "your-secret-value"
        easykey get API_KEY
        easykey list
        easykey --help

      Note: This CLI tool integrates with the macOS keychain and requires
      appropriate permissions. On first use, you may be prompted to allow
      keychain access.

      For the full EasyKey experience including the beautiful macOS app,
      Python package, and Node.js package, visit:
      https://github.com/kingofmac/easykey
    EOS
  end

  test do
    # Test that the binary was installed and can show help
    assert_match "easykey <command>", shell_output("#{bin}/easykey --help")
    # Test version output
    assert_match version.to_s, shell_output("#{bin}/easykey --version")
  end
end
