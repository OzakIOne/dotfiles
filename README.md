# dotfiles

## Requirements

```bash
sudo apt update && sudo apt upgrade -y

sudo apt install -y software-properties-common \
    build-essential \
    gcc \
    neovim \
    unzip \
    htop \
    trash-cli \
    python3 \
    ffmpeg

## install only you aren't on WSL
grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null || sudo apt install -y kitty \
  vlc \
  mpv \
  flatpak \
  yt-dlp

wget https://raw.githubusercontent.com/OzakIOne/dotfiles/master/install.sh

sudo ./install.sh
```