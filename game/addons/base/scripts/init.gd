extends Node

func onLoad(loadedScene):
	var sceneData = dzej.sceneAddToParent(dzej.addonGetPath("base") + "/prefabs/player.tscn", loadedScene)
	var player = sceneData
	
	var sandboxGlobal = Node.new()
	sandboxGlobal.name = "sandbox"
	dzej.nodeSetScript(sandboxGlobal, dzej.resLoadToMem(dzej.addonGetPath("base") + "/scripts/globalsandbox.gd"))
	dzej.nodeAddToParent(sandboxGlobal, dzej.root)
	sandboxGlobal.move_child(player, dzej.gameplayMap.get_index() - 1)

	sandboxGlobal.sandboxPlayer = player

	var scriptObject = dzej.resLoadToMem(dzej.addonGetPath("base") + "/scripts/playerController.gd")
	dzej.nodeSetScript(player.get_node("KinematicBody"), scriptObject, true)

	dzej.lpShowNotification("Welcome to Dzejmod!\nThis is an early alpha build so beware of bugs!\nAlso make sure to check out the website and the wiki!\n\nhttps://dzejmod.tk/", 8)

	return true