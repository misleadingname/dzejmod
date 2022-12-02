extends Control

onready var statusLabel = $Label

func _ready():
	if(dzej.hello() == "hello dzejmod"):
		statusLabel.text = "awaiting map list"
		if(dzej.sceneGetList() != null):
			statusLabel.text = "loading addons"
			if(dzej.addonRequestList() != null):
				statusLabel.text = "done!"

				print(dzej.sceneCurrent)
				dzej.sceneSwtich("res://scenes/engine/backgroundmainmenu.tscn", false)
				print(dzej.sceneCurrent)
			else:
				statusLabel.text = "error with loading addons"
		else:
			statusLabel.text = "error no maps"
	else:
		statusLabel.text = "error with dzejscript."
