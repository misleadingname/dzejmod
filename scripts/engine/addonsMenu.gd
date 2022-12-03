extends VBoxContainer

onready var templateAddon = $ScrollContainer/AddonList/AddonEntry
onready var addonList = $ScrollContainer/AddonList

func _ready():
	var addons = dzej.addonRequestList()
	for addon in addons:
		var entry = templateAddon.duplicate()
		addonList.add_child(entry)
		entry.setAddon(addon)
		entry.visible = true


func _on_closeButton_pressed():
	get_parent().hide()
