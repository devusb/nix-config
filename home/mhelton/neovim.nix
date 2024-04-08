{ inputs, pkgs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    globals.mapleader = ",";
    opts = {
      number = true;
      clipboard = "unnamedplus";
    };
    plugins = {
      nix.enable = true;
      treesitter.enable = true;
      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
        extensions.fzf-native.settings.fuzzy = true;
      };
      nvim-autopairs = {
        enable = true;
        checkTs = true;
      };
      oil = {
        enable = true;
      };
      bufferline.enable = true;
      indent-blankline.enable = true;
      lualine = {
        enable = true;
        theme = "gruvbox-material";
      };
      commentary.enable = true;
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = true;
          terraformls.enable = true;
          gopls.enable = true;
          pyright.enable = true;
        };
        keymaps.lspBuf = {
          "gd" = "definition";
          "gD" = "references";
          "gt" = "type_definition";
          "gi" = "implementation";
          "K" = "hover";
        };
      };
      luasnip.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
          ];
          mapping.__raw = ''
            cmp.mapping.preset.insert({
              ['<C-d>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<CR>'] = cmp.mapping.confirm({ select = true }),
            })
          '';
        };
      };
      nvim-osc52 = {
        enable = true;
        keymaps.enable = true;
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      editorconfig-nvim
      indent-o-matic
      leap-nvim
    ];
    extraConfigLua = ''
      require('leap').add_default_mappings()
    '';
    colorschemes = {
      gruvbox.enable = true;
    };
    keymaps = [
      {
        key = "<leader>ft";
        action = "<CMD>Telescope find_files<CR>";
      }
      {
        key = "<leader>fg";
        action = "<CMD>Telescope live_grep<CR>";
      }
      {
        key = "j";
        action = "gj";
      }
      {
        key = "k";
        action = "gk";
      }
      {
        key = "<leader>o";
        action = "<CMD>Oil --float .<CR>";
      }
      {
        mode = "t";
        key = "<esc><esc>";
        action = "<C-\\><C-N>";
      }
    ];
    autoCmd = [
      {
        event = [ "TermOpen" ];
        pattern = [ "*" ];
        command = "startinsert";
      }
    ];
  };

}
