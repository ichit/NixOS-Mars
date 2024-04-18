{ config, pkgs, lib, ... }:  let

  pointer = config.home.pointerCursor;
  homeDir = config.home.homeDirectory;

in {
    wayland.windowManager.hyprland.settings = {
        exec-once = [
            "hyprctl setcursor ${pointer.name} ${toString pointer.size}"
            "waybar && dbus-update-activation-environment --systemd --allx WAYLAND DISPLAY XDG_CURRENT_DESKTOP"
            "kanshi"
            "hyprpaper"
            "dunst"
            "systemctl --user restart pipewire"
            "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1"
            "wl-clipboard-history -t"
            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"
            "$POLKIT_BIN"
            "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
        ];
    };
}
