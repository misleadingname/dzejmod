extends Spatial

onready var spinnerAnimation = $UI/AnimationPlayer
onready var bannerText = $UI/bannerPanel/Label
onready var finishSound = $UI/finishSound

onready var devSpatial = $UI_ontop/hacky/developer

var scene: Node = null
var loadedScene: Node = null

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
	yield(get_tree(), "idle_frame")

	scene = null
	loadedScene = null

	if dzej.targetScene == "engine/GameplayWorld.tscn" || dzej.targetScene == "res://scenes/engine/GameplayWorld.tscn":
		bannerText.text = "Error, check console for details."
		get_tree().quit()
		return false

	yield(get_tree(), "idle_frame")
	spinnerAnimation.play("spinner")
	bannerText.text = "Now loading\n" + dzej.targetScene
	dzej.msg(dzej.addonGetPath(dzej.addonMapFrom) + "/maps/" + dzej.targetScene)
	var loader = ResourceLoader.load_interactive(dzej.addonGetPath(dzej.addonMapFrom) + "/maps/" + dzej.targetScene)
	var loadingStatus = loader.poll()
	while true:
		loadingStatus = loader.poll()
		if loadingStatus == OK:
			yield(get_tree(), "idle_frame")
		if loadingStatus == ERR_FILE_EOF:
			dzej.msg("[INFO] Scene loaded: " + dzej.targetScene)
			loadedScene = dzej.nodeAddToParent(loader.get_resource().instance(), self)[0]
			loadedScene.name = "map"
			break
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
	initNode.call("onLoad", loadedScene)

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

	finishSound.play()
	spinnerAnimation.play("slideDown")
	dzej.msg("[INFO] Scene loaded: " + dzej.targetScene)
	bannerText.text = "Done! :D"
	$UI/Image.visible = false
