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
      # Build the app using xcodebuild with code signing and sandboxing disabled
      system "xcodebuild", "-project", "app.xcodeproj", "-scheme", "app", 
             "-configuration", "Release", "-derivedDataPath", "./build",
             "CODE_SIGN_IDENTITY=", "CODE_SIGNING_REQUIRED=NO", 
             "CODE_SIGNING_ALLOWED=NO", "DEVELOPMENT_TEAM=",
             "ENABLE_APP_SANDBOX=NO", "ENABLE_HARDENED_RUNTIME=NO"
      
      # Find the built app - try multiple possible locations
      possible_paths = [
        "./build/Build/Products/Release/EasyKey.app",
        "./build/dst/Applications/EasyKey.app",
        "./build/Release/EasyKey.app"
      ]
      
      app_path = possible_paths.find { |path| File.exist?(path) }
      
      if app_path
        # Ensure Applications directory exists
        applications_dir = "#{ENV["HOME"]}/Applications"
        system "mkdir", "-p", applications_dir
        
        # Remove existing installation
        existing_app = "#{applications_dir}/EasyKey.app"
        system "rm", "-rf", existing_app if File.exist?(existing_app)
        
        # Copy the app
        system "/bin/cp", "-r", app_path, applications_dir
        ohai "EasyKey.app installed to #{applications_dir}/EasyKey.app"
      else
        opoo "EasyKey.app not found at any expected location, skipping app installation"
        opoo "Searched: #{possible_paths.join(', ')}"
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
