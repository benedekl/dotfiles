" Use Vim settings, rather then Vi settings. This setting must be as early as
" possible, as it has side effects.
set nocompatible

" Set map leader
let mapleader = ","

" Quick way to edit and source vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" history and undo
set history=100
set undolevels=100

set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" enable sudo editing after the fact with w!!
cmap w!! w !sudo tee % >/dev/null

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

filetype plugin indent on

set softtabstop=2
set shiftwidth=2
set tabstop=2
set expandtab
set shell=/usr/bin/zsh

" Numbers
set number
set numberwidth=5

set background=dark
color jellybeans

" search subfolders for tab-completion on file tasks
set path+=**

" display matching files when tab completing
set wildmenu

" enable highlighted search
set hlsearch

" default some search settings
set showmatch
set ignorecase
set smartcase
set incsearch

" enable highlighted search
set hlsearch

" attach to the system clipboard
set clipboard=unnamedplus

" statusline
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#CursorColumn#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 

" Create directional shortcuts for moving among between splits
nmap <C-j> <C-W>j
nmap <C-k> <C-W>k
nmap <C-l> <C-W>l
nmap <C-h> <C-W>h

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Easier window resizing
if bufwinnr(1)
  map + <C-W>+
  map - <C-W>-
end

" Remap jj or jk or to be the same as Esc to leave Insert mode.
imap ii <Esc>

" Mouse
" ======

" Send more characters for redraws
set ttyfast

" Enable mouse use in all modes
set mouse=a

" show hidden characters
set showbreak=↪\
set list
set listchars=tab:»·,eol:↲,nbsp:•
set listchars+=trail:◥
set listchars+=extends:❯
set listchars+=precedes:❮

"vertical splits less gap between bars
set fillchars+=vert:│

highlight SpecialKey ctermbg=DarkRed guibg=DarkRed
"highlight NonText ctermbg=DarkGray guibg=DarkGray

augroup vimrcEx
  autocmd!

  " automatically remove trailing whitespace before write
  function! StripTrailingWhitespace()
    normal mZ
    %s/\s\+$//e
    if line("'Z") != line(".")
      echo "Stripped whitespace\n"
    endif
    normal `Z
  endfunction
  autocmd BufWritePre *.{bldr,md,coffee,rake,js,rb,
        \css,sass,scss,haml,erb,cpp,hpp,i,py}
        \ :call StripTrailingWhitespace()
augroup END

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
