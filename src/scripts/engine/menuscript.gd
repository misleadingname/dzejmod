extends VBoxContainer

onready var hoverPlayer = $buttonHover
onready var clickPlayer = $buttonClick
onready var settings = get_parent().get_node("Settings")
onready var addons = get_parent().get_node("Addons")

signal newGame

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
	emit_signal("newGame")
	# dzej.sceneSwtich("res://scenes/engine/GameplayWorld.tscn") # no

# IN GAME

func _on_resumeButton_pressed():
	buttonClick()
	
	self.get_parent().visible = false
	dzej.lpMouseLock(true)

func _on_disconnectButton_pressed():
	buttonClick()
	
	dzej.sceneSwtich("res://scenes/engine/backgroundmainmenu.tscn", true)

# MENU TOGGLE

func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		if(self.get_parent().visible and get_parent().name != "mainmenu"):
			self.get_parent().visible = false
			dzej.lpMouseLock(true)
		else:
			self.get_parent().visible = true
			dzej.lpMouseLock(false)

func _on_optionsButton_pressed():
	buttonClick()
	
	settings.get_node("SettingsDialog").popup()
	
func _on_addonsButton_pressed():
	buttonClick()

	addons.get_node("AddonDialog").popup()
