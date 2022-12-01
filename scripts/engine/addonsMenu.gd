extends VBoxContainer

onready var templateAddon = $AddonList/AddonEntry
onready var addonList = $AddonList

func _ready():
	var addons = dzej.addonRequestList()
	for addon in addons:
		var entry = templateAddon.duplicate()
		addonList.add_child(entry)
		entry.setAddon(addon)
		entry.visible = true
