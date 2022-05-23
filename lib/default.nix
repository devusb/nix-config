{ inputs, overlays }:
{
  importAttrset = path: builtins.mapAttrs (_: import) (import path);

  mkSystem =
    { hostname
    , system
    , users ? [ ]
    }:
    inputs.nixpkgs.lib.nixosSystem {
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
            inherit overlays;
            config.allowUnfree = true;
          };
          # Add each input as a registry
          nix.registry = inputs.nixpkgs.lib.mapAttrs'
            (n: v:
              inputs.nixpkgs.lib.nameValuePair n { flake = v; })
            inputs;
        }
        # System wide config for each user
      ] ++ inputs.nixpkgs.lib.forEach users
        (u: ../users/${u}/system);
    };

  mkDarwinSystem =
    { hostname
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
            inherit overlays;
            config.allowUnfree = true;
          };
          # Add each input as a registry
          nix.registry = inputs.nixpkgs.lib.mapAttrs'
            (n: v:
              inputs.nixpkgs.lib.nameValuePair n { flake = v; })
            inputs;
        }
      ];
    };

  mkHome =
    { username
    , system
    , hostname
    , graphical ? false
    , gaming ? false
    , work ? false
    , homeDirectory ? "/home/${username}"
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit username system homeDirectory;
      extraSpecialArgs = {
        inherit system hostname graphical gaming work inputs;
      };
      configuration = ../users/${username}/home;
      extraModules = builtins.attrValues (import ../modules/home-manager) ++ [
        # Base configuration
        {
          nixpkgs = {
            inherit overlays;
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
