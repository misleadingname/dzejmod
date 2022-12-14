extends Node


func onLoad(loadedScene):
	var sceneData = dzej.sceneAddToParent(dzej.getAddonPath("base") + "/prefabs/player.tscn", loadedScene)
	var player = sceneData[0]
	
	var scriptObject = dzej.resLoadToMem(dzej.getAddonPath("base") + "/scripts/playerController.gd")
	print(scriptObject)

	player.get_node("KinematicBody").set_script(scriptObject)

	dzej.lpShowNotification("Welcome to Dzejmod!\nThis is an early alpha build so beware of bugs!\nAlso make sure to check out the website and the wiki!\n\nhttps://dzejmod.tk/", 8)
	return true