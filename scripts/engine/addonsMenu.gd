extends VBoxContainer

onready var templateAddon = $AddonList/AddonEntry
onready var addonList = $AddonList

func _ready():
	var dir = Directory.new()
	dir.open("res://addons")
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		if file == "." or file == "..":
			file = dir.get_next()
		else:
			if dir.current_is_dir():
				var addon = templateAddon.duplicate()
				addon = addonList.add_child(addon)
				# addon.get_child("HBoxContainer").get_child("Info").get_child("Label").text = "123"
				# addon.get_child("HBoxContainer").get_child("Info").get_child("Label2").text = "!23"
			file = dir.get_next()
