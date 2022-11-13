extends VBoxContainer

onready var hoverPlayer = $buttonHover
onready var clickPlayer = $buttonClick

func buttonHover():
	hoverPlayer.play()

func buttonClick():
	clickPlayer.play()

func _on_newgameButton_pressed():
	buttonClick()
	
	get_tree().change_scene("res://scenes/defaultmap.tscn")
	
	get_tree().paused = false

func _on_exitButton_pressed():
	buttonClick()
	
	get_tree().quit()
