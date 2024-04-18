{ config, pkgs, pkgs-stable, lib, ... }:

{
 #= Firefox
  programs.firefox = {                  
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "widget.use-xdg-desktop-portal.mime-handler" = 1;
      "browser.download.animateNotifications" = false;
      "security.dialog_enable_delay" = false;
      "network.prefetch-next" = false;
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;
      "browser.ping-centre.telemetry" = false;
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "toolkit.telemetry.hybridContent.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.reportingpolicy.firstRun" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "privacy.trackingprotection.fingerprinting.enable" = true;
      "privacy.trackingprotection.cryptomining.enable" = true;
      "privacy.trackingprotection.enable" = true;
      "browser.send_pings" = false;
      "browser.sessionstore.privacy_level" = 2;
      "browser.safebrowsing.downloads.remote.enabled" = false;
      "browser.pocket.enabled" = false;
      "loop.enabled" = false;
      "fission.autostart" = true;
      "reader.parse-on-load.enabled" = false;
      "reader.parse-on-load.force-enabled" = false;
      "beacon.enabled" = false;
      "webgl.disabled" = false;
      "gfx.webrender.all" = true;
      "dom.event.clipboardevents.enabled" = false;
      "media.navigator.enabled" = false;
      "network.cookie.cookieBehavior" = 1;
    };
    languagePacks = [ "es-MX" ];
    package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {});
  };
}
