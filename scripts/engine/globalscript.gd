extends Node

var pausemenu = preload("res://scenes/engine/mainmenu.tscn")

var root : Node = null
var currentScene : Node = null

func _ready():
	root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)

	print("dzejscript loaded.\nreference using dzej.X")

func _input(event):

	
	if(Input.is_action_just_pressed("ui_console")):
		overlayScene("res://scenes/engine/console.tscn")

func hello():
	print("Hello, dzejmod!")

func overlayScene(resname : String):
	root.add_child(load(resname).instance())
