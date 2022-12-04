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
		clone.text = the
		clone.visible =true
		clone.disabled =false
		clone.connect("button_down", self, "button_press")
		add_child(clone)
	

var nameasd = "null"

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
		var temp = clone.text
		nameasd = temp
		dzej.targetScene = temp
		funny()
		dzej.sceneSwtich("res://scenes/engine/GameplayWorld.tscn")
		
		
func funny():
	var temp1 = dzej.addonRequestList()
	for i in temp1.size():
		var addonDir = Directory.new()
		print(dzej.addonpath + temp1[i] + "/maps/")
		addonDir.open(dzej.addonpath + temp1[i] + "/maps/")
		addonDir.list_dir_begin()
		while(true):
			
			var file = addonDir.get_next()
			if(file == ""):
				break
			if(nameasd in file):
				dzej.addonMapFrom = temp1[i]
				break
		addonDir.list_dir_end()
