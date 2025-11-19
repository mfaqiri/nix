{pkgs, ...}: {
  home.packages = with pkgs; [
    flat-remix-gtk
    adwaita-icon-theme
    bibata-cursors
    gnome-themes-extra
    gtk-engine-murrine
    gsettings-desktop-schemas  # Required for gsettings to work
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Grey-Darkest";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita-dark";
  };

  home.sessionVariables = {
    GTK_THEME = "Flat-Remix-GTK-Grey-Darkest";
    GTK_USE_PORTAL = "1";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "16";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Flat-Remix-GTK-Grey-Darkest";
      icon-theme = "Adwaita";
      cursor-theme = "Bibata-Modern-Classic";
      cursor-size = 16;
      font-name = "Sans 11";
    };
    
    "org/gnome/desktop/background" = {
      picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
    };
  };

  # XDG portal is configured at system level, don't duplicate here
  # See: nixos/desktop-host/configuration.nix
  # xdg.portal already configured there

  # Create a systemd service that propagates theme env vars BEFORE graphical-session.target
  systemd.user.services.apply-gtk-theme = {
    Unit = {
      Description = "Propagate GTK theme environment variables early";
      Before = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = let
        systemd = pkgs.systemd;
        coreutils = pkgs.coreutils;
      in pkgs.writeShellScript "apply-gtk-theme" ''
        # Update systemd environment with theme variables
        # This ensures apps started via systemd see the theme
        ${systemd}/bin/dbus-update-activation-environment --systemd \
          GTK_THEME \
          XCURSOR_THEME \
          XCURSOR_SIZE \
          QT_QPA_PLATFORMTHEME
        
        # Small delay to ensure propagation
        ${coreutils}/bin/sleep 0.2
      '';
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
