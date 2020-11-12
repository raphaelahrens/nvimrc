set encoding=utf-8
scriptencoding utf-8
colorscheme tantmustang
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set directory^=~/swp

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Windows split
set splitright

set nobackup		" do not keep a backup file, use versions instead
set history=250		" keep 250 lines of command line history
set hidden          " Abandon buffers even if they have changes
set number          " The numbered lines
set laststatus=2    " Always show the status line
set ruler	    	" show the cursor position all the time
set showcmd	    	" display incomplete commands
set wildmenu        " show matched words of tab completion and highlight selected
set wildmode=longest,list,full " complete longest match and then show menu
" set completeopt=longest,menu,preview " complete longest match and then show menu
set completeopt=preview,menuone,noselect " complete longest match and then show menu
set scrolloff=1 
set display+=lastline

set formatoptions+=j " Delete comment character when joining commented lines

set mouse=a         " In many terminal emulators the mouse works just fine, thus enable it.

set incsearch		" do incremental searching
set hlsearch

" jamessan's
set statusline=   " clear the statusline for when vimrc is reloaded
set statusline+=%-3.3n\                      " buffer number
set statusline+=[%{strlen(&ft)?&ft:'none'},  " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%t\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=%=                           " right align
" set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\  " highlight
set statusline+=%b,0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

set fileencodings=ucs-bom,utf-8,latin1
" Show line breaks with a beginning …
set showbreak=…
" Set tab to 4 spaces
set tabstop=4 shiftwidth=4 expandtab
" change the symbols for tab and eol for :set list!
set listchars=tab:▸\ ,eol:¬

highlight Cursor guifg=white guibg=black
highlight iCursor guifg=white guibg=steelblue
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkwait10
set guicursor&
"""""
" END
"""""

"""""""""""""""""""""""""""""""""
"Execute shell command in buffer"
"""""""""""""""""""""""""""""""""
function! s:ExecuteInShell(command, bang)
	let _ = a:bang != '' ? s:_ : a:command == '' ? '' : join(map(split(a:command), 'expand(v:val)'))

	if (_ != '')
		let s:_ = _
		let bufnr = bufnr('%')
		let winnr = bufwinnr('^' . _ . '$')
		silent! execute  winnr < 0 ? 'belowright new ' . fnameescape(_) : winnr . 'wincmd w'
		setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile wrap number
		silent! :%d
		let message = 'Execute ' . _ . '...'
		call append(0, message)
		echo message
		silent! 2d | resize 1 | redraw
		silent! execute 'silent! %!'. _
		silent! execute 'resize ' . line('$')
		silent! execute 'syntax on'
		silent! execute 'autocmd BufUnload <buffer> execute bufwinnr(' . bufnr . ') . ''wincmd w'''
		silent! execute 'autocmd BufEnter <buffer> execute ''resize '' .  line(''$'')'
		silent! execute 'nnoremap <silent> <buffer> <CR> :call <SID>ExecuteInShell(''' . _ . ''', '''')<CR>'
		silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . _ . ''', '''')<CR>'
		silent! execute 'nnoremap <silent> <buffer> <LocalLeader>g :execute bufwinnr(' . bufnr . ') . ''wincmd w''<CR>'
		nnoremap <silent> <buffer> <C-W>_ :execute 'resize ' . line('$')<CR>
		silent! syntax on
		silent! execute 'AnsiEsc'
	endif
endfunction
"""""""""""""""""""""""""""""""""
"Set command to shell and Shell
command! -complete=shellcmd -nargs=* -bang Shell call s:ExecuteInShell(<q-args>, '<bang>')
cabbrev shell Shell
"""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis


" Pathogen load
filetype off

filetype plugin indent on
syntax on

let mapleader = "ä"

" Don't use Ex mode, use Q for formatting
nnoremap Q gq

" Copy from cousor to the end of the line and ignore vi defaults
nnoremap Y y$

" The better p and P command
nnoremap ü "0p
nnoremap Ü "0P
vnoremap ü "0p
vnoremap Ü "0P

nnoremap ° ^

nnoremap <Leader>c :Gstatus<CR>
nnoremap <Leader>sw :SessionSave<CR>
nnoremap <Leader>sl :SessionList<CR>
nnoremap <Leader>l :!leo <C-R><C-W><CR>

function! AddWord(word)
    execute "terminal addword --choose \"".a:word."\""
    if v:shell_error != 0
        return 1
    endif

    "let changedDict = system("cat ~/.vim/spell/.last-spell")
    let changedDict = system("cat ~/.config/nvim/pack/minpac/start/raspell/spell")
    silent execute "mkspell! ".changedDict
    redraw!
    return 0
endfunc

function! VAddWord()
    let temp = @t
    norm! gv"ty
    call AddWord(@t)
    let @t = temp
endfunc

function! NAddWord()
    let word = expand("<cword>")
    call AddWord(word)
endfunc

function! RemoveFromArgList()
    execute ".argdelete"
    execute "next"
endfunc

nnoremap <Leader>ö :call NAddWord()<CR>
vnoremap <Leader>ö :call VAddWord()<CR>

nnoremap <Leader>dd :call RemoveFromArgList()<CR>

nnoremap <F3> :BufExplorer<CR>
nnoremap <F5> :GundoToggle<CR>
nnoremap <F7> :TagbarToggle<CR>
nnoremap <F9> :edit %:p:h<CR>
nnoremap <F11> :split ~/.vim/tolearn.txt<CR>
nnoremap <F12> :split ~/notes<CR>
" Move trow linebreaks
inoremap <A-Down> <Esc>gja
inoremap <A-Up> <Esc>gka
vnoremap <A-Down> gj
vnoremap <A-up> gk
nnoremap <A-Down> gj
nnoremap <A-Up> gk

nnoremap <silent> <C-Left> :previous<CR>
nnoremap <silent> <C-Right> :next<CR>
nnoremap <silent> <C-S-Left> :cprevious<CR>
nnoremap <silent> <C-S-Right> :cnext<CR>

nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
nnoremap <Leader>* :Grepper -cword -noprompt<CR>

if has("gui_running") || has("nvim")
    " C-Space seems to work under gVim and neovim
    inoremap <C-Space> <C-n>
else " no gui
  if has("unix")
    inoremap <Nul> <C-n>
  else
  " I have no idea of the name of Ctrl-Space elsewhere
  endif
endif

tnoremap <ESC> <C-\><C-n>
tnoremap <C-v><ESC> <ESC>

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function! PrintFile(fname)
   call system("cat " . a:fname . " | gtklp")
   call delete(a:fname)
   return v:shell_error
endfunction
set printexpr=PrintFile(v:fname_in)

let g:jsdoc_default_mapping = 0

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<C-S-Space>"
let g:UltiSnipsJumpForwardTrigger="<C-S-Space>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

let g:togglecursor_force = "xterm"

let g:ale_completion_enabled = 1
let g:ale_linters = {'rust': ['rls']}
