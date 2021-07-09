-- neovim config
-- github.com/ojroques

-------------------- HELPERS -------------------------------
local api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
local opt, wo = vim.opt, vim.wo
local fmt = string.format

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
        print('LOL' .. changedDict)
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

cmd 'colorscheme tantmustang'

-- Key mappings
g.mapleader = 'ä'
nmap('Q', 'gq')

nmap('ü', '"0p')
nmap('Ü', '"0P')
vmap('ü', '"0p')
vmap('Ü', '"0P')

nmap('°', '^')
nmap('<leader>l', '<cmd>!leo <C-r><C-w><CR>')

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
  pyls = {
      root_dir = lsp.util.root_pattern('.git', fn.getcwd())
  },
}) do lsp[ls].setup(cfg) end

nmap('<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
nmap('<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
nmap('<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
nmap('<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
nmap('<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
nmap('<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
nmap('<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
nmap('<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
nmap('<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

g.togglecursor_force = 'xterm'
