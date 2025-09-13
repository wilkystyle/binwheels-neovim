from hatchling.builders.hooks.plugin.interface import BuildHookInterface
from packaging import tags


class CustomBuildHook(BuildHookInterface):
    def initialize(self, version, build_data):
        # This is e.g. macosx_15_0_x86_64
        platform_tags = str(next(tags.platform_tags()))

        # We only want the platform tags, don't care about Python version
        build_data["tag"] = f"py3-none-{platform_tags}"
