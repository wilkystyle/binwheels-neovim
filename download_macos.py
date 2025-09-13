import platform
import tarfile
import urllib.request
from pathlib import Path

ARCH = platform.machine().lower()
NEOVIM_DOWNLOAD_URL = f"https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-macos-{ARCH}.tar.gz"
TARBALL_OUTPUT = f"nvim-macos-{ARCH}.tar.gz"
INITIAL_NEOVIM_DIR_NAME = Path(f"nvim-macos-{ARCH}")
TARGET_NEOVIM_DIR_NAME = Path("neovim_pyinstaller/install")

print(f"{ARCH=}")
print(f"{NEOVIM_DOWNLOAD_URL=}")
print(f"{TARBALL_OUTPUT=}")
print(f"{INITIAL_NEOVIM_DIR_NAME=}")
print(f"{TARGET_NEOVIM_DIR_NAME=}")

# Download the Noevim release tarball
urllib.request.urlretrieve(NEOVIM_DOWNLOAD_URL, TARBALL_OUTPUT)

# Unpack the tarball
with tarfile.open(TARBALL_OUTPUT, "r:*") as tar:
    tar.extractall()

INITIAL_NEOVIM_DIR_NAME.rename(TARGET_NEOVIM_DIR_NAME)
