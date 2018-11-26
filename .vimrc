packadd minpac

call minpac#init()

call minpac#add('w0rp/ale')
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('tpope/vim-unimpaired')
call minpac#add('junegunn/fzf', {'dir': '/usr/local/opt/fzf', 'do': './install --all'})
call minpac#add('junegunn/fzf.vim')
call minpac#add('airblade/vim-gitgutter')
call minpac#add('keith/swift.vim')
call minpac#add('scrooloose/nerdtree')
call minpac#add('mileszs/ack.vim')
call minpac#add('mhinz/vim-grepper')
call minpac#add('junegunn/vim-easy-align')
call minpac#add('prettier/vim-prettier')
call minpac#add('tpope/vim-fugitive')
" call minpac#add('')

packloadall
" Load all of the helptags now, after plugins have been loaded.
" " All messages and errors will be ignored.
silent! helptags ALL

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()

let mapleader = ","

" Use ,a for fzf buffer nav
nnoremap <silent> <leader>a :Buffers<CR>

" ,W to kill all tailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" ctr-n for NerdTree at the file location
map <C-n> :NERDTreeFind<CR>

" ack.vim config to use ag
let g:grepper = {}
let g:grepper.tools = ['grep', 'git', 'rg']

" Search for the current word
nnoremap <leader>* :Grepper -cword -noprompt<CR>

" Search fo the current selection
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

cabbrev grep GrepperGrep

" Split Config
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" Tabs
set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
" Use 2 space tabs for yaml files
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" Turn off expandtab for makefiles
autocmd FileType make setlocal noexpandtab

" Hightlight extra whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
let python_space_errors = 1

" Don't load python2
let g:loaded_python_provider = 1

" Clear search highlighting
nmap <silent> <leader>/ :nohlsearch<CR>
" Uncomment if you'd like to toggle highlighting instead of clear it
" nmap <silent> <leader>/ :set invhlsearch<CR>

" :help clipboard-unnamedplus
set clipboard+=unnamedplus

" Align GitHub-flavored Markdown tables
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

" Set Fastlane file to by filetype ruby
autocmd BufNewFile,BufRead Fastfile set filetype=ruby

" Show line numbers
set number
nmap <C-N><C-N> :set relativenumber!<CR>

" Better command history with q:
command! CmdHist call fzf#vim#command_history({'right': '40'})
nnoremap q: :CmdHist<CR>

" Better search history
command! QHist call fzf#vim#search_history({'right': '40'})
nnoremap q/ :QHist<CR>
