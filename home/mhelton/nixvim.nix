{ pkgs, ... }: {
  clipboard = {
    register = "unnamedplus";
  };
  viAlias = true;
  vimAlias = true;
  globals.mapleader = ",";
  opts = {
    number = true;
    foldlevelstart = 99;
  };
  plugins = {
    nix.enable = true;
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        incremental.selection.enable = true;
      };
    };
    telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
      extensions.fzf-native.settings.fuzzy = true;
      keymaps = {
        "<leader>b" = "buffers";
        "<leader>ft" = "find_files";
        "<leader>fg" = "live_grep";
      };
    };
    nvim-autopairs = {
      enable = true;
      settings = {
        checkTs = true;
      };
    };
    oil = {
      enable = true;
    };
    bufferline.enable = true;
    indent-blankline.enable = true;
    indent-o-matic.enable = true;
    lualine = {
      enable = true;
      settings.options.theme = "gruvbox-material";
    };
    commentary.enable = true;
    lsp = {
      enable = true;
      servers = {
        nil-ls.enable = true;
        terraformls.enable = true;
        gopls.enable = true;
        pyright.enable = true;
        yamlls.enable = true;
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
    leap = {
      enable = true;
      addDefaultMappings = true;
    };
  };
  extraPackages = with pkgs; [
    ripgrep
  ];
  extraPlugins = with pkgs.vimPlugins; [
    editorconfig-nvim
  ];
  colorschemes = {
    gruvbox.enable = true;
  };
  keymaps = [
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
    {
      key = "<Tab>";
      action = "<CMD>bn<CR>";
    }
    {
      key = "<S-Tab>";
      action = "<CMD>bp<CR>";
    }
  ];
  autoCmd = [
    {
      event = [ "TermOpen" ];
      pattern = [ "*" ];
      command = "startinsert";
    }
  ];

}
