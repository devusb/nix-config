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
    home-manager.inputs.flake-compat.follows = "flake-compat";
    home-manager.inputs.utils.follows = "utils";

    # nix-darwin
    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # nixos-wsl
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.flake-utils.follows = "utils";
    nixos-wsl.inputs.flake-compat.follows = "flake-compat";

    # mpack
    mpack.url = "github:league/mpack";
    mpack.inputs.nixpkgs.follows = "nixpkgs";

    # mach-nix
    mach-nix.url = "github:DavHau/mach-nix";
    mach-nix.inputs.flake-utils.follows = "utils";
    mach-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    let
      my-lib = import ./lib { inherit inputs; };
      inherit (builtins) attrValues mapAttrs;
      inherit (my-lib) mkSystem mkHome mkDarwinSystem mkDeploy importAttrset;
      inherit (inputs.nixpkgs.lib) genAttrs systems;
      forAllSystems = genAttrs systems.flakeExposed;
    in
    rec {
      overlays = {
        default = import ./overlays { inherit inputs; };
      };

      nixosModules = importAttrset ./modules/nixos;
      homeManagerModules = importAttrset ./modules/home-manager;

      packages = forAllSystems (system:
        import inputs.nixpkgs { inherit system; overlays = attrValues overlays; }
      );

      devShells = forAllSystems (system: {
        default = import ./shell.nix { pkgs = packages.${system}; };
      });

      # System configurations
      # Accessible via 'nixos-rebuild --flake'
      nixosConfigurations = {
        tomservo = mkSystem {
          inherit overlays;
          hostname = "tomservo";
          system = "x86_64-linux";
          users = [ "mhelton" ];
        };
      };

      darwinConfigurations = {
        superintendent = mkDarwinSystem {
          inherit overlays;
          hostname = "superintendent";
          system = "aarch64-darwin";
        };
        imubit-morganh-mbp13 = mkDarwinSystem {
          inherit overlays;
          hostname = "imubit-morganh-mbp13";
          system = "aarch64-darwin";
        };
      };

      homeConfigurations = {
        "mhelton@tomservo" = mkHome {
          inherit overlays;
          username = "mhelton";
          system = "x86_64-linux";
          hostname = "tomservo";
          graphical = true;
          gaming = true;
        };
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
