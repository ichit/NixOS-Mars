{ config, pkgs, pkgs-stable, lib, ... }:

{
#=> Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.consoleMode = "auto";

#=> Enable "Silent Boot"
  boot.loader.timeout = 10;
  boot.plymouth.enable = true;
  boot.plymouth = {
    theme = "lone";
    logo = "${pkgs.nixos-icons}/share/icons/hicolor/48x48/apps/nix-snowflake-white.png";
    themePackages = with pkgs; [
    # By default we would install all themes
      (adi1090x-plymouth-themes.override {
          selected_themes = [ "lone" ];
      })
    ];
  };
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;

#=> Kernel
  boot.kernelPackages = pkgs.linuxPackages_zen; # Latest Kernel
  boot.kernelParams = [
      "amd_iommu=on"
      "amd_pstate.shared_mem=1"
      "amdgpu.noretry=0"
      "amdgpu.dc=1"
      "amdgpu.dpm=1"
      "amdgpu.ppfeaturemask=1"
      "amdgpu.exp_hw_support=1"
      "amdgpu.sq_display=0"
      "amdgpu.si_support=1"
      "amdgpu.cik_support=1"
      "radeon.si_support=0"
      "radeon.cik_support=0"
      "nvme_core.default_ps_max_latency_us=2000"
      "nvme_core.io_timeout=500"
      "nvme_core.use_host_mem=1"
      "mitigations=auto"
      "rcu_nocbs=0-15"
      "transparent_hugepage=always"
      "mitigations=off"
      "vt.global_cursor_default=0"
      "usbcore.autosuspend=-1"
      "video4linux"
      "i8042.nopnp"
      "initcall_blacklist=acpi_cpufreq_init"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
  ];

  boot.kernelModules = [ "tcp_bbr" "amd-pstate-epp" ];
  boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642;  # A simple change Valve made on the Steam Deck...
      "vm.swappiness" = 50;
      "vm.vfs_cache_pressure" = 50;
      "vm.overcommitMemory" = 0;
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 10;
      "vm.dirty_background_bytes" = 134127728;
      "vm.dirty_writeback_centisecs" = 1500;
      "vm.compaction_proactiveness" = 0;
      "vm.watermark_boost_factor" = 1;
      "vm.zone_reclaim_mode" = 0;
      "vm.page_lock_unfairness" = 1;
      "vm.page-cluster" = 0;
      "vm.anon_min_ratio" = 15;
      "vm.clean_low_ratio" = 0;
      "vm.clean_min_ratio" = 15;
      "kernel.sysrq" = 1;
      "kernel.split_lock_mitigate" = 0;
      "kernel.nmi_watchdog" = 0;
      "kernel.unprivileged_userns_clone" = 1;
      "kernel.kptr_restrict" = 2;
      "kernel.kexec_load_disabled" = 1;
      "kernel.sched_rt_runtime_us" = 980000;
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      "net.core.somaxconn" = 8192;
      "net.core.netdev_max_backlog" = 16384;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_enc" = 1;
      "net.ipv4.tcp_fin_timeout" = 5;
      "net.ipv4.tcp_timestamps" = 0;
      "net.ipv4.tcp_slow_start_after_idle" = 0;
      "net.ipv4.tcp_rfc1337" = 1;
      "fs.inotify.max_user_watches" = 524288;
      "fs.file-max" = 2097152;
  };

  boot.supportedFilesystems = [ "ntfs" ];
  boot.initrd.kernelModules = [ "amdgpu" "amd_pmc" "zenpower" "nvme" "nvme_core" "acer_wmi" "acer_wireless" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "mq-deadline" "vmd" ];
  boot.blacklistedKernelModules = [ "k10temp" "iTCO_wdt" "sp5100_tco" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
  boot.extraModprobeConfig = "options kvm_amd nested=1"; # AMD

}
