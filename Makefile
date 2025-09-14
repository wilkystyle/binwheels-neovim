NEOVIM_INSTALL_DIR := $(CURDIR)/neovim_pyinstaller/install


help:
	@git grep -ho --perl-regexp --color=never '^[A-Za-z-]+(?=:)' Makefile

clean:
	rm -rf .venv/ neovim_pyinstaller/install/

bootstrap:
	@curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/usr/local/bin" sh

.venv:
	@uv venv --seed --managed-python -cp 3.10
	@uv pip install -e '.[dev]'

install: .venv

install-manylinux:
	@uv venv --seed --no-managed-python -cp 3.10
	@uv pip install -e '.[dev]'

build-linux: install-manylinux
	git clone --depth=1 https://github.com/neovim/neovim /tmp/neovim
	cd /tmp/neovim && make CMAKE_INSTALL_PREFIX=$(NEOVIM_INSTALL_DIR) CMAKE_BUILD_TYPE=RelWithDebInfo && make install
	uv run --no-project python -m build --wheel

build-macos: .venv
	uv run python download_macos.py
	uv run --no-project python -m build --wheel

docker:
	@echo Launching container...
	@docker run --rm -d --name neovim_pyinstaller quay.io/pypa/manylinux_2_24_x86_64 tail -f /dev/null
	@echo Copying source directory...
	@docker cp ./ neovim_pyinstaller:/source
	-@docker exec --workdir /source -it neovim_pyinstaller /bin/bash
	@echo Removing neovim_pyinstaller container...
	@docker kill neovim_pyinstaller
	@echo ...done.
