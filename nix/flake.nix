{
  description = "ozaki configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    # fine-cmdline = {
    #   url = "github:VonHeikemen/fine-cmdline.nvim";
    #   flake = false;
    # };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      host = "ace";
      username = "ozaki";
    in {
      nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit username;
            inherit host;
          };
          modules = [
            ./nixos/configuration.nix
            inputs.stylix.nixosModules.stylix
            inputs.vscode-server.homeModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = {
                inherit username;
                inherit inputs;
                inherit host;
              };
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./nixos/home.nix;
            }
          ];
        };
      };
    };
}
