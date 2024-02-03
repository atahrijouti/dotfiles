# Update system
sudo pacman -Suy
sudo pacman -S zsh
chsh -s $(which zsh)

pacman -S --needed git base-devel


mkdir ~/source && cd ~/source

# Dotfiles
git clone https://github.com/atahrijouti/dotfiles.git
sh source/dotfiles/create-symlinks.sh

# YAY
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cd source
git clone https://github.com/helix-editor/helix
cd helix
cargo install --path helix-term --locked
cd

yay -Suy
yay -S google-chrome protonu

sudo pacman -S github-cli
sudo pacman -S iio-sensor-proxy ttf-jetbrains-mono-nerd noto-fonts-emoji wezterm intel-ucode bluez bluez-utils btop p7zip unrar tar rsync git neofetch exfat-utils fuse-exfat ntfs-3g flac curl wget ufw steam flatpak fwupd wl-clipboard github-cli lazygit lf


