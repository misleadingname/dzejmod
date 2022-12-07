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
		spinnerAnimation.play("slideDown")
	else:
		yield(get_tree(), "idle_frame")
		spinnerAnimation.play("spinner")
		bannerText.text = "Now loading\n" + dzej.targetScene
		print(dzej.getAddonPath(dzej.addonMapFrom) + "maps/" + dzej.targetScene)
		var loader = ResourceLoader.load_interactive(dzej.getAddonPath(dzej.addonMapFrom) + "maps/" + dzej.targetScene)
		var loadingStatus = loader.poll()
		while true:
			loadingStatus = loader.poll()
			if loadingStatus == OK:
				yield(get_tree(), "idle_frame")
			if(loadingStatus == ERR_FILE_EOF):
				dzej.msg("[INFO] Scene loaded: " + dzej.targetScene)
				spinnerAnimation.play("slideDown")
				loadedScene = dzej.nodeAddToParent(loader.get_resource().instance(), self)[0]
				break

		finishSound.play()
		dzej.msg("[INFO] Scene loaded: " + dzej.targetScene)
		bannerText.text = "Done! :D"
		$UI/Image.visible=false

		dzej.lpShowNotification("Welcome to Dzejmod!\nThis is an early alpha build so beware of bugs!\nAlso make sure to check out the website and the wiki!\n\nhttps://dzejmod.tk/", 10)

		var temp:String = "res://base/prefabs/player.tscn"
		print(temp)
		var playera = load(temp)
		print(playera)
		var player = playera.instance()
		loadedScene.add_child(player)
		for i in loadedScene.get_children():
			if(i.name == "PlayerSpawn"):
				dzej.msg(i.get_name())
				player.translation = i.translation
				player.rotation.y = i.rotation.y
				break
