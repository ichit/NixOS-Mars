{ config, pkgs, pkgs-stable, lib, ... }:

{
 #= Allow unfree packages
  nixpkgs.config.allowUnfree = true;

 #=> Packages Installed in System Profile.
 environment.systemPackages = with pkgs; [
 #= Gnome
    #gnome-extension-manager
    #gnomeExtensions.appindicator
    #gnomeExtensions.dash-to-dock
    #gnomeExtensions.blur-my-shell
    #gnomeExtensions.gamemode-indicator-in-system-settings
    #gnomeExtensions.vitals
    #gnomeExtensions.xwayland-indicator
    #gnome.gnome-tweaks
    #gnome.gnome-calculator
    #gnome.dconf-editor
    #gnome.eog
    gnome.nautilus
    #Clipboard-specific
    wl-clipboard
    # XWayland/Wayland
    glfw-wayland
    wayland-utils
    xwayland
    xwaylandvideobridge
 #= Hyprland
     #=> Hyprland
    # Terminal
    kitty
    # Top bar
    #eww
    # Hyprland
    hyprland-protocols
    wayland-utils
    #hyprcursor # The hyprland cursor format, library and utilitie
    # Wayland - Kiosk. Used for login_managers
    cage
    # Notification Deamon
    dunst
    libnotify
    notify
    # Wallpaper
    hyprpaper
    # App-Launcher
    rofi-wayland
    # Applets
    networkmanagerapplet
    # Screen-Locker
    wlogout
    kanshi # To turn a laptop's internal screen off when docked.
    # Lock Screen
    hyprlock
    # Idle manager
    hypridle # required by the screen locker
    # Brightnes Manager
    brightnessctl
    # Media CMD Utility
    playerctl
    #Clipboard-specific
    wl-clipboard
    # An xrandr clone for wlroots compositors
    wlr-randr
    # Screenshot
    grimblast # Taking
    slurp # Selcting
    swappy # Editing
  #= Polkit
    polkit
    polkit_gnome
    libsForQt5.polkit-kde-agent
    # Image Viewer
    imv
    # Theme's
    adwaita-qt6
    qgnomeplatform-qt6
    qgnomeplatform
    tokyo-night-gtk
    # XWayland/Wayland
    glfw-wayland
    wlr-randr
    xwaylandvideobridge
 #= Main
    alsa-plugins
    alsa-utils
    appimage-run
    libsForQt5.ark
    clamtk
    cmake
    glibc
    glibmm
    helvum
    webcord
    electron
    jq
    #socat
    #libportal
    #libsForQt5.qt5ct
    #libstdcxx5
    python3
    qt5.qtwayland
    qt6.qtwayland
    usbutils
    wget
    libreoffice
    yarn
 #= XDG
    xdg-utils
    xdg-launch
 #= Cli Utilities
    babelfish
    bat
    dunst
    eza
    fzf
    ripgrep
    fastfetch
    kitty
    git
    skim
    # Fish Plugins
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.grc
    grc
 #= Archives
    imagemagick
    zip
    unzip
    gnutar
    rarcrack
    rar
    unrar-free
 #= Rust
    cargo # PM for rust
    rustup # Rust toolchain installer
 #= Drives utilities
    gnome.gnome-disk-utility # Disk Manager
    #etcher # Flash OS images for Linux and another...
    woeusb # Flash OS images for Windows.
 #= Flatpak
    libportal
    libportal-qt5
 #= Graph manager dedicated for PipeWire
    pavucontrol # Pulseaudio Volume Control
 #= Appimages
    appimagekit
    appimage-run
 #= TOR
    #obfs4
    #tor-browser
 #= Image Editors
    krita
    gimp
 #= Video/Audio Tools
    olive-editor # Professional open-source NLE video editor
    (pkgs.wrapOBS {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
        obs-vkcapture
        obs-gstreamer
        obs-vaapi
      ];
    })
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
 #= ROCm
    rocmPackages.rocm-core
    rocmPackages.rocm-runtime 
    rocmPackages.clr
    rocmPackages.rocm-smi # Managment interface
    rocmPackages.rocminfo # ROCm app for reporting System info
    rocmPackages.rocm-device-libs
 #= Vulkan
    vulkan-headers
    vulkan-loader
    vulkan-tools
    vulkan-tools-lunarg
    vulkan-validation-layers
    vulkan-extension-layer
    vkdisplayinfo
    vkd3d-proton
    vk-bootstrap
 #= PC monitoring
    stacer # Linux System Optimizer and Monitoring.
    clinfo
    glxinfo
    hardinfo
    hwinfo
    htop-vim
    lm_sensors
    # gaming monitoring
    goverlay
    mangohud
    vkbasalt
 #= Wine
    # support both 32- and 64-bit applications
    wineWowPackages.stagingFull
    samba
 #= The best Game in the World
    superTuxKart
 #= Steam Utils
    winetricks
    protontricks
    protonup-qt
 #= Lutris
    lutris-unwrapped
 #= OpenSource Minecraft Launcher
    glfw-wayland-minecraft
    (prismlauncher.override { jdks = [ jdk19 jdk17 jdk8 ]; })
 #= Launcher for Veloren.
    airshipper
  ];
}
