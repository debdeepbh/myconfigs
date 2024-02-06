# Xbuntu 22.04 desktop
sudo apt-get update
sudo apt-get --assume-yes upgrade

# update all snap packages
sudo snap refresh

# install minimal packages minus the laptop-specific ones
min="vim vim-gtk3 zathura ranger xdotool git openssh-server htop unclutter redshift mplayer sxiv exuberant-ctags suckless-tools i3 rofi i3blocks py3status xfce4-goodies compton curl fzf tmux python3-pip pandoc xclip borgbackup"

pkglist="$min"
sudo apt-get install --assume-yes $pkglist

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

cat $HOME/.ssh/id_rsa.pub | xclip -sel clip
echo "Key copied to clipboard. Check if connection works with: ssh -T git@github.com"
firefox https://github.com/settings/keys &


#######################################################################

## docker: From https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl --assume-yes
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin --assume-yes
## need to start the service
# systemctl start docker 
## Testing
sudo docker run hello-world

#######################################################################

# immich-app: https://immich.app/docs/install/docker-compose
immich_dir="$HOME/immich-app"
mkdir "$immich_dir"
cd "$immich_dir"
wget  https://github.com/immich-app/immich/releases/latest/download/docker-compose.yml
wget -O .env https://github.com/immich-app/immich/releases/latest/download/example.env
wget https://github.com/immich-app/immich/releases/latest/download/hwaccel.yml
# sudo docker compose up -d

# To run docker commands without root, add yourself as a docker manager https://docs.docker.com/engine/install/linux-postinstall/
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world

read -p "Change the database password in .env file: $HOME/immich-app/.env"

docker compose up -d

# immich cli for bulk upload of images
npm i -g @immich/cli

#######################################################################

# tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up	# requires login and setup
sudo tailscale funnel --set-path /immich --bg 2283	# open to web
#sudo tailscale serve --set-path /immich --bg 2283	# open to private network
tailscale funnel status

#######################################################################

# borg backup 
cp $HOME/myconfigs/borg-setup.sh "$immich_dir/"
# Add to crontab -e: run everyday at 3:27 am
# 27 3 * * * ~/myconfigs/borg-setup.sh >> ~/immich-app/backup.log

# set up /etc/fstab to auto mount backup media on boot
# lsblk or blkid to find device name or uuid
# sudo vim /etc/fstab for setting it up. Set 0 0 to skip dskchk etc


#######################################################################
# bulk upload
# immich-go does not work very well as it makes many of the uploaded file corrupted (but downloading and uploading them fixes them). Therefore, we will use: https://github.com/TheLastGimbus/GooglePhotosTakeoutHelper/tree/master?tab=readme-ov-file
# Download the script from the github, and run it on extracted takeout zips. This creates a flattened list of images which we can upload using bulk-upload script.
# Create an api key for the user. Then upload all images from directory [see](https://immich.app/docs/features/command-line-interface/)
# immich login-key http://localhost:2283/api <api_key>
# immich upload --recursive directory/
