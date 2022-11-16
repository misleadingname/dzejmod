extends Node

var all_settings : Dictionary = {
	"max_players": 8,
	"fxaa": false,
	"mouse_sens": 7.0
}

func apply_video_settings():
	ProjectSettings.set_setting("rendering/quality/filters/use_fxaa", all_settings.get("fxaa"))
	
	#at the end
	#ProjectSettings.save()
