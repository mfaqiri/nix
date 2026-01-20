{
  inputs,
  pkgs,
  ...
}: let
  self = inputs.self;
in {
  nixpkgs.overlays = [
  (final: prev: {
    python313 = prev.python313.override {
      packageOverrides = pyfinal: pyprev: {
        setproctitle = pyprev.setproctitle.overridePythonAttrs (old: {
          doCheck = false;
        });
      };
    };
  })
];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    browserpass
    kubectl
    kind
    minikube
    newman
    docker
    awscli2
    curl
  ];

  homebrew = {
    enable = true;

    brews = [
      "qemu"
      "k9s"
      "jq"
      "python@3.13"
      "python@3.12"
      "python@3.11"
      "pinentry-mac"
      "spotify_player"
      "gnu-sed"
      "pass"
      "helm"
      "pipx"
      "postgresql"
      "fzf"
      "zoxide"
      "msodbcsql18"
      "mssql-tools"
      "direnv"
      "actionlint"
      {
        name = "colima";
        start_service = true;
      }
      "awscli-local"
    ];

    casks = [
      "librewolf"
      "spotify"
    ];
  };
  fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      font-awesome
      powerline-fonts
      powerline-symbols
      fira-code
      fira-code-symbols
      liberation_ttf
    ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  system.primaryUser = "mfaqiri";
  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
