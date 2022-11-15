extends Node

var pausemenu = preload("res://scenes/engine/mainmenu.tscn")

onready var root : Node = get_tree().get_root()
var currentScene : Node = null

var paused : bool = false

func _ready():
	currentScene = root.get_child(root.get_child_count() - 1)

	print("dzejscript loaded.\nreference using dzej.X")

func hello():
	return "hello dzejmod"

# SCENE MANAGEMENT

func overlayScene(resname : String):
	var scene = load(resname).instance()
	root.add_child(scene)

	return scene

func removeScene(sceneRef : Node):
	if(sceneRef != null):
		sceneRef.queue_free()
		return true
	else:
		return false

func switchScene(resname : String):
	var scene = load(resname).instance()
	root.add_child(scene)
	currentScene.queue_free()
	currentScene = scene

	return scene

# MENUS
func _input(event):
	if(Input.is_action_just_pressed("ui_cancel")):
		if(paused):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			overlayScene("res://scenes/engine/pausemenu.tscn")
	
	if(Input.is_action_just_pressed("ui_console")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		overlayScene("res://scenes/engine/console.tscn")
