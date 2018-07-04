.PHONY: all ycm spell

all: minpac spell
	printf "Update Packages!\n"
	nvim -c 'execute ":source packages.vim" | echo "" | qall!'
	printf "\n"

config: ${HOME}/.config/nvim
	printf "Setting up Config!\n"
	mkdir -p "${HOME}/.config"
	ln -s "${PWD}"  ${HOME}/.config/nvim

py3:
	python3 -m pip install --user neovim

minpac: pack/minpac/opt/minpac/

pack/minpac/opt/minpac/:
	printf "Setting up Minpack!\n"
	mkdir -p pack/minpac/opt
	git clone https://github.com/k-takata/minpac.git pack/minpac/opt/minpac

ycm: 
	cd pack/minpac/start/ycm/ && \
	 git submodule update --init --recursive && \
	python3 ./install.py --tern-completer
	

spell: 
	printf "Build spell dictionaries!\n"
	cd "pack/minpac/start/raspell/" && make
