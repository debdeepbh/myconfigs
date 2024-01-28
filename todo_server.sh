# Xbuntu 22.04 desktop
sudo apt-get update
sudo apt-get --assume-yes upgrade

# update all snap packages
sudo snap refresh

# install minimal packages minus the laptop-specific ones
min="vim vim-gtk3 zathura ranger xdotool git openssh-server htop unclutter redshift mplayer sxiv exuberant-ctags suckless-tools i3 rofi i3blocks py3status xfce4-goodies compton curl fzf tmux python3-pip pandoc"
sudo apt-get install --assume-yes $minpkg

# get dotfiles
git clone https://github.com/debdeepbh/myconfigs.git $HOME/myconfigs
cp -r $HOME/myconfigs/dotfiles/. $HOME/
source $HOME/.bashrc	# this will add some paths too

# remove dunst (used by i3) to get pretty notification popup
sudo apt purge dunst


# nodejs: need to add .local/bin as path, so need to get the dotfiles first
echo 'installing nodejs for coc'
curl -sL install-node.now.sh/lts >> install_nodejs
chmod +x install_nodejs
# install locally
./install_nodejs --prefix=$HOME/.local --yes

# vim set up
echo 'installing vim plugins: ignore gruvbox warning'
vim +PlugInstall +qall

# ssh setup
echo 'generating SSH key: silent with nopassphrase'
ssh-keygen -t rsa -N '' -f $HOME/.ssh/id_rsa
eval `ssh-agent -s`
ssh-add


# docker
