extends Node

func onLoad(loadedScene):
		var player : Node = dzej.sceneAddToParent("res://addons/sandbox/prefabs/player.tscn", self)[0]

		for i in loadedScene.get_children():
			if(i.name == "PlayerSpawn"):
				dzej.msg(i.get_name())
				player.translation = i.translation
				player.rotation.y = i.rotation.y
				break
