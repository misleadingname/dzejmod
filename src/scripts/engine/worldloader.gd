extends Spatial

onready var spinnerAnimation = $UI/AnimationPlayer
onready var bannerText = $UI/bannerPanel/Label
onready var finishSound = $UI/finishSound

var scene : Node = null
var loadedScene : Node = null

func _ready():
	dzej.gameplayMap = self
	yield(get_tree(), "idle_frame") # Just to be safe :P

	scene = null
	loadedScene = null

	if(dzej.targetScene == "scenes/engine/GameplayWorld.tscn" || dzej.targetScene == "res://scenes/engine/GameplayWorld.tscn"):
		bannerText.text = "Error, check console for details."
		dzej.msg("[FATAL] Don't use GameplayWorld as the target scene!")
		return false
		
	yield(get_tree(), "idle_frame")
	spinnerAnimation.play("spinner")
	bannerText.text = "Now loading\n" + dzej.targetScene
	print(dzej.getAddonPath(dzej.addonMapFrom) + "/maps/" + dzej.targetScene)
	var loader = ResourceLoader.load_interactive(dzej.getAddonPath(dzej.addonMapFrom) + "/maps/" + dzej.targetScene)
	var loadingStatus = loader.poll()
	while true:
		loadingStatus = loader.poll()
		if(loadingStatus == OK):
			yield(get_tree(), "idle_frame")
		if(loadingStatus == ERR_FILE_EOF):
			dzej.msg("[INFO] Scene loaded: " + dzej.targetScene)
			loadedScene = dzej.nodeAddToParent(loader.get_resource().instance(), self)[0]
			loadedScene.name = "map"
			break
		yield(get_tree(), "idle_frame")
		

	bannerText.text = "Loading addons..."

	dzej.msg("[INFO] Loading init.gd script from " + dzej.getAddonPath(dzej.addonMapFrom) + "/scripts/init.gd")

	var initScriptPath = dzej.getAddonPath(dzej.addonMapFrom) + "/scripts/init.gd"
	if (dzej.resExists(initScriptPath)):
		var initNode = Spatial.new()
		initNode.name = "initScript (DO NOT DELETE)"
		
		var initScript = dzej.resLoadToMem(initScriptPath)

		dzej.nodeSetScript(initNode, initScript)

		dzej.nodeAddToParent(initNode, loadedScene)
		initNode.call("onLoad", loadedScene)

	finishSound.play()
	spinnerAnimation.play("slideDown")
	dzej.msg("[INFO] Scene loaded: " + dzej.targetScene)
	bannerText.text = "Done! :D"
	$UI/Image.visible=false
