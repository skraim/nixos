local function setup()
  ps.sub("cd", function()
    local cwd = cx.active.current.cwd
    if cwd:ends_with("Downloads") then
      ya.manager_emit("sort", { "modified", reverse = true, dir_first = false })
      ya.manager_emit("linemode", { "btime" })
    else
      ya.manager_emit("sort", { "alphabetical", reverse = false, dir_first = true })
      ya.manager_emit("linemode", { "size" })
    end
  end)
end

return { setup = setup }
