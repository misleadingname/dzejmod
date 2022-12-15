extends Node

const VERSION = "0.1"

onready var pauseScene: Node = load("res://scenes/engine/pausemenu.tscn").instance()
var consoleScene: Node = load("res://scenes/engine/console.tscn").instance()

onready var root: Node = get_tree().get_root()
var sceneCurrent: Node = null
var gameplayMap: Node = null
var addonMapFrom = "base"

var targetScene: String = "res://scenes/defaultmap.tscn"
var targetGamemode: String = "Sandbox"

var paused: bool = false
var path: String = OS.get_executable_path().get_base_dir()
var addonpath = path + "/addons/"

func _notification(what):
	if what == MainLoop.NOTIFICATION_CRASH:
		fatal(null, null, null)


func _ready():
	sceneCurrent = root.get_child(root.get_child_count() - 1)

func reloadShit():
	print("[DEBUG] Reloading everything...")

	pauseScene = load("res://scenes/engine/pausemenu.tscn").instance()
	consoleScene = load("res://scenes/engine/console.tscn").instance()
	root = get_tree().get_root()

	root.add_child(consoleScene)

	sceneCurrent = root.get_child(root.get_child_count() - 1)
	gameplayMap = sceneCurrent.get_node("Map")
	addonMapFrom = "base"
	targetScene = "res://scenes/defaultmap.tscn"
	targetGamemode = "Sandbox"
	paused = false
	path = OS.get_executable_path().get_base_dir()
	addonpath = path + "/addons/"


func hello():
	return "hello dzejmod"


func fatal(returnee, status, err_path):
	msg("")
	msg("")
	msg("[FATAL ERROR]")
	msg("[FATAL ERROR]")
	msg(
		"[FATAL ERROR] A fatal error only occurs when there's a SERIOUS problem that dzejmod couldn't give a fuck about, so instead of crashing the game, it will just show this message and continue."
	)
	msg("[FATAL ERROR] Good luck with that noob :D")
	msg("[FATAL ERROR]")

	if returnee == null && status == null && err_path == null:
		msg(
			"[FATAL ERROR] Like, I have no idea how you ended up in a situation where NOTHING was returned, but it may be your memory dying or something. But either way, you're fucked."
		)
	else:
		var msg = "A fatal error occured and the info IS:"
		if returnee != null:
			msg += "\n	Error code returned by: (" + str(returnee) + ")"
		if status != null:
			msg += "\n	And the code was: (" + str(status) + ") "
		if err_path != null:
			msg += "\n	By doing something related to: (" + err_path + ") "
		msg("[FATAL ERROR] " + msg)

	msg("[FATAL ERROR]")
	msg("[FATAL ERROR]")
	msg("")
	msg("")
	lpShowNotification("[dzej] An error occured, please check the console.", 10)


# SCENE MANAGEMENT


func sceneAddToParent(resname: String, parent: Node):
	print("[INFO] adding " + resname + " to " + str(parent))
	if parent == null:
		fatal(null, "Parent is null", resname)
		return false

	if resname == null || resname == "":
		fatal(null, "Invalid scene name", resname)
		return false

	if !ResourceLoader.exists(resname):
		fatal(null, "Scene does not exist", resname)
		return false

	if !resname.ends_with(".tscn"):
		fatal(null, "Scene is not a .tscn file", resname)
		return false

	msg("[INFO] adding '" + resname + "' to " + str(parent))
	var scene = ResourceLoader.load(resname)
	if scene == null:
		fatal(scene, null, resname)
		return false

	scene = scene.instance()
	parent.add_child(scene)
	return [scene, parent]


func sceneOverlayNew(resname: String):
	if resname == null || resname == "":
		fatal(null, "Invalid scene name", resname)
		return false

	if !ResourceLoader.exists(resname):
		fatal(null, "Scene does not exist", resname)
		return false

	msg("[INFO] overlaying new scene at root: " + resname)
	var scene = load(resname).instance()
	root.add_child(scene)

	return scene


func sceneOverlay(scene: Node):
	msg("[INFO] overlaying " + str(scene))
	return root.add_child(scene)


func sceneRemove(sceneRef: Node, soft: bool = false):
	if sceneRef != null:
		msg("[INFO] removing scene: " + sceneRef.get_name())
		root.remove_child(sceneRef)
		if !soft:
			msg("[INFO] freeing scene: " + sceneRef.get_name())
			sceneRef.queue_free()
		msg("[INFO] scene removed.")
		return true
	else:
		msg("[INFO] invalid scene")
		return false


func sceneSwtich(resname: String, nomenu: bool = false):
	if resname == null || resname == "":
		fatal(null, "Invalid scene name", resname)
		return false

	if !ResourceLoader.exists(resname):
		fatal(null, "Scene does not exist", resname)
		return false

	msg("[INFO] switching to scene " + resname)
	var scene = load(resname).instance()
	msg("[INFO] instantiated scene")
	root.add_child(scene)
	msg("[INFO] added scene to root")
	sceneRemove(sceneCurrent)
	msg("[INFO] removed current scene")
	sceneCurrent = scene

	if nomenu:
		sceneRemove(pauseScene)

		pauseScene = load("res://scenes/engine/pausemenu.tscn").instance()
	else:
		sceneRemove(pauseScene, true)
		sceneOverlay(pauseScene)

	sceneRemove(consoleScene, true)
	sceneOverlay(consoleScene)

	msg("[INFO] engine windows re-added " + resname)
	return scene


func sceneGetList():
	var scenes = []
	var sceneDir = Directory.new()
	sceneDir.open("res://scenes")
	sceneDir.list_dir_begin(true, true)
	while true:
		var file = sceneDir.get_next()
		if file == "":
			break
		if file.ends_with(".tscn"):
			scenes.append(file)
	sceneDir.list_dir_end()
	return scenes


func addonSceneGetList(addons):
	var scenes = []
	var sceneDir = Directory.new()
	for i in addons.size():
		sceneDir.open(addonpath + addons[i] + "/maps")
		sceneDir.list_dir_begin(true, true)
		while true:
			var file = sceneDir.get_next()
			if file == "":
				break
			if file.ends_with(".tscn"):
				scenes.append(file)
		sceneDir.list_dir_end()
	return scenes


# RESOURCE MANAGEMENT


func resLoadToMem(path: String):
	if path == null || path == "":
		fatal(path, "Invalid resource path", path)
		return false

	if !ResourceLoader.exists(path):
		fatal(path, "Resource doesn't exist", path)
		return false

	msg("[INFO] loading resource " + path + " to memory")
	var res = ResourceLoader.load(path)
	if res == null:
		fatal(res, "Resource is null", path)
		return false

	msg("[INFO] resource loaded")
	return res


func resExists(path: String):
	if path == null || path == "":
		fatal(path, "Invalid resource path", path)
		return false

	if !ResourceLoader.exists(path):
		fatal(path, "Resource doesn't exist", path)
		return false

	return true


# NODE MANAGEMENT


func nodeSetScript(node: Node, script: Script, update: bool = false):
	if node == null:
		fatal(node, "Node is null", script)
		return false

	if script == null:
		fatal(script, "Script is null", node)
		return false

	msg("[INFO] setting script " + str(script) + " to node " + str(node))
	node.set_script(script)

	if update:
		node._ready()
		node.set_process(true)
		node.set_process_input(true)
		node.set_process_unhandled_input(true)
		node.set_physics_process(true)

	return node


func nodeAddToParent(node: Node, parent: Node):
	msg("[INFO] adding " + str(node) + " to " + str(parent))
	if parent == null:
		fatal(null, "Parent is null", str(node))
		return false

	if node == null:
		fatal(null, "Node is null", str(node))
		return false

	parent.add_child(node)

	msg("[INFO] added " + str(node) + " to " + str(parent))

	return [node, parent]


# ADDON MANAGEMENT


func addonRequestList():
	var addons = []
	var addonsDir = Directory.new()
	addonsDir.open(addonpath)
	addonsDir.list_dir_begin(true)
	while true:
		var addon = addonsDir.get_next()
		match addon:
			"":
				break
			_:
				addons.append(addon)
	addonsDir.list_dir_end()
	return addons


func addonGetInfo(addon: String):
	var addonDir = Directory.new()
	addonDir.open(addonpath + addon)
	addonDir.list_dir_begin()
	while true:
		var file = addonDir.get_next()
		if file == "":
			break
		if file == "meta.json":
			var meta = File.new()
			meta.open(addonpath + addon + "/meta.json", File.READ)
			var metaInfo = meta.get_as_text()
			meta.close()
			return JSON.parse(metaInfo).result
	addonDir.list_dir_end()
	return null


func addonGetPath(addon: String):
	return addonpath + addon


# CONSOLE


func msg(msg):
	msg = str(msg)
	consoleScene.get_node("ConsoleWindow").call("outText", msg)


# LOCAL PLAYER MANAGEMENT


func lpMouseLock(type: bool = 0):
	if type:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func lpMouseIsLocked():
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED


func lpParseJson(lin: String):
	return JSON.parse(lin).result


func lpGetFileAsText(lin: String):
	msg("[INFO] file " + lin + " was read")
	var file = File.new()
	file.open(lin, File.READ)
	var actualFile = file.get_as_text()
	file.close()
	return actualFile


func lpShowNotification(text: String, time: float = 5):
	msg("[INFO] displaying notification: " + text + " for " + str(time) + " seconds")
	if gameplayMap == null:
		msg("[WARN] gameplayMap is null")
		return false
	var ontop = gameplayMap.get_node("UI_ontop")

	var notifTemplate = ontop.get_node("hacky?/notifDisplay/notifTemplate")
	var notif = notifTemplate.duplicate()

	ontop.get_node("hacky?/notifDisplay").add_child(notif)

	notif.visible = true
	notif.call("displaynotif", text, time)
