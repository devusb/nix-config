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
  };

  outputs = inputs: 
    let
      overlay = import ./overlays;
      overlays = with inputs; [
        overlay
      ];
      lib = import ./lib { inherit inputs overlays; };
    in
    {
      inherit overlay overlays;

      nixosModules = lib.importAttrset ./modules/nixos;
      homeManagerModules = lib.importAttrset ./modules/home-manager;

      # System configurations
      # Accessible via 'nixos-rebuild --flake'
      nixosConfigurations = {
        tomservo = lib.mkSystem {
          hostname = "tomservo";
          system = "x86_64-linux";
          users = ["mhelton"];
        };
        imubit-morgan = lib.mkSystem {
          hostname = "imubit-morgan";
          system = "x86_64-linux";
          users = ["mhelton"];
        };
      };

      darwinConfigurations = {
        superintendent = lib.mkDarwinSystem {
          hostname = "superintendent";
          system = "aarch64-darwin";
        };
      };

      homeConfigurations = {
        "mhelton@tomservo" = lib.mkHome {
          username = "mhelton";
          system = "x86_64-linux";
          hostname = "tomservo";
          graphical = true;
          gaming = true;
        };
        "mhelton@imubit-morgan" = lib.mkHome {
          username = "mhelton";
          system = "x86_64-linux";
          hostname = "imubit-morgan";
          work = true;
        };
        "mhelton@superintendent" = lib.mkHome {
          username = "mhelton";
          system = "aarch64-darwin";
          hostname = "superintendent";
        };
      };
  }

  // inputs.utils.lib.eachDefaultSystem (system:
    let
      pkgs = import inputs.nixpkgs { inherit system overlays; };
    in
    {
      # Your custom packages, plus nixpkgs and overlayed stuff
      # Accessible via 'nix build .#example' or 'nix build .#nixpkgs.example'
      packages = pkgs;

      # Devshell for bootstrapping plus editor utilities (fmt and LSP)
      # Accessible via 'nix develop'
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [ home-manager git ];
          NIX_CONFIG = "experimental-features = nix-command flakes";
        };
    });
}
