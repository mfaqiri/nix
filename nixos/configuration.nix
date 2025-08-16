#Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./desktop-host/desktopbundle.nix
    ./nixosModules/modulebundle.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_6_12;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelModules = ["kvm-amd"];

  # Set your time zone.
  time.timeZone = "America/New_York";

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    font-awesome
    powerline-fonts
    powerline-symbols
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  security.polkit.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      mfaqiri = {
        isNormalUser = true;
        extraGroups = ["wheel" "power" "storage" "networkmanager" "sudo" "audio" "video" "tss" "libvirtd" "rtkit" "docker" "dialout" "input"]; # Enable ‘sudo’ for the user.
      };
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {
      "mfaqiri" = import ../home-manager/home.nix;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    brave
    looking-glass-client
    virtiofsd
    usbutils
    cmake-language-server
    alsa-utils
    libreoffice
    hunspell
    wget
    clinfo
    git
    adwaita-icon-theme
    tor-browser-bundle-bin
    remmina
  ];

  services = {
    pcscd.enable = true;
    udev.packages = [pkgs.yubikey-personalization];
    xserver.displayManager.gdm.enable = true;
    displayManager = {
      sessionPackages = [
        (
          (
            pkgs.writeTextDir "share/wayland-sessions/sway.desktop" ''              [Desktop Entry]
                                  Name=sway
                                  Comment=Sway run from a login shell
                                  Exec=${pkgs.dbus}/bin/dbus-run-session -- bash -l -c sway
                                  Type=Application''
          )
          .overrideAttrs (oldAttrs: {
            passthru = {
              providedSessions = ["sway"];
            };
          })
        )
        (
          (
            pkgs.writeTextDir "share/wayland-sessions/hyprland.desktop" ''              [Desktop Entry]
                                  Name=hyprland
                                  Comment=Hyprland run from a login shell
                                  Exec=${pkgs.dbus}/bin/dbus-run-session -- bash -l -c hyprland
                                  Type=Application''
          )
          .overrideAttrs (oldAttrs: {
            passthru = {
              providedSessions = ["hyprland"];
            };
          })
        )
      ];
    };

    desktopManager.plasma6.enable = true;

    tor = {
      settings = {
        UseBridges = true;
        ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/lyrebird";
        Bridge = "obfs4 IP:ORPort [fingerprint]";
      };
    };

    flatpak.enable = true;

    dbus.enable = true;

    openssh.enable = true;

    ntp.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.

  programs = {
    zsh.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [xdg-desktop-portal-wlr xdg-desktop-portal-hyprland xdg-desktop-portal-gtk];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
