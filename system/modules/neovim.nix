{ config, pkgs, pkgs-stable, lib, ... }:

{
 #= Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    package = pkgs.neovim-unwrapped;
    configure = {
      customRC = ''
        syntax on
        set ignorecase
        set smartcase
        set encoding=utf-8
        set number relativenumber

        " Autocompletion
        set wildmode=longest,list,full

        " Use system Clipboard
        set clipboard+=unnamedplus

        " Lines Number
        set number

        " Tab Settings
        set expandtab
        set shiftwidth=4
        set softtabstop=4
        set tabstop=4

        set path=.,,**
      '';
      packages.myVimPlugins = with pkgs.vimPlugins; {
        start = [
          indentLine
          vim-lastplace 
          vim-nix
          vim-plug
          vim-sensible
          vim-nerdtree-syntax-highlight
        ]; 
        opt = [];
      };
    };
  };
}
