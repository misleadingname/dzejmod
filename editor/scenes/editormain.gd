extends Node2D

onready var tree:Tree = $Properties/tree/Tree
var treee:Viewport

var playing = false
onready var conv = $BottomView/console/Panel/TextEdit
onready var errv = $BottomView/errors/Panel/TextEdit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var thefuckery:DzejGame = $midview/game/Panel/ViewportContainer/DzejGame


# Called when the node enters the scene tree for the first time.
func _ready():
	if playing:
		treee = thefuckery.createGame(thefuckery.exePath+"/editorgame.pck")
		tree.create_tree_item(self, tree)
		for child in treee.get_children():
			tree.create_tree_item(child, treee)
			for childchild in child.get_children():
				tree.create_tree_item(childchild, child)
				for childchildchild in childchild.get_children():
					tree.create_tree_item(childchildchild, childchild)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !conv.text==dzej.allconsole:
		conv.text = dzej.allconsole
	if !errv.text==dzej.error:
		errv.text = dzej.error
	if playing:
		tree.clear()
		tree.create_tree_item(self, tree)
		for child in treee.get_children():
			tree.create_tree_item(child, treee)
			for childchild in child.get_children():
				tree.create_tree_item(childchild, child)
				for childchildchild in childchild.get_children():
					tree.create_tree_item(childchildchild, childchild)


func _on_play_button_down():
	treee = thefuckery.createGame(thefuckery.exePath+"/editorgame.pck")
	playing=true
	dzej.fatal("testing", "holy shit", "sex")
