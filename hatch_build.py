import re

from hatchling.builders.hooks.plugin.interface import BuildHookInterface
from packaging import tags


class CustomBuildHook(BuildHookInterface):
    def initialize(self, version, build_data):
        # This is e.g. macosx_15_0_x86_64
        platform_tags = str(next(tags.platform_tags()))

        # Replace all macosx compatibility tags with macosx_11_0 to ensure
        # wider compatibility.
        #
        # In a *proper* binary wheel, you'd want to use `delocate` for this
        # instead of directly manipulating the wheel tags, but we're just
        # wrapping a Neovim installation.
        tag = re.sub(
            r"macosx_\d+_\d+_",
            "macosx_11_0_",
            f"py3-none-{platform_tags}",
        )

        # We only want the platform tags, don't care about Python version
        build_data["tag"] = tag
