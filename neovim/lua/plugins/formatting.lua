-- lua/plugins/formatting.lua

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufNewFile" },
    cmd = { "ConformInfo", "ConformEnable", "ConformDisable" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "black" },
        javascript = { "biome" },
        typescript = { "biome" },
        html = { "prettierd" },
        css = { "prettierd" },
        json = { "prettierd" },
        yaml = { "prettierd" },
        markdown = { "prettierd" },
        go = { "gofumpt", "golines" },
      },

      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = "fallback",
      },

      log_level = vim.log.levels.ERROR,

      notify_on_error = true,

      notify_no_formatters = false,

      formatters = {},
    },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = "fallback" })
        end,
        mode = { "n", "v" },
        desc = "Format buffer/selection",
      },
      {
        "<leader>cdF",
        function()
          vim.b.conform_disable_format_on_save = true
          print("Format on save disabled for this buffer")
        end,
        mode = "n",
        desc = "Disable format on save for buffer",
      },
      {
        "<leader>ceF",
        function()
          vim.b.conform_disable_format_on_save = false
          print("Format on save enabled for this buffer")
          require("conform").format({ async = true, lsp_fallback = "fallback" })
        end,
        mode = "n",
        desc = "Enable format on save for buffer",
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          vim.b.conform_disable_format_on_save = true
          vim.notify("Format on save disabled for current buffer", vim.log.levels.INFO)
        else
          vim.g.conform_disable_format_on_save = true
          vim.notify("Format on save disabled globally", vim.log.levels.INFO)
        end
      end, { desc = "Disable format-on-save (globally or buffer-local with !)", bang = true })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.conform_disable_format_on_save = false
        vim.g.conform_disable_format_on_save = false
        vim.notify("Format on save enabled", vim.log.levels.INFO)
      end, { desc = "Re-enable format-on-save" })
    end,
  },
}
