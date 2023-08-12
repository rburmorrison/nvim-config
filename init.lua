-- vim:fileencoding=utf-8:foldmethod=marker

-- LazyNvim Bootstrapping {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- }}}

----------------------
-- Default Settings --
----------------------

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop    = 2
vim.opt_local.expandtab  = true

vim.opt_local.number      = true
vim.opt_local.colorcolumn = "81"

--------------------------------------
-- LSP and Treesitter Configuration --
--------------------------------------

local language_servers = {
  "lua_ls",
  "rust_analyzer"
}

local treesitter_languages = {
  "lua",
  "rust"
}

----------------------------
-- Dependency Definitions --
----------------------------

require("lazy").setup({

  -- Aesthetics {{{
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "lukas-reineke/indent-blankline.nvim" },
  -- }}}

  -- NvimTree {{{
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  -- }}}

  -- Treesitter {{{
  { "nvim-treesitter/nvim-treesitter" },
  -- }}}

  -- Autocomplete and LSP {{{
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-vsnip" },
  { "hrsh7th/vim-vsnip" },

  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  -- }}}

  -- Miscellaneous {{{
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "tpope/vim-sleuth" },
  { "voldikss/vim-floaterm" },
  -- }}}

  -- Key Bindings {{{
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },
  -- }}}

})

--------------------------
-- Plugin Configuration --
--------------------------

-- Aesthetics {{{
require("catppuccin").setup({ flavour = "macchiato" })
vim.cmd.colorscheme "catppuccin"

require("indent_blankline").setup()

require('lspconfig.ui.windows').default_options.border = "rounded" -- lsp info borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with( -- help window border
  vim.lsp.handlers.hover, { border = "rounded" }
)
-- }}}

-- NvimTree {{{
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
require("nvim-tree").setup()
-- }}}

-- Treesitter {{{
require("nvim-treesitter.configs").setup({
  ensure_installed = treesitter_languages
})
vim.cmd("TSUpdate")
-- }}}

-- Autocomplete and LSP {{{
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
  }, {
    { name = "buffer" },
  })
})

cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "git" },
  }, {
    { name = "buffer" },
  })
})

cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" }
  }
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" }
  }, {
    { name = "cmdline" }
  })
})

require("mason").setup({
  ui = {
    border = "rounded",
  },
})
require("mason-lspconfig").setup({
  ensure_installed = language_servers
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, server in ipairs(language_servers) do
  require("lspconfig")[server].setup({
    capabilities = capabilities
  })
end

require("lspconfig").rust_analyzer.setup({
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      check = {
        command = "clippy"
      }
    }
  }
})
-- }}}

-- Key Bindings {{{
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- CTRL+HJKL Movement {{{
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { noremap = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { noremap = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { noremap = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { noremap = true })
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { noremap = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { noremap = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { noremap = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { noremap = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })
-- }}}

-- Terminal Bindings {{{
vim.keymap.set(
  "n",
  "<C-/>",
  "<CMD>FloatermToggle<CR><CMD>FloatermUpdate --title=Terminal --titleposition=center --width=0.8 --height=0.8<CR>",
  { noremap = true }
)
vim.keymap.set("t", "<C-/>", "<ESC><CMD>FloatermToggle<CR>", { noremap = true } )
-- }}}

-- Miscellaneous Bindings {{{
vim.keymap.set("n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>", { noremap = true })
-- }}}

local wk = require("which-key")
wk.register({
  e = { "<CMD>NvimTreeToggle<CR>", "toggle file explorer" },
  l = {
    name = "lsp",
    f = { "<CMD>lua vim.lsp.buf.format()<CR>", "format" },
    a = { "<CMD>lua vim.lsp.buf.code_action()<CR>", "code action" },
  },
  t = {
    name = "toggle",
    t = { "<CMD>FloatermToggle Terminal<CR>", "toggle terminal" },
  }
}, { prefix = "<LEADER>" })
-- }}}
