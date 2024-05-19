{ ... }: {
  programs.vim = {
    enable = true;
    defaultEditor = true;

    extraConfig = ''
      set nocompatible
      filetype off

      " Remap leader to <space>
      let mapleader=" "

      " Enable syntax highlighting
      syntax enable

      " Enable relative line numbers
      set relativenumber

      " Set encoding to UTF-8 for YCM
      set encoding=utf-8

      " Remap split navigation shortcut keys
      nnoremap <C-j> <C-W><C-J>
      nnoremap <C-k> <C-W><C-K>
      nnoremap <C-l> <C-W><C-L>
      nnoremap <C-h> <C-W><C-H>

      " Better splitting
      set splitbelow
      set splitright

      " disable viminfo
      let skip_defaults_vim=1
      set viminfo=""
      set viminfofile=NONE

      " Copy and paste system clipboard
      " vnoremap <C-c> "*y :let @+=@*<CR>
      " map <C-v> "+P

      " Spell check
      map <Leader>s :setlocal spell! spelllang=en_us<CR>

      " Toggle line numbers with ctrl-N
      set number
      highlight LineNr ctermfg=grey
      nmap <C-n> :set invnumber<CR>:set relativenumber!<CR>

      " Map <Leader>S to save as sudo
      noremap <Leader>S :w !sudo tee % > /dev/null <CR>

      " Base64 inline replace
      vnoremap <Leader>atob c<C-r>=system('base64', @")<CR><ESC>
      vnoremap <Leader>btoa c<C-r>=system('base64 --decode', @")<CR><ESC>

      " Reload .vimrc
      noremap <Leader><Leader>r :so ~/.vimrc <CR>

      set rtp+=~/.vim/bundle/Vundle.vim
      call vundle#begin()

      " Vundle package
      Plugin 'VundleVim/Vundle.vim'

      " Nord Theme
      Plugin 'arcticicestudio/nord-vim'
      let g:nord_cursor_line_number_background = 1
      let g:nord_bold_vertical_split_line = 1

      " " Syntastic
      " Plugin 'vim-syntastic/syntastic.git'

      " ALE
      Plugin 'dense-analysis/ale'

      " YouCompleteMe
      " cd ~/.vim/bundle/YouCompleteMe
      " python3 install.py --clangd-completer --java-completer --go-completer --rust-completer
      " Plugin 'ycm-core/YouCompleteMe'
      " noremap <Leader>g :YcmCompleter GoTo<CR>

      " Easymotion
      Plugin 'easymotion/vim-easymotion.git'

      " indentLine
      Plugin 'Yggdroot/indentLine'
      let g:indentLine_conceallevel = 2
      let g:indentLine_concealcursor = 'nc'
      let g:indentLine_fileTypeExclude = ['json']
      noremap <Leader>i :IndentLinesToggle<CR>

      " Colored brackets
      Plugin 'luochen1990/rainbow'
      let g:rainbow_active = 1

      " vim-airline
      Plugin 'vim-airline/vim-airline'
      " vim-airline without new split
      set laststatus=2
      " powerline fonts
      let g:airline_powerline_fonts = 1

      " remove trailing whitespace
      Plugin 'bronson/vim-trailing-whitespace'

      " NERDTree
      Plugin 'scrooloose/nerdtree'
      " Autoclose
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
      " Open/close NERDTree
      noremap <Leader>f :NERDTreeToggle<Enter>
      " Open/close NERDTree on file
      noremap <Leader>v :NERDTreeFind<CR>
      " Autoopen
      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
      autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
      " Minimalist NERDTree
      let NERDTreeMinimalUI = 1
      let NERDTreeDirArrows = 1

      " FZF
      Plugin 'junegunn/fzf'

      " Buffer explorer
      Plugin 'jlanzarotta/bufexplorer'
      noremap <Leader>b :BufExplorer<CR>

      " Window swap plugin
      Plugin 'wesQ3/vim-windowswap'

      " goyo plugin (reading mode)
      Plugin 'junegunn/goyo.vim'
      map <Leader>o :Goyo \| set linebreak<CR>

      " vim-tmux navigation
      Plugin 'christoomey/vim-tmux-navigator'

      " End vundle
      call vundle#end()

      " Set colorscheme
      colorscheme nord

      " Set tabs to 4 spaces
      set ts=4
      set sw=4
      set sts=4
      set expandtab

      " yaml settings
      autocmd Filetype yaml setlocal ts=2 sw=2 sts=2 expandtab smartindent
      " json settings
      autocmd Filetype json setlocal ts=2 sw=2 sts=2 expandtab smartindent

      " asm settings
      let asmsyntax="nasm"
      autocmd Filetype asm setlocal ts=8 sw=8 noexpandtab smartindent
      autocmd Filetype nasm setlocal ts=8 sw=8 noexpandtab smartindent

      " make settings
      autocmd Filetype make set noexpandtab

      filetype plugin indent on
    '';
  };
}
