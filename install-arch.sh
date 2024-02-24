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


sudo pacman -S linux-headers base-devel git github-cli intel-ucode pacman-contrib dkms zsh
sudo pacman -S plasma-meta konsole kwrite dolphin ark plasma-wayland-session egl-wayland sddm pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumber iio-sensor-proxy bluez bluez-utils powerdevil power-profiles-daemon cpupower 
sudo pacman -S nano vim openssh htop wget iwd wireless_tools wpa_supplicant smartmontools xdg-utils lazygit fwupd wl-clipboard btop p7zip unrar tar rsync neofetch flac curl wget ufw flatpak samba 
sudo pacman -S exfat-utils fuse-exfat ntfs-3g
sudo pacman -S ttf-jetbrains-mono-nerd noto-fonts-emoji noto-fonts ttf-scheherazade-new
sudo pacman -S steam  wezterm lf fd fzf xclip wmctrl xdotool syncthing spectacle discord kodi retroarch retroarch-assets-xmb retroarch-assets-glui retroarch-assets-ozone libretro-core-info libretro-shaders-slang keepassxc

yay -Suy
yay -S \
 google-chrome \
 protonup-qt \
 koi \
 informant \
 xone-dkms-git xone-dongle-firmware \
 kodi-addon-pvr-iptvsimple \
 moonlight-qt \
 appimagelauncher

sudo usermod -a -G informant,render,video,audio,input,informant,wheel atj 
