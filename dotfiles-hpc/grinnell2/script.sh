### Copy all configs


### install nodejs
curl -sL install-node.now.sh/lts >> install_nodejs
chmod +x install_nodejs
# install locally
mkdir ~/.local
./install_nodejs --prefix=$HOME/.local --yes


### vim 9 from source with python feature, installed at ~/.local/bin
git clone https://github.com/vim/vim.git
./configure --with-features=huge --enable-python3interp --prefix=$HOME/.local
make
make install
# make sure the path ~/.local/bin is in $PATH
which vim

echo 'installing vim plugins'
vim +PlugInstall +qall


# ranger
pip3 install ranger-fm
