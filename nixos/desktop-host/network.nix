{...}: {
  networking = {
    networkmanager.enable = true; # Easiest to use and most distros use this by default.

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.

    firewall = {
      enable = true;
      allowedTCPPorts = [47984 47989 47990 48010];
      allowedUDPPortRanges = [
        {
          from = 47998;
          to = 48000;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
    };

    nftables.enable = true;

    extraHosts = ''
      192.168.1.254	mzfaqiri.server
      192.168.1.254	gitlab.mzfaqiri.com
      192.168.1.254	mzfaqiri.tld
      192.168.1.254	pi.hole
    '';

  };
}
