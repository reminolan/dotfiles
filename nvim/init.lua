
vim.g.mapleader = ' '

-- Bootstrap lazy.nvim
local function BootstrapLazy(colorscheme, lazy_spec)
  if type(colorscheme) ~= "string" or colorscheme == "" then
    colorscheme = "default"
  end

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
      "git", "clone", "--filter=blob:none", "--branch=stable",
      lazyrepo, lazypath
    })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)

  -- Make sure to setup `mapleader` and `maplocalleader` before
  -- loading lazy.nvim so that mappings are correct.
  -- This is also a good place to setup other settings (vim.opt)
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  -- Setup lazy.nvim
  lazy = require("lazy")
  lazy.setup({
    spec = lazy_spec,
    install = { colorscheme = { colorscheme } },
    checker = { enabled = true },
  })

  return lazy
end

local lazy = BootstrapLazy("adwaita", {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    lazy = false,
    build = ":TSUpdate"
  },
  {
    "neanias/everforest-nvim"
  },
  {
    "Mofiqul/adwaita.nvim",
    lazy = false,
    priority = 1000,
  }
})

require('nvim-treesitter.configs').setup({
  ensure_installed = { 'c', 'cmake', 'lua', 'markdown', 'python' },
  auto_install = true,

  highlight = {
    enable = true
  }
})

vim.opt.background = 'dark'
vim.opt.number = true 
vim.opt.relativenumber = false
vim.opt.spell = false

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.colorcolumn="81"

vim.opt.guifont = "Cascadia Mono NF:h13"
vim.wo.wrap = false

vim.cmd.colorscheme("adwaita")

vim.keymap.set('n', 'q', function()
  vim.cmd([[:noh]])
end)

vim.keymap.set('n', '<C-l>', function()
  vim.cmd([[:set cursorline!]])
end)

vim.keymap.set('n', '<C-c>', function()
  vim.cmd([[:set cursorcolumn!]])
end)

