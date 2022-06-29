{ inputs, lib, config, pkgs, hostname, graphical, gaming, system, work, ... }: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors), use something like:
    # inputs.nix-colors.homeManagerModule
    ./zsh.nix
    ./packages.nix
  ]
  ++ (if graphical == true then [ ./graphical.nix ] else [ ])
  ++ (if gaming == true then [ ./gaming.nix ] else [ ])
  ++ (if system == "aarch64-linux" then [ ./aarch64-vm.nix ] else [ ])
  ++ (if work == true then [ ./work.nix ] else [ ./personal.nix ])
  ++ (if system != "aarch64-darwin" then [ ./linuxPackages.nix ] else [ ./darwin.nix ]);

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "micro";
  };
}
