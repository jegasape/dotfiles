vim.env.TERM          = "xterm-256color"
vim.scriptencoding    = "utf-8"
vim.opt.encoding      = "utf-8"
vim.opt.fileencoding  = "utf-8"

vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.title          = true
vim.opt.laststatus     = 3
vim.opt.mouse          = ""
vim.opt.splitkeep      = "cursor"
vim.opt.signcolumn     = "yes"
vim.opt.scrolloff      = 8
vim.opt.cursorline     = true

vim.opt.autoindent  = true
vim.opt.expandtab   = true
vim.opt.shiftwidth  = 2
vim.opt.tabstop     = 2

local cursor_block = "n-v-c:block-blinkon1-blinkoff1"
local cursor_beam  = "i:ver25-blinkon1-blinkoff1"
vim.opt.guicursor  = cursor_block .. "," .. cursor_beam

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.opt.guicursor = cursor_block .. "," .. cursor_beam
  end,
})
vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    io.write("\x1b[5 q")
  end,
})

vim.opt.foldmethod     = "expr"
vim.opt.foldexpr       = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.foldenable     = true

lvim.transparent_window = true

lvim.keys.normal_mode["<C-t>"] = ":ToggleTerm<CR>"

lvim.builtin.treesitter.ensure_installed = {
  "python",
  "javascript",
  "typescript",
  "go",
  "lua",
  "json",
  "tsx",
  "yaml",
  "markdown",
}

local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "black",    filetypes = { "python" } },
  { command = "gofmt",    filetypes = { "go" } },
  { command = "prettier", filetypes = { "javascript", "typescript", "tsx", "json" } },
}

lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.go", "*.py", "*.js", "*.ts", "*.tsx", "*.json" }

require("lvim.lsp.manager").setup("pyright")
require("lvim.lsp.manager").setup("tsserver")
-- require("lvim.lsp.manager").setup("gopls")

require('user.dashboard')

-- lvim.plugins = {
--   {
--     "sphamba/smear-cursor.nvim",
--     event = "VimEnter",
--     opts = {
--       cursor_color                     = "#ffffff",
--       stiffness                        = 0.8,
--       trailing_stiffness               = 0.6,
--       damping                          = 0.95,
--       distance_stop_animating          = 0.5,
--       smear_between_buffers            = false,
--       smear_between_neighbor_lines     = false,
--       legacy_computing_symbols_support = true,
--     },
--   },
-- }


