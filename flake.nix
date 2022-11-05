{
  description = "mhelton nix config";

  inputs = {
    # Utilities for building flakes
    utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Core nix flakes
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";

    # Home manager flake
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.utils.follows = "utils";

    # nix-darwin
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # mpack
    mpack.url = "github:league/mpack";
    mpack.inputs.nixpkgs.follows = "nixpkgs";

    # mach-nix
    mach-nix.url = "github:DavHau/mach-nix";
    mach-nix.inputs.flake-utils.follows = "utils";
    mach-nix.inputs.nixpkgs.follows = "nixpkgs";

    # vscode-server
    vscode-server.url = "github:msteen/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";

    # nur
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      my-lib = import ./lib { inherit inputs; };
      #inherit (builtins) attrValues mapAttrs;
      inherit (my-lib) mkHome mkDarwinSystem mkDeploy importAttrset;
      inherit (inputs.nixpkgs.lib) genAttrs;
      inherit (self) outputs;
      forAllSystems = genAttrs [ "x86_64-linux" "aarch64-darwin" ];
    in
    rec {
      overlays = {
        default = import ./overlays { inherit inputs; };
      };

      nixosModules = import ./modules/nixos;
      darwinModules = import ./modules/darwin;
      homeManagerModules = import ./modules/home-manager;

      legacyPackages = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
      );

      devShells = forAllSystems (system: {
        default = import ./shell.nix { pkgs = legacyPackages.${system}; };
      });

      nixosConfigurations = {
        tomservo = nixpkgs.lib.nixosSystem {
          pkgs = legacyPackages."x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/tomservo
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs outputs; };
                users.mhelton.imports = [
                  ./home/mhelton
                  ./home/mhelton/personal.nix
                  ./home/mhelton/linux.nix
                  ./home/mhelton/graphical.nix
                  ./home/mhelton/gaming.nix
                ];
              };
            }
          ];
        };
      };

      darwinConfigurations = {
        superintendent = darwin.lib.darwinSystem {
          pkgs = legacyPackages."aarch64-darwin";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/superintendent
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs outputs; };
                users.mhelton.imports = [ ./home/mhelton ./home/mhelton/personal.nix ./home/mhelton/darwin.nix ];
              };
            }
          ];
        };
        imubit-morganh-mbp13 = mkDarwinSystem {
          inherit overlays;
          hostname = "imubit-morganh-mbp13";
          system = "aarch64-darwin";
          users = [ "mhelton" ];
        };
      };

      homeConfigurations = {
        "mhelton@superintendent" = mkHome {
          inherit overlays;
          username = "mhelton";
          system = "aarch64-darwin";
          hostname = "superintendent";
        };
        "mhelton@imubit-morganh-mbp13" = mkHome {
          inherit overlays;
          username = "mhelton";
          system = "aarch64-darwin";
          hostname = "imubit-morganh-mbp13";
          work = true;
        };
      };
    };
}
