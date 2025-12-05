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

     # Create the waydroid bridge
    bridges.waydroid0.interfaces = [ ];
    
    # Configure the bridge interface
    interfaces.waydroid0 = {
      ipv4.addresses = [{
        address = "192.168.240.1";
        prefixLength = 24;
      }];
    };

    # NAT for waydroid
    nat = {
      enable = true;
      internalInterfaces = [ "waydroid0" ];
      # Replace with your external interface (e.g., "eth0", "wlan0", "enp0s3")
      externalInterface = "enp0s31f6"; # adjust this to your network interface
    };
  };
}
