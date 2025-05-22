{
  lib,
  config,
  ...
}: {
  imports = [
    ./audio.nix
    ./disks.nix
    ./games.nix
    ./hardware.nix
    ./network.nix
    ./security.nix
    ./video.nix
  ];
}
