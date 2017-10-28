"Start
packadd minpac

call minpac#init()
call minpac#add('Valloric/YouCompleteMe', {'name': 'YouCompleteMe'})
call minpac#add('tpope/vim-fugitive', {'name': 'fugitive'})
call minpac#add('rking/ag.vim', {'name': 'ag'})
call minpac#add('jlanzarotta/bufexplorer', {'name': 'bufexplorer'})
call minpac#add('sjl/gundo.vim', {'name': 'gundo'})
call minpac#add('honza/vim-snippets', {'name': 'vim-snippets'})
call minpac#add('thinca/vim-localrc', {'name': 'localrc'})
call minpac#add('vim-scripts/rfc-syntax', {'name': 'rfc-syntax'})
call minpac#add('scrooloose/syntastic', {'name': 'syntastic'})
call minpac#add('majutsushi/tagbar', {'name': 'tagbar'})
call minpac#add('jszakmeister/vim-togglecursor', {'name': 'togglecursor'})
call minpac#add('SirVer/ultisnips', {'name': 'ultisnips'})
call minpac#add('mhinz/vim-rfc', {'name': 'vim-rfc'})
call minpac#add('vim-scripts/vimwiki', {'name': 'vimwiki'})
call minpac#add('AndrewRadev/linediff.vim', {'name': 'linediff'})


call minpac#add('git@github.com:raphaelahrens/spell.git', {'name': 'raspell'})

" OPT
call minpac#add('vim-scripts/confluencewiki.vim', {'type': 'opt', 'name': 'confluencewiki.vim'})
"" JS 
call minpac#add('othree/javascript-libraries-syntax.vim', {'type': 'opt', 'name': 'javascript-libraries-syntax'})
call minpac#add('Shutnik/jshint2.vim', {'type': 'opt', 'name': 'jshint2'})
call minpac#add('othree/yajs.vim', {'type': 'opt', 'name': 'yajs'})
" Python
call minpac#add('jmcantrell/vim-virtualenv', {'type': 'opt', 'name': 'vim-virtualenv'})
call minpac#add('nvie/vim-flake8', {'type': 'opt', 'name': 'vim-flake8'})
call minpac#add('hdima/python-syntax', {'type': 'opt', 'name': 'python-syntax'})
""Elixir
call minpac#add('elixir-lang/vim-elixir', {'type': 'opt', 'name': 'vim-elixir'})
"" Pandoc
call minpac#add('vim-pandoc/vim-pandoc-syntax', {'type': 'opt', 'name': 'vim-pandoc-syntax'})
"" Writing
call minpac#add('inkarkat/vim-SpellCheck', {'type': 'opt', 'name': 'vim-SpellCheck'})
call minpac#add('inkarkat/vim-ingo-library', {'type': 'opt', 'name': 'vim-ingo-library'})

call minpac#update()
call minpac#clean()
