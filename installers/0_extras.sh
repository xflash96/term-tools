#!/bin/bash
set -e

if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get install -y vim git fzf cmake zsh less tmux curl wget fd-find ripgrep
    sudo apt-get install -y imagemagick source-highlight ninja-build

    sudo apt-get install -y libc++-15-dev libc++abi-15-dev
    curl -sL https://apt.llvm.org/llvm.sh | sudo -E bash /dev/stdin 15

    NVIM_ARCH=linux64
    FZF_ARCH=linux_amd64
elif command -v brew >/dev/null 2>&1; then
    brew install vim git fzf cmake zsh less lesspipe tmux curl wget fd ripgrep \
        coreutils ripgrep source-highlight
    brew install llvm
    NVIM_ARCH=macos-$(uname -m)
    FZF_ARCH=darwin_amd64
else
    echo "ERROR: don't know how to install extras!"
    exit 1
fi

export NVM_DIR=$HOME/.nvm
export NODE_VERSION=20
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

NVIM_VER=0.10.1
NVIM_BIN=nvim-$NVIM_ARCH.tar.gz
mkdir -p ~/.local
curl -fLO https://github.com/neovim/neovim/releases/download/v$NVIM_VER/$NVIM_BIN \
    && tar xf $NVIM_BIN --strip 1 -C ~/.local \
    && rm $NVIM_BIN

FZF_ARCH=linux_amd64
FZF_VER=0.54.3
FZF_BIN=fzf-$FZF_VER-$FZF_ARCH.tar.gz
mkdir -p ~/.local/bin
curl -fLO https://github.com/junegunn/fzf/releases/download/v$FZF_VER/$FZF_BIN \
    && tar xf $FZF_BIN -C ~/.local/bin \
    && rm $FZF_BIN
