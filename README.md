# dotfiles

## Requirements

```bash
sudo apt update && sudo apt upgrade -y && sudo apt install -y software-properties-common build-essential
```

```bash
sudo pacman -S --needed git base-devel which wget
```

## Installation

```bash
wget https://raw.githubusercontent.com/OzakIOne/dotfiles/master/install.sh && chmod +x ./install.sh

./install.sh
```

## mpv

To install mpv plugin run :

```
chmod +x clone.sh
./clone.sh
stow mpv
```