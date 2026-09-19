vim.pack.add({ "https://github.com/folke/snacks.nvim" });

require("snacks").setup({
  bigfile = {
    enabled = true,
    notify = false
  },
  dim = { animate = { enabled = false } },
  indent = { enabled = true, animate = { enabled = false } },
  picker = {
    enabled = true,
    win = {
      input = {
        keys = {
          ["<C-c>"] = "cancel",
          ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
          ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          ["<c-h>"] = { "list_down", mode = { "i", "n" } },
          ["<c-a>"] = { "list_up", mode = { "i", "n" } },
          ["<c-w>Y"] = "layout_left",
          ["<c-w>H"] = "layout_bottom",
          ["<c-w>A"] = "layout_top",
          ["<c-w>E"] = "layout_right",
          ["h"] = "list_down",
          ["a"] = "list_up",
          ["k"] = false,
        }
      }
    },
    sources = {
      explorer = {
        hidden = true,
        win = {
          list = {
            keys = {
              ["<CR>"] = "confirm",
              ["<c-p>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
              ["<c-w>Y"] = "layout_left",
              ["<c-w>H"] = "layout_bottom",
              ["<c-w>A"] = "layout_top",
              ["<c-w>E"] = "layout_right",
              ["<c-f>"] = "toggle_maximize",
              ["h"] = "list_down",
              ["a"] = "list_up",
              ["e"] = "confirm",
              ["y"] = "explorer_close",
              ["k"] = "explorer_add",
              ["s"] = "search_in_directory",
              ["<leader>/"] = false,
              ["<c-g>"] = false,
              ["<c-a>"] = false,
              ["l"] = "copy_item_cwd_path",
              ["L"] = "copy_item_path",
              ["P"] = "aemsync_push",
            }
          }
        },
        actions = {
          copy_item_cwd_path = {
            action = function(_, item)
              if not item or not item.file then
                return
              end

              local path = vim.fn.fnamemodify(item.file, ":.")
              vim.fn.setreg("+", path)
              Snacks.notify.info("Yanked `" .. path .. "`")
            end,
          },
          copy_item_path = {
            action = function(_, item)
              if not item then
                return
              end

              local vals = {
                ["BASENAME"] = vim.fn.fnamemodify(item.file, ":t:r"),
                ["EXTENSION"] = vim.fn.fnamemodify(item.file, ":t:e"),
                ["FILENAME"] = vim.fn.fnamemodify(item.file, ":t"),
                ["PATH"] = item.file,
                ["PATH (CWD)"] = vim.fn.fnamemodify(item.file, ":."),
                ["PATH (HOME)"] = vim.fn.fnamemodify(item.file, ":~"),
                ["URI"] = vim.uri_from_fname(item.file),
              }

              local options = vim.tbl_filter(function(val)
                return vals[val] ~= ""
              end, vim.tbl_keys(vals))
              if vim.tbl_isempty(options) then
                vim.notify("No values to copy", vim.log.levels.WARN)
                return
              end
              table.sort(options)
              vim.ui.select(options, {
                prompt = "Choose to copy to clipboard:",
                format_item = function(list_item)
                  return ("%s: %s"):format(list_item, vals[list_item])
                end,
              }, function(choice)
                local result = vals[choice]
                if result then
                  vim.fn.setreg("+", result)
                  Snacks.notify.info("Yanked `" .. result .. "`")
                end
              end)
            end,
          },
          search_in_directory = {
            action = function(_, item)
              if not item then
                return
              end
              local dir = vim.fn.fnamemodify(item.file, ":p:h")
              Snacks.picker.grep({
                cwd = dir,
                cmd = "rg",
                args = {
                  "-g", "!.git",
                  "-g", "!node_modules",
                  "-g", "!dist",
                  "-g", "!build",
                  "-g", "!coverage",
                  "-g", "!.DS_Store",
                  "-g", "!.docusaurus",
                  "-g", "!.dart_tool",
                },
                show_empty = true,
                hidden = true,
                ignored = true,
                follow = false,
                supports_live = true,
              })
            end,
          },
          aemsync_push = {
            action = function(_, item)
              if not item then
                Snacks.notify.warn("No item selected")
                return
              end

              local path = vim.fn.fnamemodify(item.file, ":p")
              if not path then
                Snacks.notify.warn("No file path available")
                return
              end

              if not path:match("jcr_root") then
                Snacks.notify.error("Not an AEM path: must be inside jcr_root directory")
                return
              end

              if vim.fn.executable("aemsync") ~= 1 then
                Snacks.notify.error("aemsync not found in PATH")
                return
              end

              Snacks.notify.info("Pushing to AEM: " .. vim.fn.fnamemodify(path, ":t"))

              vim.fn.jobstart({ "aemsync", "-p", path }, {
                stdout_buffered = true,
                stderr_buffered = true,
                on_stdout = function(_, data)
                  if data and #data > 0 then
                    local output = table.concat(data, "\n")
                    if output:match("Pushed") or output:match("OK") then
                      Snacks.notify.info("AEM push successful:\n" .. output)
                    elseif output ~= "" then
                      Snacks.notify.info(output)
                    end
                  end
                end,
                on_stderr = function(_, data)
                  if data and #data > 0 then
                    local output = vim.trim(table.concat(data, "\n"))
                    if output ~= "" then
                      Snacks.notify.error("AEM push error:\n" .. output)
                    end
                  end
                end,
                on_exit = function(_, exit_code)
                  if exit_code ~= 0 then
                    Snacks.notify.error("AEM push failed (exit code: " .. exit_code .. ")")
                  end
                end,
              })
            end,
          },
        }
      }
    },
    formatters = {
      file = {
        truncate = 80
      }
    }
  },
  explorer = {
    replace_netrw = true,
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  statuscolumn = { enabled = true }
})

local map = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = desc })
end

map("<leader><space>", function() Snacks.picker.smart({ multi = { "buffers", "files" }, hidden = true }) end, "Smart Find Files")
map("<leader>,",       function() Snacks.picker.buffers({ hidden = true }) end, "Buffers")
map("<leader>/",       function() Snacks.picker.grep({ hidden = true }) end, "Grep")
map("<leader>ff",      function() Snacks.picker.files({ hidden = true }) end, "Find Files")
map("<leader>fw",      function() Snacks.picker.grep_word({ hidden = true }) end, "Find Selected Word")
map("<leader>e",       function() Snacks.picker.explorer({ auto_close = true, layout = { preset = "dropdown" } }) end, "Open Explorer")
map("<leader>E",       function() Snacks.picker.explorer() end, "Open Explorer No Close")
map("<leader>fg",      function() Snacks.picker.git_files({ submodules = true }) end, "Find Git Files")
map("<leader>gs",      function() Snacks.picker.git_status({ submodules = true }) end, "Git Status")
map("<leader>fm",      function() Snacks.picker.marks() end, "Marks")
map("gd",              function() Snacks.picker.lsp_definitions() end, "Goto Definition")
map("gD",              function() Snacks.picker.lsp_declarations() end, "Goto Declaration")
map("gr",              function() Snacks.picker.lsp_references() end, "References")
map("gI",              function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
map("gy",              function() Snacks.picker.lsp_type_definitions() end, "Goto T[y]pe Definition")
map("<leader>Z",       function() Snacks.zen() end, "Toggle Zen Mode")
map("<leader>z",       function() Snacks.zen.zoom() end, "Toggle Zoom")
map("<leader>.",       function() Snacks.scratch() end, "Toggle Scratch Buffer")
map("<leader>S",       function() Snacks.scratch.select() end, "Select Scratch Buffer")
map("<C-/>",           function() Snacks.terminal() end, "Toggle Terminal")

Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
Snacks.toggle.option("relativenumber", { name = "Relative Numbers" }):map("<leader>tr")
Snacks.toggle.diagnostics():map("<leader>td")
Snacks.toggle.inlay_hints():map("<leader>th")
