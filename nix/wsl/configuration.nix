# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    # https://nix-community.github.io/NixOS-WSL/how-to/change-username.html
    defaultUser = "nixos";

    wslConf.interop.appendWindowsPath = false;
    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;

  };
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };
  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs [
    wget
    nix-ld
    git

    # WSL
    # antigen-git v2.2.3.r8.g64de2dc-1
    # aria2 1.37.0-1
    # atuin 18.3.0-1
    # bash 5.2.032-1
    # bat 0.24.0-2
    # btop 1.3.2-1
    # bun-bin 1.1.24-1
    # docker 1:27.1.2-1
    # docker-compose 2.29.2-1
    # dust 1.1.1-1
    # eza 0.19.0-1
    # fd 10.2.0-1
    # find-the-command 2.0.1-1
    # fx 35.0.0-1
    # fzf 0.54.3-1
    # gawk 5.3.0-1
    # git 2.46.0-1
    # github-cli 2.55.0-1
    # gzip 1.13-4
    # imagemagick 7.1.1.37-1
    # lazydocker 0.23.3-1
    # make 4.4.1-2
    # ncdu 2.5-1
    # neovim 0.10.1-3
    # nixfmt 0.6.0-4
    # nixfmt-debug 0.6.0-4
    # starship 1.20.1-1
    # stow 2.4.0-1
    # tldr++ 1.0.0.alpha-5
    # ugit 5.8-1
    # ugrep 6.5.0-1
    # unzip 6.0-21
    # wget 1.24.5-3
    # xz 5.6.2-1
    # yay 12.3.5-1
    # yt-dlp 2024.08.06-1
    # zoxide 0.9.4-2
    # zsh 5.9-5
  ];

    programs.nix-ld {
      enable = true;
      package = pkgs.nix-ld-rs;
    };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
