{ config, pkgs, lib, ... }: let custom = {

    back =  "rgba( 14, 14, 23, 0.75);";
    color = "#BBBBBB;";
    borders = "#0E0E0E;";
    inactives = "rgba(204, 204, 204, 0.3);";
    urgent = "#FFFFFF;";
};
in {
    programs.waybar.enable = true;
    programs.waybar.package = pkgs.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    });
    programs.waybar.settings.mainBar = {
        layer = "top";
        position = "top";
        mode = "dock";
        exclusive = true;
        height = 0;

        modules-left = [ "clock" "hyprland/window" ];
        modules-center = [ "custom/nix" "hyprland/workspaces" ];
        modules-right = [ "gamemode" "tray" "network" "cpu" "memory" "temperature" "battery" "wireplumber" "backlight" ];

        "hyprland/window" = {
	        format = " /{}";
	        tooltip = true;
	        separate-outputs = true;
        };

        "hyprland/workspaces" = {
            active-only = false;
            all-outputs = true;
	        format = "{icon}";
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
            format-icons = {
	    	    active = "󰮯";
                default = "󰊠";
	        };
    	    persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
            "6" = [];
            };
        };

        "custom/nix" = {
	        format = " ";
        };

        wireplumber = {
	        format = "{volume}% {icon}";
	        format-icons = ["󰖁" "" "" "󰕾" ""];
	        on-click = "wpctl";
        };

        backlight = {
	        format = "{percent}% {icon}";
	        format-icons = ["󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠"];
            on-click = "brightnessctl";
        };

        gamemode = {
	        format = "{glyph}";
            format-alt = "{glyph} {count}";
            glyph = "";
            hide-not-running = true;
            use-icon = true;
            icon = "nf-fa-gamepad";
            icon-spacing = 4;
            icon-size = 20;
        };

        tray = {
	        icon-size = 20;
            spacing = 10;
        };

        cpu = {
	        interval = 5;
	        tooltip = false;
            format = " {usage}%";
	        format-alt = " {load}";
	        states = {
	            warning = 70;
	            critical = 90;
	        };
        };

        memory = {
	        interval = 5;
	        format = "󰗉 {used:0.1f}G/{total:0.1f}G";
	        states = {
	            warning = 70;
	            critical = 90;
	        };
	        tooltip = false;
        };

        network = {
            format-wifi = " {bandwidthTotalBytes}";
            format-ethernet = "";
            tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "󰖪 ";
        };

        clock = {
            calendar = {
                format = { today = "<span color='#b4befe'><b>{}</b></span>"; };
            };
            format = " {:%H:%M}";
            tooltip= "true";
            tooltip-format= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt= " {:%d/%m}";
        };

        temperature = {
            critical-threshold = 90;
            format = "{icon} {temperatureC}°C";
            format-critical = "{icon} {temperatureC}°C";
            format-icons = [
            ""
	        ""
	        ""
	        ""
	        ""
            ];
            interval = 2;
        };

        battery = {
            format = "{icon} {capacity}%";
            format-alt = "{icon} {time}";
            format-charging = "󰚥 {capacity}%";
            format-icons = [" " " " " " " "];
        };
    };

    programs.waybar.style = ''
    * {
    font-family: "DaddyTimeMono", Mono;
    font-weight: Bold;
    font-size: 14px;
}

window#waybar {
    background-color: transparent;
}


/* -----------------------------------------------------
 * Workspaces 
 * ----------------------------------------------------- */

#workspaces button {
    padding: 4px 8px;
    color: ${custom.inactives};
    margin-left: 1px;
    margin-right: 1px;
}

#workspaces button.active {
    color: ${custom.urgent};
    transition: all 0.3s ease-in-out;
}

#workspaces button.focused {
    color: ${custom.color};
    border-radius: 10px;
   }

#workspaces button.urgent {
    color: ${custom.urgent};
    border-radius: 10px;
}

#workspaces button:hover {
    color: ${custom.color};
    background: ${custom.back};
}


/* -----------------------------------------------------
 * Tooltips
 * ----------------------------------------------------- */

tooltip {
    color: ${custom.color};
    background: ${custom.back};
    border-color: ${custom.borders};
    border-radius: 10px;
    border-width: 2px;
}





/* -----------------------------------------------------
 * Custom Quicklinks
 * ----------------------------------------------------- */

#custom-nix,
#gamemode,
#window,
#clock,
#battery,
#pulseaudio,
#network,
#workspaces,
#backlight,
#wireplumber,
#battery,
#temperature,
#cpu,
#memory,
#gamemode,
#tray {
    padding: 0px 10px;
    color: ${custom.color};
    background: ${custom.back};
    margin: 3px 0px;
    margin-top: 10px;
}


/* -----------------------------------------------------
 * Window and Clock
 * ----------------------------------------------------- */

#window {
    color: ${custom.color};
    background: ${custom.back};
    border-radius: 0px 10px 10px 0px;
    margin-left: 0px;
    margin-right: 5px;
    padding: 2px 10px 0px 10px;
    font-size:16px;
    font-weight:normal;
}

#clock {
    color: ${custom.color};
    background: ${custom.back};
    border-radius: 10px 0px 0px 10px;
    margin-right: 0px;
    margin-left: 5px;
}


/* -----------------------------------------------------
 * Workspaces and Nix Logo
 * ----------------------------------------------------- */

#workspaces {
    color: ${custom.color};
    background: ${custom.back};
    border-radius: 0px 10px 10px 0px;
    margin-right: 2px;
}

#custom-nix {
    color: ${custom.color};
    background: ${custom.back};
    border-radius: 10px 0px 0px 10px;
    margin-left: 5px;
}


/* -----------------------------------------------------
 * Gamemode
 * ----------------------------------------------------- */

#gamemode {
    color: ${custom.color};
    background: ${custom.back};
    border-radius: 10px;
    margin-left: 2px;
    margin-right: 2px;
}

/* -----------------------------------------------------
 * Tray
 * ----------------------------------------------------- */

#tray {
    color: ${custom.color};
    background: ${custom.back};
    border-radius: 10px;
    margin-right: 2px;
    margin-left: 2px;
}



/* -----------------------------------------------------
 * Network
 * ----------------------------------------------------- */

#network {
    color: ${custom.color};
    background: ${custom.back};
    border-radius: 10px; 
    border-left: 0px;
    border-right: 0px;
    margin-right: 2px;
    margin-left: 2px;
}


/* -----------------------------------------------------
 * Cpu and Ram
 * ----------------------------------------------------- */

#cpu {
    color: ${custom.color};
    background: ${custom.back};
    border-radius: 10px 0px 0px 10px;
    margin-left: 2px;
    margin-right: -1px;
}

#memory {
    color: ${custom.color};
    background: ${custom.back};
    border-radius: 0px 10px 10px 0px; 
    margin-right: 2px;
    margin-left: 0px;
}

/* -----------------------------------------------------
 * Battery and Temperature
 * ----------------------------------------------------- */

#battery {
    color: ${custom.color};
    background: ${custom.back};
    border-radius: 0px 10px 10px 0px; 
    margin-right: 2px;
    margin-left: 0px;
}

#temperature {
    color: ${custom.color};
    background: ${custom.back};
    border-radius: 10px 0px 0px 10px;
    margin-right: 0px;
    margin-left: 2px;
}


/* -----------------------------------------------------
 * Audio and Backlight
 * ----------------------------------------------------- */

#wireplumber {
    color: ${custom.color};
    background: ${custom.back};
    border-radius: 10px 0px 0px 10px;
    margin-left: 2px;
    margin-right: -1px;
}

#backlight {
    color: ${custom.color};
    background: ${custom.back};
    border-radius: 0px 10px 10px 0px; 
    margin-right: 2px;
    margin-left: 0px; 
}

    '';

}
