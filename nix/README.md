# Nix

- `nix-shell -p git`
- `git clone https://github.com/ozakione/dotfiles .dotfiles && cd .dotfiles`
- `nixos-generate-config --show-hardware-config > ./nix/nixos/hardware.nix`
- `NIX_CONFIG="experimental-features = nix-command flakes"`
- `sudo nixos-rebuild switch --flake .#nixos`

## Ressources

- [Apple Borked my Nix!](https://gist.github.com/meeech/0b97a86f235d10bc4e2a1116eec38e7e)
- [ZaneyOS](https://gitlab.com/Zaney/zaneyos)

## Todo

- [ ] [nixos-vscode-server](https://github.com/nix-community/nixos-vscode-server)
  - [ ] vscode-server.nixosModules.default instead of homeModules
- [ ] hyperland config
- [ ] os theming
