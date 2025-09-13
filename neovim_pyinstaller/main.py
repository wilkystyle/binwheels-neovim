import os
import pathlib
import subprocess
import sys


def launch_neovim():
    if sys.platform.startswith("win"):
        bin_name = "nvim.exe"
    else:
        bin_name = "nvim"

    package_dir = pathlib.Path(__file__).parent
    bin_path_str = str(package_dir / "install" / "bin" / bin_name)

    if os.name == "posix":
        # On Unix: replace current process with binary
        os.execv(bin_path_str, [bin_path_str] + sys.argv[1:])
    else:
        # Windows fallback: spawn new process, return its exit code
        sys.exit(subprocess.call([bin_path_str] + sys.argv[1:]))
