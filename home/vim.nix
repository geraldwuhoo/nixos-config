{ lib, pkgs, ... }:
let
  bufpicker = pkgs.vimUtils.buildVimPlugin {
    pname = "bufpicker";
    version = "0-unstable-2022-04-09";
    src = pkgs.fetchFromGitHub {
      owner = "yegappan";
      repo = "bufpicker";
      rev = "504af1f37a175ce4356fe2530cab4550f1d96eaa";
      hash = "sha256-8/nkgfxRqgDChUsnO8UVer+2HSdqws+EIuGri1yBklg=";
    };
  };
in
{
  programs.vim = {
    enable = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      nord-vim
      # vim-syntastic
      ale
      # YouCompleteMe
      vim-easymotion
      indentLine
      # Colored brackets
      rainbow
      vim-airline
      # remove trailing whitespace
      vim-trailing-whitespace
      nerdtree
      fzfWrapper
      # Buffer explorer
      bufpicker
      # Window swap plugin
      vim-windowswap
      # goyo plugin (reading mode)
      goyo-vim
      vim-tmux-navigator
    ];

    settings = {
      # Enable relative line numbers
      relativenumber = true;
      number = true;
      # Set tabs to 4 spaces
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
    };

    extraConfig = lib.mkAfter ''
      " Remap leader to <space>
      let mapleader=" "

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
      set viminfo=
      set viminfofile=NONE

      " Copy and paste system clipboard
      " vnoremap <C-c> "*y :let @+=@*<CR>
      " map <C-v> "+P

      " Spell check
      map <Leader>s :setlocal spell! spelllang=en_us<CR>

      " Toggle line numbers with ctrl-N
      highlight LineNr ctermfg=grey
      nmap <C-n> :set invnumber<CR>:set relativenumber!<CR>

      " Map <Leader>S to save as sudo
      noremap <Leader>S :w !sudo tee % > /dev/null <CR>

      " Base64 inline replace
      vnoremap <Leader>atob c<C-r>=system('base64', @")<CR><ESC>
      vnoremap <Leader>btoa c<C-r>=system('base64 --decode', @")<CR><ESC>

      " Reload .vimrc
      noremap <Leader><Leader>r :so $MYVIMRC <CR>

      let g:nord_cursor_line_number_background = 1
      let g:nord_bold_vertical_split_line = 1

      " noremap <Leader>g :YcmCompleter GoTo<CR>

      let g:indentLine_conceallevel = 2
      let g:indentLine_concealcursor = 'nc'
      let g:indentLine_fileTypeExclude = ['json']
      noremap <Leader>i :IndentLinesToggle<CR>

      let g:rainbow_active = 1

      " vim-airline without new split
      set laststatus=2
      " powerline fonts
      let g:airline_powerline_fonts = 1

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

      noremap <Leader>b :BufPicker<CR>

      map <Leader>o :Goyo \| set linebreak<CR>

      " Set colorscheme
      colorscheme nord

      set sts=4

      " yaml settings
      autocmd Filetype yaml setlocal ts=2 sw=2 sts=2 expandtab smartindent
      " json settings
      autocmd Filetype json setlocal ts=2 sw=2 sts=2 expandtab smartindent

      " asm settings
      let asmsyntax="nasm"
      autocmd Filetype asm setlocal ts=8 sw=8 noexpandtab smartindent
      autocmd Filetype nasm setlocal ts=8 sw=8 noexpandtab smartindent

      " make settings
      autocmd Filetype make setlocal noexpandtab
    '';
  };
}
