-- neovim config
--
function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

-------------------- HELPERS -------------------------------
local cmd = vim.cmd
local fn = vim.fn
local g =  vim.g
local opt = vim.opt

local home = os.getenv('HOME')
local nvimrc = home .. '/.config/nvim/'
local pack_dir = nvimrc .. 'pack/default/start/'

local function map(mode, lhs, rhs, desc, opts)
    local options = {
        noremap = true,
        desc = desc
    }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

local function nmap(lhs, rhs, desc, opts)
    map('n', lhs, rhs, desc, opts)
end

local function vmap(lhs, rhs, desc, opts)
    map('v', lhs, rhs, desc, opts)
end

local function imap(lhs, rhs, desc, opts)
    map('i', lhs, rhs, desc, opts)
end

local function tmap(lhs, rhs, desc, opts)
    map('t', lhs, rhs, desc, opts)
end

g.mapleader = 'ä'

local function add_word(word)
    local aw_exit = function()
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
    fn.termopen('addword --choose "' .. word .. '"',
        {
            on_exit = aw_exit,
            buffer_nr = fn.bufnr('%')
        }
    )
end

local function n_add_word()
    local word = fn.expand('<cword>')
    add_word(word)
end


local indent = 4

opt.backspace = { 'indent', 'eol', 'start' }
opt.history = 10000
opt.timeoutlen = 300
opt.hidden = true
opt.number = true
opt.showcmd = true
opt.wildmenu = true
opt.wildmode = { 'longest', 'list', 'full' }
opt.completeopt = { 'preview', 'menu', 'menuone', 'noselect' }
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
opt.updatetime = 250


-- cmd [[colorscheme substrata]]
-- Example config in lua
vim.g.nord_contrast = true
vim.g.nord_borders = false
vim.g.nord_disable_background = false
vim.g.nord_italic = true

vim.diagnostic.config({
    virtual_text = true,
    float = {
        focusable = false,
        close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
        border = 'single',
        source = 'always',
        prefix = ' ',
        scope = 'line',
    }
})

require('luatab').setup({})
-- Load the colorscheme
require('nord').set()

require('which-key').setup({})

require'nvim-treesitter'.setup {
  -- Directory to install parsers and queries to
  install_dir = vim.fn.stdpath('data') .. '/site'
}
require'nvim-treesitter'.install {
    'bash',
    'c',
    'diff',
    'dot',
    'json',
    'html',
    'lua',
    'make',
    'markdown',
    'python',
    'rust',
    'tmux',
}

--require'nvim-treesitter.configs'.setup {
--  textobjects = {
--    select = {
--      enable = true,
--
--      -- Automatically jump forward to textobj, similar to targets.vim
--      lookahead = true,
--
--      keymaps = {
--        -- You can use the capture groups defined in textobjects.scm
--        ["af"] = "@function.outer",
--        ["if"] = "@function.inner",
--        ["ac"] = "@class.outer",
--        -- You can optionally set descriptions to the mappings (used in the desc parameter of
--        -- nvim_buf_set_keymap) which plugins like which-key display
--        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
--        -- You can also use captures from other query groups like `locals.scm`
--        ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
--      },
--      -- You can choose the select mode (default is charwise 'v')
--      --
--      -- Can also be a function which gets passed a table with the keys
--      -- * query_string: eg '@function.inner'
--      -- * method: eg 'v' or 'o'
--      -- and should return the mode ('v', 'V', or '<c-v>') or a table
--      -- mapping query_strings to modes.
--      selection_modes = {
--        ['@parameter.outer'] = 'v', -- charwise
--        ['@function.outer'] = 'V', -- linewise
--        ['@class.outer'] = '<c-v>', -- blockwise
--      },
--      -- If you set this to `true` (default is `false`) then any textobject is
--      -- extended to include preceding or succeeding whitespace. Succeeding
--      -- whitespace has priority in order to act similarly to eg the built-in
--      -- `ap`.
--      --
--      -- Can also be a function which gets passed a table with the keys
--      -- * query_string: eg '@function.inner'
--      -- * selection_mode: eg 'v'
--      -- and should return true or false
--      include_surrounding_whitespace = true,
--    },
--  },
--}

require('telescope').setup {
    pickers = {
        man_pages = {
            man_cmd = { 'apropos', ' ' },
        }
    },
}

---- Bind <leader>fp to Telescope projections
--require('telescope').load_extension('projections')
--
---- Autostore session on VimExit
--local Session = require("projections.session")
--vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
--    callback = function() Session.store(vim.loop.cwd()) end,
--})
--
--vim.api.nvim_create_autocmd({ "VimEnter" }, {
--    callback = function()
--        if vim.fn.argc() ~= 0 then return end
--        local session_info = Session.info(vim.loop.cwd())
--        if session_info == nil then
--            Session.restore_latest()
--        else
--            Session.restore(vim.loop.cwd())
--        end
--    end,
--    desc = "Restore last session automatically"
--})

require('gitsigns').setup()

require('crates').setup()

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local luasnip = require('luasnip')
local snippet = require('snippet')
luasnip.add_snippets(nil, snippet)
local cmp = require('cmp')
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = function(_)
            if cmp.visible() then
                cmp.confirm({ select = true })
            else
                cmp.complete()
            end
        end,
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources(
        {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'crates' },
            { name = 'cmp_pandoc' },
        }, {
            { name = 'buffer' },
        }, {
        { name = 'path' },
        --{ name = 'spell' },
    }
    )
})
require'cmp_pandoc'.setup()
-- opt.foldmethod='expr'
-- opt.foldexpr='nvim_treesitter#foldexpr()'
local open_diagnostics = function()
    local opts = {
        focusable = false,
        close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
end

local on_attach = function(client)
    vim.api.nvim_create_autocmd('CursorHold', {
        buffer = bufnr,
        callback = function()
            --open_diagnostics()
        end
    })
    require 'lsp_signature'.on_attach() -- Note: add in lsp client on-attach
end

-- configure the litee.nvim library 
require('litee.lib').setup({
    tree = {
        icon_set = "nerd"
    },
    panel = {
        orientation = "right",
        panel_size  = 30
    }
})


local icon_set = {
    Account         = "🗣",
    Array           = "",
    Bookmark        = "🏷",
    Boolean         = "∧",
    Calendar        = '🗓',
    Check           = '✓',
    CheckAll        = '🗸🗸',
    Circle          = '🞆',
    CircleFilled    = '●',
    CirclePause     = '⦷',
    CircleSlash     = '⊘',
    CircleStop      = '⦻',
    Class           = "𝓒",
    Collapsed       = "▶",
    Color           = "🖌",
    Comment         = '🗩',
    CommentExclaim  = '🗩',
    Constant        = "",
    Constructor     = "",
    DiffAdded       = '+',
    Enum            = "ℰ",
    EnumMember      = "",
    Event           = "🗲",
    Expanded        = "▼",
    Field           = "",
    File            = "",
    Folder          = "🗁",
    Function        = "",
    GitBranch       = ' ',
    GitCommit       = '⫰',
    GitCompare      = '⤄',
    GitIssue        = '⊙',
    GitMerge        = '⫰',
    GitPullRequest  = '⬰',
    GitRepo         = '🕮',
    History         = '⟲',
    IndentGuide     = "⎸",
    Info            = '🛈',
    Interface       = "ﰮ",
    Key             = "🔐",
    Keyword         = "",
    Method          = "ƒ",
    Module          = "",
    MultiComment    = '🗩',
    Namespace       = "[]",
    Notebook        = "🕮",
    Notification    = '🕭',
    Null            = "null",
    Number          = "#",
    Object          = "{}",
    Operator        = "+",
    Package         = "",
    Pass            = '🗸',
    PassFilled      = '🗸',
    Pencil          = '',
    Property        = "",
    Reference       = "⛉",
    RequestChanges  = '⨪',
    Separator       = "•",
    Space           = " ",
    String          = "𝓐",
    Struct          = "𝓢",
    Sync            = '🗘',
    Text            = "\"",
    TypeParameter   = "𝙏",
    Unit            = "U",
    Value           = "v",
    Variable        = "",
}


-- configure litee-symboltree.nvim
require('litee.symboltree').setup({
    map_resize_keys = false,
    icon_set_custom = icon_set
})
require('litee.calltree').setup({})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local null_ls = require("null-ls")

-- null_ls.setup({
--     sources = {
--         null_ls.builtins.completion.spell,
--     },
-- })


local lsp = require('lspconfig')
for ls, cfg in pairs({
    rust_analyzer = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            ['rust-analyzer'] = {
                diagnostics = {
                    enable = false;
                }
            }
        }
    },
    pylsp = {
        on_attach = on_attach,
        capabilities = capabilities,
    },
    clangd = {
        cmd = {"/usr/local/bin/clangd17"},
        on_attach = on_attach,
        capabilities = capabilities,
    },
    lua_ls = {
        cmd = {"/home/tant/git/lua-language-server-rust/bin/lua-language-server"},
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                version = 'Lua 5.1',
            }
        }
}
    },
}) do 
    vim.lsp.config(ls, cfg)
    vim.lsp.enable(ls)
end

require("arg_buffer").setup()

-- Key mappings
nmap('Q', 'gq', 'Format lines `gq`')

nmap('ü', '"0p', 'paste last yank')
nmap('Ü', '"0P', 'paste last yank')
vmap('ü', '"0p', 'paste last yank')
vmap('Ü', '"0P', 'paste last yank')

nmap('°', '^', 'Go to start of the line')
-- nmap('<leader>l', '<cmd>!leo <C-r><C-w><CR>')

nmap('<leader>ö', n_add_word, 'Add word to dictionary')
nmap('<F3>', require("arg_buffer").open, 'Show the arg list buffer')

-- nmap('<F12>', '<cmd>split ~/notes<CR>')

imap('<A-Down>', '<Esc>gja', 'move cursor down in wrap lines')
imap('<A-Up>', '<Esc>gka', 'move cursor up in wrap lines')
vmap('<A-Down>', 'gj', 'move cursor down in wrap lines')
vmap('<A-Up>', 'gk', 'move cursor up in wrap lines')
nmap('<A-Down>', 'gj', 'move cursor down in wrap lines')
nmap('<A-Up>', 'gk', 'move cursor up in wrap lines')

nmap('<C-Left>', ':previous<CR>', 'Goto previous buffer in arglist')
nmap('<C-Right>', ':next<CR>', 'Goto tp the next biffer in the arglist')
nmap('<C-S-Left>', ':cprevious<CR>', ' Got to previous buffer in the bufferlist')
nmap('<C-S-Right>', ':cnext<CR>', ' Got to next buffer in the bufferlist')

nmap('<Tab>', '>>_', 'ident line')
nmap('<S-Tab>', '<<_', 'indent line')
vmap('<Tab>', '>gv', 'indent visual selection')
vmap('<S-Tab>', '<gv', 'indent visual selection')

-- Move visual block
vmap('J', ":m '>+1<CR>gv=gv", 'move visual selection down')
vmap('K', ":m '<-2<CR>gv=gv", 'move visual selection up')

-- Use <C-L> to clear the highlighting of :set hlsearch.
nmap('<C-L>', ':nohlsearch<CR><C-L>', 'clear higlight')

tmap('<ESC>', '<C-\\><C-n>')
tmap('<C-v><ESC>', '<ESC>')

require('which-key').add({
    { "<leader>f", group = "find with Telescope" },
    { "<leader>l", group = "LSP" },
  }
 )


vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local opts = {buffer = true}

    nmap('<leader>lC', vim.lsp.buf.outgoing_calls, 'LSP calls out', opts)
    nmap('<leader>la', vim.lsp.buf.code_action, 'LSP code action', opts)
    nmap('<leader>lc', vim.lsp.buf.incoming_calls, 'LSP calls in', opts)
    nmap('<leader>lD', open_diagnostics, 'LSP open diagnostic', opts)
    nmap('<leader>ld', vim.lsp.buf.definition, 'LSP definition', opts)
    nmap('<leader>lf', vim.lsp.buf.format, 'LSP formatting', opts)
    nmap('<leader>lh', vim.lsp.buf.hover, 'LSP hover', opts)
    nmap('<leader>li', vim.lsp.buf.implementation, 'LSP calls', opts)
    nmap('<leader>lm', vim.lsp.buf.rename, 'LSP rename', opts)
    nmap('<leader>lr', vim.lsp.buf.references, 'LSP references', opts)
    nmap('<leader>ls', vim.lsp.buf.document_symbol, 'LSP document symbol', opts)
    nmap('<leader>lt', vim.lsp.buf.type_definition, 'LSP type definition', opts)
    nmap('gd', vim.lsp.buf.definition, 'Goto definition', opts)
    nmap('gD', vim.lsp.buf.declaration, 'Goto declaration', opts)
    nmap('<C-S-Left>', vim.diagnostic.goto_prev, ' Got to previous buffer in the bufferlist', opts)
    nmap('<C-S-Right>', vim.diagnostic.goto_next, ' Got to next buffer in the bufferlist', opts)
  end
})



nmap("<leader>fp", function() vim.cmd("Telescope projections") end, 'Telescope projections')
nmap('<leader>ff', require('telescope.builtin').find_files, 'Telescope find files')
nmap('<leader>fg', require('telescope.builtin').live_grep, 'Telescope live grep')
nmap('<leader>fb', require('telescope.builtin').buffers, 'Telescope buffers')
nmap('<leader>fh', require('telescope.builtin').help_tags, 'Telescope help tags')

imap('<C-J>', luasnip.expand_or_jump, 'LuaSnip expand or jump')
imap('<C-S-J>', function() luasnip.jump(-1) end, 'LuaSnip jump back')
imap('<C-B>', function() luasnip.change_choice(1) end, 'LuaSnip next choice')
imap('<C-S-B>', function() luasnip.change_choice(-1) end, 'LuaSnip previous choice')

g.togglecursor_force = 'xterm'
