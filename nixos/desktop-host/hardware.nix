{ pkgs, ... }: {

    hardware.opentabletdriver.enable = true;

  systemd.services."config-mglru" = {
    enable = true;
    after = ["basic.target"];
    wantedBy = ["sysinit.target"];
    script = let inherit (pkgs) coreutils; in ''
    ${coreutils}/bin/echo Y > /sys/kernel/mm/lru_gen/enabled
    ${coreutils}/bin/echo 1000 > /sys/kernel/mm/lru_gen/min_ttl_ms
    '';
  };

  systemd.oomd = {
    enable = true;
    enableRootSlice = false;
    enableSystemSlice = false;
    enableUserSlices = false;
    extraConfig.DefaultMemoryPressureDurationSec = "4s";
  };

  systemd.user.slices."app".sliceConfig = {
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "16%";
  };
  systemd.slices."background".sliceConfig = {
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "8%";
  };
  systemd.user.slices."background".sliceConfig = {
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "8%";
  };



  services.system76-scheduler = {
    enable = true;
    useStockConfig = false;
    settings = {
      cfsProfiles.default.preempt = "voluntary";
      processScheduler = {
        pipewireBoost.enable = false;
        foregroundBoost.enable = false;
      };
    };
    assignments = {
      batch = {
        class = "batch";
	matchers = [
          "bazel"
	  "clangd"
	  "rust-analyzer"
	];
      };
    };

    exceptions = [
      "include descends=\"schedtool\""
      "include descends=\"nice\""
      "include descends=\"chrt\""
      "include descends=\"taskset\""
      "include descends=\"ionice\""

      "schedtool"
      "nice"
      "chrt"
      "ionice"

      "dbus"
      "dbus-broker"
      "rtkit-daemon"
      "taskset"
      "systemd"
    ];
  };

}
