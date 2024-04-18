{ config, pkgs, lib, inputs, ... }:

{

    imports = [ 
        ./config/exec.nix
        ./config/keybinds.nix
        ./config/windowrule.nix
    ];

    # enable hyprland
    wayland.windowManager.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        systemd = {
            variables = ["--all"];
            extraCommands = [
                "systemctl --user stop graphical-session.target"
                "systemctl --user start hyprland-session.target"
            ];
        };
    };
    wayland.windowManager.hyprland.settings = {  

    general = {
        monitor = [
          #"monitor = HDMI-A-1, highres, auto, 1"
          "monitor = eDP-1, highres, auto, 1"
        ];
        gaps_in = 1;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "0x66BBBBBB";
        "col.inactive_border" = "0x66333333";
        "no_border_on_floating" = false;
        layout = "dwindle";
        no_cursor_warps = true;
    };

    input = {
        kb_model = "pc104";
        kb_layout = "latam";
        kb_options = "terminate:ctrl_alt_bksp";
        follow_mouse = 1;
        sensitivity = 0;
        force_no_accel = false;
        accel_profile = "flat";
        touchpad = {
          disable_while_typing = false;
          natural_scroll = true;
        };
    };

    gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_min_speed_to_force = 0;
        workspace_swipe_use_r = false;
    };

    decoration = {
        rounding = 5;
        blur = {
            enable = true;
            size = 3; # minimo 1
            passes = 1; # minimo 1
            new_optimizations = "1"; # si habilitar más optimizaciones para el desenfoque. Se recomienda dejar puesto, ya que mejorará enormemente el rendimiento.
        };
        dim_inactive = true;
        dim_strength = "0.3";
        fullscreen_opacity = 1;
        drop_shadow = true;
        shadow_ignore_window = true;
        shadow_offset = "0 8";
        shadow_range = 50;
        shadow_render_power = 3;
    };

    animation = {
        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "easeinoutsine, 0.37, 0, 0.63, 1"
        ];
        animation = [
          "windowsIn, 1, 1.7, easeOutCubic, slide" # window open
          "windowsOut, 1, 1.7, easeOutCubic, slide" # window close
          "windowsMove, 1, 2.5, easeinoutsine, slide" # everything in between, moving, dragging, resizing

          # fading
          "fadeIn, 1, 3, easeOutCubic" # fade in (open) -> layers and windows
          "fadeOut, 1, 3, easeOutCubic" # fade out (close) -> layers and windows
          "fadeSwitch, 1, 5, easeOutCirc" # fade on changing activewindow and its opacity
          "fadeShadow, 1, 5, easeOutCirc" # fade on changing activewindow for shadows
          "fadeDim, 1, 6, fluent_decel" # the easing of the dimming of inactive windows
          "border, 1, 2.7, easeOutCirc" # for animating the border's color switch speed
          "workspaces, 1, 2, fluent_decel, slide" # styles: slide, slidevert, fade, slidefade, slidefadevert
          "specialWorkspace, 1, 3, fluent_decel, slidevert"
        ];
    };

    dwindle = {
        no_gaps_when_only = false;
        pseudotile = true;
        preserve_split = true;
    };

    master = {
        new_on_top = true;
        new_is_master = true;
    };

    misc = {
        disable_autoreload = true;
        mouse_move_enables_dpms = true;
        swallow_regex = "^(foot|kitty|Alacritty)$";
        animate_mouse_windowdragging = false;
        vrr = 1; # VRR (Adaptive Sync). 0 - Disabled, 1 - Enabled, 2 - Only FullScreen
        no_direct_scanout = false;
        vfr = true;
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
    };

    xwayland.force_zero_scaling = true;

    env = [ "QT_WAYLAND_DISABLE_WINDOWDECORATION,1" ];

  };
  xdg.configFile = {
    # Hyprpaper
    "hypr/hyprpaper.conf" = {
        enable = true;
        text = ''
            preload = ~/wal/spaceman.png
            wallpaper = , ~/wal/spaceman.png

            ipc = off
            splash = false
        '';
    };
    "hypr/hypridle.conf" = {
        enable = true;
        text = ''
            general {
            ignore_dbus_inhibit = false
        }

        # Screenlock
        listener {
            timeout = 600
            on-timeout = ${pkgs.hyprlock}/bin/hyprlock
            on-resume = ${pkgs.libnotify}/bin/notify-send "Welcome back!"
        }

        # Suspend
        listener {
            timeout = 660
            on-timeout = systemctl suspend
            on-resume = ${pkgs.libnotify}/bin/notify-send "Welcome back to your desktop!"
        }
        '';
    };
    "hypr/hyprlock" = {
        enable = true;
        text = ''
    background {
        monitor =
        path = $HOME/wal/synthwave.png
        blur_size = 4
        blur_passes = 3
        noise = 0.0117
        contrast = 1.3000
        brightness = 0.8000
        vibrancy = 0.2100
        vibrancy_darkness = 0.0
    }

    input-field {
        monitor =
        size = 250, 50
        outline_thickness = 3
        dots_size = 0.2 # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.64 # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true
 
        fade_on_empty = true
        fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
        placeholder_text = <i>Password...</i> # Text rendered in the input box when it's empty.
        hide_input = false
        rounding = -1 # -1 means complete rounding (circle/oval)
        check_color = rgb(204, 136, 34)
        fail_color = rgb(204, 34, 34) # if authentication failed, changes outer_color and fail message color
        fail_transition = 300 # transition time in ms between normal outer_color and fail_color
        capslock_color = -1     
        numlock_color = -1
        bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
        invert_numlock = false # change color if numlock is off
        swap_font_color = false # see below
        position = 0, 50
        halign = center
        valign = bottom
    }

    # Current time
    label {
        monitor =
        text = cmd[update:1000] echo "<b><big> $(date +"%H:%M:%S") </big></b>"

        font_size = 64

        position = 0, 16
        halign = center
        valign = center
    }

    # User label
    label {
        monitor =
        text = Hey <span text_transform="capitalize" size="larger">$USER</span>

        font_size = 20

        position = 0, 0
        halign = center
        valign = center
    }


    # Type to unlock
    label {
        monitor =
        text = Type to unlock!

        font_size = 16

        position = 0, 30
        halign = center
        valign = bottom
    }
        '';
    };
  };

}
