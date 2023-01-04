#!/bin/sh

# if we are in the root of the dotfiles repo then set dir to the scripts folder
if [ "$PWD" != "$HOME/.config/mpv/scripts" ]; then
  dir="$PWD/mpv/.config/mpv/scripts"
fi

# if we are in the scripts folder then set dir to the scripts folder
if [ "$PWD" = "$HOME/.dotfiles/mpv/.config/mpv/scripts" ]; then
  dir="$PWD"
fi

git clone https://github.com/po5/mpv_sponsorblock "$dir/mpv_sponsorblock"
git clone https://github.com/zxhzxhz/mpv-chapters "$dir/mpv-chapters"
git clone https://github.com/Static39/mpv-scripts "$dir/mpv-scripts"
git clone https://github.com/mrxdst/webtorrent-mpv-hook "$dir/webtorrent-mpv-hook"
