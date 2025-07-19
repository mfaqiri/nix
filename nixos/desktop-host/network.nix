{...}: {
  networking = {
    networkmanager.enable = true; # Easiest to use and most distros use this by default.

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.

    firewall = {
      enable = true;
      allowedTCPPorts = [1337];
    };

    extraHosts = ''
      192.168.1.254	mzfaqiri.server
      192.168.1.254	gitlab.mzfaqiri.com
      192.168.1.254	mzfaqiri.tld
      192.168.1.254	pi.hole
    '';
  };
}
