{ pkgs, username, ... }:

let inherit (import ./variables.nix) gitUsername;
in {
  users.users = {
    "${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups =
        [ "networkmanager" "wheel" "libvirtd" "docker" "scanner" "lp" ];
      shell = pkgs.zsh;
      # ignoreShellProgramCheck = true;
      packages = with pkgs; [ ];
    };
  };
}

