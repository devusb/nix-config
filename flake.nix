{
  description = "You new nix config";

  inputs = {
    # Utilities for building flakes
    utils.url = "github:numtide/flake-utils";

    # Core nix flakes
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    hardware.url = "github:nixos/nixos-hardware";

    # Home manager flake
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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

      #nixosModules = lib.importAttrset ./modules/nixos;
      #homeManagerModules = lib.importAttrset ./modules/home-manager;

      # System configurations
      # Accessible via 'nixos-rebuild --flake'
      nixosConfigurations = {
        tomservo = lib.mkSystem {
          hostname = "tomservo";
          system = "x86_64-linux";
          users = ["mhelton"];
        };
        superintendent-vm = lib.mkSystem {
          hostname = "superintendent-vm";
          system = "aarch64-linux";
          users = ["mhelton"];
        };
      };

      homeConfigurations = {
        "mhelton@tomservo" = lib.mkHome {
          username = "mhelton";
          system = "x86_64-linux";
          hostname = "tomservo";
        };
        "mhelton@superintendent-vm" = lib.mkHome {
          username = "mhelton";
          system = "aarch64-linux";
          hostname = "superintendent-vm";
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
