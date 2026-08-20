{
  config,
  pkgs,
  lib,
  ...
}:
let
  mainIface = "enp8s0"; # <-- change to your real interface (ip a)
  vpnNs = "protonvpn";

  # DNS for inside the namespace, declared via environment.etc below
  vpnDns = "10.2.0.1"; # check your ProtonVPN WireGuard config's DNS line

  # Point directly at your home directory config
  wgConfPath = "/home/mfaqiri/.config/protonvpn/protonvpn.conf";

  netnsUp = pkgs.writeShellScript "protonvpn-netns-up" ''
    set -e

    # Clean up any leftovers from a previous failed run
    ip netns delete ${vpnNs} 2>/dev/null || true
    ip link delete veth-host 2>/dev/null || true

    ip netns add ${vpnNs}
    ip link add veth-host type veth peer name veth-ns
    ip link set veth-ns netns ${vpnNs}

    ip addr add 10.200.200.1/24 dev veth-host
    ip link set veth-host up
    ip netns exec ${vpnNs} ip addr add 10.200.200.2/24 dev veth-ns
    ip netns exec ${vpnNs} ip link set veth-ns up
    ip netns exec ${vpnNs} ip link set lo up

    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING -s 10.200.200.0/24 -o ${mainIface} -j MASQUERADE

    ip netns exec ${vpnNs} ip route add default via 10.200.200.1
    ip netns exec ${vpnNs} wg-quick up ${wgConfPath}
  '';

  netnsDown = pkgs.writeShellScript "protonvpn-netns-down" ''
    ip netns exec ${vpnNs} wg-quick down ${wgConfPath} || true
    ip netns delete ${vpnNs} || true
    ip link delete veth-host || true
  '';

  netnsExecScript = pkgs.writeShellScript "protonvpn-netns-exec" ''
    exec ${pkgs.iproute2}/bin/ip netns exec ${vpnNs} "$@"
  '';
  librewolfVpn = pkgs.writeShellScriptBin "librewolf-vpn" ''
    exec /run/wrappers/bin/protonvpn-netns-exec \
      ${pkgs.librewolf}/bin/librewolf -P vpn-profile -no-remote "$@"
  '';

  transmissionVpn = pkgs.writeShellScriptBin "transmission-vpn" ''
    exec /run/wrappers/bin/protonvpn-netns-exec \
      ${pkgs.transmission_4-gtk}/bin/transmission-gtk \
      --config-dir "$HOME/.config/transmission-vpn" "$@"
  '';

  librewolfVpnDesktop = pkgs.makeDesktopItem {
    name = "librewolf-vpn";
    desktopName = "LibreWolf (VPN)";
    exec = "${librewolfVpn}/bin/librewolf-vpn %u";
    icon = "librewolf";
    categories = [
      "Network"
      "WebBrowser"
    ];
  };

  transmissionVpnDesktop = pkgs.makeDesktopItem {
    name = "transmission-vpn";
    desktopName = "Transmission (VPN)";
    exec = "${transmissionVpn}/bin/transmission-vpn %U";
    icon = "transmission";
    categories = [
      "Network"
      "FileTransfer"
    ];
  };

  torBrowserVpn = pkgs.writeShellScriptBin "tor-browser-vpn" ''
    exec /run/wrappers/bin/protonvpn-netns-exec \
      ${pkgs.tor-browser}/bin/tor-browser "$@"
  '';

  torBrowserVpnDesktop = pkgs.makeDesktopItem {
    name = "tor-browser-vpn";
    desktopName = "Tor Browser (VPN)";
    exec = "${torBrowserVpn}/bin/tor-browser-vpn %u";
    icon = "torbrowser";
    categories = [
      "Network"
      "WebBrowser"
    ];
  };

in
{
  environment.systemPackages = [
    pkgs.iproute2
    pkgs.iptables
    pkgs.wireguard-tools
    transmissionVpn
    transmissionVpnDesktop
    librewolfVpn
    librewolfVpnDesktop
    torBrowserVpn
    torBrowserVpnDesktop
  ];

  # Declarative resolv.conf for the namespace — no manual /etc edits
  environment.etc."netns/${vpnNs}/resolv.conf".text = ''
    nameserver ${vpnDns}
  '';

  systemd.services.protonvpn-netns = {
    description = "ProtonVPN isolated network namespace";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.iproute2
      pkgs.iptables
      pkgs.wireguard-tools
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${netnsUp}";
      ExecStop = "${netnsDown}";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  security = {
    wrappers.protonvpn-netns-exec = {
      source = "${netnsExecScript}";
      capabilities = "cap_sys_admin+ep";
      owner = "root";
      group = "root";
      permissions = "u+rx,g+x,o+x";
    };
  };

  networking = {
    networkmanager.enable = true; # Easiest to use and most distros use this by default.

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.

    firewall = {
      enable = true;
      allowedTCPPorts = [
        47984
        47989
        47990
        48010
      ];
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
