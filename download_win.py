import platform
import urllib.request
import zipfile
from pathlib import Path

NEOVIM_DOWNLOAD_URL = (
    "https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-win64.zip"
)
ZIPFILE_OUTPUT = "nvim-win64.zip"
INITIAL_NEOVIM_DIR_NAME = Path("nvim-win64")
TARGET_NEOVIM_DIR_NAME = Path("neovim_pyinstaller/install")

print(f"{NEOVIM_DOWNLOAD_URL=}")
print(f"{ZIPFILE_OUTPUT=}")
print(f"{INITIAL_NEOVIM_DIR_NAME=}")
print(f"{TARGET_NEOVIM_DIR_NAME=}")

# Download the Noevim release zipfile
urllib.request.urlretrieve(NEOVIM_DOWNLOAD_URL, ZIPFILE_OUTPUT)

# Unpack the zipfile
with zipfile.ZipFile(ZIPFILE_OUTPUT, "r") as zip_ref:
    zip_ref.extractall()

INITIAL_NEOVIM_DIR_NAME.rename(TARGET_NEOVIM_DIR_NAME)
