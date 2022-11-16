extends MarginContainer

onready var window : Node = $WindowDialog

onready var fxaa : Node = $WindowDialog/EntireContents/SettingsContainer/Fxaa
onready var mouse_sens : Node = $WindowDialog/EntireContents/SettingsContainer/MouseSens

func _ready():
	#applies all stored settings found in the global settings, prob needs a better implementation by japan
	fxaa.pressed = settings.all_settings.get("fxaa")
	mouse_sens.value = settings.all_settings.get("mouse_sens")

func _process(delta):
	pass

func apply_settings():
	settings.all_settings["fxaa"] = fxaa.pressed
	settings.all_settings["mouse_sens"] = mouse_sens.value
	

func _on_Ok_pressed():
	apply_settings()
	settings.apply_video_settings()
	window.hide()


func _on_Apply_pressed():
	apply_settings()
	settings.apply_video_settings()


func _on_Cancel_pressed():
	window.hide()
