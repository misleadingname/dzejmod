extends Spatial

onready var spinnerAnimation = $UI/Panel/AnimationPlayer

var scene : Node = null
var loadedScene : Node = null

var loadingStatus = null

func _ready():
	if(dzej.targetScene == "engine/GameplayWorld.tscn" || dzej.targetScene == "res://GameplayWorld.tscn"):
		dzej.msg("[FATAL] Don't use GameplayWorld as the target scene!")
	else:
		spinnerAnimation.play("spinner")

		var loader = ResourceLoader.load_interactive(dzej.targetScene)

		while true:
			loadingStatus = loader.poll()
			if loadingStatus == OK:
				yield(get_tree(), "idle_frame")
			if(loadingStatus == ERR_FILE_EOF):
				dzej.msg("[INFO] Scene loaded: " + dzej.targetScene)
				spinnerAnimation.play("slideDown")
				loadedScene = dzej.addNodeToParent(loader.get_resource().instance(), self)[0]
				break

		dzej.msg("[INFO] Scene loaded: " + dzej.targetScene)

		var player : Node = dzej.addSceneToCustomParent("res://imports/player.tscn", self)[0]

		for i in loadedScene.get_children():
			if(i.name == "PlayerSpawn"):
				dzej.msg(i.get_name())
				player.translation = i.translation
				player.rotation.y = i.rotation.y
				break
