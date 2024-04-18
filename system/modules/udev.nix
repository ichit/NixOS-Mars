{ config, pkgs, lib, ... }:

{
 #= UDEV
  services.udev.enable = true;
  services.udev.extraRules = ''
      DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"

      # HDD
      ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

      # SSD
      ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"

      # NVMe SSD
      ACTION=="add|change",KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"

      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"
  '';
}
