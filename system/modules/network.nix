{ config, pkgs, lib, ... }:

{
  #==> Network and Security <==#

  networking = {
    networkmanager.enable = true;
    hostName = "razor-crest"; # Define your hostname.
    firewall = {
      enable = true;
      allowedTCPPorts = [
        53
        80
        443
        631
        3478
        3479
        8080
      ];
    };
    enableIPv6 = false;
  };

  services.resolved.enable = false;

# Fail2Ban
  services.fail2ban = {
    enable = true;
    ignoreIP = [
      "9.9.9.11"
      "149.112.112.11"
      "2620:fe::11"
      "2620:fe::fe:11"
    ];
    maxretry = 5;
    bantime = "12h";
  };
}
