" ~/.vimrc (configuration file for vim only)

" Tabs/indents
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set cinoptions+=j1

set copyindent
set smartindent
set smarttab


" other settings
syntax on
filetype plugin on
filetype indent on
set nocompatible
set hidden " hide buffers instead of closing (when using :e)
set ruler " show line and col info
set wrap

set number
set shiftround
set showmatch " matching parens

set hlsearch
set incsearch

set ttyfast

set visualbell
set noerrorbells

set nobackup
set noswapfile

"
" Shortcuts
"

" don't need shift
nmap ; :

" hide search results
nmap <silent> ,/ :let @/=""<CR>

imap jk <ESC>

map <silent> <F1> :tabnew<CR>
map <silent> <F2> :tabp<CR>
map <silent> <F3> :tabn<CR>

imap <BS> <C-W>

" Short cut to grep word under cursor
nnoremap <leader>g "gye:!grep -I -r g *

" Short cut to copy file to clipboard
nnoremap <leader>c :w !xclip -selection clipboard
vnoremap <leader>c :w !xclip -selection clipboard

"
" UI
"
"

colors Tomorrow
set textwidth=80
set cc=+1
hi ColorColumn ctermbg=lightgrey guibg=lightgrey

set so=5

set wildmenu " show list of matching files when opening
set wildmode=longest:full,full
set wildignore=*.pyc,*.class

" Mark tab characters with arrow and trailing white space
set list listchars=tab:▸\ ,trail:⋅,nbsp:⋅

" word processing mode
cabbr wp call Wp()
function Wp()
    setlocal formatoptions=ta1
    setlocal noexpandtab
    set formatprg=par
    setlocal wrap
    setlocal linebreak
    nnoremap j gj
    nnoremap k gk
    set nonumber
    set spell spelllang=en_us
    set textwidth=72
endfunction

"
" Files
"

" Protobuf
augroup filetype
    au! BufRead,BufNewFile *.proto setfiletype proto
augroup end

" Log files
au BufRead,BufNewFile *.log set filetype=log
autocmd Filetype log setlocal nowrap


"
" Extensions
"

" Tagbar
nnoremap <silent> <F5> :TagbarToggle<CR>

" For ctrl-p
let g:ctrlp_working_path_mode = 0

" Syntastic
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
let g:syntastic_disabled_filetypes = ['java']

" Java Checkstyle
let Checkstyle_Classpath = ""
let Checkstyle_XML = ""

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,preview

" Haskell
let g:haddock_browser = "/usr/bin/firefox"

" Load pathogen
call pathogen#infect()
call pathogen#helptags()
" ~/.vimrc ends here
