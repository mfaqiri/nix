{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nvf.homeManagerModules.default
    ./nvim/nvim.nix
    ./hyprland.nix
    ./theme.nix
    ./waybar.nix
    ./kitty.nix
  ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  nixpkgs.config.allowUnfree = true;
  home.username = "mfaqiri";
  home.homeDirectory = "/home/mfaqiri";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  fonts = {
    fontconfig = {
      enable = true;
    };
  };
  home.packages = with pkgs; [
    bash-language-server
    parsec-bin
    clang-tools
    arduino
    arduino-language-server
    arduino-cli
    p7zip
    fd
    wl-clipboard
    networkmanagerapplet
    hyprshot
    parsec-bin
    prusa-slicer
    nautilus
    openvpn
    docker-compose
    postman
    kubectl
    minikube
    osu-lazer
    revolt-desktop
    thunderbird
    r2modman
    freerdp
    htop
    krita
    ryubing
    networkmanager-openvpn
    slack
    pureref
    inkscape
    gimp
    ardour
    (pass-wayland.withExtensions
      (exts: [exts.pass-otp]))
    vlc
    godot_4
    gdtoolkit_4
    grim
    slurp
    (librewolf.override {nativeMessagingHosts = [passff-host];})
    makemkv
    parsec-bin
    transmission_4-gtk
    discord
    #rpcs3
    ludusavi
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs = {
    home-manager.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch --flake /home/mfaqiri/.config/nix#desktop";
      };

      zplug = {
        enable = true;
        plugins = [
          {name = "zsh-users/zsh-autosuggestions";}
          {
            name = "ergenekonyigit/lambda-gitster";
            tags = ["as:theme"];
          }
          {name = "chisui/zsh-nix-shell";}
        ];
      };

      history.size = 10000;
      history.ignoreAllDups = true;
      history.path = "$HOME/.zsh_history";

      initExtra =
        /*
        bash
        */
        ''
          # Fix delete key
          bindkey "^[[3~" delete-char
        '';
    };
    yazi = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        opener = {
          video = [
            {
              run = ''vlc "$@"'';
              desc = "VLC Media Player";
              for = "unix";
            }
            {
              run = ''vlc "$@" &'';
              desc = "VLC (background)";
              for = "unix";
            }
          ];
        };

        open = {
          rules = [
            {
              name = "*/";
              use = ["edit" "open" "reveal"];
            }
            {
              mime = "video/*";
              use = ["video" "reveal"];
            }
            {
              mime = "video/mp4";
              use = ["video" "reveal"];
            }
            {
              mime = "video/mpeg";
              use = ["video" "reveal"];
            }
            {
              mime = "video/x-msvideo";
              use = ["video" "reveal"];
            }
            {
              mime = "video/quicktime";
              use = ["video" "reveal"];
            }
            {
              mime = "video/x-matroska";
              use = ["video" "reveal"];
            }
            {
              mime = "video/webm";
              use = ["video" "reveal"];
            }
            {
              mime = "video/x-flv";
              use = ["video" "reveal"];
            }
            {
              mime = "video/3gpp";
              use = ["video" "reveal"];
            }
            {
              mime = "video/x-ms-wmv";
              use = ["video" "reveal"];
            }
          ];
        };
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd cd"];
    };
  };

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mfaqiri/etc/profile.d/hm-session-vars.sh
  #

  # Let Home Manager install and manage itself.
  # home.nix
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/parsec" = "parsecd.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/parsec" = "parsecd.desktop";

      # Video formats
      "video/mp4" = "vlc.desktop";
      "video/mpeg" = "vlc.desktop";
      "video/x-msvideo" = "vlc.desktop";
      "video/quicktime" = "vlc.desktop";
      "video/x-matroska" = "vlc.desktop";
      "video/webm" = "vlc.desktop";
      "video/x-flv" = "vlc.desktop";
      "video/3gpp" = "vlc.desktop";
      "video/x-ms-wmv" = "vlc.desktop";
      "video/ogg" = "vlc.desktop";

      # Audio formats (optional)
      "audio/mpeg" = "vlc.desktop";
      "audio/mp4" = "vlc.desktop";
      "audio/x-wav" = "vlc.desktop";
      "audio/ogg" = "vlc.desktop";
      "audio/x-flac" = "vlc.desktop";
    };
  };
}
