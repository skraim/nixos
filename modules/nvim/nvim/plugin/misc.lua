vim.pack.add({
  "https://github.com/yorickpeterse/nvim-window",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/TheNoeTrevino/haunt.nvim",
  "https://github.com/folke/sidekick.nvim",
  "https://github.com/brenoprata10/nvim-highlight-colors",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/folke/trouble.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/bngarren/checkmate.nvim",
  -- { src = "https://github.com/bluz71/vim-nightfly-colors", name = "nightfly" },
  { src = "https://github.com/ThePrimeagen/harpoon",       version = "harpoon2" },
  { src = "https://github.com/s1n7ax/nvim-window-picker",  version = vim.version.range '2.*' },
	{
		src = "https://github.com/rose-pine/neovim",
		name = "rose-pine",
	},
  {
    src = "https://github.com/folke/which-key.nvim",
    data = {
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = true })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    }
  },
  {
    src = "https://github.com/Wansmer/treesj",
    data = { keys = { '<leader>m' } },
  },
});

require("rose-pine").setup({
    variant = "auto", -- auto, main, moon, or dawn
    dark_variant = "main", -- main, moon, or dawn
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true, -- Handle deprecated options automatically
    },

    styles = {
        bold = true,
        italic = false,
        transparency = true,
    },

    groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
    },

    palette = {
        -- Override the builtin palette per variant
        -- moon = {
        --     base = '#18191a',
        --     overlay = '#363738',
        -- },
    },

	-- NOTE: Highlight groups are extended (merged) by default. Disable this
	-- per group via `inherit = false`
    highlight_groups = {
    RenderMarkdownCode = { bg = "none" },
     Cursor = { fg = "love", bg = "rose" },
      CursorInsert = { fg = "love", bg = "foam" },
      CursorVisual = { fg = "love", bg = "iris" },
        -- Comment = { fg = "foam" },
        -- StatusLine = { fg = "love", bg = "love", blend = 15 },
        -- VertSplit = { fg = "muted", bg = "muted" },
        -- Visual = { fg = "base", bg = "text", inherit = false },
    },

    before_highlight = function(group, highlight, palette)
        -- Disable all undercurls
        -- if highlight.undercurl then
        --     highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        --     highlight.fg = palette.foam
        -- end
    end,
})

vim.cmd("colorscheme rose-pine")

require('nvim-highlight-colors').setup({})
require("which-key").setup({ preset = "modern" })
require('checkmate').setup({})
require("trouble").setup {
  keys = {
    ["<c-x>"] = "jump_split"
  }
}
require 'window-picker'.setup({
  -- type of hints you want to get
  -- following types are supported
  -- 'statusline-winbar' | 'floating-big-letter' | 'floating-letter'
  -- 'statusline-winbar' draw on 'statusline' if possible, if not 'winbar' will be
  -- 'floating-big-letter' draw big letter on a floating window
  -- 'floating-letter' draw letter on a floating window
  -- used
  hint = 'floating-big-letter',

  -- when you go to window selection mode, status bar will show one of
  -- following letters on them so you can use that letter to select the window
  selection_chars = 'SHTARENIWFDOLUCP',

  -- whether to show 'Pick window:' prompt
  show_prompt = false,


  -- if you want to manually filter out the windows, pass in a function that
  -- takes two parameters. You should return window ids that should be
  -- included in the selection
  -- EX:-
  -- function(window_ids, filters)
  --    -- folder the window_ids
  --    -- return only the ones you want to include
  --    return {1000, 1001}
  -- end
  filter_func = nil,

  -- following filters are only applied when you are using the default filter
  -- defined by this plugin. If you pass in a function to "filter_func"
  -- property, you are on your own
  filter_rules = {
    -- -- when there is only one window available to pick from, use that window
    -- -- without prompting the user to select
    -- autoselect_one = true,
    --
    -- -- whether you want to include the window you are currently on to window
    -- -- selection or not
    -- include_current_win = false,
    --
    -- -- whether to include windows marked as unfocusable
    -- include_unfocusable_windows = false,

    -- filter using buffer options
    bo = {
      -- if the file type is one of following, the window will be ignored
      filetype = { 'snacks_notif', 'snacks_picker_input', 'nvim-undotree' },

      -- if the file type is one of following, the window will be ignored
      buftype = {},
    },

    -- filter using window options
    wo = {},

    -- if the file path contains one of following names, the window
    -- will be ignored
    file_path_contains = {},

    -- if the file name contains one of following names, the window will be
    -- ignored
    file_name_contains = {},
  },

  -- You can pass in the highlight name or a table of content to set as
  -- highlight
  -- highlights = {
  --     enabled = true,
  --     statusline = {
  --         focused = {
  --             fg = '#ededed',
  --             bg = '#e35e4f',
  --             bold = true,
  --         },
  --         unfocused = {
  --             fg = '#ededed',
  --             bg = '#44cc41',
  --             bold = true,
  --         },
  --     },
  --     winbar = {
  --         focused = {
  --             fg = '#ededed',
  --             bg = '#e35e4f',
  --             bold = true,
  --         },
  --         unfocused = {
  --             fg = '#ededed',
  --             bg = '#44cc41',
  --             bold = true,
  --         },
  --     },
  -- },
})

vim.cmd.packadd('nvim.undotree');

-- vim.keymap.set({ "n", "v", "o", "t" }, "<C-j>", "<cmd>lua require('nvim-window').pick()<cr>",
--   { noremap = true, silent = true, desc = 'nvim-window: Jump to window' })

local quickSelect = function()
  local window = require("window-picker").pick_window()
  if not window or not vim.api.nvim_win_is_valid(window) then
    return
  end

  vim.api.nvim_set_current_win(window)
end
vim.api.nvim_create_user_command("PickWin", quickSelect, {
  nargs = "?"
})
vim.keymap.set({ "n", "t" }, "<C-g>", "<cmd>PickWin<cr>")
