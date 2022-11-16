extends Node

onready var pauseScene : Node = preload("res://scenes/engine/pausemenu.tscn").instance()
var consoleScene : Node = preload("res://scenes/engine/console.tscn").instance()

onready var root : Node = get_tree().get_root()
var currentScene : Node = null

var targetScene : String = "res://scenes/defaultmap.tscn"

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

func addSceneToCustomParent(resname : String, parent : Node):
	if(parent == null):
		msg("[dzej] parent is null")
		return false

	if(resname == null || resname == ""):
		msg("[dzej] invalid scene name")
		return false

	if(!ResourceLoader.exists(resname)):
		msg("[dzej] scene " + resname + " does not exist")
		return false
	
	msg("[dzej] adding " + resname + " to " + str(parent))
	var scene = load(resname)
	scene = scene.instance()

	parent.add_child(scene)

	return [scene, parent]

func overlayNewScene(resname : String):
	if(resname == null || resname == ""):
		msg("[dzej] invalid scene name")
		return false

	if(!ResourceLoader.exists(resname)):
		msg("[dzej] scene " + resname + " does not exist")
		return false

	msg("[dzej] overlaying new scene at root: " + resname)
	var scene = load(resname).instance()
	root.add_child(scene)

	return scene

func overlayScene(scene : Node):
	msg("[dzej] overlaying " + str(scene))
	return root.add_child(scene)

func removeScene(sceneRef : Node, soft : bool = false):
	if(sceneRef != null):
		msg("[dzej] removing scene: " + sceneRef.get_name())
		root.remove_child(sceneRef)
		if(!soft):
			msg("[dzej] freeing scene: " + sceneRef.get_name())
			sceneRef.queue_free()
		msg("[dzej] scene removed.")
		return true
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
	removeScene(currentScene)
	msg("[dzej] removed current scene")
	currentScene = scene

	if(nomenu):
		removeScene(pauseScene)

		pauseScene = load("res://scenes/engine/pausemenu.tscn").instance()
	else:
		removeScene(pauseScene, true)
		overlayScene(pauseScene)

	removeScene(consoleScene, true)
	overlayScene(consoleScene)

	msg("[dzej] engine windows re-added " + resname)
	return scene

# CONSOLE

func msg(msg):
	msg = str(msg)
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
