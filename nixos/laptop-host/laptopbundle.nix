{ lib, config, ... }: {

    options.laptopbundle.enable = lib.mkEnableOption "enables laptop bundle";
    
    imports = [
        ./disks.nix
    ];

    config = lib.mkIf config.laptopbundle.enable {

};
}
