extends VBoxContainer

onready var hoverPlayer = $buttonHover
onready var clickPlayer = $buttonClick

func _ready():
	dzej.paused = true

func buttonHover():
	hoverPlayer.play()

func buttonClick():
	clickPlayer.play()

func _on_exitButton_pressed():
	buttonClick()
	
	get_tree().quit()

# MAIN MENU

func _on_newgameButton_pressed():
	buttonClick()
	
	dzej.switchScene("res://scenes/defaultmap.tscn")

# IN GAME

func _on_resumeButton_pressed():
	buttonClick()

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	dzej.paused = false

	dzej.removeScene(self.get_parent())
