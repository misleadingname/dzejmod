extends MarginContainer

onready var window : Node = $WindowDialog

onready var fxaa : Node = $WindowDialog/EntireContents/SettingsContainer/Fxaa
onready var mouse_sens : Node = $WindowDialog/EntireContents/SettingsContainer/MouseSens

func _ready():
	#applies all stored settings found in the global settings, prob needs a better implementation by japan
	#hi, japan here, i'm gonna do this later but now i'm gonna fix your other code lmfao

	fxaa.pressed = settings.all_settings.get("fxaa")
	mouse_sens.value = settings.all_settings.get("mouse_sens") * 46.666
	#ok wtf is this, why tHIS ISN'T A FUNCTION

	#rewriting this by tomorrow.

func apply_settings():
	# dark you stupid, what's 9+10? 21 you say? TOO BAD! 
	# settings.all_settings["fxaa"] = fxaa.pressed
	# settings.all_settings["mouse_sens"] = mouse_sens.value

	var settingsKeys : Array = settings.all_settings.keys()

	dzej.msg("settingsKeys: " + str(settingsKeys[1]))

	# for i in settings.all_settings:
	# 	dzej.msg(str("[dzej-settings] ", settingsKeys[i]))
	

func _on_Ok_pressed():
	apply_settings()
	settings.apply_video_settings()
	window.hide()


func _on_Apply_pressed():
	apply_settings()
	settings.apply_video_settings()


func _on_Cancel_pressed():
	window.hide()
