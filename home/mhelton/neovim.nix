{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    withPython3 = true;
    withNodeJs = true;
    extraPackages = with pkgs; [
      ripgrep
      gcc
      stylua
      black
      nodePackages.prettier
      python3Packages.flake8
      google-java-format
      wget
    ];
  };

}
