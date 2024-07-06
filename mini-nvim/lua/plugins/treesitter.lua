require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"go",
		"lua",
		"markdown",
		"markdown_inline",
		"vim",
		"vimdoc",
		"query",
		"python",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
	},
	ignore_install = { "" },
	indent = {
		enable = true,
		disable = { "ruby" },
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
})
