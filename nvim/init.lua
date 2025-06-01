-- if vim.fn.has "nvim-0.11" == 0 then error "Need Neovim 0.11+ in order to use this config" end

-- init.lua
require "core.options"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup {
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "cyberdream" } },
  checker = { enabled = true },
}

require "core.autocommands"
require "core.keymaps"

vim.cmd("colorscheme cyberdream")
