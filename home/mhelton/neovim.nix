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
      bufferline.enable = true;
      indent-blankline.enable = true;
      fugitive.enable = true;
      lualine = {
        enable = true;
        theme = "gruvbox-material";
      };
      commentary.enable = true;
      lsp = {
        enable = true;
        servers = {
          rnix-lsp = {
            enable = true;
            autostart = true;
          };
        };
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
      "<leader>ft" = "<CMD>Telescope find_files<CR>";
      "<leader>fg" = "<CMD>Telescope live_grep<CR>";
      "j" = "gj";
      "k" = "gk";
      "<leader>tt" = "<CMD>NeoTreeShowToggle<CR>";
    };
    maps.terminal = {
      "<esc><esc>" = "<C-\\><C-N>";
    };
    autoCmd = [
      {
        event = [ "TermOpen" ];
        pattern = [ "*" ];
        command = "startinsert";
      }
    ];
  };

}
