{ config, pkgs, lib, inputs, ... }: let
  
    pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

in {
#====> GAMING <====#

#= System76 Scheduler 
  services.system76-scheduler.enable = true;
  services.system76-scheduler.useStockConfig = true;

#= IRQBalance
  services.irqbalance.enable = lib.mkDefault true;

#= Ananicy
  services.ananicy.enable = true;
  services.ananicy.package = pkgs.ananicy-cpp;
  services.ananicy.rulesProvider = pkgs.ananicy-rules-cachyos;

#=> Gamescope
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope;
    capSysNice = false;
  };

#=> Gamemode
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        amd_performance_level = "high";
      };
      cpu = {
        park_cores = "no";
        pin_cores = "yes";
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode Started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode Ended'";
      };
    };
  };

#=> Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

#= CORECTRL (Overclock).
  programs.corectrl.enable = true;

#=> Vulkan, Codecs and more... 
  hardware.cpu.amd.updateMicrocode = true;
  hardware.cpu.amd.sev.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true; 
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    libdrm
    pkgs-unstable.mesa.drivers
    vaapiVdpau
    vdpauinfo
    libvdpau
    libvdpau-va-gl
    rocmPackages.clr.icd
  ]; 
  hardware.opengl.extraPackages32 = with pkgs.driversi686Linux; [
    pkgs-unstable.pkgsi686Linux.mesa.drivers
    glxinfo
    vaapiVdpau
    vdpauinfo
    libvdpau-va-gl
  ];
  hardware.opengl.setLdLibraryPath = true;
  hardware.steam-hardware.enable = true;
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true; # Lemme update my CPU Microcode, alr?!

#= FWUPD
  services.fwupd.enable = true;
}
