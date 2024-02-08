" tweak syntax
autocmd FileType lisp syntax clear lispAtom
autocmd FileType lisp syntax clear lispEscapeSpecial
autocmd FileType lisp syntax clear lispAtomList
autocmd FileType lisp syntax clear lispBQList

" ******************** vim-sexp ****************************

let g:sexp_insert_after_wrap = 0

let g:sexp_mappings = {
            \ 'sexp_flow_to_prev_open':         'g?(',
            \ 'sexp_flow_to_next_close':        'g/)',
            \ 'sexp_flow_to_prev_close':        'g?)',
            \ 'sexp_flow_to_next_open':         'g/(',
            \ 'sexp_flow_to_prev_leaf_head':    'gH',
            \ 'sexp_flow_to_next_leaf_head':    'gh',
            \ 'sexp_flow_to_prev_leaf_tail':    'gL',
            \ 'sexp_flow_to_next_leaf_tail':    'gl',
            \
            \ 'sexp_round_head_wrap_list':      '<LocalLeader>ei',
            \ 'sexp_round_tail_wrap_list':      '<LocalLeader>eI',
            \ 'sexp_round_head_wrap_element':   '<LocalLeader>ew',
            \ 'sexp_round_tail_wrap_element':   '<LocalLeader>eW',
            \ 'sexp_splice_list':               '<LocalLeader>e@',
            \ 'sexp_convolute':                 '<LocalLeader>e?',
            \ 'sexp_raise_list':                '<LocalLeader>eo',
            \ 'sexp_raise_element':             '<LocalLeader>eO',
            \
            \ 'sexp_insert_at_list_head':       '<LocalLeader>eh',
            \ 'sexp_insert_at_list_tail':       '<LocalLeader>el',
            \
            \ 'sexp_square_head_wrap_list':     '<LocalLeader>e[',
            \ 'sexp_square_tail_wrap_list':     '<LocalLeader>e]',
            \ 'sexp_curly_head_wrap_list':      '<LocalLeader>e{',
            \ 'sexp_curly_tail_wrap_list':      '<LocalLeader>e}',
            \ 'sexp_square_head_wrap_element':  '<LocalLeader>ee[',
            \ 'sexp_square_tail_wrap_element':  '<LocalLeader>ee]',
            \ 'sexp_curly_head_wrap_element':   '<LocalLeader>ee{',
            \ 'sexp_curly_tail_wrap_element':   '<LocalLeader>ee}',
            \ }

autocmd FileType lisp imap <silent><buffer> <C-H> <Plug>(sexp_insert_backspace)

" ******************** vlime *******************************

let g:vlime_leader = '<LocalLeader>'
let g:vlime_enable_autodoc = v:true
let g:vlime_window_settings =
      \ {'repl':      {'pos': 'belowright', 'vertical': v:true},
       \ 'sldb':      {'pos': 'belowright', 'vertical': v:true},
       \ 'inspector': {'pos': 'belowright', 'vertical': v:true},
       \ 'preview':   {'pos': 'belowright', 'size': v:null, 'vertical': v:true}}

let g:vlime_force_default_keys = v:true
" let g:vlime_cl_use_terminal = v:true

function! VlimeEnableInteractionMode()
    let b:vlime_interaction_mode = v:true
    nnoremap <buffer> <silent> <CR> :call vlime#plugin#SendToREPL(vlime#ui#CurExprOrAtom())<CR>
    vnoremap <buffer> <silent> <CR> :<c-u>call vlime#plugin#SendToREPL(vlime#ui#CurSelection())<CR>
endfunction

autocmd FileType lisp call VlimeEnableInteractionMode()
autocmd BufNewFile,BufRead * if &ft=~?'lisp'|:call VlimeEnableInteractionMode()|endif

let g:vlime_cl_impl = "sbcl"
function! VlimeBuildServerCommandFor_sbcl(vlime_loader, vlime_eval)
    return ["sbcl",
                \ "--load", a:vlime_loader,
                \ "--eval", a:vlime_eval]
endfunction

" ******************** lisp-semantic-highlight *******************************

let g:semanticLispPersistCacheLocation = $XDG_CACHE_HOME . "/nvim/semantic-lisp-highlight-cache"

