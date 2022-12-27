extends Node

func onLoad(scene):
	var playerPrefab = dzej.sceneAddToParent(dzej.addonGetPath("marble") + "/prefabs/player.tscn", scene)

	var playerScript = dzej.resLoadToMem(dzej.addonGetPath("marble") + "/scripts/playerController.gd")
	dzej.nodeSetScript(playerPrefab, playerScript, true)

	var spawnNode = scene.get_node("SPAWN")
	if(spawnNode != null):
		playerPrefab.transform = spawnNode.transform
	else:
		dzej.msg("[marble] Spawn node not found, spawning at 0 to the power of 3 :(")
		
		
		
	
	
func peerConnected(id):
	pass


func peerDisconnected(id):
	pass

func netUpdate(data : Array):
	pass
