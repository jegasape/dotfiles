require'lspconfig'.pyright.setup{}

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

local formatters = require "lvim.lsp.null-ls.formatters"

formatters.setup {
  { command = "black" },
}

lvim.format_on_save.enabled = true

lvim.format_on_save.pattern = { "*.py", "*.js", "*.ts", "*.tsx" }

local linters = require "lvim.lsp.null-ls.linters"

linters.setup {
  { command = "ruff", filetypes = { "python" } }
}

lvim.plugins = {
  {
    "terryma/vim-multiple-cursors"
  }
}

vim.log.level = "debug"

table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    vim.defer_fn(function()
      require("copilot").setup()
      require("copilot_cmp").setup()
    end, 100)
  end,
})


