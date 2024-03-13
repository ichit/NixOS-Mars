# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }: let

  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";

  unstable = import (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable) { config = config.nixpkgs.config; };

  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

  hyprland-flake = (import flake-compat { src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz"; }).defaultNix;

in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

#=> Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
#=> Kernel
  boot.kernelPackages = unstable.pkgs.linuxPackages_zen; # Latest Kernel (ZEN).
  boot.kernelParams = [
    "HDMI-A-1:1920x1080@60"
    "amdgpu.noretry=0"
    "amdgpu.dc=1"
    "amdgpu.dpm=1"
    "amdgpu.sg_display=0"
    "amdgpu.vm_fragment_size=9"
    "radeon.si_support=0"
    "amdgpu.si_support=1"
    "radeon.cik_support=0"
    "amdgpu.cik_support=1"
    "amd_pstate=guided"
    "amd_pstate_epp=pperformance"
    "transparent_hugepage=always"
    "ksm=1"
    "mitigations=auto"
    "sched_mc_power_savings=0"
    "nohibernate"
    "quiet"
    "nosplash"
    "fbcon=nodefer"
    "acpi_rev_override=5"
    "tsc=reliable"
    "clocksource=tsc"
    "kcfi"
  ];

  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;  # A simple change Valve made on the Steam Deck...
    "vm.swappiness" = 10;  # Reduce swappiness since RAM's faster.
    "vm.compaction_proactiveness" = 0;
    "vm.watermark_boost_factor" = 1;
    "vm.zone_reclaim_mode" = 0;
    "vm.page_lock_unfairness" = 1;
  };

  boot.tmp.cleanOnBoot = true;
  boot.extraModprobeConfig = "options kvm_amd nested=1"; # AMD
  boot.supportedFilesystems = [ "ntfs" ];
  boot.initrd.kernelModules = [ "amdgpu" "radeon" "zenpower" "vmd" "xhci_pci" "ahci" "usbhid" "sd_mod" "mq-deadline" ];
  boot.blacklistedKernelModules = [ "k10temp" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.zenpower ];

#==> SystemD <==#

  systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      "L+    /usr/share/wayland-sessions/hyprland.desktop   -    -    -     -    ${pkgs.hyprland}/share/wayland-sessions/hyprland.desktop"
    ];

  systemd.extraConfig = ''
      [Process]
      Name=bit.trip.runner
      Priority=10
      Interactive=true
      ...
      [Process]
      Name=wineserver
      Priority=20
      Fixed=true
      NegativePriority=19
      ...
      [Process]
      Name=steam.exe
      Priority=10
      Interactive=true
      NegativePriority=5
      ...
      DefaultTimeoutStopSec=10s
      ...
      DefaultLimitNOFILE=524288
    '';

  systemd.user.extraConfig = ''
      DefaultLimitNOFILE=524288
    '';

#==> User and Home Manager <==#
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {  };
  home-manager.users.rick = {
    home.stateVersion = "23.11";
  # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
    home.username = "rick";
    home.homeDirectory = "/home/rick";

#= Dconf
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  #= QT
    qt.enable = true;

    # platform theme "gtk" or "gnome"
    qt.platformTheme = "gtk";

    # name of the qt theme
    qt.style.name = "adwaita-dark";

    # detected automatically:
    # adwaita, adwaita-dark, adwaita-highcontrast,
    # adwaita-highcontrastinverse, breeze,
    # bb10bright, bb10dark, cde, cleanlooks,
    # gtk2, motif, plastique

    # package to use
    qt.style.package = pkgs.adwaita-qt;

  #= GTK
    gtk.enable = true;

    gtk.cursorTheme.package = pkgs.gnome-themes-extra;
    gtk.cursorTheme.name = "adwaita_cursor";

    gtk.theme.package = pkgs.adw-gtk3;
    gtk.theme.name = "Adwaita-dark";

    gtk.iconTheme.package = pkgs.papirus-icon-theme;
    gtk.iconTheme.name = "ePapirus-Dark";

    gtk.gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk.gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

#= Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rick = {
    isNormalUser = true;
    description = "Rick";
    extraGroups = [
      "wheel" # enable 'sudo'
      "root"
      "video"
      "audio"
      "render"
      "games" # Access to some game software. /var/games.
      "gamemode" # Required for 'renicing' via gamemode.
      "storage" # Used to gain access to removable drives such as USB hard drives.
      "disk"
      "libvirt"
      "flatpak"
      "networkmanager"
      "kvm"
      "qemu"
      "input"
    ];
    shell = pkgs.fish; #pkgs.zsh;
    packages = with pkgs; [ ];
  };

#=> Fonts Config
  fonts = {
    packages = with pkgs; [
      montserrat
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "DaddyTimeMono" "Meslo" "JetBrainsMono" "UbuntuMono" ]; })
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
      monospace = [ "DaddyTimeMono Nerf Font Propo" ];
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Noto Sans" "Source Han Sans" ];
      };
    };
  };

  # Set your time zone.
  time.timeZone = "America/Chihuahua";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_MX.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_MX.UTF-8";
    LC_IDENTIFICATION = "es_MX.UTF-8";
    LC_MEASUREMENT = "es_MX.UTF-8";
    LC_MONETARY = "es_MX.UTF-8";
    LC_NAME = "es_MX.UTF-8";
    LC_NUMERIC = "es_MX.UTF-8";
    LC_PAPER = "es_MX.UTF-8";
    LC_TELEPHONE = "es_MX.UTF-8";
    LC_TIME = "es_MX.UTF-8";
  };

#==> Services <==#

#= thermal CPU management
  services.thermald.enable = true;

#= Enable Flatpak
  services.flatpak.enable = true;

#= KDE Plasma
  # Enable the KDE Plasma Desktop Environment.
  #services.xserver.desktopManager.plasma5.enable = true;
  #services.xserver.displayManager.defaultSession = "plasmawayland";

#= SDDM
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = true;
  services.xserver.displayManager.sddm.theme = "Elegant";

#= X.ORG/X11
  services.xserver = {
    enable = true;
    updateDbusEnvironment = true;
    videoDrivers = [ "amdgpu" ];
    libinput.enable = true;
    layout = "es";
    xkbVariant = "nodeadkeys";
    excludePackages = [ pkgs.xterm ];
  };

#= Configure console keymap
  console.keyMap = "es";
  console.packages = with pkgs; [ terminus-nerdfont ];

#= Printers
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
    hplip
  ];

#= FWUPD
  services.fwupd.enable = true;

#= Dbus
  services.dbus = {
    enable = true;
    apparmor = "enabled";
    implementation = "broker"; 
    packages = with pkgs; [ flatpak gcr gnome.gnome-settings-daemon ];
  };

# Nautilus
  services.gvfs.enable = true;
  services.gvfs.package = pkgs.gnome.gvfs;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.gnome.gnome-settings-daemon.enable = true;

#= Pipewire

  sound.enable = true;
  security.rtkit.enable = true; # Real-Time Priority to Processes.
  services.pipewire = {
    enable = true;
    audio.enable = true; # Use as primary sound server
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    socketActivation = true;
    package = pkgs.pipewire;
  };

#=> PROGRAMS <=#

#= Firefox
  programs.firefox = {                  
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "widget.use-xdg-desktop-portal.mime-handler" = 1;
      "browser.download.animateNotifications" = false;
      "security.dialog_enable_delay" = false;
      "network.prefetch-next" = false;
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
      "browser.ping-centre.telemetry" = false;
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "toolkit.telemetry.hybridContent.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.reportingpolicy.firstRun" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "privacy.trackingprotection.fingerprinting.enable" = true;
      "privacy.trackingprotection.cryptomining.enable" = true;
      "privacy.trackingprotection.enable" = true;
      "browser.send_pings" = false;
      "browser.sessionstore.privacy_level" = 2;
      "browser.safebrowsing.downloads.remote.enabled" = false;
      "browser.pocket.enabled" = false;
      "loop.enabled" = false;
      "fission.autostart" = true;
      "reader.parse-on-load.enabled" = false;
      "reader.parse-on-load.force-enabled" = false;
      "beacon.enabled" = false;
      "webgl.disabled" = false;
      "gfx.webrender.all" = true;
      "dom.event.clipboardevents.enabled" = false;
      "media.navigator.enabled" = false;
      "network.cookie.cookieBehavior" = 1;
    };
    languagePacks = [ "es-MX" ];
    package = pkgs.floorp;
  };

#= Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    package = unstable.pkgs.neovim-unwrapped;
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
          nvchad
          nvchad-ui
        ]; 
        opt = [];
      };
    };
  };

#= Java
  programs.java = {
    enable = true;
    package = pkgs.jdk;
    binfmt = true;
  };

#=> Shell's

#= Fish

  programs.fish = {
    enable = true;
    useBabelfish = true;
    promptInit = "set fish_greeting";
    shellAliases = {
      grep = "grep --color=auto";
      cat = "bat --style=plain --paging=never";
      ls = "eza --all --group-directories-first --grid --icons";
      tree = "eza -T --all --icons";
      ll = "eza -l --all --octal-permissions --icons";
    };
    interactiveShellInit = "fastfetch";
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

#= XWayland
  programs.xwayland.enable = true;

#==>~HYPRLAND~<==#

  programs.hyprland = {
    enable = true;
    portalPackage = unstable.pkgs.xdg-desktop-portal-hyprland;
    enableNvidiaPatches = false; # false if you use a AMD GPU
    xwayland.enable = true;
    #package = pkgs.hyprland;
    package = hyprland-flake.packages.${pkgs.system}.hyprland;
  };
#= Top Bar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
  };

#= File Managers
  # Yazi
  programs.yazi = {
    enable = true;
    package = unstable.pkgs.yazi;
  };
  # Nautilus
  services.gnome.sushi.enable = true;

#= Enable xdg desktop Integration
  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        libsForQt5.xdg-desktop-portal-kde
        lxqt.xdg-desktop-portal-lxqt
      ];
      config = {
        common = {
          default = [ "xdph" "gtk" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          "org.freedesktop.portal.FileChooser" = [ "xdg-desktop-portal-gtk" ];
        };
      };
    };
    sounds.enable = true;
    autostart.enable = true;
    menus.enable = true;
  # Many apps+DEs utilize MIME to represent types of files.
  # Connections may be added by other Nix modules.
    mime.enable = true;
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

#= Permitted Insecure Packages
  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
  ];

#= Enable Nix-Shell and Flakes
  nix = {
    settings = {
      warn-dirty = true;
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = ["rick"];
    };
  };

#= Allow unfree packages
  nixpkgs.config.allowUnfree = true;

#= Prismlauncher fetchTarball
  #nixpkgs.overlays = [(import (builtins.fetchTarball "https://github.com/PrismLauncher/PrismLauncher/archive/develop.tar.gz")).overlays.default];

#=> Packages Installed in System Profile.
  environment.systemPackages = with pkgs; [
    #=> Hyprland
    # Terminal
    unstable.kitty
    # Top bar
    #waybar
    #waybar-mpris
    # Main
    #hyprland
    unstable.hyprland-protocols
    unstable.hyprland-per-window-layout
    unstable.hyprland-autoname-workspaces
    unstable.wayland-utils
    # Wayland - Kiosk. Used for login_managers
    cage
    # Notification Deamon
    dunst
    libnotify
    notify
    # Wallpaper
    unstable.hyprpaper
    # App-Launcher
    rofi-wayland
    # Applets
    networkmanagerapplet
    # Screen-Locker
    wlogout
    # Idle manager
    swayidle # required by the screen locker
    #Clipboard-specific
    wl-clipboard
    # Screenshot
    unstable.grimblast # Taking
    unstable.slurp # Selcting
    swappy # Editing
#= Polkit
    polkit
    libsForQt5.polkit-kde-agent
#= Filemanagers
    gnome.nautilus
    # Image Viewer
    imv
    # Theme's
    adwaita-qt6
    qgnomeplatform-qt6
    qgnomeplatform
    sddm-chili-theme # SDDM
    unstable.elegant-sddm
    # XWayland/Wayland
    unstable.glfw-wayland
    unstable.xwayland
    unstable.xwaylandvideobridge
#= Main
    alsa-plugins
    alsa-utils
    android-tools
    android-udev-rules
    ark
    clamtk # Antivirus
    webcord # discord client
    electron
    findutils
    godot_4
    libportal
    libsForQt5.qt5ct
    libstdcxx5
    unstable.linuxHeaders
    unstable.fastfetch
    pipewire
    protonup-qt
    python3
    qt5.qtwayland
    qt6.qtwayland
    usbutils
    wget
    libreoffice # Office Suite
    xboxdrv # Xbox Gamepad Driver
    #xclip
    yarn
#= Cli Utilities
    babelfish
    bat
    dunst
    unstable.eza
    git
    skim
#= XDG
    xdg-launch
    xdg-user-dirs
    xdg-utils 
    xdg-dbus-proxy 
#= Archives
    zip
    unzip
    gnutar
    rar
    unrar
#= Torrent
    frostwire-bin
    rqbit
#= Waydroid
    lzip
#= electron based launchers need newer versions of these libraries than what runtime provides
    sqlite
#= Godot + Blender
    stdenv.cc.cc
#= Godot Engine
    libunwind
#= Rust
    cargo # PM for rust
    rustup # Rust toolchain installer
#= Drives utilities
    gnome.gnome-disk-utility # Disk Manager
    etcher # Flash OS images for Linux and another...
    woeusb # Flash OS images for Windows.
#= Flatpak
    libportal
    libportal-qt5
    zip
#= Graph manager dedicated for PipeWire
    helvum # A GTK patchbay for pipewire
    pwvucontrol # Pipewire Volume Control
    pavucontrol # Pulseaudio Volume Control
    easyeffects
#= Guitar Amp Simulator
    #guitarix
#= Appimages
    appimagekit
    appimage-run
#= TOR
    #obfs4
    #tor-browser
#= Virtualization
    virt-manager
    virt-viewer
    virtio-win
    qemu_kvm
    spice spice-gtk
    spice-protocol
    win-spice
#= Image Editors
    krita
    gimp-with-plugins
#= Video/Audio Tools
    carla # An audio plugin host
    gxplugins-lv2 # A set of extra lv2 plugins from the guitarix project
    olive-editor # Professional open-source NLE video editor
    giada # Your hardcore loop machine.
    ardour # Multi-track hard disk recording software
    audacity
    (wrapOBS {
      plugins = with obs-studio-plugins; [ 
        obs-vkcapture 
        input-overlay 
        obs-pipewire-audio-capture
        wlrobs 
        obs-move-transition 
        waveform
        obs-tuna
        obs-backgroundremoval 
      ];
    })
    obs-studio
    obs-studio-plugins.obs-pipewire-audio-capture
#= GStreamer and codecs
    # Video/Audio data composition framework tools like "gst-inspect", "gst-launch" ...
    gst_all_1.gstreamer
    gst_all_1.gstreamermm # C++ interface for GStreamer
    # Common plugins like "filesrc" to combine within e.g. gst-launch
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-rs # Written in Rust
    # Specialized plugins separated by quality
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    # Plugins to reuse ffmpeg to play almost every video format
    gst_all_1.gst-libav
    # Support the Video Audio (Hardware) Acceleration API
    gst_all_1.gst-vaapi
    # Library for creation of audio/video non-linear editors
    gst_all_1.gst-editing-services
    # H.264 encoder/decoder plugin for mediastreamer2
    mediastreamer-openh264
    # H264/AVC 
    x264 
    # H.265/HEVC
    x265
    # WebM VP8/VP9 codec SDK
    libvpx
    # Vorbis audio compression
    libvorbis
    # Open, royalty-free, highly versatile audio codec
    libopus
    # MPEG
    lame
    # A library for decrypting DVDs
    libdvdcss
    # PNG
    libpng
    # JPEG
    libjpeg
    # FFMPEG
    ffmpeg
    ffmpeg-headless
    ffmpegthumbnailer
#= Media Player
    mpv
#= AMD P-STATE EPP
    amdctl
#= Vulkan
    unstable.vulkan-headers
    unstable.vulkan-loader
    unstable.vulkan-tools
    unstable.vulkan-tools-lunarg
    unstable.vulkan-validation-layers
    unstable.vulkan-extension-layer
    unstable.vkdisplayinfo
    unstable.vkd3d-proton
    unstable.vk-bootstrap
#= ROCm
    rocmPackages.rocm-core
    rocmPackages.rocm-runtime 
    rocmPackages.clr
    rocmPackages.rocm-smi # Managment interface
    rocmPackages.rocminfo # ROCm app for reporting System info
    rocmPackages.rocm-device-libs
#= Administrative/GUI.
    corectrl # Let's you overclock/etc. Requires Polkit authentication!
#= PC monitoring
    stacer # Linux System Optimizer and Monitoring.
    clinfo
    glxinfo
    hardinfo
    htop-vim
    hwloc
    btop
    nvtop
    lm_sensors
    # gaming monitoring
    goverlay
    mangohud
    vkbasalt
    # cpu-x dependencies
    cpu-x
    nawk
    libcpuid
    #glfw
#= Tools from the vengi voxel engine and more.
    vengi-tools
#= Wine
    # support both 32- and 64-bit applications
    (unstable.wineWowPackages.stagingFull.override {
      mingwSupport = false;
      vulkanSupport = true;
    })
    samba
    # support 32-bit only
    #wine
    # support 64-bit only
    #(wine.override { wineBuild = "wine64"; })
    # wine-staging (version with experimental features)
    #wineWowPackages.staging
    # winetricks (all versions)
    #winetricks
    # native wayland support (unstable)
    #wineWowPackages.waylandFull
#= Emulators
    # Retro
    mame
    retroarchFull
    # Xbox
    xemu
    # Nintendo
    unstable.dolphin-emu # Gamecube/Wii/Triforce
    unstable.ryujinx # Switch
#= The best Game in the World
    superTuxKart
#= Heroic GOG/Epic/Amazon Game Launcher
    unstable.heroic
    unstable.gogdl
#= Steam
    winetricks
    protontricks
    steamtinkerlaunch
#= Lutris
    lutris-unwrapped
#= OpenSource Minecraft Launcher
    glfw-wayland-minecraft
    (prismlauncher.override { jdks = [ jdk19 jdk17 jdk8 ]; })
    jdk8
    jdk17
    jdk19
#= Launcher for Veloren.
    airshipper 
  ];


##==> GAMING <==##

#=> Gamescope
  programs.gamescope = {
    enable = true;
    package = unstable.pkgs.gamescope;
    capSysNice = false;
  };

#=> Gamemode
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        amd_performance_level = "high";
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode Started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode Ended'";
      };
    };
  };
#=> Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    package = pkgs.steam.override {
      extraLibraries = p: with p; [
        atk
        dnsmasq
        glxinfo
        gtkmm2
        gtkmm3
        gtkmm4
        libgdiplus
        libxkbcommon
        openal
        xwayland
        steamPackages.steam-runtime-wrapped
        # steamwebhelper
        harfbuzz
        libthai
        pango
        lsof # friends options won't display "Launch Game" without it
        file # called by steam's setup.sh
        # Gamescope
        gamescope
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  };

#=> Vulkan, Codecs and more... 
  hardware.cpu.amd.updateMicrocode = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true; 
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    unstable.amdvlk
    unstable.libdrm
    mesa.drivers
    mesa.llvmPackages.llvm.lib
    rocmPackages.clr
    rocmPackages.clr.icd
    #vaapiIntel
    vaapiVdpau
    vdpauinfo
    libvdpau
    libvdpau-va-gl
    #intel-media-driver
  ]; 
  hardware.opengl.extraPackages32 = with pkgs.driversi686Linux; [
    unstable.amdvlk
    mesa.drivers
    mesa.llvmPackages.llvm.lib
    glxinfo
    vaapiVdpau
    vdpauinfo
    libvdpau-va-gl
    #intel-media-driver
  ];
  hardware.opengl.setLdLibraryPath = true;
  hardware.steam-hardware.enable = true;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true; # Lemme update my CPU Microcode, alr?!

#==> Environment Configs <==#

  environment = { 
    etc = {
#=> Pipewire
    "pipewire/pipewire.conf.d/92-pipewire-config".text = ''
        [pipewire]
        realtime = true
        support.dbus = true
        cpu.zero.denormals = false
        [alsa]
        jack.period-size = 1024
        jack.periods = 2
      '';
    };
    pathsToLink = [ "/share/X11" "/libexec" "/share/zsh" "/share/nix-ld" ];
    sessionVariables = rec {
#=> Default's
      EDITOR = "nvim";
      BROWSER = "firefox";
      TERMINAL = "kitty";
#=> Enable touch-scrolling in Mozilla software
      MOZ_USE_XINPUT2 = "1";
#=> JAVA
      _JAVA_AWT_WM_NONREPARENTING = "1";
#=> RADV
      AMD_VULKAN_ICD = "RADV"; # Force radv
      RADV_PERFTEST = "aco"; # Force aco
#=> Steam
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
#=> Wayland
      NIXOS_OZONE_WL = "1";
      OZONE_PLATFORM = "wayland";
      WLR_RENDERER = "vulkan";
      WLR_NO_HARDWARE_CURSORS = "1";
      MOZ_ENABLE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
#=> Flatpak
      FLATPAK_GL_DRIVERS = "mesa-git";
#=> Pipewire
      PIPEWIRE_LATENCY = "256/48000 jack_simple_client";
#=> QT
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_DEBUG_PLUGINS = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
#=> GTK
      GTK_USE_PORTAL = "1";
      GDK_SCALE = "1";
      GDK_BACKEND = "wayland,x11";
      XCURSOR_SIZE = "16";
#=> NIX
      NIXOS_XDG_OPEN_USE_PORTAL = "1";
#=> NIX-LD
      NIX_LD = "/run/current-system/sw/share/nix-ld/lib/ld.so";
      NIX_LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";
#=> Electron
      ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
#=> User Dirs
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_DESKTOP_DIR = "/mnt/sdb1/Home/Escritorio";
      XDG_DOWNLOAD_DIR = "/mnt/sdb1/Home/Descargas";
      XDG_TEMPLATES_DIR = "/mnt/sdb1/Home/Templates";
      XDG_PUBLICSHARE_DIR = "/mnt/sdb1/Home/Público";
      XDG_DOCUMENTS_DIR = "/mnt/sdb1/Home/Documentos";
      XDG_MUSIC_DIR = "/mnt/sdb1/Home/Música";
      XDG_PICTURES_DIR = "/mnt/sdb1/Home/Imágenes";
      XDG_VIDEOS_DIR = "/mnt/sdb1/Home/Vídeos";
    };
  };

#=> Storage Options
  nix.optimise.automatic = true;
  #https://github.com/nix-community/nix-direnv
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    silent = false;
    loadInNixShell = true;
    direnvrcExtra = "";
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };


#=> Virtual Machines <=#

  virtualisation = {
    waydroid.enable = true; 
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
	    ovmf.enable = true;
	  };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

#==> Drives

#= Media Disk
  fileSystems."/mnt/sdb1" =
  { device = "/dev/disk/by-uuid/5d5d4cdc-2a16-466a-aaf6-03bb93931d97";
    fsType = "ext4";
    options = [ "defaults" "async" "noatime" "nodiratime" "data=writeback" "barrier=1" ];
  };

#= Enable Trim Needed for SSD's
  services.fstrim.enable = true;

#= Swap
  zramSwap = {
      enable = true;
      priority = 70;
      memoryPercent = 50;
      algorithm = "zstd";
      swapDevices = 2;
  };

#==> Polkit <==#

  security.polkit.enable = true;

  #= Polkit User Service
  systemd.user.services.polkit-kde-authentication-agent-1 = {
    enable = true;
    description = "polkit-kde-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

#==> Network and Security <==#

  networking = {
    networkmanager.enable = true;
    hostName = "razor-crest"; # Define your hostname.
    firewall = {
      enable = true;
      allowedTCPPorts = [
        53
        80
        443
        631
        3478
        3479
        8080
      ];
    };
    enableIPv6 = false;
  };
# Fail2Ban
  services.fail2ban = {
    enable = true;
    ignoreIP = [
      "9.9.9.11"
      "149.112.112.11"
      "2620:fe::11"
      "2620:fe::fe:11"
    ];
    maxretry = 5;
    bantime = "1h";
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

  documentation.nixos.enable = true;
}
