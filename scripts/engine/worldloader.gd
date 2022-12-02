extends Spatial

onready var spinnerAnimation = $UI/AnimationPlayer
onready var bannerText = $UI/bannerPanel/Label
onready var finishSound = $UI/finishSound

var scene : Node = null
var loadedScene : Node = null

var loadingStatus = null

func _ready():
	scene = null
	loadedScene = null
	loadingStatus = null

	if(dzej.targetScene == "scenes/engine/GameplayWorld.tscn" || dzej.targetScene == "res://scenes/engine/GameplayWorld.tscn"):
		bannerText.text = "Error, check console for details."
		dzej.msg("[FATAL] Don't use GameplayWorld as the target scene!")
		spinnerAnimation.play("slideDown")
	else:
		yield(get_tree(), "idle_frame")
		spinnerAnimation.play("spinner")
		bannerText.text = "Now loading\n" + dzej.targetScene

		var loader = ResourceLoader.load_interactive(dzej.targetScene)

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

		var player : Node = dzej.sceneAddToParent("res://addons/sandbox/prefabs/player.tscn", self)[0]

		for i in loadedScene.get_children():
			if(i.name == "PlayerSpawn"):
				dzej.msg(i.get_name())
				player.translation = i.translation
				player.rotation.y = i.rotation.y
				break
