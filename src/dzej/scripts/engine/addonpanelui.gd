extends PanelContainer

onready var nameString = $HBoxContainer/Info/Name
onready var authorString = $HBoxContainer/Info/Author
onready var addontagString = $HBoxContainer/Info/Tag
onready var desc = $HBoxContainer/desc/container/Desc
onready var path = $HBoxContainer/desc/container2/path
var meta: Dictionary
var realpath: String
var historicalpath: String = ""

func setAddon(name):
	meta = dzej.addonGetInfo(name)

	nameString.set_text(meta.name)
	authorString.set_text(meta.author)
	addontagString.set_text(meta.tag)
	desc.set_text(meta.desc)
	path.set_text("addons/" + meta.filename)
	realpath = dzej.addonGetPath(meta.filename)
	dzej.msg("[fatal] restart required!") # wtf
	# var icon = dzej.resLoadToMem(dzej.addonGetPath(meta.filename) + "/icon.png")
	# if icon != null:
	# 	$HBoxContainer/Info/Icon.set_texture(icon)

func explore_directory(dir: String):
	var explorer: Directory = Directory.new()
	#dzej.msg(dir)

	if explorer.open(dir) == OK:
		if historicalpath != "":
			historicalpath += "/" + dir
		else:
			historicalpath += dir
		#print(historicalpath)
		explorer.list_dir_begin(true)

		var next_victim = explorer.get_next()
		while next_victim != "":
			if explorer.current_is_dir():
				#dzej.msg("Directory found: " + next_victim)
				explore_directory(next_victim)
			else:
				#dzej.msg(historicalpath + "/" + next_victim)
				explorer.remove(historicalpath + "/" + next_victim)
			next_victim = explorer.get_next()
	else:
		dzej.fatal(explorer, "Cannot open!", dir)


func _on_delete_button_down():
	var dir: Directory = Directory.new()
	if dir.open(realpath) == OK:
		dir.list_dir_begin(true)
		var victim = dir.get_next()
		while victim != "":
			if dir.current_is_dir():
				#dzej.msg("Found directory: " + victim)
				explore_directory(realpath + "/" + victim)
				historicalpath = ""
				dir.remove(realpath + "/" + victim)
			else: 
				dir.remove(realpath + "/" + victim)
			victim = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	dir.remove(realpath)
	dzej.lpMessageBox("Deleted an addon! \nRestart the game to apply changes.", "Alert!")
