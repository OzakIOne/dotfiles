# Nix

- `sudo nix-channel --add <https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz> home-manager`
- `sudo nix-channel --update`
- `nix-shell -p git`
- `git clone https://github.com/ozakione/dotfiles> .dotfiles`
- `cd .dotfiles`
- `nixos-generate-config --show-hardware-config > ./nix/nixos/hardware.nix`
- `nix-env -iA nixos.home-manager`
w
