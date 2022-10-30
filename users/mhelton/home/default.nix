{ inputs, lib, config, pkgs, system, graphical, gaming, work, ... }: {
  imports = [
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
