extends VBoxContainer

onready var hoverPlayer = $buttonHover
onready var clickPlayer = $buttonClick
onready var settings = get_parent().get_node("Settings")

func buttonHover():
	hoverPlayer.play()

func buttonClick():
	clickPlayer.play()

# SHARED

func _on_exitButton_pressed():
	buttonClick()
	
	get_tree().quit()

# MAIN MENU

func _on_newgameButton_pressed():
	buttonClick()
	
	dzej.switchScene("res://scenes/engine/GameplayWorld.tscn")

# IN GAME

func _on_resumeButton_pressed():
	buttonClick()
	
	self.get_parent().visible = false
	dzej.lockMouse(true)

func _on_disconnectButton_pressed():
	buttonClick()
	
	dzej.playercount = 0 # Probably not the best way to do this

	dzej.switchScene("res://scenes/engine/backgroundmainmenu.tscn", true)

# MENU TOGGLE

func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		if(self.get_parent().visible and get_parent().name != "mainmenu"):
			print(get_parent().name)
			self.get_parent().visible = false
			dzej.lockMouse(true)
		else:
			self.get_parent().visible = true
			dzej.lockMouse(false)


func _on_optionsButton_pressed():
	buttonClick()
	
	settings.get_node("WindowDialog").popup()
	
