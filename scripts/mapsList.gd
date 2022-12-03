extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var b = preload("res://scenes/engine/mapButton.tscn")
	var a = dzej.addonSceneGetList(dzej.addonRequestList())
	
	for i in a.size():
		var id = i
		var clone = b.instance()
		var the = a[id]
		clone.text = the.rstrip(".tscn").replace("_"," ")
		clone.visible =true
		clone.disabled =false
		clone.connect("button_down", self, "button_press")
		add_child(clone)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func button_press():
	var clone:Button
	for child in get_children():
		print(child)
		if(child.pressed):
			clone = child
	if(!clone == null):
		var temp = clone.text + ".tscn"
		dzej.targetScene = temp.replace(" ", "_")
		var temp1 = dzej.addonRequestList()
		for i in temp1.size():
			
		dzej.sceneSwtich("res://scenes/engine/GameplayWorld.tscn")
