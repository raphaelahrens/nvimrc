function! s:TrimEmptyLines()
    """ Trim empty lines after header and replace it by exactly one empty line
    "if first line is 
    silent! 1s/\(^#.*\)\(\n\s*\)*\n/\1\r\r/e
    if line('$') >= 2
        silent! 2,$s/\(^\s*\n\)*\(^#.*\)\(\n\s*\)*\n/\r\2\r\r/e
    endif
endfunc

function! s:SpaceHeader()
    """ Put a Space between "#" and the header text 
    silent! %s/\v(^#{1,6})([^# ]{1})/\1 \2/e
endfunc

function! s:FormatMarkdown()
    let cursor_pos = getpos(".")
    call s:TrimEmptyLines()
    call s:SpaceHeader()
    call cursor(cursor_pos[1], cursor_pos[2])
endfunc

set complete+=kspell

augroup markdowntant
    autocmd BufWritePre <buffer> :call s:FormatMarkdown()
augroup END
