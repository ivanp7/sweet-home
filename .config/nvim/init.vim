" options {{{

set expandtab             " Use spaces instead of tabs.
set tabstop     =4        " Tab key indents by 4 spaces.
set softtabstop =4        " Tab key indents by 4 spaces.
set shiftwidth  =4        " >> indents by 4 spaces.
set shiftround            " >> indents to next multiple of 'shiftwidth'.

set hidden                " Switch between buffers without having to save first.
set splitbelow            " Open new windows below the current window.
set splitright            " Open new windows right of the current window.

set number
set relativenumber
set cursorline            " Find the current line quickly.
set scroll      =10

set report      =0        " Always report changed lines.
set wrapscan              " Searches wrap around end-of-file.
set noshowmode

set inccommand  =nosplit

set wildmode    =longest,list,full

set synmaxcol   =400      " Only highlight the first 400 columns.

set mouse       =a

set termguicolors

set title
set titlestring=%(%{expand(\"%:~:.:h\")}%)/%t\ -\ nvim

set list                   " Show non-printable characters.
if has('multi_byte') && &encoding ==# 'utf-8'
  let &listchars = 'tab:▸ ,extends:❯,precedes:❮,nbsp:±'
else
  let &listchars = 'tab:> ,extends:>,precedes:<,nbsp:.'
endif

set clipboard+=unnamedplus

set langmap=ЁФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;~ABCDEFGHIJKLMNOPQRSTUVWXYZ,ёфисвуапршолдьтщзйкыегмцчня;`abcdefghijklmnopqrstuvwxyz
set keymap=russian
set iminsert=0
set spelllang=en_us,ru_yo

set timeoutlen=3000

set backup
set backupdir   -=.
set backupext    =-vimbackup
set updatecount =100
set undofile

if empty($XDG_CACHE_HOME)
    let $XDG_CACHE_HOME = $HOME . '/.cache'
endif

set viewdir=$XDG_CACHE_HOME/nvim/view
set shada+='1000,n$XDG_CACHE_HOME/nvim/info

" }}}
" editing of binary files using hexmode {{{

" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    silent :e " this will reload the file without trickeries
              "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

" autocmds to automatically enter hex mode and handle file writes properly
if has("autocmd")
  " vim -b : edit binary using xxd-format!
  augroup Binary
    au!

    " set binary option for all binary files before reading them
    au BufReadPre *.bin,*.hex setlocal binary

    " if on a fresh read the buffer variable is already set, it's wrong
    au BufReadPost *
          \ if exists('b:editHex') && b:editHex |
          \   let b:editHex = 0 |
          \ endif

    " convert to hex on startup for binary files automatically
    au BufReadPost *
          \ if &binary | Hexmode | endif

    " When the text is freed, the next time the buffer is made active it will
    " re-read the text and thus not match the correct mode, we will need to
    " convert it again if the buffer is again loaded.
    au BufUnload *
          \ if getbufvar(expand("<afile>"), 'editHex') == 1 |
          \   call setbufvar(expand("<afile>"), 'editHex', 0) |
          \ endif

    " before writing a file when editing in hex mode, convert back to non-hex
    au BufWritePre *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd -r" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif

    " after writing a binary file, if we're in hex mode, restore hex mode
    au BufWritePost *
          \ if exists("b:editHex") && b:editHex && &binary |
          \  let oldro=&ro | let &ro=0 |
          \  let oldma=&ma | let &ma=1 |
          \  silent exe "%!xxd" |
          \  exe "set nomod" |
          \  let &ma=oldma | let &ro=oldro |
          \  unlet oldma | unlet oldro |
          \ endif
  augroup END
endif

" }}}
" custom mappings {{{

" Record into register 'q', playback with 'Q'
nnoremap Q @q

noremap \ ,
noremap ,, ,
noremap ,; ,

let mapleader=","
let maplocalleader=" "

set cedit=\<C-Y>

" New buffers
nnoremap <silent> <leader>e :enew<CR>
nnoremap <silent> <leader>l :enew<CR>:set<Space>ft=lisp<CR>

" Paste mode toggle
autocmd VimEnter * set pastetoggle=<F2>

" Switch language
nnoremap <silent> <C-^> :let &iminsert = (&iminsert == 0 ? 1 : 0)<CR>
nnoremap <silent> <C-S> :let &iminsert = (&iminsert == 0 ? 1 : 0)<CR>
inoremap <silent> <C-S> <C-O>:let &iminsert = (&iminsert == 0 ? 1 : 0)<CR>

" Unfocus terminal
tnoremap <silent> <C-\><C-\> <C-\><C-N>

" GDB ------------------------------------------------------------------------

" info
nnoremap <silent> <F8>a :call TermDebugSendCommand('info args')<CR>
nnoremap <silent> <F8>t :call TermDebugSendCommand('info threads')<CR>
nnoremap <silent> <F8>v :call TermDebugSendCommand('info locals')<CR>
nnoremap <silent> <F8>w :call TermDebugSendCommand('where')<CR>

" stack navigation
nnoremap <silent> <F8>u :call TermDebugSendCommand('up')<CR>
nnoremap <silent> <F8>d :call TermDebugSendCommand('down')<CR>

" stepping
nnoremap <silent> <F8>c :call TermDebugSendCommand('continue')<CR>
nnoremap <silent> <F8>f :call TermDebugSendCommand('finish')<CR>
nnoremap <silent> <F8>n :call TermDebugSendCommand('next')<CR>
nnoremap <silent> <F8>N :call TermDebugSendCommand('nexti')<CR>
nnoremap <silent> <F8>s :call TermDebugSendCommand('step')<CR>
nnoremap <silent> <F8>S :call TermDebugSendCommand('stepi')<CR>

" starting
nnoremap <silent> <F8>r :call TermDebugSendCommand('run')<CR>
nnoremap <silent> <F8>R :call TermDebugSendCommand('start')<CR>

" other
nnoremap <silent> <F8><F8> :call TermDebugSendCommand(input('gdb> '))<CR>
nnoremap <F8><Space> :Evaluate<Space>

" quick actions
nnoremap <silent> <F5> :Run<CR>
nnoremap <silent> <F6> :Stop<CR>

nnoremap <silent> <F7> :Gdb<CR>A

nnoremap <silent> <F8>b :Break<CR>
nnoremap <silent> <F8>B :Clear<CR>
nnoremap <silent> <F9> :Break<CR>
nnoremap <silent> <S-F9> :Clear<CR>

nnoremap <silent> <F10> :Over<CR>
nnoremap <silent> <F11> :Step<CR>
nnoremap <silent> <S-F11> :Finish<CR>
nnoremap <silent> <F12> :Finish<CR>

" }}}
" movement mappings {{{

" Map the cursor keys for precision scrolling by visual lines
imap <up> <C-O>gk
imap <down> <C-O>gj
nmap <up> gk
nmap <down> gj
vmap <up> gk
vmap <down> gj

" Emacs-style editing in insert mode and on the command-line:
" start of line
noremap! <C-A>  <Home>
" back one character
noremap! <C-B>  <Left>
" delete character under cursor
noremap! <C-D>  <Del>
" end of line
noremap! <C-E>  <End>
" forward one character
noremap! <C-F>  <Right>

" }}}
" copy-paste mappings {{{

noremap Y y$

" black hole register operations
map <leader>d "_d
map <leader>D "_D
map <leader>x "_x
map <leader>X "_X
map <leader>c "_c
map <leader>C "_C

" file name/path copying
command! CopyRelativePath        let @" = expand("%")                     | exe 'CCO' | call TmuxYank()
command! CopyRelativePathAndLine let @" = expand("%") . ":" . line('.')   | exe 'CCO' | call TmuxYank()
command! CopyAbsolutePath        let @" = expand("%:p")                   | exe 'CCO' | call TmuxYank()
command! CopyAbsolutePathAndLine let @" = expand("%:p") . ":" . line('.') | exe 'CCO' | call TmuxYank()
command! CopyFileName            let @" = expand("%:t")                   | exe 'CCO' | call TmuxYank()
command! CopyFileDirectory       let @" = expand("%:p:h")                 | exe 'CCO' | call TmuxYank()

nnoremap <silent> <leader>yn :CopyFileName<CR>
nnoremap <silent> <leader>yd :CopyFileDirectory<CR>
nnoremap <silent> <leader>ypp :CopyAbsolutePath<CR>
nnoremap <silent> <leader>ypl :CopyAbsolutePathAndLine<CR>
nnoremap <silent> <leader>ypP :CopyRelativePath<CR>
nnoremap <silent> <leader>ypL :CopyRelativePathAndLine<CR>

" }}}
" indentation mappings {{{

" Visual mode blockwise indent
vmap > >gv
vmap < <gv

" }}}
" search&replace mappings {{{

nnoremap <silent> <leader>o :noh<CR>

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - https://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
    " Save the current register and clipboard
    let reg_save = getreg('"')
    let regtype_save = getregtype('"')
    let cb_save = &clipboard
    set clipboard&

    " Put the current visual selection in the " register
    normal! ""gvy
    let selection = getreg('"')

    " Put the saved registers and clipboards back
    call setreg('"', reg_save, regtype_save)
    let &clipboard = cb_save

    return selection
endfunction

" Escape special characters in a string for exact matching.
" This is useful to copying strings from the file to the search tool
" Based on this - http://peterodding.com/code/vim/profile/autoload/xolox/escape.vim
function! EscapeString (string, type)
    let string=a:string
    " Escape regex characters
    if !a:type
        let string = escape(string, '^$.*\/~[]')
    else
        let string = escape(string, '\/~&')
    endif
    " Escape the line endings
    let string = substitute(string, '\n', '\\n', 'g')
    return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - https://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetEscapedVisual(type) range
    let selection = GetVisual()

    "Escape any special characters in the selection
    let escaped_selection = EscapeString(selection, a:type)

    return escaped_selection
endfunction

vnoremap <leader>v <Esc>/<C-r>=GetEscapedVisual(0)<CR><CR>
vnoremap <leader>V <Esc>/\<<C-r>=GetEscapedVisual(0)<CR>\><CR>
vnoremap <leader>z <Esc>:%s/<c-r>=GetEscapedVisual(0)<cr>//gc<left><left><left>

function! ReplaceWith()
    let expr = GetEscapedVisual(0)
    let expr_str = GetEscapedVisual(1)

    call inputsave()
    let new_expr = input('replace /' . expr . '/ with: ', expr_str)

    if new_expr == expr_str
        call inputrestore()
        return
    endif

    let scope = input('replace /' . expr . '/ with /' . new_expr . '/ in: ', '%')
    call inputrestore()

    let command = scope . 's/' . expr . '/' . new_expr . '/gc'
    execute command
    call histadd("cmd", command)
endfunction

vnoremap <silent> <leader>Z <Esc>:call ReplaceWith()<CR>

" }}}
" user interface operations mappings {{{

" Close window
nnoremap <silent> <C-Q> :q<CR>

" Resize windows
nnoremap <silent> <C-W><C-H> :vert res -10<CR>
nnoremap <silent> <C-W><C-J> :res -5<CR>
nnoremap <silent> <C-W><C-K> :res +5<CR>
nnoremap <silent> <C-W><C-L> :vert res +10<CR>
" Switch between windows: nmap <silent> <C-hjkl> :wincmd hjkl<CR>

nnoremap <silent> gb :bnext<CR>
nnoremap <silent> gB :bprev<CR>

function! SwitchToNextBuffer(incr)
    let help_buffer = (&filetype == 'help')
    let current = bufnr("%")
    let last = bufnr("$")
    let new = current + a:incr
    while 1
        if new != 0 && bufexists(new) &&
           \ ((getbufvar(new, "&filetype") == 'help') == help_buffer)
            execute ":buffer ".new
            break
        else
            let new = new + a:incr
            if new < 1
                let new = last
            elseif new > last
                let new = 1
            endif
            if new == current
                break
            endif
        endif
    endwhile
endfunction

nnoremap <silent> <C-N> :call SwitchToNextBuffer(1)<CR>
nnoremap <silent> <C-P> :call SwitchToNextBuffer(-1)<CR>

" Copy text to/from the system clipboard
command! CCI let @" = @+
command! CCO let @+ = @" | let @* = @"

" Color column
function! SwitchColorColumn()
    if &colorcolumn == ''
        let &colorcolumn="80,100,120,140,160"
    else
        let &colorcolumn=""
    endif
endfunction

nnoremap <silent> <leader>t :call SwitchColorColumn()<CR>

nnoremap <silent> <leader>n :set relativenumber!<CR>

" }}}
" built-in plugins {{{

" ******************** termdebug **************************

packadd termdebug
let g:termdebug_wide = 1

" }}}
" plug.vim {{{

call plug#begin($XDG_CACHE_HOME . '/nvim/plugged')

" Basic things
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-obsession'
Plug 'farmergreg/vim-lastplace'
Plug 'justinmk/vim-sneak'
Plug 'gagoar/StripWhiteSpaces'

" Appearance
Plug 'fxn/vim-monochrome'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'raymond-w-ko/vim-niji'
Plug 'Yggdroot/indentLine'
Plug 'machakann/vim-highlightedyank'

" Syntax highlighting
Plug 'jaxbot/semantic-highlight.vim'

" Interface enhancement
Plug 'qpkorr/vim-bufkill'
Plug 'rbgrouleff/bclose.vim'

Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'

" Development
Plug 'neomake/neomake'

" Other plugins
for f in glob($XDG_CONFIG_HOME . '/nvim/plug/*.vim', 0, 1)
    execute 'source' f
endfor

call plug#end()

" }}}
" basic things {{{

" ******************** vim-sneak **************************

let g:sneak#label = 1
let g:sneak#target_labels = ";sftunq/[]SFGHLTUNRMZ?0"
let g:sneak#s_next = 1

" }}}
" appearance {{{

" ******************** COLOR SCHEME ********************

colorscheme monochrome

" tweak color scheme
highlight CursorLine        guibg=#444444
highlight CursorColumn      guibg=#444444
highlight CursorLineNR      guifg=#ee3333
highlight LineNr            guifg=#999999
highlight MatchParen        guifg=#ffffff guibg=#ff0000
highlight ColorColumn       guibg=#3a3a3a
highlight IncSearch         guifg=#aa2200 guibg=#ffffff

highlight debugPC           guibg=#4444aa
highlight debugBreakPoint   guibg=#aa0000

" terminal colors

" 8 normal colors
let g:terminal_color_0 = '#000000' " black
let g:terminal_color_1 = '#d54e53' " red
let g:terminal_color_2 = '#b9ca4a' " green
let g:terminal_color_3 = '#e6c547' " yellow
let g:terminal_color_4 = '#7aa6da' " blue
let g:terminal_color_5 = '#c397d8' " magenta
let g:terminal_color_6 = '#70c0ba' " cyan
let g:terminal_color_7 = '#eaeaea' " white
" 8 bright colors
let g:terminal_color_8  = '#666666' " black
let g:terminal_color_9  = '#ff3334' " red
let g:terminal_color_10 = '#9ec400' " green
let g:terminal_color_11 = '#e7c547' " yellow
let g:terminal_color_12 = '#7aa6da' " blue
let g:terminal_color_13 = '#b77ee0' " magenta
let g:terminal_color_14 = '#54ced6' " cyan
let g:terminal_color_15 = '#ffffff' " white

" ******************** vim-lightline **************************

function! LanguageStatus(...) abort
    return &iminsert == 1 ? (a:0 == 1 ? a:1 : 'RU') : ''
endfunction

function! CapsLockStatus(...) abort
    return CapsLockStatusline('CAPS')
endfunction

let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'lang', 'caps', 'paste' ],
      \             [ 'gitbranch', 'filename', 'readonly', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'lang': 'LanguageStatus',
      \   'caps': 'CapsLockStatus',
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" ******************** indentLine **************************

let g:indentLine_char = '·'
let g:indentLine_color_gui = '#888888'

" ******************** vim-highlightedyank **************************

" set highlight for 1 second
let g:highlightedyank_highlight_duration = 1000

" }}}
" syntax highlighting {{{

let g:semanticEnableFileTypes = ['c', 'cpp', 'java', 'javascript', 'python', 'vim']
let g:semanticPersistCacheLocation = $XDG_CACHE_HOME . "/nvim/semantic-highlight-cache"

" }}}
" interface enhancement {{{

set grepprg=rg\ --vimgrep\ --smart-case\ --follow

" ********************* fzf.vim *****************************

nnoremap <silent> <leader>u :Buffers<CR>
nnoremap <silent> <leader>f :GFiles<CR>
nnoremap <silent> <leader>F :Files<CR>

nnoremap <silent> <leader>g :Rg<CR>
vnoremap <silent> <leader>g <Esc>:execute ':Rg ' . GetVisual()<CR>
nnoremap <silent> <leader>G :Lines<CR>
vnoremap <silent> <leader>G <Esc>:execute ':Lines ' . GetVisual()<CR>
nnoremap <silent> <leader>/ :BLines<CR>
vnoremap <silent> <leader>/ <Esc>:execute ':BLines ' . GetVisual()<CR>
nnoremap <silent> <leader>a :Tags<CR>
vnoremap <silent> <leader>a <Esc>:execute ':Tags ' . GetVisual()<CR>

nnoremap <silent> <leader>' :Marks<CR>

nnoremap <silent> <leader>: :Commands<CR>

nnoremap <silent> <leader>hh :History<CR>
nnoremap <silent> <leader>h: :History:<CR>
nnoremap <silent> <leader>h/ :History/<CR>

nnoremap <silent> <leader>H :Helptags<CR>

command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case --glob '!.git' ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

" ********************* tagbar ******************************

nmap <F4> :TagbarToggle<CR>

" }}}
" development {{{

" Neomake
let g:neomake_c_enabled_makers = ['cppcheck']
let g:neomake_c_cppcheck_maker = {
   \ 'args': ['--enable=warning,style,performance,portability,information', '--language=c'],
   \}

let g:neomake_cpp_enabled_makers = ['cppcheck']
let g:neomake_cpp_cppcheck_maker = {
   \ 'args': ['--enable=warning,style,performance,portability,information', '--language=c++'],
   \}

" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 500ms; no delay when writing).
call neomake#configure#automake('nrwi', 500)

" }}}
" other plugins {{{

for f in glob($XDG_CONFIG_HOME . '/nvim/conf/*.vim', 0, 1)
    execute 'source' f
endfor

" }}}
" plugins override {{{

" ******************** vim-sensible **************************

runtime! plugin/sensible.vim
set sidescrolloff=0

" }}}

" vim: foldmethod=marker:
