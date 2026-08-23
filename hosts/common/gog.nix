{ inputs, ... }: {
  imports = [
    inputs.gog-nix.nixosModules.gog
  ];

  programs.gog = {
    enable = true;
    serverUrl = "https://chopper.springhare-egret.ts.net:6060";
    games.soma.enable = true;
  };

}
