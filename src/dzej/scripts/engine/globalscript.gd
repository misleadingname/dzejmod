extends Node

const VERSION = "0.2a"

onready var pauseScene: Node = load("res://dzej/scenes/engine/pausemenu.tscn").instance()
onready var consoleScene: Node = load("res://dzej/scenes/engine/console.tscn").instance()

onready var root: Node = get_tree().get_root()

var chat = null

var sceneCurrent: Node = null
var gameplayMap: Node = null
var addonMapFrom = "base"

var foreignNodes = []

var targetScene: String = "res://dzej/scenes/defaultmap.tscn"
var targetGamemode: String = "Sandbox"

var paused: bool = false
var developer = false

var chatting = false

var path: String = OS.get_executable_path().get_base_dir()
var addonpath = path + "/addons/"

var blockedAddons = ["qodot"]

var mpPort = 3621
var mpMaxClients = 32
var mpHost = ""
var mpRole = null
var mpNickname = "Mingebag"

var mpSession : NetworkedMultiplayerENet = null

var hostPlayerList = []

func _notification(what):
	if what == MainLoop.NOTIFICATION_CRASH:
		fatal(null, null, null)

func _ready():
	sceneCurrent = root.get_child(root.get_child_count() - 1)

	if(OS.get_name() == "Windows"):
		OS.set_window_title("dzejmod " + VERSION + " (Windows)")
	elif(OS.get_name() == "X11"):
		OS.set_window_title("dzejmod " + VERSION + " (Linux)")
	elif(OS.get_name() == "OSX"):
		OS.set_window_title("dzejmod " + VERSION + " (MacOS)")
	else:
		OS.set_window_title("dzejmod " + VERSION + " (Unknown OS)")
	
	get_tree().connect("connected_to_server", self, "mpHookConnected")
	get_tree().connect("server_disconnected", self, "mpHookDisconnected")

	mpHost = lpGetLocalIP()

func reloadShit():
	print("[DEBUG] Reloading everything...")

	pauseScene = load("res://dzej/scenes/engine/pausemenu.tscn").instance()
	consoleScene = load("res://dzej/scenes/engine/console.tscn").instance()
	root = get_tree().get_root()

	root.add_child(consoleScene)

	sceneCurrent = root.get_child(root.get_child_count() - 1)
	gameplayMap = sceneCurrent.get_node("Map")
	addonMapFrom = "base"
	targetScene = "res://dzej/scenes/defaultmap.tscn"
	targetGamemode = "Sandbox"
	paused = false
	path = OS.get_executable_path().get_base_dir()
	addonpath = path + "/addons/"

	sceneSwtich("res://dzej/scenes/engine/initialloading.tscn")


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
			msg += "\n	And the status was: (" + str(status) + ") "
		if err_path != null:
			msg += "\n	By doing something related to: (" + err_path + ") "
		msg("[FATAL ERROR] " + msg)
		OS.alert("A fatal error has occured, whilst this is not a crash. It may be a good idea to check what happened.\n\n" + msg, "THIS IS NOT A CRASH.")

	msg("[FATAL ERROR]")
	msg("[FATAL ERROR]")
	msg("")
	msg("")
	lpShowNotification("[dzej] An error occured, please check the console.", 10)


# SCENE MANAGEMENT


func sceneAddToParent(resname: String, parent: Node):
	msg("[INFO] adding " + resname + " to " + str(parent))
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
	return scene


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
	if sceneRef == null:
		msg("[INFO] invalid scene")
		return false
	
	msg("[INFO] removing scene: " + sceneRef.get_name())
	root.remove_child(sceneRef)
	msg("[INFO] scene removed.")
	if !soft:
		msg("[INFO] freeing scene: " + sceneRef.get_name())
		sceneRef.queue_free()
		return true
	else:
		return sceneRef


func sceneSwtich(resname: String, nomenu: bool = false):
	if resname == null || resname == "":
		fatal(null, "Invalid scene name", resname)
		return false

	if !resExists(resname):
		fatal(null, "Scene does not exist", resname)
		return false

	msg("[INFO] switching to scene " + resname)

	for node in foreignNodes:
		if node != null:
			node.queue_free()
	foreignNodes = []

	var scene = resLoadToMem(resname)
	if scene == null:
		return false
	scene = scene.instance()
	msg("[INFO] instantiated scene")
	root.add_child(scene)
	msg("[INFO] added scene to root")
	sceneRemove(sceneCurrent)
	msg("[INFO] removed current scene")
	sceneCurrent = scene

	if nomenu:
		sceneRemove(pauseScene)

		pauseScene = load("res://dzej/scenes/engine/pausemenu.tscn").instance()
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

# RESOURCE MANAGEMENT


func resLoadToMem(path: String):
	if path == null || path == "":
		fatal(path, "Invalid resource path", path)
		return false

	if !resExists(path):
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

	msg("[INFO] Checking script for naughty code...")

	var scriptFile = File.new()
	scriptFile.open(script.get_path(), File.READ)
	var scriptText = scriptFile.get_as_text()
	scriptFile.close()

	var scriptLines = scriptText.split("\n")
	for line in scriptLines:
		var regex = RegEx.new()
		regex.compile("(func dzej.*)|(dzej.*=)")
		if regex.search(line):
			fatal(script, "Script contains unsafe code", line)
			return false

	foreignNodes.append(node)

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

func addonSceneGetList(addon):
	print(addonpath + addon + "/maps")
	var scenes = []

	if !Directory.new().dir_exists(addonpath + addon + "/maps"):
		msg("[WARN] addon " + addon + " has no maps folder, returning empty list")
		return scenes

	var sceneDir = Directory.new()
	sceneDir.open(addonpath + addon + "/maps")
	sceneDir.list_dir_begin(true, true)
	while true:
		var file = sceneDir.get_next()
		print(file)
		if file == "":
			break
		if file.ends_with(".tscn"):
			scenes.append(file)
	sceneDir.list_dir_end()
	return scenes

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
			"qodot":
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
	return false


func addonGetPath(addon: String):
	return addonpath + addon


# CONSOLE MANAGEMENT

func msg(msg):
	msg = str(msg)
	consoleScene.get_node("ConsoleWindow").call("outText", msg)
	

func getallconsole():
	return consoleScene.get_node("ConsoleWindow/VBoxContainer/TextEdit").text


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

	var notifTemplate = ontop.get_node("hacky/notifDisplay/notifTemplate")
	var notif = notifTemplate.duplicate()

	ontop.get_node("hacky/notifDisplay").add_child(notif)

	notif.visible = true
	notif.call("displaynotif", text, time)

func lpMessageBox(text : String, title : String = "Alert"):
	lpMouseLock(false)
	var msgBox = AcceptDialog.new()
	msgBox.set_text(text)
	msgBox.set_title(title)

	root.add_child(msgBox)

	msgBox.popup_centered()

	msgBox.connect("confirmed", self, "lpMouseLock", [true])

func lpChatText(text):
	if(gameplayMap == null):
		msg("[WARN] gameplayMap is null")
		return false

	chat.addText(text)
	return true

func lpGetLocalIP():
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168."):
			return ip
		else:
			return "failure"
	
# MULTIPLAYER MANAGEMENT

func mpCreateSession():
	msg("[INFO] creating server")
	if(mpSession != null):
		fatal(mpSession, "session running", null)
		return false	
		
	mpSession = NetworkedMultiplayerENet.new()

	var result = mpSession.create_server(mpPort, mpMaxClients)
	
	if(result != OK):
		fatal(mpSession, result, null)
		return false

	mpRole = "host"

	get_tree().set_network_peer(mpSession)
	
	mpSession.connect("peer_connected", self, "mpHookPeerConnected")
	mpSession.connect("peer_disconnected", self, "mpHookPeerDisconnected")

	msg("[INFO] session created at " + str(mpHost) + ":" + str(mpPort))
	
	return true

func mpJoinSession():
	msg("[INFO] joining server")
	if(mpSession != null):
		fatal(mpSession, "session running", null)
		return false
	
	if(mpHost == null):
		fatal(mpSession, "host is null", null)
		return false
		
	mpSession = NetworkedMultiplayerENet.new()

	var result = mpSession.create_client(mpHost, mpPort)
	
	if(result != OK):
		fatal(mpSession, result, null)
		return false

	mpRole = "client"

	get_tree().set_network_peer(mpSession)
	
	msg("[INFO] session joined!")
	
	msg("[INFO] fetching server info")

	return true

func mpDiscardSession():
	msg("[INFO] discarding session")
	if(mpSession == null):
		msg("[WARN] there is no session running, returning false")
		return false
		
	mpSession.close_connection()
	mpSession = null
	
	mpRole = null

	mpHost = lpGetLocalIP()

	msg("[INFO] session discarded!")
	
	return true

func mpSceneAddToParentToId(id : int, resname : String, parent : Node):
	if(mpSession == null):
		fatal(mpSession, "session is null", null)
		return false
	
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
	scene.name += "_" + str(id)
	scene.set_network_master(id)
	return scene

func mpSendToPeer(id : int, funcname : String, args : Array):
	if(mpSession == null):
		fatal(mpSession, "session is null", null)
		return false

	if funcname == null || funcname == "":
		fatal(null, "Invalid function name", funcname)
		return false

	if args == null:
		fatal(null, "Invalid arguments", funcname)
		return false

	msg("[INFO] sending '" + funcname + "' to " + str(id))
	var result = rpc_id(id, funcname, args)
	print(result)
	return true

func mpSendChat(text):
	if(gameplayMap == null):
		msg("[WARN] gameplayMap is null")
		return false

	if(text == null || text == ""):
		msg("[WARN] text is null or empty")
		return false
	
	if(mpSession == null):
		msg("[WARN] mpSession is null")
		return false
	
	if(mpRole == null):
		msg("[WARN] mpRole is null")
		return false
	
	rpc("internalChatText", text, get_tree().get_network_unique_id())

	chat.addText("Player " + str(get_tree().get_network_unique_id()) + ": " + text)

func mpRPC(id : int, data : Array):
	if(mpSession == null):
		fatal(mpSession, "session is null", null)
		return false

	if(data == null):
		fatal(null, "Invalid data", null)
		return false

	var result = rpc("netUpdate", [id] + data)
	return true

# HOOKS

func mpHookConnected():
	dzej.msg("[INFO] connected to server as " + str(get_tree().get_network_unique_id()))
	lpChatText("Connected to server")

func mpHookDisconnected():
	msg("[INFO] disconnected from server")
	lpMessageBox("Disconnected from server")

	mpDiscardSession()
	sceneSwtich("res://dzej/scenes/engine/backgroundmainmenu.tscn", true)

func mpHookConnectionFailed():
	msg("[INFO] connection failed")
	lpMessageBox("Connection failed")

	mpDiscardSession()
	sceneSwtich("res://dzej/scenes/engine/backgroundmainmenu.tscn", true)

func mpHookPeerConnected(id):
	lpShowNotification("Player " + str(id) + " connected")
	msg("[INFO] peer " + str(id) + " connected")
	lpChatText("Peer " + str(id) + " connected")

	hostPlayerList.append(id)
	gameplayMap.peerConnected(id)

func mpHookPeerDisconnected(id):
	msg("[INFO] peer " + str(id) + " disconnected")
	lpChatText("Peer " + str(id) + " disconnected")

	hostPlayerList.erase(id)
	gameplayMap.peerDisconnected(id)

# INTERNAL

remote func internalPlayerConnected(id : int):
	mpHookPeerConnected(id)

remote func internalServerInfo(info : Array):
	msg("[INFO] server info received")
	targetGamemode = info[0]
	targetScene = info[1]
	addonMapFrom = info[2]
	hostPlayerList = info[3]

remote func internalChatText(text : String, id : int):
	chat.addText("Player " + str(id) + ": " + text)

remote func netUpdate(data : Array):
	gameplayMap.netUpdate(data)	

remote func clientInfo(id : int, info : Array):
	dzej.msg("player " + str(id) + " sends info:" + str(info))
	gameplayMap.clientInfo(id, info)

# Crashes

func crash(reason : String, errcode : int):
	OS.alert("Your game crashed!\n\n      Here is the error code: " + str(errcode) + "\n      And here is the reason: " + reason + "\n\nThe console has been dumped to crashes/crashlog.txt", "Engine Error")
	OS.crash(reason)
