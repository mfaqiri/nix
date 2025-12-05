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
    chromium
    moonlight-qt
    neovim-remote
    bash-language-server
    parsec-bin
    clang-tools
    arduino
    arduino-language-server
    arduino-cli
    git-lfs
    unzip
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
    rpcs3
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
    ".config/sunshine/sunshine.conf".text = ''
      # VAAPI encoding with correct device
      encoder = vaapi
      adapter_name = /dev/dri/renderD128

      # Use h264 (you have it, more compatible)
      hevc_mode = 0

      # Video settings
      fps = 60
      bitrate = 20000

      # Audio
      audio_sink = auto

      # Display selection
      output_name = auto

      # Disable tray
      tray = false

      # Logging
      min_log_level = info

      # Controller support
      gamepad = enabled
    '';
    # Godot external editor script
    ".local/bin/godot-nvr.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        set -e

        file_info="$1"

        if ! command -v nvr &> /dev/null; then
            echo "[$(date)] ERROR: nvr not found" >> /tmp/godot-nvr.log
            exit 1
        fi

        # Find the best nvim server to use
        # Priority:
        # 1. Dedicated Godot server if it exists
        # 2. Any visible kitty nvim instance
        # 3. Create new kitty window with nvim

        SERVER=""

        # Check for dedicated Godot nvim server
        if [ -S "/tmp/nvim-godot" ]; then
            SERVER="/tmp/nvim-godot"
        else
            # Find any running nvim server that's NOT in current terminal
            # (avoid the terminal running Godot)
            SERVERS=$(nvr --serverlist 2>/dev/null || echo "")

            if [ -n "$SERVERS" ]; then
                # Use first available server
                SERVER=$(echo "$SERVERS" | head -1)
            fi
        fi

        # Parse file info
        if [[ "$file_info" =~ ^(.+):([0-9]+):([0-9]+)$ ]]; then
            file="''${BASH_REMATCH[1]}"
            line="''${BASH_REMATCH[2]}"
            col="''${BASH_REMATCH[3]}"
            CURSOR_CMD="+call cursor($line,$col)"
        elif [[ "$file_info" =~ ^(.+):([0-9]+)$ ]]; then
            file="''${BASH_REMATCH[1]}"
            line="''${BASH_REMATCH[2]}"
            CURSOR_CMD="+$line"
        else
            file="$file_info"
            CURSOR_CMD=""
        fi

        # Open file
        if [ -n "$SERVER" ]; then
            # Use existing nvim instance
            if [ -n "$CURSOR_CMD" ]; then
                nvr --servername "$SERVER" --remote "$CURSOR_CMD" "$file"
            else
                nvr --servername "$SERVER" --remote "$file"
            fi

            # Try to focus the window
            sleep 0.1
            hyprctl dispatch focuswindow "title:.*nvim.*" 2>/dev/null || \
            hyprctl dispatch focuswindow "class:kitty" 2>/dev/null || true
        else
            # No nvim running, open in new kitty window
            if [ -n "$CURSOR_CMD" ]; then
                kitty --title "Godot Nvim" nvim --listen /tmp/nvim-godot "$CURSOR_CMD" "$file" &
            else
                kitty --title "Godot Nvim" nvim --listen /tmp/nvim-godot "$file" &
            fi
        fi
      '';
    };
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

      initContent =
        /*
        bash
        */
        ''
          # Fix delete key
          bindkey "^[[3~" delete-char
          # Source any other private zsh config
          if [[ -f ~/.zshrc.private ]]; then
             source ~/.zshrc.private
          fi

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
