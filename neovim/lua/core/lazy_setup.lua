-- ~/.config/nvim/lua/core/lazy_setup.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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

-- Setup lazy.nvim
-- The first argument "plugins" means lazy.nvim will look for plugin specs
-- in lua/plugins/*.lua and lua/plugins/*/init.lua
require("lazy").setup("plugins", {
  checker = {
    enabled = true, -- Check for plugin updates
    notify = true, -- Notify when updates are available
  },
  change_detection = {
    notify = true, -- Notify when a plugin has changed locally
  },
})

-- Load core configurations after plugins are potentially set up
require("core.options")
require("core.keymaps")
