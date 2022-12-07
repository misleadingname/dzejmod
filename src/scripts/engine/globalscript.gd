extends Node

onready var pauseScene : Node = load("res://scenes/engine/pausemenu.tscn").instance()
var consoleScene : Node = load("res://scenes/engine/console.tscn").instance()

onready var root : Node = get_tree().get_root()
var sceneCurrent : Node = null
var gameplayMap : Node = null
var addonMapFrom = "sandbox"

var targetScene : String = "res://scenes/defaultmap.tscn"
var targetGamemode : String = "Sandbox"

var paused : bool = false
var path = OS.get_executable_path().get_base_dir()
var addonpath = path+"/addons/"

func _ready():
	sceneCurrent = root.get_child(root.get_child_count() - 1)

func hello():
	return "hello dzejmod"

# SCENE MANAGEMENT

func sceneAddToParent(resname : String, parent : Node):
	if(parent == null):
		msg("[ERROR] parent is null")
		return false

	if(resname == null || resname == ""):
		msg("[ERROR] invalid scene name")
		return false

	if(!ResourceLoader.exists(resname)):
		msg("[ERROR] scene " + resname + " does not exist")
		return false
	
	msg("[INFO] adding " + resname + " to " + str(parent))
	var scene = load(resname)
	scene = scene.instance()

	parent.add_child(scene)

	return [scene, parent]

func nodeAddToParent(node : Node, parent : Node):
	if(parent == null):
		msg("[ERROR] parent is null")
		return false

	if(node == null):
		msg("[ERROR] node is null")
		return false

	msg("[INFO] adding " + str(node) + " to " + str(parent))
	parent.add_child(node)

	return [node, parent]

func sceneOverlayNew(resname : String):
	if(resname == null || resname == ""):
		msg("[ERROR] invalid scene name")
		return false

	if(!ResourceLoader.exists(resname)):
		msg("[ERROR] scene " + resname + " does not exist")
		return false

	msg("[INFO] overlaying new scene at root: " + resname)
	var scene = load(resname).instance()
	root.add_child(scene)

	return scene

func sceneOverlay(scene : Node):
	msg("[INFO] overlaying " + str(scene))
	return root.add_child(scene)

func sceneRemove(sceneRef : Node, soft : bool = false):
	if(sceneRef != null):
		msg("[INFO] removing scene: " + sceneRef.get_name())
		root.remove_child(sceneRef)
		if(!soft):
			msg("[INFO] freeing scene: " + sceneRef.get_name())
			sceneRef.queue_free()
		msg("[INFO] scene removed.")
		return true
	else:
		msg("[INFO] invalid scene")
		return false

func sceneSwtich(resname : String, nomenu : bool = false):
	if(resname == null || resname == ""):
		msg("[ERROR] invalid scene name")
		return false

	if(!ResourceLoader.exists(resname)):
		msg("[ERROR] scene " + resname + " does not exist")
		return false
	
	msg("[INFO] switching to scene " + resname)
	var scene = load(resname).instance()
	msg("[INFO] instantiated scene")
	root.add_child(scene)
	msg("[INFO] added scene to root")
	sceneRemove(sceneCurrent)
	msg("[INFO] removed current scene")
	sceneCurrent = scene

	if(nomenu):
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
	while(true):
		var file = sceneDir.get_next()
		if(file == ""):
			break
		if(file.ends_with(".tscn")):
			scenes.append(file)
	sceneDir.list_dir_end()
	return scenes

func addonSceneGetList(addons):
	var scenes = []
	var sceneDir = Directory.new()
	for i in addons.size():
		sceneDir.open(addonpath + addons[i] + "/maps")
		sceneDir.list_dir_begin(true, true)
		while(true):
			var file = sceneDir.get_next()
			if(file == ""):
				break
			if(file.ends_with(".tscn")):
				scenes.append(file)
		sceneDir.list_dir_end()
	return scenes

# ADDON MANAGEMENT
func addonRequestList():
	var addons = []
	var addonsDir = Directory.new()
	addonsDir.open(addonpath)
	addonsDir.list_dir_begin(true)
	while(true):
		var addon = addonsDir.get_next()
		match addon:
			"":
				break
			_:
				addons.append(addon)
	addonsDir.list_dir_end()
	return addons

func addonGetInfo(addon : String):
	var addonDir = Directory.new()
	addonDir.open(addonpath + addon)
	addonDir.list_dir_begin()
	while(true):
		var file = addonDir.get_next()
		if(file == ""):
			break
		if(file == "meta.json"):
			var meta = File.new()
			meta.open(addonpath + addon + "/meta.json", File.READ)
			var metaInfo = meta.get_as_text()
			meta.close()
			return JSON.parse(metaInfo).result
	addonDir.list_dir_end()
	return null

func getAddonPath(addon : String):
	return addonpath+addon + "/"
# CONSOLE

func msg(msg):
	msg = str(msg)
	consoleScene.get_node("ConsoleWindow").call("outText", msg)

# LOCAL PLAYER MANAGEMENT

func lpMouseLock(type : bool = 0):
	if(type):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func lpMouseIsLocked():
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED	
	
func lpParseJson(lin:String):
	return JSON.parse(lin).result
	
func lpGetFileAsText(lin:String):
	msg("[INFO] file " + lin + " was read")
	var file = File.new()
	file.open(lin, File.READ)
	var actualFile = file.get_as_text()
	file.close()
	return actualFile

func lpShowNotification(text : String, time : float = 5):
	msg("[INFO] displaying notification: " + text + " for " + str(time) + " seconds")
	if(gameplayMap != null):
		# PLS VIX FIND A BETTER WAY TO DO THIS
		# IT FEELS SO WRONG TO DO THIS
		# I BEG OF YOU
		# AND IF YOU CAN'T FIND A BETTER WAY
		# JUST SEND ME THAT "I fucked it up beyond repair" VIDEO.
		var ontop = gameplayMap.get_node("UI_ontop")
		var notif = ontop.get_node("hacky?/notifDisplay/notifTemplate").duplicate()
		ontop.get_node("hacky?/notifDisplay").add_child(notif)
		notif.visible = true
		notif.call("displaynotif", text, time)