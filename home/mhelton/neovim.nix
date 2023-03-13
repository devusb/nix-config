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

  xdg.configFile.nvim.source = pkgs.fetchFromGitHub {
    owner = "LunarVim";
    repo = "nvim-basic-ide";
    rev = "6eb2c3c4cc42d7bb113ed5cfb07a88b99e86ae3c";
    sha256 = "sha256-7Q+ANmis9kVuKeCRAC87JvoE1Af1Tawjl6Iyxmik/cY=";
  };
}
