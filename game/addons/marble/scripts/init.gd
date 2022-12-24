extends Node

func onLoad(scene):
	var playerPrefab = dzej.sceneAddToParent(dzej.addonGetPath("marble") + "/prefabs/player.tscn", scene)

	var playerScript = dzej.resLoadToMem(dzej.addonGetPath("marble") + "/scripts/playerController.gd")
	dzej.nodeSetScript(playerPrefab, playerScript, true)

	var spawnNode = scene.get_node("marbleSpawn")
	playerPrefab.transform = spawnNode.transform