{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager/trunk";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    stylix = {
      url = "github:danth/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    arkenfox = {
      url = "github:arkenfox/user.js";
      flake = false;
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
              "vscode-extension-anthropic-claude-code"

              # Clanker
              "claude-code"
            ];
          config.permittedInsecurePackages = [
            "electron-31.7.7"
          ];
        };
      };
      overlay-hydrus = final: prev: {
        hydrus = prev.hydrus.overrideAttrs (oldAttrs: {
          doCheck = false;
          doInstallCheck = false;
          propagatedBuildInputs = builtins.filter (
            dep: dep != final.python3Packages.psd-tools
          ) oldAttrs.propagatedBuildInputs;
        });
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
                nixpkgs.overlays = [
                  overlay-unstable
                  overlay-hydrus
                ];
              }
            )
            ./hosts/NixDesktop
            stylix.nixosModules.stylix

            home-manager.nixosModules.home-manager
            (
              { config, ... }:
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "bak";
                  extraSpecialArgs = { inherit inputs; };

                  sharedModules = [
                    plasma-manager.homeModules.plasma-manager
                    sops-nix.homeManagerModules.sops
                  ];
                  users.jerry = import ./home;
                };
              }
            )
          ];
        };
      };
    };
}
