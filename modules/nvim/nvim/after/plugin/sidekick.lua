local haunt_sk = require("haunt.sidekick")
require('sidekick').setup({
  nes = {
    enabled = false,
  },
  copilot = {
    status = {
      enabled = false
    }
  },
  cli = {
    prompts = {
      haunt_all = function()
        return haunt_sk.get_locations()
      end,
      haunt_buffer = function()
        return haunt_sk.get_locations({ name = "claude", current_buffer = true })
      end,
    },
  }
});

local map = function(keys, func, desc, mode)
  mode = mode or 'n'
  vim.keymap.set(mode, keys, func, { desc = '[A]I: ' .. desc })
end

map("<leader>aa", function()
  require("sidekick.cli").toggle({ name = "claude", focus = true })
end, "Toggle [A]I")

map("<leader>at", function()
  require("sidekick.cli").send({ name = "claude", focus = true, msg = "{this}" })
end, "Send [T]his", { "x", "n" })

map("<leader>af", function()
  require("sidekick.cli").send({ name = "claude", focus = true, msg = "{file}" })
end, "Send [F]ile")

map("<leader>av", function()
  require("sidekick.cli").send({ name = "claude", focus = true, msg = "{selection}" })
end, "Send [V]isual Selection", "x")

map("<leader>ap", function()
  require("sidekick.cli").prompt()
end, "Select [P]rompt", { "n", "x" })
