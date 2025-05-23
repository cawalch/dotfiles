-- lua/plugins/bufferline.lua

return {
  {
    "akinsho/bufferline.nvim",
    version = "*", -- Or specify a particular version tag
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy", -- Or {"BufAdd", "BufReadPost"}
    -- Define opts that are simple values here
    opts = {
      options = {
        mode = "buffers",
        themable = true, -- plugin will use far more colors highlights
        numbers = "ordinal",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
          -- icon = '▎', -- Omitted for style_preset.minimal if you choose that
          style = "underline",
        },
        buffer_close_icon = "x",
        modified_icon = "●",
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "slant", -- "slant" | "slope" | "thick" | "thin" | { "any", "any" }
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        sort_by = "id",
        insert_at_end = false,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "left",
            separator = true,
            padding = 1,
          },
        },
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        -- style_preset is removed from here
      },
      highlights = {
        -- Your custom highlight overrides if any
      },
    },
    config = function(_, opts)
      -- `opts` here is the table defined directly above.
      -- Now, require the bufferline module, it's safe to do so here.
      local bufferline_module = require("bufferline")

      -- Add or modify options that require the bufferline module itself.
      -- For example, setting the style_preset:
      if not opts.options then
        opts.options = {}
      end -- Ensure options table exists
      opts.options.style_preset = bufferline_module.style_preset.default
      -- Or, if you prefer another preset:
      -- opts.options.style_preset = bufferline_module.style_preset.minimal
      -- opts.options.style_preset = bufferline_module.style_preset.gruvbox -- etc.

      -- If bufferline.nvim supports string presets like "default" or "minimal"
      -- (some plugins do, but for bufferline it's typically the table from the module),
      -- you could have potentially used a string in the main `opts` table.
      -- But this approach of setting it in `config` is safer and always works.

      bufferline_module.setup(opts)

      -- Keymaps
      vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
      vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
      vim.keymap.set("n", "<leader>bc", "<cmd>bdelete<cr>", { desc = "Close current buffer" })
      vim.keymap.set("n", "<leader>bC", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
      vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close buffers to left" })
      vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Close buffers to right" })

      print("bufferline.nvim configured")
    end,
  },
}
