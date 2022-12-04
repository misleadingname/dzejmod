extends Control

onready var statusLabel = $Label


func _ready():
	statusLabel.text = "Godot is ready!"
	yield(get_tree().create_timer(0.5), "timeout")
	statusLabel.text = "Waiting for dzejscript."
	yield(get_tree().create_timer(1), "timeout")
	statusLabel.text = "dzej.hello() returned: " + dzej.hello()
	
	if(dzej.hello() != "hello dzejmod"):
		statusLabel.text += " (FAIL)"
		return false
	statusLabel.text += " (OK)"

	yield(get_tree().create_timer(0.25), "timeout")
	statusLabel.text = "Requesting addon list."
	
	yield(get_tree().create_timer(0.25), "timeout")
	if(dzej.addonRequestList() == null || dzej.addonRequestList().size() <= 0):
		statusLabel.text += " (FAIL)"
		return false
	statusLabel.text += " (OK)"

	yield(get_tree().create_timer(0.25), "timeout")
	for i in range(dzej.addonRequestList().size()):
		statusLabel.text = "Requesting addon info for " + dzej.addonRequestList()[i] + "."
		yield(get_tree(), "idle_frame")
		if(dzej.addonGetInfo(dzej.addonRequestList()[i]) == null):
			statusLabel.text += " (FAIL)"
			return false
		statusLabel.text += " (OK)"

	dzej.sceneSwtich("res://scenes/engine/backgroundmainmenu.tscn", true)
	dzej.mouseLock(false)
