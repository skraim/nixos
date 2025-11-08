local overseer = require("overseer")

overseer.register_template({
  name = "AEM (Author, NoTest) Install - autoInstallPackage,autoInstallBundle",
  builder = function()
    return {
      cmd = { "mvn" },
      args = {
        "clean",
        "install",
        "-DskipTests=true",
        "-Daem.port=4502",
        "-PautoInstallPackage,autoInstallBundle",
      },
      components = {
        "unique",
        "on_output_quickfix",
        { "on_exit_set_status", success_codes = { 0 } },
        "on_complete_notify",
      },
    }
  end,
  condition = {
    callback = function(search)
      return true
    end,
  },
})
