# EasyKey Homebrew Tap

This is a custom Homebrew tap for [EasyKey](https://github.com/kingofmac/easykey), a secure replacement for environment variables on macOS.

## Installation

First, tap this repository:

```bash
brew tap kingofmac/easykey https://github.com/kingofmac/homebrew-easykey
```

Then install EasyKey (both CLI and macOS app):

```bash
brew install easykey --build-from-source
```

**Note**: The `--build-from-source` flag is required to build both the CLI tool and macOS app from source on your machine.

## What Gets Installed

When you install EasyKey via Homebrew, you get:

- 🖥️ **CLI Tool** - Command-line interface for managing secrets (installed to PATH)
- 📱 **macOS App** - Beautiful native app with Touch ID/Face ID (installed to ~/Applications/)

## About EasyKey

EasyKey is a comprehensive macOS solution that stores your secrets securely in the system keychain with biometric authentication. The complete ecosystem includes:

- 🖥️ **CLI Tool** - Command-line interface for managing secrets
- 📱 **macOS App** - Beautiful native app with Touch ID/Face ID
- 🐍 **Python Package** - Easy integration with Python projects  
- 📦 **Node.js Package** - Seamless JavaScript/TypeScript support

## Quick Start

### Using the CLI Tool

```bash
# Store a secret
easykey set API_KEY "your-secret-value"

# Retrieve a secret
easykey get API_KEY

# List all secrets
easykey list

# Get help
easykey --help
```

### Using the macOS App

1. Open **EasyKey** from ~/Applications/ or press Cmd+Space and search "EasyKey"
2. Authenticate with Touch ID/Face ID
3. Click **"+ Add"** to store your first secret
4. Search, view, copy, and manage secrets with the intuitive interface

## Security Features

- 🔐 **Keychain Integration** - Uses macOS keychain for encrypted storage
- 👆 **Biometric Authentication** - Touch ID/Face ID required for access
- 🔒 **Device-Local** - Secrets never leave your device
- 📝 **Audit Trail** - Optional reason logging for all access
- 🚫 **No Plain Text** - Secrets are never stored in plain text

## Full Project

For the complete EasyKey experience including the macOS app and language packages, visit the [main repository](https://github.com/kingofmac/easykey).

## License

MIT License - see the [main repository](https://github.com/kingofmac/easykey) for details.
