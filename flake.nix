{
  description = "You new nix config";

  inputs = {
    # Utilities for building flakes
    utils.url = "github:numtide/flake-utils";

    # Core nix flakes
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
        imubit-morgan = lib.mkSystem {
          hostname = "imubit-morgan";
          system = "x86_64-linux";
          users = ["mhelton"];
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
        "mhelton@superintendent-vm" = lib.mkHome {
          username = "mhelton";
          system = "aarch64-linux";
          hostname = "superintendent-vm";
        };
        "mhelton@imubit-morgan" = lib.mkHome {
          username = "mhelton";
          system = "x86_64-linux";
          hostname = "imubit-morgan";
          work = true;
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
