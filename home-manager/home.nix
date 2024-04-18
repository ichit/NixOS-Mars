{ config, pkgs, lib, ... }:

{

    imports = [
        #./hyprland/general.nix
        #./waybar/general.nix
    ];

    home.stateVersion = "23.11";
    home.username = "rick";
    home.homeDirectory = "/home/rick";
    #home.file.".config".source = ./.config;


#= DCONF
    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

#= CURSOR
    home.pointerCursor = {
      gtk.enable = true;
      #x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

#= GTK
    gtk = {
      enable = true;
      theme = {
        package = pkgs.whitesur-gtk-theme; #pkgs.material-black-colors;
        name = "WhiteSur-Dark"; #"Material-Black-Blueberry";
      };
      iconTheme = {
        package = pkgs.flat-remix-icon-theme;
        name = "Flat-Remix-Blue-Dark";
      };
    };

#= QT
    qt = {
      enable = true;
      platformTheme = "gtk";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };
}
