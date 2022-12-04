extends PanelContainer

onready var nameString = $HBoxContainer/Info/Name
onready var authorString = $HBoxContainer/Info/Author
onready var addontagString = $HBoxContainer/Info/Tag
onready var desc = $HBoxContainer/desc/container/Desc
onready var path = $HBoxContainer/desc/container2/path
var meta:Dictionary

func setAddon(name):
	meta = dzej.addonGetInfo(name)

	nameString.set_text(meta.name)
	authorString.set_text(meta.author)
	addontagString.set_text(meta.tag)
	desc.set_text(meta.desc)
	path.set_text("addons/" + meta.filename)
	dzej.msg("[fatal] restart required!")
	#var icon = load(dzej.getAddonPath(name) + "icon.png")
	#if(!icon==null):
		#$HBoxContainer/ImageCenter/MarginContainer/TextureRect.texture = icon


func _on_delete_button_down():
	dzej.msg("[FATAL] restart required!")
	get_tree().quit()
	
	
