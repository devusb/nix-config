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
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

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

    # lix
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixvim
    nixvim.url = "github:nix-community/nixvim";

    # disko
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # lanzaboote
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    # Jovian-NixOS
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
  };

  outputs = { self, nixpkgs, home-manager, darwin, flake-parts, hercules-ci-effects, nixvim, ... }@inputs:
    let
      patches = [
        {
          url = "https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/341219.diff";
          hash = "sha256-m/mvZAuPF+pVOE5OvZocwMtXUdLL930BKnB407oRqhk=";
        }
      ];
    in
    flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, ... }: {
      imports = [
        hercules-ci-effects.flakeModule
        hercules-ci-effects.push-cache-effect
      ];

      perSystem = { pkgs, system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nixvimModule = {
            inherit pkgs;
            module = import ./home/mhelton/nixvim.nix { inherit pkgs; };
          };
          originPkgs = nixpkgs.legacyPackages."x86_64-linux";
          patchedPkgs = originPkgs.applyPatches {
            name = "nixpkgs-patched";
            src = nixpkgs;
            patches = map originPkgs.fetchpatch patches;
          };
        in
        rec {
          legacyPackages =
            import patchedPkgs {
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

          checks = {
            nvim = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
          };

          formatter = legacyPackages.nixpkgs-fmt;

          packages = {
            nvim = nixvim'.makeNixvimWithModule nixvimModule;
          };
        };

      flake = rec {
        overlays = {
          default = import ./overlays { inherit inputs; };
        };

        nixosModules = import ./modules/nixos;

        nixosConfigurations = {
          tomservo = withSystem "x86_64-linux" ({ pkgs, ... }: nixpkgs.lib.nixosSystem {
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
          });

          durandal = withSystem "x86_64-linux" ({ pkgs, ... }: nixpkgs.lib.nixosSystem {
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
          });

          bob =
            withSystem "x86_64-linux" ({ pkgs, ... }: nixpkgs.lib.nixosSystem {
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
            });

          r2d2 =
            withSystem "x86_64-linux" ({ pkgs, ... }: nixpkgs.lib.nixosSystem {
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
            });
        };

        darwinConfigurations = {
          imubit-morganh-mbp13 = withSystem "aarch64-darwin" ({ pkgs, ... }: darwin.lib.darwinSystem {
            specialArgs = { inherit inputs; };
            modules = [
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
          });
        };
      };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      herculesCI = { ... }: {
        ciSystems = [ "x86_64-linux" ];
      };

      push-cache-effect =
        let
          pushConfigurations = [ "tomservo" "durandal" "bob" "r2d2" ];
        in
        {
          enable = true;
          attic-client-pkg = nixpkgs.legacyPackages.x86_64-linux.attic-client;
          caches.r2d2 = {
            type = "attic";
            secretName = "attic";
            packages = map (host: self.nixosConfigurations."${host}".config.system.build.toplevel) pushConfigurations;
          };
        };

    });
}
