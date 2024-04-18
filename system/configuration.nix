# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ 
    config,
    pkgs,
    pkgs-stable,
    lib,
    inputs,
    ... 
}:

{
  imports =
    [ # Include the results of the hardware scan.
        ./hardware-configuration.nix

        ./modules/boot.nix
        ./modules/env.nix
        ./modules/firefox.nix
        ./modules/gaming.nix
        ./modules/hyprland.nix
        ./modules/login-manager.nix
        ./modules/neovim.nix
        ./modules/network.nix
        ./modules/packages.nix
        ./modules/pipewire.nix
        ./modules/printing.nix
        ./modules/powermanagment.nix
        ./modules/security.nix
        ./modules/shell.nix
        ./modules/systemd.nix
        ./modules/udev.nix
        ./modules/user.nix
        ./modules/waybar.nix
        ./modules/yazi.nix
    ];

#==> Services <==#

 #= Enable Flatpak
  services.flatpak.enable = true;

#= Chrony
  services.chrony = {
    enable = true;
    enableNTS = true;
  };

 #= Dbus
  services.dbus = {
    enable = true;
    apparmor = "enabled";
    implementation = "dbus"; 
    packages = with pkgs; [ flatpak ];
  };

 #= Java
  programs.java = {
    enable = true;
    package = pkgs.jdk;
    binfmt = true;
  };

 #= XWayland
  programs.xwayland.enable = true;

 #= XDG
  xdg = {
    portal = {
        enable = true;
        wlr.enable = true;
        config.common.default = "gtk";
        extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
            libsForQt5.xdg-desktop-portal-kde
            lxqt.xdg-desktop-portal-lxqt
        ];
    };
    sounds.enable = true;
    autostart.enable = true;
    menus.enable = true;
  };

 #=> Appimages
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

#==> NIX/NIXPKGS <==#

 #= Enable Nix-Shell and Flakes
  nix = {
    settings = {
      warn-dirty = true;
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = ["rick"];
      substituters = [
          "https://nix-gaming.cachix.org"
          "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  #= Permitted Insecure Packages
  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
  ];

 #=> Storage Options
  nix.optimise.automatic = true;
  #https://github.com/nix-community/nix-direnv
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    silent = true;
    loadInNixShell = true;
    direnvrcExtra = "";
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

 #=> WAYDROID <=#
  virtualisation.waydroid.enable = true;

#==> Drives <==#

 #= Enable Trim Needed for SSD's
  services.fstrim.enable = true;
  services.fstrim.interval = "weekly";

 #= Swap
  zramSwap = {
      enable = true;
      priority = 100;
      memoryPercent = 50;
      algorithm = "zstd";
      swapDevices = 2;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  #system.copySystemConfiguration = true;
  #system.autoUpgrade.enable = true;
  #system.autoUpgrade.allowReboot = false;
  #system.autoUpgrade.channel = "https://nixos.org/channels/nixos-23.11";

  #documentation.nixos.enable = true;
}
