" VIM Configuration File
" Description: Optimized for C/C++ development, but useful also for other things.
" Author: Gerhard Gappmeier
 map <F8> : !clang % && ./a.out <CR>
map <F5> : python3 %
 " set UTF-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
" disable vi compatibility (emulation of old bugs)
set nocompatible
" use indentation of previous line
set autoindent
" use intelligent indentation for C
set smartindent
" configure tabwidth and insert spaces instead of tabs
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces
" wrap lines at 120 chars. 80 is somewaht antiquated with nowadays displays.
set textwidth=120
" turn syntax highlighting on
set t_Co=256
syntax on
" turn line numbers on
set number
" highlight matching braces
set showmatch
" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */
set nowrap
" Install OmniCppComplete like described on http://vim.wikia.com/wiki/C++_code_completion
" This offers intelligent C++ completion when typing ‘.’ ‘->’ or <C-o>
" Load standard tag files
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/gl
set tags+=~/.vim/tags/sdl
set tags+=~/.vim/tags/qt4
" Install DoxygenToolkit from http://www.vim.org/scripts/script.php?script_id=987
let g:DoxygenToolkit_authorName="John Doe <john@doe.com>"

" Enhanced keyboard mappings
"
" in normal mode F2 will save the file
nmap <F2> :w<CR>
" in insert mode F2 will exit insert, save, enters insert again
imap <F2> <ESC>:w<CR>i
" switch between header/source with F4
map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
" recreate tags file with F5
" create doxygen comment
map <F6> :Dox<CR>
" build using makeprg with <F7>
map <F7> :make<CR>
" build using makeprg with <S-F7>
map <S-F7> :make clean all<CR>
" goto definition with F12
map <F12> <C-]>
" in diff mode we use the spell check keys for merging
if &diff
  ” diff settings
  map <M-Down> ]c
  map <M-Up> [c
  map <M-Left> do
  map <M-Right> dp
  map <F9> :new<CR>:read !svn diff<CR>:set syntax=diff buftype=nofile<CR>gg
else
  " spell settings
  :setlocal spell spelllang=en
  " set the spellfile - folders must exist
  set spellfile=~/.vim/spellfile.add
  map <M-Down> ]s
  map <M-Up> [s
endif
syntax enable
set relativenumber
set nocompatible
filetype off
filetype plugin indent on
colorscheme default
nnoremap <C-i> :tabn<CR>
nnoremap <C-p> :tabnew<CR>
nnoremap <C-t> :NERDTreeToggle <CR>
let g:NERDTreeWinPos = "right"
let g:netrw_banner = 0
let g:netrw_keepdir = 0
let g:netrw_winsize = 20
let g:netrw_liststyle = 3
let g:netrw_localcopydircmd = 'cp -r'
hi! link netrwMarkFile Search
nmap <C-m> :Lexplore<CR>
:set nolist
call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-default branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
Plug 'github/copilot.vim'
" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Use release branch (recommend)
" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'
" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'deoplete-plugins/deoplete-clang'
" Initialize plugin system
call plug#end()


















if exists('g:autoclose_loaded') || &cp
    finish
endif


let g:autoclose_loaded = 1
let s:cotstate = &completeopt

if !exists('g:autoclose_on')
    let g:autoclose_on = 1
endif

" (Toggle) Mappings -----------------------------{{{1
"
nmap <Plug>ToggleAutoCloseMappings :call <SID>ToggleAutoCloseMappings()<CR>
if (!hasmapto( '<Plug>ToggleAutoCloseMappings', 'n' ))
    nmap <unique> <Leader>a <Plug>ToggleAutoCloseMappings
endif
fun <SID>ToggleAutoCloseMappings() " --- {{{2
    if g:autoclose_on
        iunmap "
        iunmap '
        iunmap (
        iunmap )
        iunmap [
        iunmap ]
        iunmap {
        iunmap }
        iunmap <BS>
        iunmap <Esc>
        let g:autoclose_on = 0
        echo "AutoClose Off"
    else
        inoremap <silent> " <C-R>=<SID>QuoteDelim('"')<CR>
        inoremap <silent> ' <C-R>=match(getline('.')[col('.') - 2],'\w') == 0 && getline('.')[col('.')-1] != "'" ? "'" : <SID>QuoteDelim("'")<CR>
        inoremap <silent> ( (<C-R>=<SID>CloseStackPush(')')<CR>
        inoremap ) <C-R>=<SID>CloseStackPop(')')<CR>
        inoremap <silent> [ [<C-R>=<SID>CloseStackPush(']')<CR>
        inoremap <silent> ] <C-R>=<SID>CloseStackPop(']')<CR>
        "inoremap <silent> { {<C-R>=<SID>CloseStackPush('}')<CR>
        inoremap <silent> { <C-R>=<SID>OpenSpecial('{','}')<CR>
        inoremap <silent> } <C-R>=<SID>CloseStackPop('}')<CR>
        inoremap <silent> <BS> <C-R>=<SID>OpenCloseBackspace()<CR>
        inoremap <silent> <C-h> <C-R>=<SID>OpenCloseBackspace()<CR>
        inoremap <silent> <Esc> <C-R>=<SID>CloseStackPop('')<CR><Esc>
        inoremap <silent> <C-[> <C-R>=<SID>CloseStackPop('')<CR><C-[>
        "the following simply creates an ambiguous mapping so vim fully
        "processes the escape sequence for terminal keys, see 'ttimeout' for a
        "rough explanation, this just forces it to work
        if &term[:4] == "xterm"
            inoremap <silent> <C-[>OC <RIGHT>
        endif
        let g:autoclose_on = 1
        if a:0 == 0
            "this if is so this message doesn't show up at load
            echo "AutoClose On"
        endif
    endif
endf
let s:closeStack = []

" AutoClose Utilities -----------------------------------------{{{1
function <SID>OpenSpecial(ochar,cchar) " ---{{{2
    let line = getline('.')
    let col = col('.') - 2
    "echom string(col).':'.line[:(col)].'|'.line[(col+1):]
    if a:ochar == line[(col)] && a:cchar == line[(col+1)] "&& strlen(line) - (col) == 2
        "echom string(s:closeStack)
        while len(s:closeStack) > 0
            call remove(s:closeStack, 0)
        endwhile
        return "\<esc>a\<CR>;\<CR>".a:cchar."\<esc>\"_xk$\"_xa"
    endif
    return a:ochar.<SID>CloseStackPush(a:cchar)
endfunction

function <SID>CloseStackPush(char) " ---{{{2
    "echom "push"
    let line = getline('.')
    let col = col('.')-2
    if (col) < 0
        call setline('.',a:char.line)
    else
        "echom string(col).':'.line[:(col)].'|'.line[(col+1):]
        call setline('.',line[:(col)].a:char.line[(col+1):])
    endif
    call insert(s:closeStack, a:char)
    "echom join(s:closeStack,'').' -- '.a:char
    return ''
endf

function <SID>JumpOut(char) " ----------{{{2
    let column = col('.') - 1
    let line = getline('.')
    let mcol = match(line[column :], a:char)
    if a:char != '' &&  mcol >= 0
        "Yeah, this is ugly but vim actually requires each to be special
        "cased to avoid screen flashes/not doing the right thing.
        echom len(line).' '.(column+mcol)
        if line[column] == a:char
            return "\<Right>"
        elseif column+mcol == len(line)-1
            return "\<C-O>A"
        else
            return "\<C-O>f".a:char."\<Right>"
        endif
    else
        return a:char
    endif
endf
function <SID>CloseStackPop(char) " ---{{{2
    "echom "pop"
    if(a:char == '')
        pclose
    endif
    if len(s:closeStack) == 0
        return <SID>JumpOut(a:char)
    endif
    let column = col('.') - 1
    let line = getline('.')
    let popped = ''
    let lastpop = ''
    "echom join(s:closeStack,'').' || '.lastpop
    while len(s:closeStack) > 0 && ((lastpop == '' && popped == '') || lastpop != a:char)
        let lastpop = remove(s:closeStack,0)
        let popped .= lastpop
        "echom join(s:closeStack,'').' || '.lastpop.' || '.popped
    endwhile
    "echom ' --> '.popped
    if line[column : column+strlen(popped)-1] != popped
        return <SID>JumpOut('')
    endif
    if column > 0
        call setline('.',line[:column-1].line[(column+strlen(popped)):])
    else
        call setline('.','')
    endif
    return popped
endf

function <SID>QuoteDelim(char) " ---{{{2
  let line = getline('.')
  let col = col('.')
  if line[col - 2] == "\\"
    "Inserting a quoted quotation mark into the string
    return a:char
  elseif line[col - 1] == a:char
    "Escaping out of the string
    return "\<C-R>=".s:SID()."CloseStackPop(\"\\".a:char."\")\<CR>"
  else
    "Starting a string
    return a:char."\<C-R>=".s:SID()."CloseStackPush(\"\\".a:char."\")\<CR>"
  endif
endf

" The strings returned from QuoteDelim aren't in scope for <SID>, so I
" have to fake it using this function (from the Vim help, but tweaked)
function s:SID()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID$')
endfun

function <SID>OpenCloseBackspace() " ---{{{2
    "if pumvisible()
    "    pclose
    "    call <SID>StopOmni()
    "    return "\<C-E>"
    "else
        let curline = getline('.')
        let curpos = col('.')
        let curletter = curline[curpos-1]
        let prevletter = curline[curpos-2]
        if (prevletter == '"' && curletter == '"') ||
\          (prevletter == "'" && curletter == "'") ||
\          (prevletter == "(" && curletter == ")") ||
\          (prevletter == "{" && curletter == "}") ||
\          (prevletter == "[" && curletter == "]")
            if len(s:closeStack) > 0
                call remove(s:closeStack,0)
            endif
            return "\<Delete>\<BS>"
        else
            return "\<BS>"
        endif
    "endif
endf

" Initialization ----------------------------------------{{{1
if g:autoclose_on
    let g:autoclose_on = 0
    silent call <SID>ToggleAutoCloseMappings()
endif
" vim: set ft=vim ff=unix et sw=4 ts=4 :
" vim600: set foldmethod=marker foldmarker={{{,}}} foldlevel=1 :
"
"
"
"
"
"
filetype plugin on
au FileType php setl ofu=phpcomplete#CompletePHP
au FileType ruby,eruby setl ofu=rubycomplete#Complete
au FileType html,xhtml setl ofu=htmlcomplete#CompleteTags
au FileType c setl ofu=ccomplete#CompleteCpp
au FileType css setl ofu=csscomplete#CompleteCSS


inoremap <C-h> <left>
inoremap <C-l> <right>
inoremap <C-k> <up>
inoremap <C-j> <down>
inoremap <C-/> :w! <CR>
