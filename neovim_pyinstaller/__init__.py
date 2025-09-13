"""
neovim-pyinstaller: Cross-platform Neovim installation via Python packaging.

This package wraps official Neovim releases to enable easy installation
on systems without admin privileges using pip or uv.
"""

from importlib.metadata import version

__version__ = version("neovim-pyinstaller")
