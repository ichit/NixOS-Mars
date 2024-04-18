{ osConfig, pkgs, lib, ... }:

{
    wayland.windowManager.hyprland.settings = {
        bind = [
            # Screenshot
            ", Print, exec, grimblast --notify copysave output"
            "SHIFT, Print, exec, grimblast --notify --cursor copysave area"

            # Launch Apps
            "SUPER, T, exec, kitty"
            "SUPER, B, exec, firefox"
            "CTRL SHIFT, E, exec, nautilus"
            "SUPER, E, exec, kitty -e yazi"
            "SUPER, S, togglesplit, # dwindle"
            "SUPER, R, exec, rofi -show drun -show-icons"

            # Windows
            "SUPER, V, togglefloating,"
            "SUPER, P, pseudo,"
            "SUPER, F, fullscreen"
            "SUPER, left, movefocus, l"
            "SUPER, right, movefocus, r"
            "SUPER, up, movefocus, u"
            "SUPER, down, movefocus, d"

            # Close Window
            "SUPER, X, killactive,"

            # Lock System
            " SUPER, L, exec, hyprlock"
            # PowerMenu
            "SUPER, M, exec, wlogout"

            # Workspaces
            "SUPER, mouse:272, movewindow"
            " SUPER, mouse:273, resizewindow"
            "SUPER, mouse_down, workspace, e+1"
            "SUPER, mouse_up, workspace, e-1"

            "SUPER, 1, workspace,1"
            "SUPER, 2, workspace,2"
            "SUPER, 3, workspace,3"
            "SUPER, 4, workspace,4"
            "SUPER, 5, workspace,5"
            "SUPER, 6, workspace,6"
            "SUPER, 7, workspace,7"
            "SUPER, 8, workspace,8"
            "SUPER, 9, workspace,9"
            "SUPER, 0, workspace,0"

            "ALT, 1, movetoworkspace,1"
            "ALT, 2, movetoworkspace,2"
            "ALT, 3, movetoworkspace,3"
            "ALT, 4, movetoworkspace,4"
            "ALT, 5, movetoworkspace,5"
            "ALT, 6, movetoworkspace,6"
            "ALT, 7, movetoworkspace,7"
            "ALT, 8, movetoworkspace,8"
            "ALT, 9, movetoworkspace,9"
            "ALT, 0, movetoworkspace,0"
        ];
        bindl = [
            # Audio
            ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

            # Multimedia
            ",XF86AudioPlay, exec, playerctl play-pause"
            ",XF86AudioPause, exec, playerctl play-pause"

            # Brightness
            ",XF86MonBrightnessUp, exec, brightnessctl set +5%"
            ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ];
    };

}
