# binwheels-neovim

Cross-platform Neovim installation via Python packaging.

This package wraps official Neovim releases to enable easy installation on systems without admin privileges `uv tool install`. This is an experimental package, mostly for fun and to prove to myself that I could make it work.

## Installation

```bash
uv tool install binwheels-neovim
```

## Usage
After installation, the `nvim` command will be available in your PATH:

```bash
nvim myfile.txt
```

## How it works


This package downloads the appropriate Neovim release tarball for your platform and architecture, extracts it into the Python package data directory, and provides a wrapper script that executes the binary with proper argument forwarding.

## Platform Support

**Currently**
- Linux (x64)

**Coming soon**
- Linux (arm64)
- macOS (x64, arm64)
- Windows (x64)

## License
This package is licensed under Apache-2.0. Neovim itself is licensed under Apache-2.0 and Vim license.
