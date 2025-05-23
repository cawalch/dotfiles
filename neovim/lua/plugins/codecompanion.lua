return {
  {
    "olimorris/codecompanion.nvim",
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup({
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
            slash_commands = {
              codebase = require("vectorcode.integrations").codecompanion.chat.make_slash_command(),
            },
            tools = {
              vectorcode = {
                description = "Run VectorCode to retrieve the project context.",
                callback = require("vectorcode.integrations").codecompanion.chat.make_tool(),
              },
            },
          },
          inline = {
            adapter = "gemini",
          },
          cmd = {
            adapter = "gemini",
          },
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              show_result_in_chat = true,
              make_vars = true,
              make_slash_commands = true,
            },
          },
        },
      })
    end,
  },
}
