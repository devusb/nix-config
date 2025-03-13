{
  description = "mhelton nix config";

  inputs = {
    # Utilities for building flakes
    utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-parts.url = "github:hercules-ci/flake-parts";

    # Core nix flakes
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    # Home manager flake
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # plasma-manager
    plasma-manager.url = "github:pjones/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    # nix-darwin
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # nixos-hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # nix-homebrew
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    # nix-packages
    nix-packages.url = "github:devusb/nix-packages";
    nix-packages.inputs.nixpkgs.follows = "nixpkgs";

    # mpack
    mpack.url = "github:league/mpack";
    mpack.inputs.nixpkgs.follows = "nixpkgs";

    # colmena
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.flake-utils.follows = "utils";
    colmena.inputs.flake-compat.follows = "flake-compat";

    # lix
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixvim
    nixvim.url = "github:nix-community/nixvim";

    # disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # lanzaboote
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Jovian-NixOS
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";

    # p81
    p81.url = "github:devusb/p81.nix";
    p81.inputs.nixpkgs.follows = "nixpkgs";

    # sentinelone
    sentinelone.url = "github:devusb/sentinelone.nix";

    # chaotic-nyx
    chaotic.url = "github:chaotic-cx/nyx";

    # treefmt-nix
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      flake-parts,
      nixvim,
      treefmt-nix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, ... }:
      {
        imports = [
          treefmt-nix.flakeModule
        ];
        perSystem =
          {
            pkgs,
            lib,
            system,
            ...
          }:
          let
            nixvimLib = nixvim.lib.${system};
            nixvim' = nixvim.legacyPackages.${system};
            nixvimModule = {
              inherit pkgs;
              module = import ./home/mhelton/nixvim.nix { inherit pkgs; };
            };
          in
          rec {
            legacyPackages = import nixpkgs {
              inherit system;
              overlays = builtins.attrValues {
                default = nixpkgs.lib.composeManyExtensions [ (import ./overlays { inherit inputs; }) ];
              };
              config.allowUnfree = true;
              config.permittedInsecurePackages = [
                "electron-24.8.6"
                "electron-25.9.0"
              ];
            };
            _module.args.pkgs = legacyPackages;

            devShells = {
              default = import ./shell.nix { pkgs = legacyPackages; };
            };

            treefmt = {
              programs.nixfmt.enable = true;
              programs.nixfmt.package = pkgs.nixfmt-rfc-style;
              programs.yamlfmt.enable = true;
              programs.mdformat.enable = true;
              settings.excludes = [
                ".editorconfig"
                ".gitignore"
                "flake.lock"
                "secrets/*"
              ];
            };

            checks =
              let
                nixosMachinesPerSystem = {
                  x86_64-linux = [
                    "tomservo"
                    "r2d2"
                    "bob"
                    "durandal"
                    "L-MHELTON"
                  ];
                };
                darwinMachinesPerSystem = {
                  aarch64-darwin = [
                    "imubit-morganh-mbp13"
                  ];
                };
                nixosMachines = lib.mapAttrs' (n: lib.nameValuePair "nixos-${n}") (
                  lib.genAttrs (nixosMachinesPerSystem.${system} or [ ]) (
                    name:
                    let
                      nixosConfiguration = self.nixosConfigurations.${name}.extendModules {
                        modules = [
                          { services.work.enable = lib.mkForce false; }
                        ];
                      };
                    in
                    nixosConfiguration.config.system.build.toplevel
                  )
                );
                darwinMachines = lib.mapAttrs' (n: lib.nameValuePair "darwin-${n}") (
                  lib.genAttrs (darwinMachinesPerSystem.${system} or [ ]) (
                    name:
                    let
                      darwinConfiguration = self.darwinConfigurations.${name}._module.args.extendModules {
                        modules = [
                          { services.work.enable = lib.mkForce false; }
                        ];
                      };
                    in
                    darwinConfiguration.config.system.build.toplevel
                  )
                );
              in
              {
                nvim = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
              }
              // nixosMachines
              // darwinMachines;

            packages = {
              nvim = nixvim'.makeNixvimWithModule nixvimModule;
            };
          };

        flake = rec {
          overlays = {
            default = import ./overlays { inherit inputs; };
          };

          nixosModules = import ./modules/nixos;
          darwinModules = import ./modules/darwin;

          nixosConfigurations = {
            tomservo = withSystem "x86_64-linux" (
              { pkgs, ... }:
              nixpkgs.lib.nixosSystem {
                inherit pkgs;
                specialArgs = { inherit inputs; };
                modules = (builtins.attrValues nixosModules) ++ [
                  ./hosts/tomservo
                  home-manager.nixosModules.home-manager
                  {
                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      extraSpecialArgs = { inherit inputs; };
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
              }
            );

            durandal = withSystem "x86_64-linux" (
              { pkgs, ... }:
              nixpkgs.lib.nixosSystem {
                inherit pkgs;
                specialArgs = { inherit inputs; };
                modules = (builtins.attrValues nixosModules) ++ [
                  ./hosts/durandal
                  home-manager.nixosModules.home-manager
                  {
                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      extraSpecialArgs = { inherit inputs; };
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
              }
            );

            bob = withSystem "x86_64-linux" (
              { pkgs, ... }:
              nixpkgs.lib.nixosSystem {
                inherit pkgs;
                specialArgs = { inherit inputs; };
                modules = (builtins.attrValues nixosModules) ++ [
                  ./hosts/bob
                  home-manager.nixosModules.home-manager
                  {
                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      extraSpecialArgs = { inherit inputs; };
                      users.mhelton.imports = [
                        ./home/mhelton
                        ./home/mhelton/personal.nix
                        ./home/mhelton/linux.nix
                        ./home/mhelton/graphical.nix
                        ./home/mhelton/gaming.nix
                        ./home/mhelton/deck.nix
                      ];
                    };
                  }
                ];
              }
            );

            r2d2 = withSystem "x86_64-linux" (
              { pkgs, ... }:
              nixpkgs.lib.nixosSystem {
                inherit pkgs;
                specialArgs = { inherit inputs; };
                modules = (builtins.attrValues nixosModules) ++ [
                  ./hosts/r2d2
                  home-manager.nixosModules.home-manager
                  {
                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      extraSpecialArgs = { inherit inputs; };
                      users.mhelton.imports = [
                        ./home/mhelton
                        ./home/mhelton/personal.nix
                        ./home/mhelton/linux.nix
                        ./home/mhelton/graphical.nix
                        ./home/mhelton/gaming.nix
                        ./home/mhelton/framework.nix
                      ];
                    };
                  }
                ];
              }
            );

            L-MHELTON = withSystem "x86_64-linux" (
              { pkgs, ... }:
              nixpkgs.lib.nixosSystem {
                inherit pkgs;
                specialArgs = { inherit inputs; };
                modules = (builtins.attrValues nixosModules) ++ [
                  ./hosts/L-MHELTON
                  home-manager.nixosModules.home-manager
                  {
                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      extraSpecialArgs = { inherit inputs; };
                      users.mhelton.imports = [
                        ./home/mhelton
                        ./home/mhelton/work.nix
                        ./home/mhelton/linux.nix
                        ./home/mhelton/graphical.nix
                      ];
                    };
                  }
                ];
              }
            );
          };

          darwinConfigurations = {
            imubit-morganh-mbp13 = withSystem "aarch64-darwin" (
              { pkgs, ... }:
              darwin.lib.darwinSystem {
                specialArgs = { inherit inputs; };
                modules = (builtins.attrValues darwinModules) ++ [
                  { nixpkgs.pkgs = pkgs; }
                  ./hosts/imubit-morganh-mbp13
                  home-manager.darwinModules.home-manager
                  {
                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      extraSpecialArgs = { inherit inputs; };
                      users.mhelton.imports = [
                        ./home/mhelton
                        ./home/mhelton/work.nix
                        ./home/mhelton/darwin.nix
                      ];
                    };
                  }
                ];
              }
            );
          };
        };

        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ];

      }
    );
}
