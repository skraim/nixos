vim.pack.add({
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/onsails/lspkind.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/xzbdmw/colorful-menu.nvim",
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range 'v2.*' },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range '1.*' }
});

require("blink.cmp").setup({
  keymap = {
    preset = 'none',
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'cancel' },
    ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
    ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
  },

  appearance = {
    nerd_font_variant = 'mono'
  },

  completion = {
    keyword = {
      range = 'full'
    },
    menu = {
      auto_show = false,
      min_width = 60,
      max_height = 15,
      draw = {
        padding = 1,
        columns = { { "kind_icon" }, { "label", gap = 1 } },
        components = {
          kind_icon = {
            text = function(ctx)
              local icon = ctx.kind_icon
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                if dev_icon then
                  icon = dev_icon
                end
              else
                icon = require("lspkind").symbolic(ctx.kind)
              end

              return icon .. ctx.icon_gap
            end,

            highlight = function(ctx)
              local hl = ctx.kind_hl
              if vim.tbl_contains({ "Path" }, ctx.source_name) then
                local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                if dev_icon then
                  hl = dev_hl
                end
              end
              return hl
            end,
          },
          label = {
            text = function(ctx)
              return require("colorful-menu").blink_components_text(ctx)
            end,
            highlight = function(ctx)
              return require("colorful-menu").blink_components_highlight(ctx)
            end,
          },
        },
      },
    },

    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },

    trigger = { show_on_trigger_character = true },

    ghost_text = { enabled = true },
  },

  signature = { enabled = true },

  sources = {
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
    providers = {
      lazydev = {
        name = 'LazyDev',
        module = 'lazydev.integrations.blink',
        score_offset = 100,
      },
      path = {
        opts = {
          get_cwd = function(_)
            return vim.fn.getcwd()
          end,
        },
      },
    },
  },

  fuzzy = { implementation = "prefer_rust" },

  cmdline = {
    enabled = true,
    keymap = {
      preset = 'none',
      ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<C-n>'] = { 'show_and_insert', 'select_next' },
      ['<C-p>'] = { 'show_and_insert', 'select_prev' },
      ['<Tab>'] = { 'select_and_accept' },
      ['<C-e>'] = { 'cancel' },
    },
    sources = function()
      local type = vim.fn.getcmdtype()
      if type == '/' or type == '?' then return { 'buffer' } end
      if type == ':' or type == '@' then return { 'cmdline' } end
      return {}
    end,
    completion = {
      trigger = {
        show_on_blocked_trigger_characters = {},
        show_on_x_blocked_trigger_characters = {},
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = true,
        },
      },
      menu = {
        auto_show = true,
      },
      ghost_text = { enabled = true }
    }
  }
});
