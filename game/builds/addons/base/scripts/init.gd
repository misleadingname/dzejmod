extends Node

func onLoad(loadedScene):
	print(loadedScene)
	# var sceneData = dzej.sceneAddToParent(dzej.getAddonPath("base") + "/prefabs/player.tscn", loadedScene)
	# var player = sceneData[0]

	# dzej.sceneAddToParent seems to be broken, so we have to do it manually
	var prompt = dzej.getAddonPath("base") + "/prefabs/player.tscn"
	var player = ResourceLoader.load(prompt).instance()
	print(player)
	dzej.nodeAddToParent(player, loadedScene)

	for i in loadedScene.get_children():
		if(i.name == "PlayerSpawn"):
			dzej.msg(i.get_name())
			player.translation = i.translation
			player.rotation.y = i.rotation.y
			break
	
	return true
