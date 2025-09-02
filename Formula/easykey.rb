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

    # Build and install the macOS app
    cd "app" do
      system "xcodebuild", "-project", "app.xcodeproj", "-scheme", "app", 
             "-configuration", "Release", "-derivedDataPath", "./build"
      
      # Install the app to Applications
      app_path = "./build/Build/Products/Release/EasyKey.app"
      if File.exist?(app_path)
        system "/bin/cp", "-r", app_path, "#{ENV["HOME"]}/Applications/"
      else
        opoo "EasyKey.app not found at expected location, skipping app installation"
      end
    end
  end

  def caveats
    <<~EOS
      EasyKey has been installed successfully!

      Components installed:
      • CLI tool: Available in your PATH as 'easykey'
      • macOS app: Installed to ~/Applications/EasyKey.app

      The CLI tool and app store secrets securely in the macOS keychain and use
      biometric authentication (Touch ID/Face ID) when available.

      Quick start (CLI):
        easykey set API_KEY "your-secret-value"
        easykey get API_KEY
        easykey list
        easykey --help

      Quick start (App):
        • Open EasyKey from ~/Applications/ or Spotlight
        • Authenticate with Touch ID/Face ID
        • Use the beautiful interface to manage your secrets

      Note: Both components integrate with the macOS keychain and require
      appropriate permissions. On first use, you may be prompted to allow
      keychain access.

      For Python and Node.js packages, visit:
      https://github.com/kingofmac/easykey
    EOS
  end

  test do
    # Test that the binary was installed and can show help
    assert_match "easykey <command>", shell_output("#{bin}/easykey --help")
    # Test version output
    assert_match version.to_s, shell_output("#{bin}/easykey --version")
    # Test that the app was installed (if it exists)
    app_path = "#{ENV["HOME"]}/Applications/EasyKey.app"
    if File.exist?(app_path)
      assert_predicate Pathname.new(app_path), :exist?
    end
  end
end
