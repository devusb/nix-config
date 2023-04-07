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
      luasnip.enable = true;
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
          terraformls = {
            enable = true;
            autostart = true;
          };
        };
      };
      nvim-cmp = {
        enable = true;
        autoEnableSources = true;
        sources = [{ name = "nvim_lsp"; }];
        snippet.expand = "luasnip";
        mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = {
            modes = [ "i" "s" ];
            action = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expandable() then
                  luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                elseif check_backspace() then
                  fallback()
                else
                  fallback()
                end
              end
            '';
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
