#!/bin/sh

NVIM_PATH="$HOME/.config/nvim"
if [ ! -d "$NVIM_PATH" ]; then
    mkdir -p "$HOME/.config"
    ln -s "$PWD"  "$NVIM_PATH"
fi

python2 -m pip install --user neovim
python3 -m pip install --user neovim

minpack_path="pack/minpac/opt/minpac"
if [ ! -d "$minpack_path" ]; then
    printf "Setting up Minpack!\n"
    mkdir -p pack/minpac/opt
    git clone https://github.com/k-takata/minpac.git pack/minpac/opt/minpac
fi

nvim -c 'execute ":source packages.vim"'
printf "\n"

if [ "$BUILD_YCM" = "TRUE" ]; then
    ycm_path="pack/minpac/start/YouCompleteMe/"
    if [ -d "$ycm_path" ]; then
        (cd "$ycm_path";
         git submodule update --init --recursive;
        python3 ./install.py --tern-completer
        )
    fi
fi

raspell_path="pack/minpac/start/raspell/"
if [ -d "$raspell_path" ]; then
    (cd "$raspell_path";
     make
     )
fi
