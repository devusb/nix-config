{ inputs, lib, config, pkgs, hostname, graphical, gaming, system, work, ... }: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors), use something like:
    # inputs.nix-colors.homeManagerModule
    ./zsh.nix
    ./packages.nix
    ./micro.nix
  ]
  ++ (if gaming == true then [ ./gaming.nix ] else [ ])
  ++ (if graphical == true then [ ./graphical.nix ] else [ ])
  ++ (if work == true then [ ./work.nix ] else [ ./personal.nix ])
  ++ (if system == "x86_64-linux" then [ ./linux.nix ] else [ ])
  ++ (if system == "aarch64-darwin" then [ ./darwin.nix ] else [ ]);

  home.stateVersion = "21.11";

  fonts.fontconfig.enable = true;

  home.sessionVariables = {
    EDITOR = "micro";
  };

}
