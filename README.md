# dotfiles

## Requirements

```bash
## Debian
sudo apt update && sudo apt upgrade -y && sudo apt install -y software-properties-common \
    build-essential \
    unzip \
    htop \
    trash-cli
```

```bash
## Arch
pacman -S --needed git base-devel which
```

```bash
wget https://raw.githubusercontent.com/OzakIOne/dotfiles/master/install.sh

chmod +x ./install.sh

./install.sh
```

```bash
## Install only you aren't on WSL
grep -qPi "(Microsoft|WSL)" /proc/version &> /dev/null || sudo apt install -y kitty \
  vlc \
  mpv \
  flatpak \
  yt-dlp
```