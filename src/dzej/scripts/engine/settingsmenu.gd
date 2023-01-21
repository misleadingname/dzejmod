extends MarginContainer

onready var window : Node = $SettingsDialog

onready var fxaa : Node = $SettingsDialog/EntireContents/SettingsContainer/Fxaa
onready var mouse_sens : Node = $SettingsDialog/EntireContents/SettingsContainer/HBoxContainer2/MouseSens
onready var mouse_sens_value : Node = $SettingsDialog/EntireContents/SettingsContainer/HBoxContainer2/LineEdit

func apply_settings():

	var settingsKeys : Array = dzej_settings.all_settings.keys()
	
	#temporarily applies mouse sensitivity
	dzej_settings.all_settings["mouse_sens"] = mouse_sens.value
	
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


func _on_LineEdit_text_entered():
	mouse_sens.value = float(mouse_sens_value.get_text())


func _on_SettingsDialog_about_to_show():
	mouse_sens.value = dzej_settings.all_settings["mouse_sens"]
