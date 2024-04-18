{ config, pkgs-stable, lib, ... }:

{
#= File Managers
  # Yazi
  programs.yazi = {
    enable = true;
    package = pkgs-stable.yazi;
  };
}
