{ inputs, pkgs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    globals.mapleader = ",";
    options = {
      number = true;
      clipboard = "unnamedplus";
    };
    plugins = {
      treesitter.enable = true;
      telescope.enable = true;
      nvim-autopairs = {
        enable = true;
        checkTs = true;
      };
      neo-tree = {
        enable = true;
      };
      barbar.enable = true;
      lightline.enable = true;
      indent-blankline.enable = true;
    };
    extraPlugins = with pkgs.vimPlugins; [
      editorconfig-nvim
      indent-o-matic
    ];
    colorschemes = {
      gruvbox.enable = true;
    };
  };

}
