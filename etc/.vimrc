scriptencoding utf-8
set termencoding=utf-8

if exists('&t_SI')
  let &t_SI = "\<Esc>]12;lightgoldenrod\x7"
  let &t_EI = "\<Esc>]12;grey80\x7"
endif

set nocompatible
set viminfo='1000,f1,:1000,/1000
set history=500
set backspace=indent,eol,start
:set textwidth=75
set tabstop=2

set backup
set showcmd
set showmatch
set hlsearch
set incsearch

if has("autocmd")
  autocmd BufEnter *
	\ if &filetype == "cpp" |
        \     set noignorecase noinfercase |
        \ else |
        \     set ignorecase infercase |
        \ endif
else
  set ignorecase
  set infercase
endif

set showfulltag
set lazyredraw

set noerrorbells
set visualbell t_vb=

if has("autocmd")
  autocmd GUIEnter * set visualbell t_vb=
endif

au BufRead,BufNewFile *.ywtxt set ft=ywtxt 

set scrolloff=3
set sidescrolloff=2

set whichwrap+=<,>,[,]

set wildmenu
set wildignore+=*.o,*~,.lo
set suffixes+=.in,.a,.1
:set fo+=want
set hidden
set winminheight=1

syntax on

set virtualedit=block,onemore

:colorscheme digerati

set shiftwidth=2
set autoindent
set smartindent
inoremap # X<BS>#

if has("folding")
    set foldenable
    set foldmethod=manual
    set foldlevelstart=99
endif

set popt+=syntax:y

if has("eval")
    filetype on
    filetype plugin on
    filetype indent on
endif

" {{{
" Nice statusbar

set laststatus=2
set statusline=
set statusline+=%2*%-3.3n%0*\                " buffer number
set statusline+=%f\                          " file name

set statusline+=%h%1*%m%r%w%0*               " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format

if filereadable(expand("$VIM/vimfiles/plugin/vimbuddy.vim"))
    set statusline+=\ %{VimBuddy()}          " vim buddy
endif

set statusline+=%=                           " right align
set statusline+=%2*0x%-8B\                   " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

" }}}

" {{{
" If possible and in gvim, use cursor row highlighting

if has("gui_running") && v:version >= 700
    set cursorline
end

" }}}

" {{{
" highlight all characters past 75 columns.

augroup vimrc_autocmds
  autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
  autocmd BufEnter * match OverLength /\%75v.*/
augroup END

" }}}

" {{{
" Include $HOME in cdpath
if has("file_in_path")
    let &cdpath=','.expand("$HOME").','.expand("$HOME").'~/'
endif

" }}}

" Better include path handling
set path+=src/
let &inc.=' ["<]'

set dictionary=/usr/share/dict/words

" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine   guibg=#4f4f4f
  hi CursorColumn guibg=#2d2d2d
  hi MatchParen   guifg=#ffffff guibg=#4f4f4f gui=bold
  hi Pmenu 		    guifg=#404040 guibg=#dcdcdc
  hi PmenuSel 	  guifg=#ffffff guibg=#93b5bf
endif

" General colors
hi Cursor 		   guifg=NONE    guibg=#909090 gui=none
hi Normal 		   guifg=#f0f0f0 guibg=#202020 gui=none
hi NonText 		   guifg=#a0a0a0 guibg=#202020 gui=none
hi LineNr        guifg=#404040 guibg=#202020 gui=none ctermfg=244 ctermbg=232
hi StatusLine    guifg=#d3d3d5 guibg=#303030 gui=none ctermfg=253 ctermbg=238
hi StatusLineNC  guifg=#939395 guibg=#303030 gui=none ctermfg=246 ctermbg=238
hi VertSplit     guifg=#444444 guibg=#303030 gui=none ctermfg=238 ctermbg=238  
hi Folded 		   guibg=#384048 guifg=#a0a8b0 gui=none
hi Title		     guifg=#ffffff guibg=NONE	   gui=bold
hi Visual		     guifg=#ffffff guibg=#b8b89f gui=none
hi SpecialKey	   guifg=#808080 guibg=#343434 gui=none

" Syntax highlighting
hi Comment 		   guifg=#808080 gui=none
hi Todo 		     guifg=#8f8f8f gui=none
hi Boolean       guifg=#cdff00 gui=none
hi String 		   guifg=#cdff00 gui=none
hi Identifier 	 guifg=#cdff00 gui=none
hi Function 	   guifg=#ffffff gui=bold
hi Type 		     guifg=#77b4c7 gui=none
hi Statement 	   guifg=#77b4c7 gui=none
hi Keyword		   guifg=#ff3b77 gui=none
hi Constant 	   guifg=#ff3b77 gui=none
hi Number		     guifg=#ff3b77 gui=none
hi Special		   guifg=#ff3b77 gui=none
hi PreProc 		   guifg=#b8b89f gui=none
hi Search        guifg=#000000 guibg=#cdff00 gui=none
hi Todo          guifg=NONE    guibg=#ff3b77 gui=none
hi Macro         guifg=#FE8777
hi Operator      guifg=#518691

" Rainbow C/Cpp
hi cBracket      guifg=#E99DE9
hi hlLevel1      guifg=#f0f0f0
hi hlLevel2      guifg=#ebf1d2
hi hlLevel3      guifg=#e7f3b4
hi hlLevel4      guifg=#e2f596
hi hlLevel5      guifg=#def778
hi hlLevel6      guifg=#daf95a
hi hlLevel7      guifg=#d5fb3c
hi hlLevel8      guifg=#d1fd1e
hi hlLevel9      guifg=#cdff00

" Custom
hi MarkerConstant guifg=#808080

" Code-specific colors
hi htmlEndTag    guifg=#ffffff gui=none 
hi htmlLink      guifg=#ff3b77 gui=underline

