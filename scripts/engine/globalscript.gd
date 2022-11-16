extends Node

onready var pauseScene : Node = preload("res://scenes/engine/pausemenu.tscn").instance()
onready var consoleScene : Node = preload("res://scenes/engine/console.tscn").instance()

onready var root : Node = get_tree().get_root()
var currentScene : Node = null

var paused : bool = false

func _ready():
	currentScene = root.get_child(root.get_child_count() - 1)
	consoleScene = load("res://scenes/engine/console.tscn").instance()

	get_tree().get_root().add_child(consoleScene)

	msg("[dzej] Dzejmod 0.1\nBy japannt.")
	msg("[dzej] enigne initalizing...")
	msg("[dzej] console loaded")

	msg("[dzej] dzejscript loaded.\nreference using dzej.method()")

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
		msg("[dzej] removing scene: " + sceneRef.get_name())
		root.remove_child(sceneRef)
		if(!soft):
			msg("[dzej] freeing scene: " + sceneRef.get_name())
			sceneRef.queue_free()
		return true
		msg("[dzej] scene removed.")
	else:
		msg("[dzej] scene not found")
		return false

func switchScene(resname : String, nomenu : bool = false):
	if(resname == null || resname == ""):
		msg("[dzej] invalid scene name")
		return false

	if(!ResourceLoader.exists(resname)):
		msg("[dzej] scene " + resname + " does not exist")
		return false
	
	msg("[dzej] switching to scene " + resname)
	var scene = load(resname).instance()
	msg("[dzej] instantiated scene")
	root.add_child(scene)
	msg("[dzej] added scene to root")
	currentScene.queue_free()
	msg("[dzej] removed current scene")
	currentScene = scene

	if(nomenu):
		removeScene(pauseScene, false)

		pauseScene = load("res://scenes/engine/pausemenu.tscn").instance()
	else:
		removeScene(pauseScene, true)
		overlayScene(pauseScene)

	removeScene(consoleScene, true)
	overlayScene(consoleScene)

	msg("[dzej] engine windows re-added " + resname)
	return scene


# CONSOLE

func msg(msg : String):
	consoleScene.get_node("ConsoleWindow").call("outText", msg)

# LOCAL PLAYER MANAGEMENT

func lockMouse(type : bool = 0):
	if(type):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		msg("[dzej] mouse locked")
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		msg("[dzej] mouse unlocked")

func isMouseLocked():
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED	
