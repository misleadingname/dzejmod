extends Spatial

var scene : Node = null
var player : Node = dzej.addSceneToCustomParent("res://imports/player.tscn", self)[0]

onready var spinnerAnimation = $UI/Panel/AnimationPlayer

func _ready():
	if(dzej.targetScene == "engine/GameplayWorld.tscn" || dzej.targetScene == "res://GameplayWorld.tscn"):
		dzej.msg("[FATAL] Don't use GameplayWorld as the target scene!")
	else:
		scene = dzej.addSceneToCustomParent(dzej.targetScene, self)[0]

		spinnerAnimation.play("spinner")

		for i in scene.get_children():
			if(i.name == "PlayerSpawn"):
				dzej.msg(i.get_name())
				player.translation = i.translation
				player.rotation.y = i.rotation.y
				break
