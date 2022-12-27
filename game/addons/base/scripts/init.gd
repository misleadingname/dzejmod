extends Node

var map : Node = null

var puppets = []

func onLoad(loadedScene):
	map = loadedScene
	
	var sandboxGlobal = Node.new()
	sandboxGlobal.name = "sandbox"
	dzej.nodeSetScript(sandboxGlobal, dzej.resLoadToMem(dzej.addonGetPath("base") + "/scripts/globalsandbox.gd"))
	dzej.nodeAddToParent(sandboxGlobal, dzej.root)

	dzej.lpShowNotification("Welcome to Dzejmod!\nThis is an early alpha build so beware of bugs!\nAlso make sure to check out the website and the wiki!\n\nhttps://dzejmod.tk/", 8)

	return true

func peerConnected(id):
	dzej.lpShowNotification("initialising player " + str(id), 2)
	var player = dzej.mpSceneAddToParentToId(id, dzej.addonGetPath("base") + "/prefabs/player.tscn", map)
	player.name = "Player_" + str(id)
	player.get_node("KinematicBody").get_node("playerName").text = "Player " + str(id)

	if(id == get_tree().get_network_unique_id()):
		var script = dzej.resLoadToMem(dzej.addonGetPath("base") + "/scripts/playerController.gd")
		dzej.nodeSetScript(player.get_node("KinematicBody"), script, true)
	else:
		var script = dzej.resLoadToMem(dzej.addonGetPath("base") + "/scripts/remotePlayer.gd")
		dzej.nodeSetScript(player.get_node("KinematicBody"), script)
		puppets.append(player)

func peerDisconnected(id):
	dzej.sceneRemove(map.get_node("Player_" + str(id)))
	for i in range(puppets.size()):
		if(puppets[i].name == "Player_" + str(id)):
			puppets.remove(i)
			break

func netUpdate(data : Array):
	for i in range(puppets.size()):
		puppets[i].get_node("KinematicBody").netUpdate(data)
