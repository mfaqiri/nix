{pkgs, ...}:
{

  security = {
    polkit.enable = true;
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
    rtkit.enable = true;
    pam = {
    yubico = {
                enable = false;
                debug = false;
                mode = "client";
                id = "27564256";
            };
    loginLimits = [{
      domain = "@audio";
      type = "-";
      item = "rtprio";
      value = "90";
    }
    {
      domain = "*";
      type = "-";
      item = "memlock";
      value = "infinity";
    }];
    };
    };

    # Grant CAP_SYS_NICE to gamescope for better performance
  security.wrappers.gamescope = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_nice+pie";
    source = "${pkgs.gamescope}/bin/gamescope";
  };

  security.wrappers.gamemode = {
    owner = "root";
    group = "root";
    source = "${pkgs.gamemode}/bin/gamemoderun";
    capabilities = "cap_sys_nice+ep";
  };
}
