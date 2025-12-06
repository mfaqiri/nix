{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mono
    protonup-ng
    heroic
    winetricks
    wineWowPackages.staging
    mangohud
  ];

  programs = {
    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
          ioprio = 0;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high"; # If you have AMD GPU
        };
      };
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extest.enable = true;

      protontricks.enable = true;

      # Extra compatibility tools
      extraCompatPackages = with pkgs; [
        proton-ge-bin # GE-Proton for better compatibility
      ];

      gamescopeSession = {
        enable = true;

        args = [
          "--adaptive-sync"
          "--hdr-enabled"
          "-W 3840"
          "-H 2160"
          "-w 3840"
          "-h 2160"
          "--force-grab-cursor"
          "--immediate-flips"
          "--prefer-output HDMI-A-1"
        ];
        env = {
          # Wayland-specific
          SDL_VIDEODRIVER = "wayland";
          GDK_BACKEND = "wayland";

          # AMD GPU optimizations (if applicable)
          # RADV_PERFTEST = "gpl,nggc";

          # NVIDIA optimizations (if applicable)
          # __GL_GSYNC_ALLOWED = "1";
          # __GL_VRR_ALLOWED = "1";
        };
      };

      package = pkgs.steam.override {
        extraEnv = {
          SDL_VIDEODRIVER = "wayland";
          GDK_BACKEND = "wayland";
          CLUTTER_BACKEND = "wayland";
        };
        extraLibraries = pkgs:
          with pkgs; [
            # Additional libraries for better compatibility
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ];
      };
    };
  };
}
