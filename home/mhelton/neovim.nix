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
      nvim-autopairs = {
        enable = true;
        checkTs = true;
      };
      neo-tree = {
        enable = true;
      };
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
