# binwheels-neovim
An unofficial Python package to enable pre-built, cross-platform Neovim installation via standard Python package installation.

## Usage
Using [uv](https://astral.sh/uv) or [pipx](https://github.com/pypa/pipx):

```bash
# uv
uv tool install binwheels-neovim

# pipx
pipx install binwheels-neovim
```

After installation, the `nvim` command will be available in your PATH:

```bash
nvim myfile.txt
```

## How does it work?
Python wheels adhere to a naming scheme to indicate [platform compatibility](https://packaging.python.org/en/latest/specifications/platform-compatibility-tags/). The code in this repository is responsible for downloading (Windows/macOS) or compiling (Linux) an official Neovim release and packaging it into a `binwheels-neovim` wheel with the same version as the Neovim release it includes, and with platform/architecture tags that match the version of Neovim we have downloaded/compiled. For widest Python interpreter compatibility possible, the `py3-none` tag is used.

During installation, the contents of a Python wheel are unzipped to the `site-packages/` directory in whatever Python environment the wheel is being installed into. This is where the Neovim application files end up: a `binwheels_neovim/` directory inside `site-packages/`. But this doesn't help us, because that location is not on the user's `$PATH`.

To make `nvim` accessible on the user's `$PATH` we will leverage the [executable scripts](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/#creating-executable-scripts) functionality of a Python wheel. This functionality allows you to specify a function in your package that will be installed as an executable command in the user's environment. If your environment is a local `.venv/` directory, for example, the script would be installed to `.venv/bin/`. When using `uv tool install` or `pipx install`, the executable is added to a location on the user's `$PATH`.

Putting it all together: In order to make the `nvim` binary from this package available on the user's path, we need a Python function that will launch the `nvim` binary in a cross-platform way, and we need that function to *itself* be installed as an executable command named `nvim`. That is accomplished by the following:

1. A file at `neovim_pyinstaller/main.py`, which contains a `launch_neovim()` function that launches the `nvim` binary.
2. The following entry in `pyproject.toml`, which ensures `launch_neovim()` is installed as an executable command named `nvim`:

```toml
[project.scripts]
nvim = "binwheels_neovim.main:launch_neovim"
```

## Platform Support

**Currently**
- Linux (x64)
- macOS (x64, arm64)
- Windows (x64)

**Maybe one day**
- Linux (arm64)

## License
This package is licensed under Apache-2.0. Neovim itself is licensed under Apache-2.0 and Vim license.
