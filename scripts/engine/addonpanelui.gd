extends PanelContainer

onready var nameString = $HBoxContainer/Info/Name
onready var authorString = $HBoxContainer/Info/Author
onready var addontagString = $HBoxContainer/Info/Tag

func setAddon(name):
	var meta = dzej.addonGetInfo(name)

	nameString.set_text(meta.name)
	authorString.set_text(meta.author)
	addontagString.set_text(meta.tag)
	# $HBoxContainer/ImageCenter/MarginContainer/TextureRect.texture = load(dzej.getAddonPath(dzej.addonMapFrom) + "icon.png")
