{ ... }: {

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  networking.extraHosts = ''
  192.168.1.185	mzfaqiri.server
  192.168.1.185	gitlab.mzfaqiri.com
  192.168.1.185	mzfaqiri.tld
  192.168.1.185	pi.hole
  '';
}
