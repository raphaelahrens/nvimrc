-- neovim config
-- github.com/ojroques

-------------------- HELPERS -------------------------------
local api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
local opt, wo = vim.opt, vim.wo

local home = os.getenv('HOME')
local nvimrc = home ..'/.config/nvim/'
local pack_dir = nvimrc .. 'pack/default/start/'

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function nmap(lhs, rhs, opts)
    map('n', lhs, rhs, opts)
end
local function vmap(lhs, rhs, opts)
    map('v', lhs, rhs, opts)
end
local function imap(lhs, rhs, opts)
    map('i', lhs, rhs, opts)
end
local function tmap(lhs, rhs, opts)
    map('t', lhs, rhs, opts)
end


local function add_word(word)
    local aw_exit = function ()
        local filename = pack_dir .. '/spell/spell/.last-spell'
        local f = assert(io.open(filename, 'r'))
        local changedDict = f:read('*all')
        f:close()
        cmd('mkspell! ' .. changedDict)
        cmd('redraw!')
    end
    cmd([[
        vnew
        setl nospell
    ]])
    fn.termopen('addword --choose "' .. word ..'"',
        {
            on_exit = aw_exit,
            buffer_nr = fn.bufnr('%')
        }
    )
end

function n_add_word()
    local word = fn.expand('<cword>')
    add_word(word)
end

local indent= 4

opt.backspace = {'indent','eol','start'}
opt.history = 10000
opt.timeoutlen = 300
opt.hidden = true
opt.number = true
opt.showcmd = true
opt.wildmenu = true
opt.wildmode = {'longest','list','full'}
opt.completeopt = {'preview','menuone','noselect'}
opt.scrolloff = 5
opt.formatoptions = 'tcqj'
opt.mouse = 'a'
opt.showbreak = '…'
opt.listchars = {
    tab = '▸ ',
    eol = '¬',
    trail = '-'
}
opt.tabstop = indent
opt.shiftwidth = indent
opt.expandtab = true

require('nord').set()

require'which-key'.setup({})

require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = { "javascript" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    additional_vim_regex_highlighting = false,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

-- opt.foldmethod='expr'
-- opt.foldexpr='nvim_treesitter#foldexpr()'

local on_attach = function(client)
    require'completion'.on_attach(client)
end
local lsp = require('lspconfig')
for ls, cfg in pairs({
  ccls = {},
  jsonls = {},
  rust_analyzer = {
      on_attach = on_attach,
    settings = {
        assist = {
            importGranularity = "module",
            importPrefix = "by_self",
        },
        cargo = {
            loadOutDirsFromCheck = true
        },
        procMacro = {
            enable = true
        },
      }
  },
  pylsp = {},
}) do lsp[ls].setup(cfg) end

-- Key mappings
g.mapleader = 'ä'
nmap('Q', 'gq')
nmap('Y', 'y$')

nmap('ü', '"0p')
nmap('Ü', '"0P')
vmap('ü', '"0p')
vmap('Ü', '"0P')

nmap('°', '^')
-- nmap('<leader>l', '<cmd>!leo <C-r><C-w><CR>')

nmap('<leader>ö', '<cmd>lua n_add_word()<CR>')


nmap('<F7>', '<cmd>TagbarToggle<CR>')
nmap('<F12>', '<cmd>split ~/notes<CR>')

imap('<A-Down>', '<Esc>gja')
imap('<A-Up>', '<Esc>gka')
vmap('<A-Down>', 'gj')
vmap('<A-up>', 'gk')
nmap('<A-Down>', 'gj')
nmap('<A-Up>', 'gk')

nmap('<C-Left>', ':previous<CR>')
nmap('<C-Right>', ':next<CR>')
nmap('<C-S-Left>', ':cprevious<CR>')
nmap('<C-S-Right>', ':cnext<CR>')

nmap('<Tab>', '>>_')
nmap('<S-Tab>', '<<_')
imap('<S-Tab>', '<C-D>')
vmap('<Tab>', '>gv')
vmap('<S-Tab>', '<gv')

-- Move visual block
vmap('J', ":m '>+1<CR>gv=gv")
vmap('K', ":m '<-2<CR>gv=gv")

-- Use <C-L> to clear the highlighting of :set hlsearch.
nmap('<C-L>', ':nohlsearch<CR><C-L>')
-- Search for selected text, forwards or backwards.
-- vnoremap <silent> * :<C-U>
--   \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
--   \gvy/<C-R><C-R>=substitute(
--   \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
--   \gV:call setreg('"', old_reg, old_regtype)<CR>
-- vnoremap <silent> # :<C-U>
--   \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
--   \gvy?<C-R><C-R>=substitute(
--   \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
--   \gV:call setreg('"', old_reg, old_regtype)<CR>
nmap('<Leader>*', ':Grepper -cword -noprompt<CR>')
imap('<C-Space>', '<C-n>')

tmap('<ESC>', '<C-\\><C-n>')
tmap('<C-v><ESC>', '<ESC>')


nmap('<leader>l,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
nmap('<leader>l.', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
nmap('<leader>la', '<cmd>lua vim.lsp.buf.code_action()<CR>')
nmap('<leader>ld', '<cmd>lua vim.lsp.buf.definition()<CR>')
nmap('<leader>lf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
nmap('<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>')
nmap('<leader>lm', '<cmd>lua vim.lsp.buf.rename()<CR>')
nmap('<leader>lr', '<cmd>lua vim.lsp.buf.references()<CR>')
nmap('<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')


nmap('<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>")
nmap('<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>")
nmap('<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>")
nmap('<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>")

g.togglecursor_force = 'xterm'
