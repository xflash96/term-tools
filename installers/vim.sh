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
# later version requries bootstrap so plz apt install
python3_verbin=python3.$(python3 -c 'import sys; print(sys.version_info[1])')
if ! python3 -m ensurepip --version; then
    if [ $python3_verbin -ne "python3.8" ]; then
        echo "simply do apt install $python3_verbin-venv"
    else
        apt-get download $python3_verbin-venv
        mv $python3_verbin-venv* ensurepip.deb
        dpkg -x ensurepip.deb . && sudo mv ./usr/lib/$python3_verbin/ensurepip /usr/lib/$python3_verbin/
        rm -rf ensurepip.deb ./usr
    fi
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
