
vim.g.mapleader = ' '

-- Bootstrap lazy.nvim
local function BootstrapLazy(colorscheme, lazy_spec)
   if type(colorscheme) ~= "string" or colorscheme == "" then
      colorscheme = "default"
   end

   local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
   if not (vim.uv or vim.loop).fs_stat(lazypath) then
     local lazyrepo = "https://github.com/folke/lazy.nvim.git"
     local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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
     -- Configure any other settings here. See the documentation for more details.
     -- colorscheme that will be used when installing plugins.
     install = { colorscheme = { colorscheme } },
     -- automatically check for plugin updates
     checker = { enabled = true },
   })

   return lazy
end

local lazy = BootstrapLazy("everforest", {
   {
      "nvim-treesitter/nvim-treesitter",
      branch = 'master',
      lazy = false,
      build = ":TSUpdate"
   },
   {
      "neanias/everforest-nvim",
      version = false,
      lazy = false,
      priority = 1000
   },
   {
      'nvim-telescope/telescope.nvim',
      lazy = true,
      dependencies = {
         { 'nvim-lua/plenary.nvim' }
      }
   },
   {
      'nvim-treesitter/nvim-treesitter'
   }
})

require('nvim-treesitter.configs').setup({
   ensure_installed = { 'c', 'lua', 'markdown', 'python' },
   auto_install = true,

   highlight = {
      enable = true
   }
})

require('everforest').setup({
   background="hard",

   italics=false,
   disable_italic_comments=true
})
vim.cmd([[colo everforest]])

vim.opt.background = 'dark'
vim.opt.number = true 
vim.opt.relativenumber = false
vim.opt.spell = false
vim.opt.wrap = false

vim.opt.shiftwidth = 3
vim.opt.tabstop = 3
vim.opt.softtabstop = 3
vim.opt.expandtab = true
vim.opt.cursorline = true

vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.lsp.enable('clangd')
vim.lsp.enable('qmlls')

vim.opt.guifont = "Maple Mono NL NF CN:h14"

vim.keymap.set('n', 'f', function()
   vim.cmd([[:noh]])
end)

vim.keymap.set('n', '<C-l>', function()
   vim.cmd([[:set cursorline!]])
end)

vim.keymap.set('n', '<C-c>', function()
   vim.cmd([[:set cursorcolumn!]])
end)

local builtin = require('telescope.builtin')
vim.keymap.set('n', 'ff', builtin.find_files, { desc = 'Telescope: find files' })
vim.keymap.set('n', 'fg', builtin.git_files, { desc = 'Telescope: git files' })
vim.keymap.set('n', 'fb', builtin.buffers, { desc = 'Telescope: buffers' })
vim.keymap.set('n', 'fh', builtin.help_tags, { desc = 'Telescope: help tags' })

