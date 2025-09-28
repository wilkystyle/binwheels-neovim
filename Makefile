NEOVIM_INSTALL_DIR := $(CURDIR)/binwheels_neovim/install

ifeq ($(OS),Windows_NT)
	NEOVIM_OS := win64
	UNAME_S :=
else
    UNAME_S := $(shell uname -s)
	UNAME_M := $(shell uname -m)

    ifeq ($(UNAME_S),Darwin)
		NEOVIM_OS := macos
	else
		NEOVIM_OS := linux
	endif

	ifeq ($(UNAME_M),x86_64)
		NEOVIM_ARCH := x86_64
	else
		NEOVIM_ARCH := arm64
	endif
endif

help:
	@git grep -ho --perl-regexp --color=never '^[A-Za-z-]+(?=:)' Makefile

bootstrap:
	@curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR="/usr/local/bin" sh

.venv:
	@/usr/local/bin/uv venv --seed --managed-python -cp 3.10
	@/usr/local/bin/uv pip install -e '.[dev]'

build: .venv
ifndef WHEEL_VERSION
	$(error WHEEL_VERSION not set. Example: make WHEEL_VERSION=0.11.4rc1)
endif

ifndef NEOVIM_VERSION_TAG
	$(error NEOVIM_VERSION_TAG not set. Example: make NEOVIM_VERSION_TAG=v0.11.4)
endif

ifeq ($(UNAME_S),Linux)
	git clone --depth=1 https://github.com/neovim/neovim /tmp/neovim
	git checkout $(NEOVIM_VERSION_TAG)
	cd /tmp/neovim && make CMAKE_INSTALL_PREFIX=$(NEOVIM_INSTALL_DIR) CMAKE_BUILD_TYPE=RelWithDebInfo && make install
else ifeq ($(UNAME_S),Darwin)
	curl -L https://github.com/neovim/neovim/releases/download/$(NEOVIM_VERSION_TAG)/nvim-$(NEOVIM_OS)-$(NEOVIM_ARCH).tar.gz -o nvim.tar.gz
	tar xf nvim.tar.gz
	mv nvim-$(NEOVIM_OS)-$(NEOVIM_ARCH)/ binwheels_neovim/install/
else
	curl -L https://github.com/neovim/neovim/releases/download/$(NEOVIM_VERSION_TAG)/nvim-$(NEOVIM_OS).zip -o nvim.zip
	unzip nvim.zip
	mv nvim-$(NEOVIM_OS)/ binwheels_neovim/install/
endif
	/usr/local/bin/uv version --frozen $(WHEEL_VERSION)
	/usr/local/bin/uv run --no-project python -m build --wheel

clean:
	uvx python -c "import shutil; shutil.rmtree('dist/', ignore_errors=True)"
	uvx python -c "import shutil; shutil.rmtree('binwheels_neovim/install/', ignore_errors=True)"

docker:
	@echo Launching container...
	@docker run --rm -d --name binwheels_neovim quay.io/pypa/manylinux_2_24_x86_64 tail -f /dev/null
	@echo Copying source directory...
	@docker cp ./ binwheels_neovim:/source
	-@docker exec --workdir /source -it binwheels_neovim /bin/bash
	@echo Removing binwheels_neovim container...
	@docker kill binwheels_neovim
	@echo ...done.
