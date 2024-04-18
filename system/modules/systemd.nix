{ config, pkgs, pkgs-stable, lib, ... }:

{
#==> SystemD <==#

  systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      "L+    /usr/share/wayland-sessions/hyprland.desktop   -    -    -     -    ${pkgs.hyprland}/share/wayland-sessions/hyprland.desktop"
  ];

  systemd.extraConfig = ''
      [Process]
      Name=steam.exe
      Priority=10
      Interactive=true
      NegativePriority=5
      ...
      [Service]
      Delegate=cpu cpuset io memory pids
      ...
      [Manager]
      DefaultLimitNOFILE=2048:2097152
    '';
  systemd.user.extraConfig = ''
      [Manager]
      DefaultLimitNOFILE=2048:1048576
    '';

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
    };
  };
}
