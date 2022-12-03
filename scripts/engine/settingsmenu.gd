extends MarginContainer

onready var window : Node = $SettingsDialog

onready var fxaa : Node = $SettingsDialog/EntireContents/SettingsContainer/Fxaa
onready var mouse_sens : Node = $SettingsDialog/EntireContents/SettingsContainer/HBoxContainer2/MouseSens
onready var mouse_sens_value : Node = $SettingsDialog/EntireContents/SettingsContainer/HBoxContainer2/LineEdit

func _ready():
	#applies all stored settings found in the global settings, prob needs a better implementation by japan
	#hi, japan here, i'm gonna do this later but now i'm gonna fix your other code lmfao

	fxaa.pressed = dzej_settings.all_settings.get("fxaa")
	mouse_sens.value = dzej_settings.all_settings.get("mouse_sens")
	mouse_sens_value.set_text(str(dzej_settings.all_settings.get("mouse_sens")))
	#ok wtf is this, why tHIS ISN'T A FUNCTION

	#rewriting this by tomorrow.

#func _process(delta):
#	mouse_sens_value.set_text(str(mouse_sens.value))

func apply_settings():
	# dark you stupid, what's 9+10? 21 you say? TOO BAD! 
	# settings.all_settings["fxaa"] = fxaa.pressed
	# settings.all_settings["mouse_sens"] = mouse_sens.value

	var settingsKeys : Array = dzej_settings.all_settings.keys()
	
	#temporarily applies mouse sensitivity
	dzej_settings.all_settings["mouse_sens"] = mouse_sens.value
	dzej_settings.all_settings["mouse_sens"] = float(mouse_sens_value.get_text())
	
	dzej.msg("settingsKeys: " + str(settingsKeys[1]))

	# for i in settings.all_settings:
	# 	dzej.msg(str("[dzej-settings] ", settingsKeys[i]))
	

func _on_Ok_pressed():
	apply_settings()
	dzej_settings.apply_video_settings()
	window.hide()


func _on_Apply_pressed():
	apply_settings()
	dzej_settings.apply_video_settings()


func _on_Cancel_pressed():
	window.hide()


func _on_MouseSens_value_changed(value):
	mouse_sens_value.set_text(str(value))


func _on_LineEdit_text_entered(new_text):
	mouse_sens.value = float(mouse_sens_value.get_text())


func _on_VBoxContainer_newGame():
	pass # Replace with function body.
