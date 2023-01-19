extends WindowDialog

onready var joinButton = $joinButton
onready var ipInput = $VBoxContainer/ipInput
onready var nameInput = $VBoxContainer/nameInput

func ready():
	print(dzej.mpHost)

func _on_joinButton_pressed():
	if(ipInput.text != ""):
		dzej.msg("[join] Discarding current session...")
		dzej.mpDiscardSession()
		
		dzej.mpHost = ipInput.text
		dzej.mpNickname = nameInput.text
		dzej.mpRole = "client"

		dzej.sceneSwtich("res://dzej/scenes/engine/GameplayWorld.tscn")
