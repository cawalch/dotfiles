-- lua/plugins/notifications.lua

return {
  {
    "rcarriga/nvim-notify",
    -- You can lazy-load it, but often it's good to have it loaded early
    -- if other plugins might show notifications during startup.
    -- event = "VeryLazy",
    -- Or, load it fairly early if you want its `vim.notify` override to be active sooner.
    lazy = false, -- Load it relatively early to ensure vim.notify is overridden.
    opts = {
      -- Animation style: "fade", "slide", "fade_in_slide_out", "static"
      stages = "fade_in_slide_out",

      -- Function called when a new window is opened
      -- on_open = nil,

      -- Function called when a window is closed
      -- on_close = nil,

      -- Default timeout for notifications
      timeout = 3000, -- milliseconds

      -- For stages that change opacity this is treated as the highlight behind the window
      -- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code
      background_colour = "#000000", -- A common choice for a distinct background

      -- Minimum log level to display
      level = "INFO", -- Show INFO, WARN, ERROR (and TRACE, DEBUG if you set lower)

      -- Icons for different levels
      icons = {
        ERROR = "", -- Nerd Font Error Icon
        WARN = "", -- Nerd Font Warning Icon
        INFO = "", -- Nerd Font Info Icon
        DEBUG = "", -- Nerd Font Debug Icon
        TRACE = "✎", -- Nerd Font Trace Icon
      },

      -- Render style: "default", "minimal", "simple", "compact", "wrapped-compact"
      render = "default",

      -- Where the notification windows appear
      top_down = true,

      -- Maximum number of notifications to keep in history
      -- history_length = 100, -- Default is usually fine

      -- Max width of notification windows
      -- max_width = "auto",

      -- Max height of notification windows
      -- max_height = "auto",

      -- Optional:
      -- fps = 30, -- For animations
      -- minimum_width = nil, -- Minimum width of notification windows
      -- stacking_strategy = "left_up", -- How notifications stack
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)

      -- This is the crucial part to make nvim-notify the default handler
      vim.notify = notify

      print("nvim-notify configured and replaced vim.notify.")

      -- Optional: Keymap to dismiss all notifications
      -- You can place this in a general keymaps file if you have one,
      -- or here if you prefer it with the plugin config.
      vim.keymap.set("n", "<leader>un", function()
        notify.dismiss({ silent = true, pending = true })
      end, { desc = "Dismiss all notifications" })

      -- You can also use the command :Notifications to view history
      -- and :NotificationsClear to clear history.
      -- If you have Telescope, you can also load the 'notify' extension:
      -- pcall(require('telescope').load_extension, 'notify')
      -- And then use :Telescope notify
    end,
  },
}
