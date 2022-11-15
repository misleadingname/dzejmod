extends Node

onready var pauseScene : Node = load("res://scenes/engine/pausemenu.tscn").instance()
onready var consoleScene : Node = load("res://scenes/engine/console.tscn").instance()

onready var root : Node = get_tree().get_root()
var currentScene : Node = null

var paused : bool = false

func _ready():
	currentScene = root.get_child(root.get_child_count() - 1)

	print("dzejscript loaded.\nreference using dzej.X")

func hello():
	return "hello dzejmod"

# SCENE MANAGEMENT

func overlayNewScene(resname : String):
	var scene = load(resname).instance()
	root.add_child(scene)

	return scene

func overlayScene(scene : Node):
	return root.add_child(scene)

func removeScene(sceneRef : Node, soft : bool = false):
	if(sceneRef != null):
		root.remove_child(sceneRef)
		if(!soft):
			sceneRef.queue_free()
			return true
		else:
			return true
	else:
		return false

func switchScene(resname : String, nomenu : bool = false):
	var scene = load(resname).instance()
	root.add_child(scene)
	currentScene.queue_free()
	currentScene = scene

	if(nomenu):
		removeScene(pauseScene, false)

		pauseScene = load("res://scenes/engine/pausemenu.tscn").instance()
	else:
		removeScene(pauseScene, true)
		overlayScene(pauseScene)

	removeScene(consoleScene, true)
	overlayScene(consoleScene)

	return scene

# LOCAL PLAYER MANAGEMENT

func lockMouse(type : bool = 0):
	if(type):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func isMouseLocked():
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED	
