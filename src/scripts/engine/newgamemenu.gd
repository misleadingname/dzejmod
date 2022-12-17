extends WindowDialog

onready var gamemodeButtonPreset = $gamemodes/VBoxContainer/VBoxContainer/Button
onready var gamemodeLabel = $gamemodes/VBoxContainer/Label

onready var mapButtonPreset = $maps/ScrollContainer/GridContainer/Map

onready var mapname = $options/VBoxContainer/name
onready var mapgamemode = $options/VBoxContainer/gamemode

onready var playbutton = $options/VBoxContainer/Button

var gamemode = null
var map = null

func play():
	if gamemode != null and map != null:
		dzej.targetScene = map
		dzej.targetGamemode = gamemode
		dzej.sceneSwtich("res://scenes/engine/GameplayWorld.tscn")
	else:
		dzej.msg("Please select a map and gamemode")
	
func findfromaddon_map():
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
			if(map in file):
				dzej.addonMapFrom = temp1[i]
				break
		addonDir.list_dir_end()

func pickgamemode(gm, button):
	mapgamemode.text = "On " + gm.name
	gamemode = gm.filename
	for child in gamemodeButtonPreset.get_parent().get_children():
		if child != gamemodeButtonPreset:
			child.disabled = false
	button.disabled = true

	if(map == null):
		playbutton.disabled = true
	else:
		playbutton.disabled = false


func pickmap(mp, button):
	mapname.text = mp
	map = mp
	findfromaddon_map()

	for child in mapButtonPreset.get_parent().get_children():
		if child != mapButtonPreset:
			child.get_child(0).disabled = false
	button.disabled = true

	if(gamemode == null):
		playbutton.disabled = true
	else:
		playbutton.disabled = false

func _ready():
	gamemodeButtonPreset.visible = false
	mapButtonPreset.visible = false
	playbutton.disabled = true

	playbutton.connect("pressed", self, "play")

	mapname.text = "No map"
	mapgamemode.text = "No gamemode"

	for addon in dzej.addonRequestList():
		var meta = dzej.addonGetInfo(addon)
		if meta.tag == "gamemode":
			var button = gamemodeButtonPreset.duplicate()
			button.text = meta.name
			button.connect("pressed", self, "pickgamemode", [meta, button])
			button.visible = true
			gamemodeButtonPreset.get_parent().add_child(button)

	for scene in dzej.sceneGetList() + dzej.addonSceneGetList(dzej.addonRequestList()):
		var preset = mapButtonPreset.duplicate()
		var button = preset.get_node("button")
		button.text = scene.replace(".tscn", "")
		button.connect("pressed", self, "pickmap", [scene, button])
		preset.visible = true
		mapButtonPreset.get_parent().add_child(preset)


	
