"Start
packadd minpac

call minpac#init({'verbose':3})
call minpac#add('sjl/gundo.vim', {'name': 'gundo'})
call minpac#add('SirVer/ultisnips', {'name': 'ultisnips'})
call minpac#add('honza/vim-snippets', {'name': 'vim-snippets'})
call minpac#add('majutsushi/tagbar', {'name': 'tagbar'})
call minpac#add('jszakmeister/vim-togglecursor', {'name': 'togglecursor'})
call minpac#add('AndrewRadev/linediff.vim', {'name': 'linediff'})
call minpac#add('dense-analysis/ale', {'name': 'ale'})
call minpac#add('mhinz/vim-grepper', {'name': 'grepper'}) 
call minpac#add('wsdjeg/vim-todo', {'name': 'todo'})
call minpac#add('airblade/vim-gitgutter', {'name': 'gitgutter'})

call minpac#add('raphaelahrens/spell', {'name': 'raspell'})
call minpac#add('raphaelahrens/timesheet.vim', {'name': 'timesheet'})
call minpac#add('dannywillems/vim-icalendar', {'name': 'icalendar'})

" OPT
" Python
call minpac#add('jmcantrell/vim-virtualenv', {'type': 'opt', 'name': 'vim-virtualenv'})
call minpac#add('hdima/python-syntax', {'type': 'opt', 'name': 'python-syntax'})
""Elixir
"" Pandoc
call minpac#add('vim-pandoc/vim-pandoc-syntax', {'type': 'opt', 'name': 'vim-pandoc-syntax'})
"" Writing
call minpac#add('inkarkat/vim-SpellCheck', {'type': 'opt', 'name': 'vim-SpellCheck'})
call minpac#add('inkarkat/vim-ingo-library', {'type': 'opt', 'name': 'vim-ingo-library'})
"" RFC
call minpac#add('vim-scripts/rfc-syntax', {'type': 'opt', 'name': 'rfc-syntax'})
call minpac#add('mhinz/vim-rfc', {'type': 'opt', 'name': 'vim-rfc'})

"" Jupyter Notebooks
call minpac#add('jupyter-vim/jupyter-vim', {'type': 'opt', 'name': 'jupyter-vim'})

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

call minpac#clean()
call minpac#update("", {"do": "quit"})
