extends GridContainer

func _ready():
	var button = preload("res://scenes/engine/mapButton.tscn")
	var maps = dzej.addonSceneGetList(dzej.addonRequestList())
	
	print(maps)
	
	for i in len(maps):
		var clone = button.instance()
		clone.text = maps[i]
		#clone.visible =true
		#clone.disabled =false
		clone.connect("button_down", self, "button_press")
		add_child(clone)
	

var nameasd = "null"

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
