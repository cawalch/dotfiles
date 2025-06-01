local api = vim.api
local g = vim.g
local lsp = vim.lsp

api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    -- Basic hidden files pattern
    local hide_pattern = "\\(^\\|\\s\\s\\)\\zs\\.\\S\\+"

    -- Try to get gitignore patterns if available
    local ok, gitignore_hide = pcall(vim.fn["netrw_gitignore#Hide"])
    if ok and gitignore_hide and gitignore_hide ~= "" then
      g.netrw_list_hide = gitignore_hide .. "," .. hide_pattern
    else
      g.netrw_list_hide = hide_pattern
    end

    -- Additional netrw settings for better UX
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.cursorline = true
  end,
})

-- Highlight yanked text
api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})

-- Auto-create directories when saving files
api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local dir = vim.fn.expand "<afile>:p:h"
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Set specific options for different file types
api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "json" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Terminal settings
api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    -- Auto enter insert mode
    vim.cmd "startinsert"
  end,
})

-- Auto-close terminal when process exits
api.nvim_create_autocmd("TermClose", {
  callback = function()
    vim.cmd "bdelete!"
  end,
})

-- Debounce LSP formatting for better performance
local format_timer = nil
local buffer_autoformat = function(bufnr)
  local group = "lsp_autoformat"
  api.nvim_create_augroup(group, { clear = false })
  api.nvim_clear_autocmds { group = group, buffer = bufnr }

  api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    group = group,
    desc = "LSP format on save",
    callback = function()
      if format_timer then
        format_timer:stop()
      end

      format_timer = vim.defer_fn(function()
        lsp.buf.format { async = false, timeout_ms = 10000 }
      end, 100)
    end,
  })
end
