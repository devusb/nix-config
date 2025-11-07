{ pkgs, ... }:
{
  viAlias = true;
  vimAlias = true;
  globals.mapleader = ",";
  opts = {
    number = true;
    foldlevelstart = 99;
  };
  diagnostic.settings = {
    virtual_lines = true;
  };
  plugins = {
    nix.enable = true;
    treesitter = {
      enable = true;
      folding = true;
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
        nil_ls = {
          enable = true;
          settings = {
            nix.flake.autoArchive = true;
          };
        };
        terraformls.enable = true;
        gopls.enable = true;
        pyright.enable = true;
        yamlls.enable = true;
        tinymist.enable = true;
        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
        };
      };
      keymaps.lspBuf = {
        "gd" = "definition";
        "gD" = "references";
        "gt" = "type_definition";
        "gi" = "implementation";
        "K" = "hover";
      };
    };
    lsp-lines.enable = true;
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
    };
    web-devicons.enable = true;
    gitblame.enable = true;
    markview.enable = true;
    hardtime = {
      enable = true;
      settings = {
        disable_mouse = false;
        restriction_mode = "hint";
        notifcation = false;
      };
    };
  };
  extraConfigLua = ''
    vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
    vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')
  '';
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
    {
      key = "<leader>d";
      action = "<CMD>lua print(vim.inspect(vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })))<CR>";
    }
    {
      key = "<leader>y";
      action = ''"+y'';
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
