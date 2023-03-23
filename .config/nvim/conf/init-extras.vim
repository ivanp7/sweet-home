" horizontal (column) ruler {{{

let g:column_ruler_auto = v:false

function! ShowColumnRuler(placement)
    let g:column_ruler_auto = v:true
    if !exists("w:column_ruler_window") && !exists("w:column_ruler")
        let l:win_id = win_getid()

        let l:win_view = winsaveview()

        setl scrollbind scrollopt+=hor cursorcolumn
        if a:placement == 'b'
            sp +enew
        else
            abo sp +enew
        endif
        call setline(1,'....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8....+....9....+....|....+....|....+....|')
        let &l:statusline="%#Normal#".repeat(' ',winwidth(0))
        res 1
        setl scrollbind nomod buftype=nofile winfixheight nonumber nocursorline nocursorcolumn bufhidden=wipe nobuflisted

        let w:column_ruler_window = l:win_id
        let l:win_id = win_getid()
        call win_gotoid(w:column_ruler_window)
        let w:column_ruler = l:win_id

        call winrestview(l:win_view)
    endif
    let g:column_ruler_auto = v:false
endfunction

function! ForgetColumnRuler()
    if exists("w:column_ruler")
        setl scrollopt-=hor noscrollbind nocursorcolumn
        unlet w:column_ruler
    endif
endfunction

function! HideColumnRuler()
    let g:column_ruler_auto = v:true
    if exists("w:column_ruler")
        let l:column_ruler = v:true
        call win_gotoid(w:column_ruler)
    endif
    if exists("l:column_ruler") || exists("w:column_ruler_window")
        let l:win_id = w:column_ruler_window
        quit
        call win_gotoid(l:win_id)
        call ForgetColumnRuler()
    endif
    let g:column_ruler_auto = v:false
endfunction

let g:column_ruler_window_count = winnr('$')

function! AutoHideColumnRulerWinLeave()
    if g:column_ruler_auto
        return
    endif

    let g:column_ruler_window_count = winnr('$')
    if exists("w:column_ruler")
        let g:column_ruler_to_hide = w:column_ruler
        let g:column_ruler_to_hide_window_mode = v:false
    elseif exists("w:column_ruler_window")
        let g:column_ruler_to_hide = w:column_ruler_window
        let g:column_ruler_to_hide_window_mode = v:true
    endif
endfunction

function! AutoHideColumnRulerWinEnter()
    if g:column_ruler_auto
        return
    else
        let g:column_ruler_auto = v:true
    endif

    let l:wincount = winnr('$')
    if exists("g:column_ruler_to_hide")
        if (l:wincount < g:column_ruler_window_count)
            call win_gotoid(g:column_ruler_to_hide)
            if !g:column_ruler_to_hide_window_mode
                unlet w:column_ruler_window
                quit
            else
                call ForgetColumnRuler()
            endif
        endif

        unlet g:column_ruler_to_hide
        unlet g:column_ruler_to_hide_window_mode
    endif

    let g:column_ruler_auto = v:false
endfunction

autocmd WinLeave * call AutoHideColumnRulerWinLeave()
autocmd WinEnter * call AutoHideColumnRulerWinEnter()

function! SwitchColumnRuler(placement)
    if !exists("w:column_ruler") && !exists("w:column_ruler_window")
        call ShowColumnRuler(a:placement)
    else
        call HideColumnRuler()
    endif
endfunction

nnoremap <silent> <leader>r :call SwitchColumnRuler('t')<CR>
nnoremap <silent> <leader>R :call SwitchColumnRuler('b')<CR>

" }}}
" buffer difference {{{

let g:buffer_diff_auto = v:false

function! ShowBufferDiff(direction)
    let g:buffer_diff_auto = v:true
    if !exists("w:buffer_diff_window") && !exists("w:buffer_diff")
        let l:win_id = win_getid()

        if a:direction == 'h'
            lefta vsp +enew
        elseif a:direction == 'j'
            sp +enew
        elseif a:direction == 'k'
            abo sp +enew
        else
            vsp +enew
        endif
        silent r #
        0d_
        setl nomod buftype=nofile bufhidden=wipe nobuflisted
        diffthis

        let w:buffer_diff_window = l:win_id
        let l:win_id = win_getid()
        call win_gotoid(w:buffer_diff_window)
        let w:buffer_diff = l:win_id

        diffthis
    endif
    let g:buffer_diff_auto = v:false
endfunction

function! ForgetBufferDiff()
    if exists("w:buffer_diff")
        diffoff
        unlet w:buffer_diff
    endif
endfunction

function! HideBufferDiff()
    let g:buffer_diff_auto = v:true
    if exists("w:buffer_diff")
        let l:buffer_diff = v:true
        call win_gotoid(w:buffer_diff)
    endif
    if exists("l:buffer_diff") || exists("w:buffer_diff_window")
        let l:win_id = w:buffer_diff_window
        quit
        call win_gotoid(l:win_id)
        call ForgetBufferDiff()
    endif
    let g:buffer_diff_auto = v:false
endfunction

let g:buffer_diff_window_count = winnr('$')

function! AutoHideBufferDiffWinLeave()
    if g:buffer_diff_auto
        return
    endif

    let g:buffer_diff_window_count = winnr('$')
    if exists("w:buffer_diff")
        let g:buffer_diff_to_hide = w:buffer_diff
        let g:buffer_diff_to_hide_window_mode = v:false
    elseif exists("w:buffer_diff_window")
        let g:buffer_diff_to_hide = w:buffer_diff_window
        let g:buffer_diff_to_hide_window_mode = v:true
    endif
endfunction

function! AutoHideBufferDiffWinEnter()
    if g:buffer_diff_auto
        return
    else
        let g:buffer_diff_auto = v:true
    endif

    let l:wincount = winnr('$')
    if exists("g:buffer_diff_to_hide")
        if (l:wincount < g:buffer_diff_window_count)
            call win_gotoid(g:buffer_diff_to_hide)
            if !g:buffer_diff_to_hide_window_mode
                unlet w:buffer_diff_window
                quit
            else
                call ForgetBufferDiff()
            endif
        endif

        unlet g:buffer_diff_to_hide
        unlet g:buffer_diff_to_hide_window_mode
    endif

    let g:buffer_diff_auto = v:false
endfunction

function! UpdateBufferDiff()
    let g:buffer_diff_auto = v:true
    if exists("w:buffer_diff")
        call win_gotoid(w:buffer_diff)
        diffoff
        normal gg"_dG
        silent r #
        0d_
        diffthis
        call win_gotoid(w:buffer_diff_window)
    endif
    let g:buffer_diff_auto = v:false
endfunction

autocmd WinLeave * call AutoHideBufferDiffWinLeave()
autocmd WinEnter * call AutoHideBufferDiffWinEnter()
autocmd BufWritePost * silent call UpdateBufferDiff()

function! SwitchBufferDiff(direction)
    if !exists("w:buffer_diff") && !exists("w:buffer_diff_window")
        call ShowBufferDiff(a:direction)
    else
        call HideBufferDiff()
    endif
endfunction

nnoremap <silent> <leader>ih :call SwitchBufferDiff('h')<CR>
nnoremap <silent> <leader>ij :call SwitchBufferDiff('j')<CR>
nnoremap <silent> <leader>ik :call SwitchBufferDiff('k')<CR>
nnoremap <silent> <leader>il :call SwitchBufferDiff('l')<CR>

" }}}

" vim: foldmethod=marker:
