extends WindowDialog

onready var joinButton = $joinButton
onready var ipInput = $VBoxContainer/ipInput

func ready():
	print(dzej.mpHost)

func _on_joinButton_pressed():
	if(ipInput.text != ""):
		dzej.msg("[join] Discarding current session...")
		dzej.mpDiscardSession()
		
		dzej.mpHost = ipInput.text

		dzej.mpRole = "client"

		dzej.sceneSwtich("res://scenes/engine/GameplayWorld.tscn")
