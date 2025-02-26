{ config, pkgs, lib, ... }:

{
#==> Environment Configs <==#

  environment = {
    pathsToLink = [ "/share/X11" "/libexec" "/share/nix-ld" ];
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
#=> Polkit
     POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
    };
  };
}
