{ config, pkgs, pkgs-stable, lib, ... }:

{
#=> Shell's

  #= Fish
  programs.fish = {
    enable = true;
    useBabelfish = true;
    promptInit = "set fish_greeting";
    shellAliases = {
      grep = "rg --color=auto";
      cat = "bat --style=plain --paging=never";
      la = "eza -a --color=always --group-directories-first --grid --icons";
      ls = "eza -al --color=always --group-directories-first --grid --icons";
      ll = "eza -l --color=always --group-directories-first --octal-permissions --icons";
      lt = "eza -aT --color=always --group-directories-first --icons";
      tree = "eza -T --all --icons";
      search = "fzf";
      hw = "hwinfo --short";
    };
    interactiveShellInit = "
    function fish_greeting
        fastfetch
    end

    ## Enable Wayland Support for different Applications
    if [ '$XDG_SESSION_TYPE' = 'wayland' ]
        set -gx WAYLAND 1
        set -gx QT_QPA_PLATFORM 'wayland;xcb'
        set -gx GDX_BACKEND 'wayland,x11'
        set -gx MOZ_DBUS_REMOTE 1
        set -gx MOZ_ENABLE_WAYLAND 1
        set -gx _JAVA_AWT_WM_NONREPARENTING 1
        set -gx BEMENU_BACKEND wayland
        set -gx ECORE_EVAS_ENGINE wayland_egl
        set -gx ELM_ENGINE wayland_egl
    end
    ";
    vendor = {
      config.enable = true;
      completions.enable = true;
      functions.enable = true;
    };
  };
  programs.nix-index.enableFishIntegration = true;

 #= Starship
  programs.starship.enable = true;
  programs.starship.settings = {
    add_newline = true;

    character = {
        success_symbol = "[<0> ~](bold green)";
        error_symbol = "[<0> ~](bold red)";
    };

    shell = {
        disabled = false;
        format = "$indicator";
        fish_indicator = "(bright-white) ";
        bash_indicator = "(bright-white) ";
    };

    nix_shell = {
      symbol = "";
      format = "[$symbol$name]($style) ";
      style = "bright-purple bold";
    };

    package.disabled = true;
  };
}
