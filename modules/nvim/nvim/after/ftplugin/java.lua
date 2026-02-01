vim.opt.tabstop = 4

local home = os.getenv 'HOME'

local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = workspace_path .. project_name

local status, jdtls = pcall(require, 'jdtls')
if not status then
  return
end
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local bundles = {}
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
    "\n"
  )
)
local config = {
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',
    '-javaagent:' .. home .. '/.local/share/nvim/mason/packages/jdtls/lombok.jar',
    '-jar',
    vim.fn.glob(home .. '/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
    '-configuration',
    home .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
    '-data',
    workspace_dir,
  },
  root_dir = vim.fs.root(0, { "pom.xml", ".git", "mvnw", "gradlew" }),

  settings = {
    java = {
      signatureHelp = { enabled = true },
      extendedClientCapabilities = extendedClientCapabilities,
      maven = {
        downloadSources = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = 'all',
        },
      },
      format = {
        enabled = true,
      },
      runtimes = {
        {
          name = "JavaSE-8",
          path = "/usr/lib/jvm/java-8-openjdk/",
        },
        {
          name = "JavaSE-11",
          path = "/usr/lib/jvm/java-11-openjdk/",
        },
        {
          name = "JavaSE-21",
          path = "/usr/lib/jvm/java-21-openjdk/",
        }
      },
    },
  },
  init_options = {
    bundles = bundles,
  },
}

-- local dap = require('dap')
--
-- dap.configurations.java = dap.configurations.java or {}
--
-- table.insert(dap.configurations.java, {
--   type = "java",
--   request = "attach",
--   name = "Debug (Attach) - Remote",
--   hostName = "127.0.0.1",
--   port = 14502,
-- })

config["on_attach"] = function(client, bufnr)
  local _, _ = pcall(vim.lsp.codelens.refresh)
  require("jdtls.dap").setup_dap_main_class_configs()
  jdtls.setup_dap({ hotcodereplace = "auto" })
  local map = function(mode, lhs, rhs, desc)
    if desc then
      desc = desc
    end

    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
  end
  map("n", "<leader>tm", jdtls.test_nearest_method, "Test Method")
  map("n", "<leader>tc", jdtls.test_class, "Test Class")
end

require('jdtls').start_or_attach(config)
