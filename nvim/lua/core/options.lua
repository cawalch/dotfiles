local opt = vim.opt
local cmd = vim.cmd
local g = vim.g
local indent = 4

cmd [[
	filetype plugin indent on
]]

-- FINDING FILES:
-- Search down into subfolders:
-- Provides tab-completion for all file-related tasks
opt.path:append "**"

-- Display all matching files when we tab complete
opt.clipboard = "unnamedplus"
opt.number = true

opt.backspace = { "eol", "start", "indent" } -- allow backspacing over everything in insert mode
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }

-- indention
opt.autoindent = true -- auto indentation
opt.expandtab = true -- convert tabs to spaces
opt.shiftwidth = indent -- the number of spaces inserted for each indentation
opt.smartindent = true -- make indenting smarter
opt.softtabstop = indent -- when hitting <BS>, pretend like a tab is removed, even if spaces
opt.tabstop = indent -- insert 2 spaces for a tab
opt.shiftround = true -- use multiple of shiftwidth when indenting with "<" and ">"

-- search
opt.hlsearch = true -- highlight all matches on previous search pattern
opt.ignorecase = true -- ignore case in search patterns
opt.smartcase = true -- smart case
opt.wildignore:append({
  "*/node_modules/*",
  "*/.git/*",
  "*/dist/*",
  "*/build/*",
  "*/.next/*",
  "*/.nuxt/*",
  "*/coverage/*",
  "*.log",
  "*.lock"
})

opt.wildmenu = true -- make tab completion for files/buffers act like bash

-- ui
opt.cursorline = true -- highlight the current line
-- opt.lazyredraw = true -- don"t update the display while executing macros
opt.list = true
-- You can also add "space" or "eol", but I feel it"s quite annoying
opt.listchars = {
    tab = "┊ ",
    trail = "·",
    extends = "»",
    precedes = "«",
    nbsp = "×",
}

opt.tabline = "%!v:lua.Tabline()"

function _G.Tabline()
    local s = ""
    for i = 1, vim.fn.bufnr "$" do
        if vim.fn.bufexists(i) == 1 and vim.fn.buflisted(i) == 1 then
            local bufname = vim.fn.fnamemodify(vim.fn.bufname(i), ":t")
            if bufname == "" then bufname = "[No Name]" end
            if i == vim.fn.bufnr() then
                s = s .. "%#TabLineSel#"
            else
                s = s .. "%#TabLine#"
            end
            s = s .. " " .. i .. ": " .. bufname .. " "
        end
    end
    s = s .. "%#TabLineFill#"
    return s
end

-- Hide cmd line
opt.cmdheight = 0 -- more space in the neovim command line for displaying messages

opt.mouse = "a" -- allow the mouse to be used in neovim
opt.scrolloff = 18 -- minimal number of screen lines to keep above and below the cursor
opt.sidescrolloff = 3 -- minimal number of screen columns to keep to the left and right (horizontal) of the cursor if wrap is `false`
opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
opt.splitbelow = true -- open new split below
opt.splitright = true -- open new split to the right
opt.wrap = true -- display a wrapped line

-- backups
opt.backup = false -- create a backup file
opt.swapfile = false -- creates a swapfile
opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited

-- autocomplete
opt.completeopt = { "menu", "menuone", "noselect", "fuzzy" }
opt.shortmess = opt.shortmess + {
    c = true,
} -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"

-- By the way, -- INSERT -- is unnecessary anymore because the mode information is displayed in the statusline.
opt.showmode = false

opt.diffopt:append("linematch:60")
opt.inccommand = "split"

-- perfomance
-- remember N lines in history
opt.history = 100 -- keep 100 lines of history
opt.redrawtime = 100000
opt.timeoutlen = 250 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.ttimeoutlen = 500
opt.updatetime = 250 -- signify default updatetime 4000ms is not good for async update

-- theme
opt.termguicolors = true -- enable 24-bit RGB colors

-- persistent undo
-- Don"t forget to create folder $HOME/.local/share/nvim/undo
local undodir = vim.fn.stdpath "data" .. "/undo"
opt.undofile = true -- enable persistent undo
opt.undodir = undodir
opt.undolevels = 1000
opt.undoreload = 10000

-- fold
opt.foldmethod = "marker"
opt.foldlevel = 99

-- Disable builtin plugins
local disabled_built_ins = {
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
    "tutor",
    "rplugin",
    "synmenu",
    "optwin",
    "compiler",
    "bugreport",
    "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

g.netrw_banner = 0 -- disable annoying banner
g.netrw_browse_split = 4 -- open in prior window
g.netrw_altv = 1 -- open splits to the right
g.netrw_liststyle = 3 -- tree view
