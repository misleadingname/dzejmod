extends Control

onready var statusLabel = $Label

func _ready():
	statusLabel.text = "Godot is ready!"
	yield(get_tree().create_timer(0.5), "timeout")
	statusLabel.text = "Waiting for dzejscript."
	yield(get_tree().create_timer(1), "timeout")
	statusLabel.text = "dzej.hello() returned: " + dzej.hello()

	if dzej.hello() != "hello dzejmod":
		statusLabel.text += " (FAIL)"
		return false
	statusLabel.text += " (OK)"

	yield(get_tree().create_timer(0.25), "timeout")
	statusLabel.text = "Requesting addon list."
	var addonList = dzej.addonRequestList()

	yield(get_tree().create_timer(0.25), "timeout")
	if addonList == null || addonList.size() <= 0:
		statusLabel.text += " (FAIL)"
		return false
	statusLabel.text += " (OK)"

	yield(get_tree().create_timer(0.25), "timeout")
	for i in range(addonList.size()):
		statusLabel.text = "Requesting addon info for \"" + addonList[i] + "\"..."
		yield(get_tree(), "idle_frame")
		var addoninfo = dzej.addonGetInfo(addonList[i])
		if addoninfo == null:
			statusLabel.text += " (FAIL)"
			return false
		if addoninfo.tag == "engine":
			statusLabel.text += " (Loading...)"
			yield(get_tree(), "idle_frame")
			var engineModule = Node.new()
			engineModule.name = addoninfo.filename
			var engineModuleScript = dzej.resLoadToMem(dzej.addonGetPath(addoninfo.filename) + "/scripts/init.gd")
			add_child(engineModule)
			engineModule.set_script(engineModuleScript)
			yield(get_tree(), "idle_frame")
		statusLabel.text += " (OK)"
		yield(get_tree(), "idle_frame")

	dzej.sceneSwtich("res://scenes/engine/backgroundmainmenu.tscn", true)
	dzej.lpMouseLock(false)
