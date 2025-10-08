{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mono
    protonup
    heroic
    winetricks
    wineWowPackages.staging
    mangohud
  ];

  programs = {
    gamemode.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession = {
        enable = true;

        args = [
          "--adaptive-sync"
          "--hdr-enabled"
          "-W 3840"
          "-H 2160"
          "-w 3840"
          "-h 2160"
          "--prefer-output HDMI-A-1"
        ];
      };
    };
  };
}
