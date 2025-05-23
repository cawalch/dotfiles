-- lua/plugins/linting.lua

return {
  {
    "mfussenegger/nvim-lint",
    event = {
      "BufWritePost",
      "BufEnter",
    },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "biomejs" },
        typescript = { "biomejs" },
        python = { "ruff" },
        lua = { "luacheck" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        markdown = { "markdownlint" },
        yaml = { "yamllint" },
        go = { "golangcilint" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("nvim-lint-autogroup", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
        group = lint_augroup,
        pattern = "*",
        callback = function(args)
          if lint.linters_by_ft[vim.bo[args.buf].filetype] then
            lint.try_lint()
          end
        end,
        desc = "Run nvim-lint on buffer events",
      })
    end,
  },
}
