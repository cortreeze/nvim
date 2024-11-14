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
vim.opt.ignorecase = true
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
    {"nvim-treesitter/nvim-treesitter", tag = "v0.9.3"},
    {"nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = {"nvim-lua/plenary.nvim"}},
    {"neovim/nvim-lspconfig", tag = "v0.1.8"},
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
        icons_enabled = false,
        theme = 'auto',
        section_separators = {},
        component_separators = { left = '|', right = '|' },
    }
})

-- LSP setup
require('lspconfig').clangd.setup{}
vim.opt.signcolumn = "yes" -- Prevents sidebar flickering on LSP rescan

vim.api.nvim_create_autocmd('LspAttach', {
group = vim.api.nvim_create_augroup('UserLspConfig', {}),
callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>gs', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
    vim.keymap.set('n', '<C-k><C-o>', function()
            vim.cmd("ClangdSwitchSourceHeader")
        end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end,
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
require('nvim-treesitter.configs').setup {
    ensure_installed = {
        "bash",
        "bitbake",
        "c",
        "cpp",
        "devicetree",
        "glsl",
        "hlsl",
        "javascript",
        "lua",
        "markdown",
        "markdown_inline",
        "nasm",
        "python",
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


-- Helpers
local function ask_save()
    local result = 'Cancel'
    vim.ui.select(
        { 'Save', 'Lose', 'Cancel' },
        { prompt = 'Buffer has unsaved changes. Save them before leave?' },
        function(choice)
            if choice then
                result = choice
            end
        end
    )

    return result
end

local function get_listed_buffers()
    local result = vim.tbl_filter(
    function(b)
        return (vim.fn.buflisted(b) == 1)
    end,
    vim.api.nvim_list_bufs()
    )

    return result
end

-- TODO: Add per window buffers history
local function unlist_buffer(buffer_id)
    local windows = vim.fn.win_findbuf(buffer_id)
    for _, win_id in pairs(windows) do
        vim.fn.win_execute(win_id, 'bprev')
    end
end

local function kill_buffer()
    if vim.fn.bufname() ~= '' and vim.bo.modified then
        local should_save = ask_save()
        if should_save == 'Cancel' then
            return
        end

        local _ = (should_save == 'Save') and vim.cmd('silent write!') or vim.cmd('edit!')
    end

    unlist_buffer(vim.fn.winbufnr(0))
    local buffers = get_listed_buffers()
    if #buffers > 1 then
        unlist_buffer(vim.fn.winbufnr(0))
        vim.cmd('bd#')
    else
        vim.cmd('bd!')
    end
end

vim.api.nvim_create_user_command('KillBuffer', kill_buffer, {});


-- Keymap
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y')
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+Y')
vim.keymap.set({'n', 'v'}, '<leader>yy', '"+yy')

vim.keymap.set({'n', 'v'}, '<leader>d', '"+d')
vim.keymap.set({'n', 'v'}, '<leader>D', '"+D')
vim.keymap.set({'n', 'v'}, '<leader>dd', '"+dd')

vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('n', '<leader>P', '"+P')
vim.keymap.set('n', '<leader>p', '"+з')
vim.keymap.set('n', '<leader>P', '"+З')

vim.keymap.set('n', '<leader>t', ':tabnew<CR>')
vim.keymap.set('n', '<leader>l', ':tabnext<CR>')
vim.keymap.set('n', '<leader>h', ':tabprevious<CR>')

vim.keymap.set('n', '<leader>kk', vim.cmd.KillBuffer, {})

vim.opt.foldlevel = 100
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.hlsl"},
  command = "set filetype=hlsl",
})
