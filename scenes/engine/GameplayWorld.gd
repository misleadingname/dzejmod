extends Spatial

var scene = dzej.addSceneToCustomParent(dzej.targetScene, self)[0]
var player = dzej.addSceneToCustomParent("res://imports/player.tscn", self)[0]

func _ready():
	#botched world loader

	for i in scene.get_children():
		if(i.name == "PlayerSpawn"):
			dzej.msg(i.get_name())
			player.translation = i.translation
			player.rotation.y = i.rotation.y

