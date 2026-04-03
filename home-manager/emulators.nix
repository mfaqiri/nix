{pkgs, ...}: {

  
  programs.retroarch = {
  enable = true;

  cores = {
    fceumm.enable = true;
    swanstation.enable = true;
    snes9x.enable = true;
    pcsx2.enable = true;
    parallel-n64.enable = true;
    gambatte.enable = true;
    mgba.enable = true;
    dolphin.enable = true;
    melonds.enable = true;
    citra.enable = true;
    bsnes.enable = true;
  };

  };

}
