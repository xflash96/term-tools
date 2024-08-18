#!/bin/bash
set -e

if [ -z "$TERM_TOOLS" ]; then
    echo "TERM_TOOLS environment variable is not set!"
    exit 1
fi

if [ -e ~/.vim ]; then
    echo "Error: .vim exists.  Move or delete ~/.vim"
    exit 1
fi

if [ -e ~/.vimrc ]; then
    echo "Error: .vimrc exists.  Move or delete ~/.vimrc"
    exit 1
fi

sudo chown -R $USER $HOME/.local $HOME/.config

# fix the missing ensurepip in ubuntu python3.8 required by mason
python3_subver=$(python3 -c 'import sys; print(sys.version_info[1])')
if [ $python3_subver -eq 8 ] && ! python3.8 -m ensurepip --version; then
    curl -fL http://ports.ubuntu.com/pool/universe/p/python3.8/python3.8-venv_3.8.10-0ubuntu1~20.04.11_arm64.deb -o ensurepip.deb
    ar x ensurepip.deb data.tar.xz
    tar xf data.tar.xz && sudo mv ./usr/lib/python3.8/ensurepip /usr/lib/python3.8/ensurepip
    rm -rf ensurepip.deb data.tar.xz ./usr
fi

# Install dotfiles (this will fail it already exists so we are safe)
ln -s $TERM_TOOLS/config/vimrc-minimal ~/.vimrc
mkdir -p ~/.config/nvim \
    && ln -s $TERM_TOOLS/config/init.lua ~/.config/nvim/init.lua

nvim --headless "+Lazy! sync" +qa

# Skip the vim part
# curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
#     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# vim +PlugInstall +qall
