{ config, pkgs, lib, inputs, ... }:

{
#==>~HYPRLAND~<==#

  programs.hyprland = {
    enable = true;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}
