{ inputs, ... }:
let
  inherit (builtins) mapAttrs attrValues;
  inherit (inputs.nixpkgs.lib) nixosSystem mapAttrs' nameValuePair forEach;
in
{
  importAttrset = path: builtins.mapAttrs (_: import) (import path);

  mkSystem =
    { hostname
    , overlays ? { }
    , system
    , users ? [ ]
    }:
    nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs system hostname;
      };
      modules = builtins.attrValues (import ../modules/nixos) ++ [
        ../hosts/${hostname}
        {
          networking.hostName = hostname;
          # Apply overlay and allow unfree packages
          nixpkgs = {
            overlays = attrValues overlays;
            config.allowUnfree = true;
          };
          # Add each input as a registry
          nix.registry = mapAttrs'
            (n: v:
              nameValuePair n { flake = v; })
            inputs;
        }
        # System wide config for each user
      ] ++ forEach users
        (u: ../users/${u}/system);
    };

  mkDarwinSystem =
    { hostname
    , overlays ? { }
    , system
    , users ? [ ]
    }:
    inputs.darwin.lib.darwinSystem {
      inherit system;
      specialArgs = {
        inherit inputs system hostname;
      };
      modules = builtins.attrValues (import ../modules/darwin) ++ [
        ../hosts/${hostname}
        {
          networking.hostName = hostname;
          # Apply overlay and allow unfree packages
          nixpkgs = {
            overlays = attrValues overlays;
            config.allowUnfree = true;
          };
          # Add each input as a registry
          nix.registry = mapAttrs'
            (n: v:
              nameValuePair n { flake = v; })
            inputs;
        }
      ];
    };

  mkHome =
    { username
    , system
    , overlays ? { }
    , hostname
    , graphical ? false
    , gaming ? false
    , work ? false
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit username system;
      pkgs = builtins.getAttr system inputs.nixpkgs.outputs.legacyPackages;
      extraSpecialArgs = {
        inherit system hostname graphical gaming work inputs;
      };
      homeDirectory = if system == "aarch64-darwin" then "/Users/${username}" else "/home/${username}";
      configuration = ../users/${username}/home;
      extraModules = builtins.attrValues (import ../modules/home-manager) ++ [
        # Base configuration
        {
          nixpkgs = {
            overlays = attrValues overlays;
            config.allowUnfree = true;
          };
          programs = {
            home-manager.enable = true;
            git.enable = true;
          };
          systemd.user.startServices = "sd-switch";
        }
      ];
    };
}
