-- lua/plugins/gitsigns.lua

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- Load early to show signs when opening files
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "▎" }, -- Alternatives: '│', '┃', '~'
        untracked = { text = "┆" }, -- Alternatives: '┊', ' unexplored '
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = true, -- Toggle with `:Gitsigns toggle_numhl` - Highlight the line number
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl` - Highlight the changed line background
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        follow_files = true,
      },
      auto_attach = true,
      attach_to_untracked = true,
      current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'inline'
        delay = 500,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Next Hunk (Gitsigns)" })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Previous Hunk (Gitsigns)" })

        map({ "n", "v" }, "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk (Gitsigns)" })
        map({ "n", "v" }, "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk (Gitsigns)" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage Buffer (Gitsigns)" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk (Gitsigns)" })
        map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset Buffer (Gitsigns)" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk (Gitsigns)" })
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, { desc = "Blame Line (Gitsigns)" })
        map("n", "<leader>htb", gs.toggle_current_line_blame, { desc = "Toggle Line Blame (Gitsigns)" })
        map("n", "<leader>hd", gs.diffthis, { desc = "Diff This (Gitsigns)" })
        map("n", "<leader>hD", function()
          gs.diffthis("~")
        end, { desc = "Diff This ~ (Gitsigns)" })
        map("n", "<leader>htd", gs.toggle_deleted, { desc = "Toggle Deleted (Gitsigns)" })

        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk (Gitsigns)" })
      end,
    },
  },
}
