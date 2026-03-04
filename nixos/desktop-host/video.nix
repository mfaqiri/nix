{ pkgs, ... }: {


  environment.systemPackages = with pkgs; [
	v4l-utils
	(pkgs.wrapOBS {
		plugins = with pkgs.obs-studio-plugins; [
			obs-vaapi
			obs-gstreamer
			obs-vkcapture
		];
	})
    ];
}
