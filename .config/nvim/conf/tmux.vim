let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-M-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-M-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-M-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-M-l> :TmuxNavigateRight<CR>

" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

" vim: foldmethod=marker:
