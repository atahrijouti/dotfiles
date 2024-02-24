# Install Packages
sudo pacman -Suy
sudo pacman -S linux-headers base-devel git github-cli intel-ucode pacman-contrib dkms zsh
sudo pacman -S plasma-meta konsole kwrite dolphin ark plasma-wayland-session egl-wayland sddm sof-firmware pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumber iio-sensor-proxy bluez bluez-utils powerdevil power-profiles-daemon cpupower 
sudo pacman -S nano vim openssh htop wget iwd wireless_tools wpa_supplicant smartmontools xdg-utils lazygit fwupd wl-clipboard btop p7zip unrar tar rsync neofetch flac curl wget ufw flatpak samba duf
sudo pacman -S exfat-utils fuse-exfat ntfs-3g
sudo pacman -S ttf-jetbrains-mono-nerd noto-fonts-emoji noto-fonts ttf-scheherazade-new
sudo pacman -S steam  wezterm lf fd fzf xclip wmctrl xdotool syncthing spectacle discord kodi retroarch retroarch-assets-xmb retroarch-assets-glui retroarch-assets-ozone libretro-core-info libretro-shaders-slang keepassxc

mkdir ~/source && cd ~/source

# Install AUR Packages
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
yay -Suy
yay -S google-chrome protonup-qt koi appimagelauncher kodi-addon-pvr-iptvsimple 
yay -S xone-dkms-git xone-dongle-firmware
yay -S informant
sudo usermod -a -G informant,render,video,audio,input,informant,wheel atj 

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Config
chsh -s $(which zsh)

# Dotfiles
cd ~/source
git clone https://github.com/atahrijouti/dotfiles.git
sh source/dotfiles/create-symlinks.sh



# Helix
cd ~/source
git clone https://github.com/helix-editor/helix
cd helix
cargo install --path helix-term --locked



