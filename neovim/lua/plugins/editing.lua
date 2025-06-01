-- lua/plugins/editing.lua

local on_attach_custom = function(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

  vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, { buffer = bufnr, desc = "Open diagnostics float" })

  local conform_is_available, conform = pcall(require, "conform")
  local conform_formatters_for_ft = {}

  if conform_is_available then
    conform_formatters_for_ft = conform.list_formatters(bufnr)
  end

  if #conform_formatters_for_ft > 0 then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
  vim.keymap.set("n", "<space>f", function()
    if conform_is_available and #conform_formatters_for_ft > 0 then
      conform.format({ bufnr = bufnr, async = true, lsp_fallback = "never" })
    elseif client.server_capabilities.documentFormattingProvider then
      vim.lsp.buf.format({ bufnr = bufnr, async = true })
    else
      vim.notify("No formatter available (Conform or LSP)", vim.log.levels.WARN)
    end
  end, opts)

  if client.server_capabilities.documentSymbolProvider then
    local navic_is_available, navic = pcall(require, "nvim-navic")
    if navic_is_available then
      navic.attach(client, bufnr)
      vim.api.nvim_set_option_value("winbar", "%{%v:lua.require'nvim-navic'.get_location()%}", { buf = bufnr })
    else
      vim.notify("nvim-navic not found, winbar not set.", vim.log.levels.WARN)
    end
  end
end

return {
  {
    "SmiteshP/nvim-navic",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      icons = {
        File = "󰈔 ",
        Module = " ",
        Namespace = "󰌗 ",
        Package = " ",
        Class = "󰌗 ",
        Method = "󰆧 ",
        Property = " ",
        Field = " ",
        Constructor = " ",
        Enum = "󰌗 ",
        Interface = " ",
        Function = "󰊕 ",
        Variable = " Variablen ",
        Constant = "󰏿 ",
        String = "󰀬 ",
        Number = "󰎠 ",
        Boolean = "◩ ",
        Array = "󰅪 ",
        Object = "󰅩 ",
        Key = "󰌋 ",
        Null = "󰟢 ",
        EnumMember = " ",
        Struct = "󰌗 ",
        Event = "󰆖 ",
        Operator = "󰆕 ",
        TypeParameter = "󰊄 ",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "SmiteshP/nvim-navic",
    },
    config = function()
      vim.diagnostic.config({
        virtual_lines = { only_current_line = false },
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach_custom,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
          },
        },
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach_custom,
        settings = {},
      })
    end,
  },

  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "gopls",
        "ts_ls",
      },
      automatic_installation = true,
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            on_attach = on_attach_custom,
          })
        end,
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Or function() vim.cmd("TSUpdate") end
    event = { "BufReadPre", "BufNewFile" }, -- Load Treesitter early for highlighting
    config = function()
      require("nvim-treesitter.configs").setup({
        ignore_install = {},
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "query",
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "json",
          "yaml",
          "markdown",
          "markdown_inline",
          "bash",
          "python",
          "go",
          "rust",
        },

        sync_install = false,

        auto_install = true,

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        indent = {
          enable = true,
        },
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.core.view:visible() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "minuet" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        performance = {
          fetching_timeout = 2000,
        },
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
  },
}
