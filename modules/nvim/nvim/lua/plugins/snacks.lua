return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
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
                ["l"] = "copy_item_path",
                ["P"] = "aemsync_push",
              }
            }
          },
          actions = {
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
                    "-g",
                    "!.git",
                    "-g",
                    "!node_modules",
                    "-g",
                    "!dist",
                    "-g",
                    "!build",
                    "-g",
                    "!coverage",
                    "-g",
                    "!.DS_Store",
                    "-g",
                    "!.docusaurus",
                    "-g",
                    "!.dart_tool",
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
  },
  keys = {
    { "<leader><space>", function() Snacks.picker.smart({ multi = { "buffers", "files" }, hidden = true }) end,          desc = "Smart Find Files" },
    { "<leader>,",       function() Snacks.picker.buffers({ hidden = true }) end,                                        desc = "Buffers" },
    { "<leader>/",       function() Snacks.picker.grep({ hidden = true }) end,                                           desc = "Grep" },
    { "<leader>ff",      function() Snacks.picker.files({ hidden = true }) end,                                          desc = "Find Files" },
    { "<leader>e",       function() Snacks.picker.explorer({ auto_close = true, layout = { preset = "dropdown" } }) end, desc = "Open Explorer" },
    { "<leader>E",       function() Snacks.picker.explorer() end,                                                        desc = "Open Explorer No Close" },
    { "<leader>fg",      function() Snacks.picker.git_files({ submodules = true, }) end,                                 desc = "Find Git Files" },
    { "<leader>gs",      function() Snacks.picker.git_status({ submodules = true }) end,                                 desc = "Find Git Files" },
    { "<leader>fw",      function() Snacks.picker.grep_word({ hidden = true }) end,                                      desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>fm",      function() Snacks.picker.marks() end,                                                           desc = "Marks" },
    { "gd",              function() Snacks.picker.lsp_definitions() end,                                                 desc = "Goto Definition" },
    { "gD",              function() Snacks.picker.lsp_declarations() end,                                                desc = "Goto Declaration" },
    { "gr",              function() Snacks.picker.lsp_references() end,                                                  nowait = true,                     desc = "References" },
    { "gI",              function() Snacks.picker.lsp_implementations() end,                                             desc = "Goto Implementation" },
    { "gy",              function() Snacks.picker.lsp_type_definitions() end,                                            desc = "Goto T[y]pe Definition" },
    { "<leader>Z",       function() Snacks.zen() end,                                                                    desc = "Toggle Zen Mode" },
    { "<leader>z",       function() Snacks.zen.zoom() end,                                                               desc = "Toggle Zoom" },
    { "<leader>.",       function() Snacks.scratch() end,                                                                desc = "Toggle Scratch Buffer" },
    { "<leader>S",       function() Snacks.scratch.select() end,                                                         desc = "Select Scratch Buffer" },
    { "<C-/>",           function() Snacks.terminal() end,                                                               desc = "Toggle Terminal" }
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
        Snacks.toggle.option("relativenumber", { name = "Relative Numbers" }):map("<leader>tr")
        Snacks.toggle.diagnostics():map("<leader>td")
        Snacks.toggle.inlay_hints():map("<leader>th")
      end,
    })
  end,
}
