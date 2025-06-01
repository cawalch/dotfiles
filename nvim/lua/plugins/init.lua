return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = false
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },
  {
    "mason-org/mason.nvim",
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    ensure_installed = {
      "bashls",
      "lua_ls",
      "ts_ls",
      "ast_grep",
      "gopls",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    run = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    config = function()
      local treesitter = require "nvim-treesitter.configs"
      treesitter.setup {
        highlight = {
          enable = true,
        },
        indent = { enable = true },
        autotag = {
          enable = true,
        },
        ensure_installed = {
          "json",
          "markdown",
          "markdown_inline",
          "javascript",
          "typescript",
          "rust",
          "yaml",
          "html",
          "css",
          "go",
          "bash",
          "lua",
          "vim",
          "dockerfile",
          "gitignore",
          "gitcommit",
          "query",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
      },
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require "cmp"
      local luasnip = require "luasnip"
      local lspkind = require "lspkind"
      require("luasnip.loaders.from_vscode").lazy_load()
      local function border(hl_name)
        return {
          { "╭", hl_name },
          { "─", hl_name },
          { "╮", hl_name },
          { "│", hl_name },
          { "╯", hl_name },
          { "─", hl_name },
          { "╰", hl_name },
          { "│", hl_name },
        }
      end
      cmp.setup {
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
          ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp", max_item_count = 10 },
          { name = "codecompanion", max_item_count = 10 },
          { name = "luasnip", max_item_count = 5 },
          { name = "buffer", max_item_count = 8 },
          { name = "path", max_item_count = 5 },
        },
        formatting = {
          format = lspkind.cmp_format {
            maxwidth = 50,
            ellipsis_char = "...",
          },
        },
        window = {
          completion = cmp.config.window.bordered(border "CmpBorder"),
          documentation = cmp.config.window.bordered(border "CmpDocBorder"),
        },
      }
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local cmp_nvim_lsp = require "cmp_nvim_lsp"
      local capabilities = cmp_nvim_lsp.default_capabilities()
      vim.lsp.config("lua_ls", {
        settings = {
          ["lua_ls"] = {
            capabilities = capabilities,
            filetypes = { "lua" },
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
                completion = {
                  callSnippet = "Replace",
                },
              },
            },
          },
        },
      })

      vim.diagnostic.config {
        signs = {
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
          },
          text = {
            [vim.diagnostic.severity.ERROR] = "X",
            [vim.diagnostic.severity.HINT] = "?",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.WARN] = "!",
          },
        },
        update_in_insert = true,
        virtual_text = false,
        virtual_lines = { current_line = true },
      }
    end,
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "mason-org/mason.nvim",
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  },
  {
    "folke/nvim-notify",
    config = function()
      require("notify").setup {
        background_colour = "#000000",
        time_formats = {
          notification = "%I:%M",
          notification_history = "%FT%T",
        },
      }
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        bottom_search = false,
        command_palette = true,
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup {
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = require("telescope.actions").move_selection_next,
              ["<C-k>"] = require("telescope.actions").move_selection_previous,
            },
          },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup {
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
        formatters_by_ft = {
          lua = { "stylua" },
          javascript = { "biome" },
          typescript = { "biome" },
          css = { "prettier" },
          python = { "black" },
          json = { "biome" },
          yaml = { "prettier" },
          html = { "prettier" },
          sh = { "shfmt" },
          go = { "gofmt", "golines" },
        },
      }
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require "null-ls"

      local function has_biome_config()
        local biome_config_files = { ".biomerc", "biome.config.js", "biome.config.json", "biome.jsonc", "biome.json" }
        for _, file in ipairs(biome_config_files) do
          if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. file) == 1 then
            return true
          end
        end
        return false
      end

      local sources = {
        has_biome_config() and null_ls.builtins.formatting.biome or null_ls.builtins.formatting.prettier,
        -- null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.diagnostics.golangci_lint,
        null_ls.builtins.diagnostics.staticcheck,
      }

      -- formatting on save
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      -- Formatter
      local lsp_formatting = function()
        vim.lsp.buf.format {
          filter = function(client)
            return client.name == "null-ls"
          end,
          async = false,
        }
      end

      null_ls.setup {
        sources = sources,
        on_attach = function(client, bufnr)
          if client.supports_method "textDocument/formatting" then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                lsp_formatting()
              end,
            })
          end
        end,
        debug = false,
      }
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons", opt = true },
    config = function()
      require("lualine").setup {
        options = { theme = "cyberdream" },
      }
    end,
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "┊",
        tab_char = "┊",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = { "help", "neo-tree", "lazy", "mason" },
      },
    },
  },
  {
    "tpope/vim-fugitive",
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup {
        on_attach = function(bufnr)
          local gitsigns = require "gitsigns"

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal { "]c", bang = true }
            else
              gitsigns.nav_hunk "next"
            end
          end, { desc = "Next Hunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal { "[c", bang = true }
            else
              gitsigns.nav_hunk "prev"
            end
          end, { desc = "Previous Hunk" })

          -- Actions
          map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
          map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Hunk" })

          map("v", "<leader>hs", function()
            gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
          end, { desc = "Stage Selected Lines" })

          map("v", "<leader>hr", function()
            gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
          end, { desc = "Reset Selected Lines" })

          map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
          map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
          map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
          map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview Hunk Inline" })

          map("n", "<leader>hb", function()
            gitsigns.blame_line { full = true }
          end, { desc = "Blame Line (Full)" })

          map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff This" })

          map("n", "<leader>hD", function()
            gitsigns.diffthis "~"
          end, { desc = "Diff This ~" })

          map("n", "<leader>hQ", function()
            gitsigns.setqflist "all"
          end, { desc = "Set Quickfix List (All Hunks)" })
          map("n", "<leader>hq", gitsigns.setqflist, { desc = "Set Quickfix List (Current Hunk)" })

          -- Toggles
          map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle Current Line Blame" })
          map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle Word Diff" })

          -- Text object
          map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select Hunk (Inner)" })
        end,
      }
    end,
  },
  { "augmentcode/augment.vim" },
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup {
        adapters = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = vim.env.GEMINI_API_KEY,
              },
              schema = {
                model = {
                  default = "gemini-2.5-flash-preview-04-17",
                },
              },
            })
          end,
        },
        strategies = {
          chat = {
            adapter = "gemini",
          },
          inline = {
            adapter = "gemini",
          },
          cmd = {
            adapter = "gemini",
          },
        },
      }
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  },
}
