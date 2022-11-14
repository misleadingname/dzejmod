extends Node

var pausemenu = preload("res://scenes/engine/mainmenu.tscn")

var root : Node = null
var currentScene : Node = null

var consoleScene : PackedScene = null

func _ready():
	root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)

	print("dzejscript loaded.\nreference using dzej.X")

func _input(event):
	if(Input.is_action_just_pressed("ui_console")):
		if(!consoleScene):
			consoleScene = overlayScene("res://scenes/engine/console.tscn")
		elif(consoleScene):
			var consoleWindow = consoleScene.instance().get_node("WindowDialog")

			if(consoleWindow.visible):
				consoleWindow.hide()
			else:
				consoleWindow.show()

func hello():
	print("Hello, dzejmod!")

# SCENE MANAGEMENT

func overlayScene(resname : String):
	var scene = load(resname)
	root.add_child(scene.instance())

	return scene

func removeScene(sceneRef : Node):
	if(sceneRef != null):
		sceneRef.queue_free()
		return "Removed scene " + sceneRef.get_name()
	else:
		return "Scene not found."
