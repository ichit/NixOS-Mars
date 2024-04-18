{ osConfig, pkgs, lib, ... }:

{
    wayland.windowManager.hyprland.settings = {
        windowrulev2 = [
            # Posición
            "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
            "float,class:^(lxqt-policykit-agent)$"

            "float,class:^(fragments)$"
            "float,class:^(pavucontrol)$"
            "float,class:^(et)$"
            "float,class:^(org.gnome.Nautilus)$"
            "float,class:^(pcmanfm)$"
            "float,class:^(gnome-disks)$"
            "float,class:^(Network)$"
            "float,class:^(steamwebhelper)"
            "float,title:^(ProtonUp-Qt)$"
            "float,class:^(fragments)$"
            "float,title:^(Media viewer)$"
            "float,title:^(Volume Control)$"
            "float,title:^(Picture-in-Picture)$"
            "float,title:^(DevTools)$"
            "float,class:^(file_progress)$"
            "float,class:^(confirm)$"
            "float,class:^(dialog)$"
            "float,class:^(download)$"
            "float,class:^(notification)$"
            "float,class:^(error)$"
            "float,class:^(confirmreset)$"
            "float,title:^(Open File)$"
            "float,title:^(branchdialog)$"
            "float,title:^(Confirm to replace files)"
            "float,title:^(File Operation Progress)"
            "nomaxsize,title:^(Waydroid)$"

            # Pipewire
            "move 1090 5%,title:^(Pipewire Volume Control)$"
            "float,title:^(Pipewire Volume Control)$"
            # PulseA
            "move 1090 5%,class:^(pavucontrol)$"
            "float,class:^(pavucontrol)$"

            # Steam
            "stayfocused, title:^()$,class:^(steam)$"
            "minsize 1 1, title:^()$,class:^(steam)$"

            "opacity 0.80 0.80,class:^(Steam)$"
            "opacity 0.80 0.80,class:^(steam)$"
            "opacity 0.80 0.80,class:^(steamwebhelper)$"
            "float,title:^(Configuraciones de Steam)$"

            # Lutris
            "float,class:^(lutris)$"

            # Workspaces
            "workspace 1, class: ^(kitty)$"
            "workspace 2 silent, class: ^(steam)$"
            "workspace 3, class: ^(firefox)$"
            "workspace 3, class: ^(floorp)$"
            "workspace 5, class: ^(mpv)$"
            "workspace 6 silent, title: ^(Waydroid)$"

            "idleinhibit focus,class:^(mpv)$"
            "idleinhibit fullscreen,class:^(Firefox)$"

            # xwaylandvideobridge
            "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
            "noanim,class:^(xwaylandvideobridge)$"
            "noinitialfocus,class:^(xwaylandvideobridge)$"
            "maxsize 1 1,class:^(xwaylandvideobridge)$"
            "noblur,class:^(xwaylandvideobridge)$"

        ];
    };
}
