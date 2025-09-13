NEOVIM_INSTALL_DIR := $(CURDIR)/neovim_pyinstaller/install


help:
	@git grep -ho --perl-regexp --color=never '^[A-Za-z-]+(?=:)' Makefile

clean:
	rm -rf .venv/ neovim_pyinstaller/install/

bootstrap:
	@curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/usr/local/bin" sh

.venv:
	@uv venv --seed --no-managed-python -cp 3.10

install: .venv
	@uv pip install -e .

build: install
	git clone --depth=1 https://github.com/neovim/neovim /tmp/neovim
	cd /tmp/neovim && make CMAKE_INSTALL_PREFIX=$(NEOVIM_INSTALL_DIR) CMAKE_BUILD_TYPE=RelWithDebInfo && make install
	uv run --no-project python -m build --wheel

docker:
	@echo Launching container...
	@docker run --rm -d --name neovim_pyinstaller quay.io/pypa/manylinux_2_28_x86_64 tail -f /dev/null
	@echo Copying source directory...
	@docker cp ./ neovim_pyinstaller:/source
	-@docker exec --workdir /source -it neovim_pyinstaller /bin/bash
	@echo Removing neovim_pyinstaller container...
	@docker kill neovim_pyinstaller
	@echo ...done.
