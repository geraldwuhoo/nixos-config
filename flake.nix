{
  description = "NixOS configuration";

  nixConfig = {
    extra-substituters = [ "https://cuda-maintainers.cachix.org" ];
    extra-trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      sops-nix,
      home-manager,
      plasma-manager,
      stylix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfreePredicate =
            pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
              # VSCode extensions
              "vscode-extension-MS-python-vscode-pylance"
              "vscode-extension-signageos-signageos-vscode-sops"
            ];
          config.permittedInsecurePackages = [
            "electron-31.7.7"
          ];
        };
      };
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        NixDesktop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [ overlay-unstable ];
              }
            )
            ./hosts/NixDesktop
            stylix.nixosModules.stylix

            { nix.settings.trusted-users = [ "jerry" ]; }

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "bak";

                sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
                users.jerry = import ./home;
              };
            }
          ];
        };
      };
    };
}
