{ pkgs, ... }: {


  environment.systemPackages = with pkgs; [
	v4l-utils
	(pkgs.wrapOBS {
		plugins = with pkgs.obs-studio-plugins; [
			wlrobs
			obs-tuna
			obs-vaapi
			obs-gstreamer
			obs-vkcapture
			obs-multi-rtmp
            input-overlay
		];
	})
    ];
}
