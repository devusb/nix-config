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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    # Home manager flake
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # nix-packages
    nix-packages.url = "github:devusb/nix-packages";
    nix-packages.inputs.nixpkgs.follows = "nixpkgs";

    # hercules-ci
    hercules-ci-effects.url = "github:mlabs-haskell/hercules-ci-effects/push-cache-effect";

    # mpack
    mpack.url = "github:league/mpack";
    mpack.inputs.nixpkgs.follows = "nixpkgs";

    # colmena
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs";
    colmena.inputs.flake-utils.follows = "utils";
    colmena.inputs.flake-compat.follows = "flake-compat";

    # attic
    attic.url = "github:zhaofengli/attic";

    # nixvim
    nixvim.url = "github:pta2002/nixvim";

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

    # sops-nix
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    # Jovian-NixOS
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";

    # chaotic-nyx
    chaotic.url = "github:chaotic-cx/nyx";

    # deckbd
    deckbd.url = "github:Ninlives/deckbd";
    deckbd.inputs.nixpkgs.follows = "nixpkgs";

    # kde2nix
    kde2nix.url = "github:nix-community/kde2nix";
    kde2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, darwin, flake-parts, hercules-ci-effects, attic, ... }@inputs:
    let
      inherit (inputs.nixpkgs.lib) genAttrs;
      inherit (self) outputs;
      forAllSystems = genAttrs [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        hercules-ci-effects.flakeModule
        hercules-ci-effects.push-cache-effect
      ];

      flake = rec {
        overlays = {
          default = import ./overlays { inherit inputs; };
        };

        nixosModules = import ./modules/nixos;
        darwinModules = import ./modules/darwin;
        homeManagerModules = import ./modules/home-manager;

        # allow for extra overlays to be added later
        legacyPackagesWithOverlays = { extraOverlays ? [ ] }: (forAllSystems (system:
          import nixpkgs {
            inherit system;
            overlays = builtins.attrValues {
              default = inputs.nixpkgs.lib.composeManyExtensions ([ (import ./overlays { inherit inputs; }) ] ++ extraOverlays);
            };
            config.allowUnfree = true;
            config.permittedInsecurePackages = [
              "electron-24.8.6"
              "electron-25.9.0"
            ];
          }
        ));
        # but create one with normal overlays if not
        legacyPackages = legacyPackagesWithOverlays { };

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
                    ./home/mhelton/gaming.nix
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

          bob =
            nixpkgs.lib.nixosSystem {
              pkgs = legacyPackages."x86_64-linux";
              specialArgs = { inherit inputs outputs; };
              modules = [
                ./hosts/bob
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
            specialArgs = { inherit inputs outputs; };
            modules = [
              { nixpkgs.pkgs = legacyPackages."aarch64-darwin"; }
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
            specialArgs = { inherit inputs outputs; };
            modules = [
              { nixpkgs.pkgs = legacyPackages."aarch64-darwin"; }
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

      };

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      herculesCI = { config, lib, ... }: {
        ciSystems = [ "x86_64-linux" ];
      };

      push-cache-effect = {
        enable = true;
        attic-client-pkg = attic.packages.x86_64-linux.attic-client;
        caches.r2d2 = {
          type = "attic";
          secretName = "attic";
          packages = map (host: self.nixosConfigurations."${host}".config.system.build.toplevel) (builtins.attrNames self.nixosConfigurations);
        };
      };

    };
}
