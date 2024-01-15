-- Trying to load colorcheme first
vim.opt.termguicolors = true
local colorscheme = "gruvbox-material"
local fallback_colorscheme = "desert"
local colorscheme_status, _ = pcall(vim.cmd.colorscheme, colorscheme)


-- Tabs configuration
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Appearance
vim.opt.number = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = false
vim.opt.endofline = true
vim.opt.list = true
vim.opt.listchars = {
    extends = '▶',
    precedes = '◀',
    tab = '→ ',
    trail = '·',
}


-- Language keys mappings
local uppercase = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЖ;ABCDEFGHIJKLMNOPQRSTUVWXYZ:"
local lowercase = "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
vim.opt.langmap = uppercase .. "," .. lowercase


-- Setup leader key
vim.keymap.set('n', ' ', '', {})
vim.g.mapleader = ' '


-- Disable language providers
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0


-- Setup default assembler syntax
vim.g.asmsyntax = "nasm"


-- Plugin manager
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

require("lazy").setup({
    {"sainnhe/gruvbox-material"},
    {"nvim-lualine/lualine.nvim"},
    {"nvim-treesitter/nvim-treesitter", tag = "v0.9.1"},
    {"nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = {"nvim-lua/plenary.nvim"}}
})

-- Trying to load colorscheme second time if it was not installed before startup
if not colorscheme_status then
    colorscheme_status, _ = pcall(vim.cmd.colorscheme, colorscheme)
    if not colorscheme_status then
        print("Failed to load '" .. colorscheme .. "' colorscheme, using '" .. fallback_colorscheme .. "' as a fallback")
        vim.cmd.colorscheme(fallback_colorscheme)
    end
end

-- TODO: Get rid of the plugin and configure the status line manually
-- Status line setup
require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = 'auto',
        section_separators = {},
        component_separators = { left = '|', right = '|' },
    }
})


-- Telescope config
local ts_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', ts_builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', ts_builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', ts_builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', ts_builtin.help_tags, {})
vim.keymap.set('n', '<leader>s',  ts_builtin.grep_string, {})

vim.keymap.set('n', '<leader>аа', ts_builtin.find_files, {})
vim.keymap.set('n', '<leader>ап', ts_builtin.live_grep, {})
vim.keymap.set('n', '<leader>аи', ts_builtin.buffers, {})
vim.keymap.set('n', '<leader>ар', ts_builtin.help_tags, {})
vim.keymap.set('n', '<leader>ы',  ts_builtin.grep_string, {})

require('telescope').setup {
    defaults = {
        initial_mode = 'insert'
    }
}


-- Treesitter config
require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "lua",
        "markdown",
        "markdown_inline",
        "nasm",
        "rust",
        "vim",
        "vimdoc",
        "cmake"
    },
    sync_install = false,
    highlight = {
        enable = true
    },
}

-- Keymap
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y')
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+Y')
vim.keymap.set({'n', 'v'}, '<leader>yy', '"+yy')

vim.keymap.set({'n', 'v'}, '<leader>d', '"+d')
vim.keymap.set({'n', 'v'}, '<leader>D', '"+D')
vim.keymap.set({'n', 'v'}, '<leader>dd', '"+dd')

vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('n', '<leader>P', '"+P')

vim.keymap.set('n', '<leader>t', ':tabnew<CR>')
vim.keymap.set('n', '<leader>l', ':tabnext<CR>')
vim.keymap.set('n', '<leader>h', ':tabprevious<CR>')

-- Open Projects directory by default
--local dev_dir = "D:/Dev/Projects"
--vim.cmd.cd(dev_dir)


