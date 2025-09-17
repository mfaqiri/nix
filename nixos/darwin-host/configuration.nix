{
  inputs,
  pkgs,
  ...
}: let
  self = inputs.self;
in {
  imports = [
    ./tmux.nix
    ../../home-manager/nvim/nvim.nix
  ];
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    kitty
    kubectl
    kind
    minikube
    newman
    zoxide
    docker
    awscli2
    curl
  ];

  homebrew = {
    enable = true;

    brews = [
      "sqlcmd"
      "qemu"
      "k9s"
      "python@3.12"
      "pinentry-mac"
      "spotify_player"
      "gnu-sed"
      "pass"
      "colima"
      "helm"
      "pipx"
      "postgresql"
      "fzf"
      "zoxide"
      "msodbcsql18"
      "mssql-tools"
    ];

    casks = [
      "chromium"
      "librewolf"
      "virtualbox"
    ];
  };

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

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
  nixpkgs.config.allowUnfree = true;
}
