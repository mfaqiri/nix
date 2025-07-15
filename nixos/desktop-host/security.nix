{...}:
{
  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
    rtkit.enable = true;
    pam = {
    yubico = {
                enable = true;
                debug = true;
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
}
