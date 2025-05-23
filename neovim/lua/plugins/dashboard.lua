-- lua/plugins/dashboard.lua

return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter", -- Load on VimEnter; Alpha's setup handles conditional display
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- For icons on buttons
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard") -- Common theme

      -- Header: ASCII art or text
      dashboard.section.header.val = {
        [[                                                                                  ]],
        [[   .-''-.                      .--.  .-. .--------.                      .-''-.   ]],
        [[  /      `'''--..              ||  \/  ||'=====. ||              ..--'''`      \  ]],
        [[ |               '.            || .  . ||  .---' ||            .'               | ]],
        [[ |           ..''` '---.       || |\/|_||  '===. ||       .---' `''..           | ]],
        [[ |        .``           ''''\  ||_|\/|.'       |_||  /''''           ``.        | ]],
        [[ /'..   /`              /    /'|_.'            '._|'\    \              `\   ..'\ ]],
        [[ |   `:'         ___..  \   /  /                  \  \   /  ..___         ':`   | ]],
        [[ '____'__...---'':::::\  '-' ./                    \. '-'  \:::::''---...__'____' ]],
        [[   \::/\ \:::::::::::':  ___/                        \___  :':::::::::::/ /\::/   ]],
        [[    \'| \ '-:::--'`  .' /              Rest              \ '.  `'--:::-' / |'/    ]],
        [[    /'|  \    ....''`__/                in                \__`''....    /  |'\    ]],
        [[    \ |   .   |  .-'`   .------. .------..------. .-. .--.   `'-.  |   .   | /    ]],
        [[     \/::.'   |  |      ||  _   V   _   ||   _   V  \/  ||      |  |   '.::\/     ]],
        [[     \':'_.---|  |      || | |  |  | |  ||  | |  | .  . ||      |  |---._':'/     ]],
        [[      \\      |  |      || | |  |   '|  ||  |'   | |\/| ||      |  |      //      ]],
        [[      \\      |  |      || |' .'|'.   .'||'.   .'|'|\/| ||      |  |      //      ]],
        [[       \\      | |      ||  .'.' '.'.'.'  '.'.'.' '|  | ||      | |      //       ]],
        [[       \\      | |      ||.'.'     '.'      '.'       |.||      | |      //       ]],
        [[        \\     |'       |_.'                          '._|       '|     //        ]],
        [[                                                                                  ]],
      }
      dashboard.section.header.opts.hl = "String" -- Highlight group for the header

      -- Buttons/Menu Items
      dashboard.section.buttons.val = {
        dashboard.button("e", "󰈔  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "󰍉  Find file", ":Telescope find_files <CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "grep Grep text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", "  Lazy Sync", ":Lazy sync<CR>"),
        dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end

      -- Footer
      local fortune_ok, fortune = pcall(require, "alpha.fortune")
      if fortune_ok then
        dashboard.section.footer.val = fortune()
      else
        dashboard.section.footer.val = "Neovim Started."
      end
      dashboard.section.footer.opts.hl = "AlphaFooter"

      -- Layout configuration
      dashboard.config.layout = {
        { type = "padding", val = vim.fn.max({ 0, vim.fn.floor(vim.fn.winheight(0) * 0.2) }) },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 2 },
        dashboard.section.footer,
        { type = "padding", val = vim.fn.max({ 0, vim.fn.floor(vim.fn.winheight(0) * 0.1) }) },
      }

      -- You can add more buffer types to ignore for Alpha's auto-start if needed
      -- dashboard.config.ignore_buffer_type = { "neo-tree", "nofile", "alpha", "gitcommit", ... }

      -- Set up alpha with the dashboard theme
      -- Alpha's setup function has built-in logic to only show the dashboard
      -- if Neovim is started without file arguments and no session is loaded.
      alpha.setup(dashboard.config)

      print("alpha-nvim (dashboard) configured.")
    end,
  },
}
