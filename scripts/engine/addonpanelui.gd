extends PanelContainer

onready var nameString = $HBoxContainer/Info/Name
onready var authorString = $HBoxContainer/Info/Author
onready var addontagString = $HBoxContainer/Info/Tag

func setAddon(name):
	var meta = dzej.addonGetInfo(name)

	nameString.set_text(meta[0])
	authorString.set_text(meta[1])
	addontagString.set_text(meta[2])
