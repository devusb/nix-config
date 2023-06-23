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
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";

    # Home manager flake
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # mpack
    mpack.url = "github:league/mpack";
    mpack.inputs.nixpkgs.follows = "nixpkgs";

    # colmena
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs";
    colmena.inputs.flake-utils.follows = "utils";
    colmena.inputs.flake-compat.follows = "flake-compat";

    # nur
    nur.url = "github:nix-community/NUR";

    # nixGL
    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.inputs.flake-utils.follows = "utils";

    # attic
    attic.url = "github:zhaofengli/attic";

    # nixvim
    nixvim.url = "github:pta2002/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.flake-utils.follows = "utils";

    # disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # devenv
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    # plasma-manager
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    # Jovian-NixOS
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      inherit (inputs.nixpkgs.lib) genAttrs;
      inherit (self) outputs;
      forAllSystems = genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
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

      formatter = forAllSystems (system: legacyPackages.${system}.nixpkgs-fmt);

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
                  ./home/mhelton/plasma.nix
                  ./home/mhelton/gaming.nix
                  ./home/mhelton/deck.nix
                ];
              };
            }
          ];
        };

        durandal = nixpkgs.lib.nixosSystem {
          pkgs = legacyPackages."x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/durandal
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
                  ./home/mhelton/plasma.nix
                  ./home/mhelton/gaming.nix
                ];
              };
            }
          ];
        };

        bb =
          let
            system = "x86_64-linux";
            # add Jovian-NixOS overlay
            legacyPackages = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = builtins.attrValues {
                default = inputs.nixpkgs.lib.composeManyExtensions [ (import ./overlays { inherit inputs; }) (import "${inputs.jovian}/overlay.nix") ];
              };
            };
          in
          nixpkgs.lib.nixosSystem {
            pkgs = legacyPackages;
            specialArgs = { inherit inputs outputs; };
            modules = [
              ./hosts/bb
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
                    ./home/mhelton/plasma.nix
                    ./home/mhelton/deck.nix
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
                users.mhelton.imports = [
                  ./home/mhelton
                  ./home/mhelton/personal.nix
                  ./home/mhelton/darwin.nix
                ];
              };
            }
          ];
        };

        imubit-morganh-mbp13 = darwin.lib.darwinSystem {
          pkgs = legacyPackages."aarch64-darwin";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/imubit-morganh-mbp13
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs outputs; };
                users.mhelton.imports = [
                  ./home/mhelton
                  ./home/mhelton/work.nix
                  ./home/mhelton/darwin.nix
                ];
              };
            }
          ];
        };
      };

      homeConfigurations = {
        "deck@bb" = home-manager.lib.homeManagerConfiguration rec {
          pkgs = legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home/mhelton
            ./home/mhelton/personal.nix
            ./home/mhelton/standalone.nix
            {
              home.username = pkgs.lib.mkForce "deck";
            }
          ];
        };
      };
    };
}
