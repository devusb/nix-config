{ inputs, pkgs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = {
      treesitter.enable = true;
      telescope.enable = true;
    };
    colorschemes = {
      gruvbox.enable = true;
    };
  };

}
