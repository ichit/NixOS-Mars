{ config, pkgs, lib, ... }:

{
 #= Pipewire
  sound.enable = true;
  security.rtkit.enable = true; # Real-Time Priority to Processes.
  services.pipewire = {
    enable = true;
    audio.enable = true; # Use as primary sound server
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    package = pkgs.pipewire;
  };
  hardware.pulseaudio.enable = false;
}
