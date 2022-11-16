extends Spatial

#temporarily instancing default map until japan makes map selector/implements map selection in console
onready var map = preload("res://scenes/dzej_jumpy.tscn")
onready var player = preload("res://imports/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#botched world loader
	if dzej.playercount < settings.all_settings.get("max_players"):
		dzej.playercount += 1
		add_child(map.instance())
		#gets the first node (the world), and adds the player in the player position node7
		get_child(0).get_child(dzej.playercount - 1).add_child(player.instance())
