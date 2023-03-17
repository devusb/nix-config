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
      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
        extensions.fzf-native.fuzzy = true;
      };
      nvim-autopairs = {
        enable = true;
        checkTs = true;
      };
      neo-tree.enable = true;
      barbar.enable = true;
      indent-blankline.enable = true;
      fugitive.enable = true;
      lualine = {
        enable = true;
        theme = "gruvbox-material";
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      editorconfig-nvim
      indent-o-matic
    ];
    colorschemes = {
      gruvbox.enable = true;
    };
    maps.normal = {
      "<leader>t" = "<CMD>NeoTreeShowToggle<CR>";
      "<leader>ft" = "<CMD>Telescope find_files<CR>";
      "<leader>fg" = "<CMD>Telescope grep_string<CR>";
      "j" = "gj";
      "k" = "gk";
    };
  };

}
