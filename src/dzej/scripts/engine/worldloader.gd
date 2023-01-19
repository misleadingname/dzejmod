extends Spatial

onready var spinnerAnimation = $UI/AnimationPlayer
onready var bannerText = $UI/bannerPanel/Label
onready var finishSound = $UI/finishSound

onready var devSpatial = $UI_ontop/hacky/developer

var scene: Node = null
var loadedScene: Node = null

var serverInfo = []

var ready : bool = false

func peerConnected(id):
	dzej.msg("[INFO] Peer connected: " + str(id))

	if(dzej.mpRole == "host"):
		dzej.msg("[INFO] Sending server info to client...")
		dzej.mpSendToPeer(id, "internalServerInfo", [dzej.targetGamemode, dzej.targetScene, dzej.addonMapFrom, dzej.hostPlayerList])
	
	dzej.root.get_node("gamemodescript").peerConnected(id)

	rpc("internalPlayerConnected", id)

func peerDisconnected(id):
	dzej.msg("[INFO] Peer disconnected: " + str(id))
	dzej.root.get_node("gamemodescript").peerDisconnected(id)

func netUpdate(data : Array):
	if ready:
		dzej.root.get_node("gamemodescript").netUpdate(data)

func _process(delta):
	devSpatial.visible = dzej.developer

	if dzej.developer:
		var addons : String = ""
		for addon in dzej.addonRequestList():
			var meta = dzej.addonGetInfo(addon)
			addons += meta.name + "	\n"

		devSpatial.get_node("topleft").get_child(0).text = "FPS: " + str(Engine.get_frames_per_second()) + "\nMap: " + dzej.targetScene + "\nGamemode: " + dzej.targetGamemode + "\nAddons:\n" + addons

func _ready():
	dzej.gameplayMap = self
	dzej.chat = $UI_ontop/hacky/chatbox
	yield(get_tree(), "idle_frame")

	if dzej.targetScene == "engine/GameplayWorld.tscn" || dzej.targetScene == "res://dzej/scenes/engine/GameplayWorld.tscn":
		bannerText.text = "Error, check console for details."
		get_tree().quit()
		return false

	spinnerAnimation.play("spinner")

	scene = null
	loadedScene = null

	bannerText.text = "Retrieving server info..."

	dzej.msg("[INFO] Multiplayer role: " + dzej.mpRole)

	if(dzej.mpRole == "host"):
		dzej.msg("[INFO] Creating multiplayer session...")

		dzej.hostPlayerList = [1]

		var result = dzej.mpCreateSession()
		if(result != true):
			bannerText.text = "Error, check console for details."
			return false
			
	elif(dzej.mpRole == "client"):
		dzej.msg("[INFO] Ready to join server...")
		dzej.targetGamemode = ""
		dzej.targetScene = ""
		dzej.addonMapFrom = ""
		dzej.hostPlayerList = []

		dzej.msg("[INFO] Joining multiplayer session...")

		dzej.mpSendToPeer(1, "clientInfo", [dzej.mpNickname])

		var result = dzej.mpJoinSession()
		if(result != true):
			bannerText.text = "Error, check console for details."
			return false
		
		dzej.msg("[INFO] Waiting for server info...")
		while true:
			yield(get_tree(), "idle_frame")
			if(dzej.targetGamemode != "" && dzej.targetScene != "" && dzej.addonMapFrom != "" && dzej.hostPlayerList != []):
				dzej.lpShowNotification("Got info from server, loading map...")
				break
				

	else:
		bannerText.text = "Error, check console for details."
		dzej.fatal(dzej.mpRole, "Invalid multiplayer role", null)
		return false
	
	bannerText.text = "Loading map..."
	dzej.msg("[INFO] Loading map: " + dzej.targetScene)
	#$map/QodotMap.set_map_file(dzej.addonGetPath(dzej.addonMapFrom) + "/maps/" + dzej.targetScene)
	#$map/QodotMap.build_map()
	
	var loader = ResourceLoader.load_interactive(dzej.addonGetPath(dzej.addonMapFrom) + "/maps/" + dzej.targetScene)
	var loadingStatus = loader.poll()
	while true:
		loadingStatus = loader.poll()
		if loadingStatus == OK:
			yield(get_tree(), "idle_frame")
		elif loadingStatus == ERR_FILE_EOF:
			dzej.msg("[INFO] Scene loaded: " + dzej.targetScene)
			loadedScene = dzej.nodeAddToParent(loader.get_resource().instance(), self)[0]
			loadedScene.name = "map"
			break
		else:
			bannerText.text = "Error, check console for details."
			dzej.fatal(loader, loadingStatus, dzej.targetScene)
			return false
		yield(get_tree(), "idle_frame")

	bannerText.text = "Loading addons..."

	dzej.msg("[INFO] Loading init.gd script from " + dzej.addonGetPath(dzej.targetGamemode) + "/scripts/init.gd")
	yield(get_tree(), "idle_frame")

	var initScriptPath = dzej.addonGetPath(dzej.targetGamemode) + "/scripts/init.gd"
	if !dzej.resExists(initScriptPath):
		bannerText.text = "Error, check console for details."
		dzej.fatal(null, "Gamemode init script not found", initScriptPath)
		return false

	var initNode = Node.new()
	initNode.name = "gamemodescript"

	var initScript = dzej.resLoadToMem(initScriptPath)

	var setnode = dzej.nodeSetScript(initNode, initScript)

	if !setnode:
		bannerText.text = "Error, check console for details."
		dzej.fatal(null, "Gamemode init script failed to load", initScriptPath)
		return false

	dzej.nodeAddToParent(initNode, dzej.root)
	initNode.onLoad(loadedScene)

	for addon in dzej.addonRequestList():
		var meta = dzej.addonGetInfo(addon)
		dzej.msg("[INFO] Checking " + meta.name + " addon...")
		if meta.tag == "plugin":
			if !meta.has("gamemode"):
				dzej.fatal(null, "Plugin " + meta.name + " does not have a gamemode tag.", dzej.addonGetPath(addon) + "/meta.json")
				break
			if meta.gamemode == dzej.targetGamemode:
				dzej.msg("[INFO] " + meta.name + " is a plugin for the current gamemode.")
				dzej.msg("[INFO] Loading " + meta.name + " plugin...")
				var pluginPath = dzej.addonGetPath(addon) + "/scripts/init.gd"
				var pluginNode = Node.new()
				pluginNode.name = "plugin_" + meta.name

				var pluginScript = dzej.resLoadToMem(pluginPath)

				dzej.nodeSetScript(pluginNode, pluginScript)

				dzej.nodeAddToParent(pluginNode, dzej.root)
				yield(get_tree(), "idle_frame")
	
	initNode.peerConnected(get_tree().get_network_unique_id())
	
	dzej.msg("[INFO] All addons loaded.")

	finishSound.play()
	spinnerAnimation.play("slideDown")
	dzej.msg("[INFO] Scene loaded: " + dzej.targetScene)
	
	if (dzej.mpRole == "client"):
		dzej.msg("[INFO] Sending playerlist to gamemode...")
		for id in dzej.hostPlayerList:
			if id != get_tree().get_network_unique_id():
				initNode.peerConnected(id)

	ready = true
	bannerText.text = "Done! :D"
	$UI/Image.visible = false
