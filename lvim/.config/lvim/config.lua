
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.title = true
vim.opt.autoindent = true

vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""
vim.opt.laststatus = 3


require('user.dashboard')

lvim.builtin.treesitter.ensure_installed = {
  "python",
}

lvim.keys.normal_mode["<C-t>"] = ":ToggleTerm<CR>"

-- setup formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black" },
}
lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.py" }

-- setup linting with ruff instead of flake8
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "ruff", filetypes = { "python" } }
}

vim.log.level = "debug"

table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    vim.defer_fn(function()
      require("copilot").setup() -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
      require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
    end, 100)
  end,
})


