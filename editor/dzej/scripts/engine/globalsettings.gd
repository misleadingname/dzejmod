extends Node

var all_settings : Dictionary = {
	"max_players": 8,
	"fxaa": false,
	"mouse_sens": 0.25
}

func _input(event):
	if(event.is_action_pressed("engine_fullscreen")):
		OS.window_fullscreen = !OS.window_fullscreen

func apply_video_settings():
	ProjectSettings.set_setting("rendering/quality/filters/use_fxaa", all_settings.get("fxaa"))
	
	#at the end
	#ProjectSettings.save()
