extends Viewport
class_name DzejGame
var exePath=OS.get_executable_path().get_base_dir()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func createGame(pathToPak:String):
	var success = ProjectSettings.load_resource_pack(pathToPak)
	if success:
		dzej.root = self
		# Now one can use the assets as if they had them in the project from the start.
		var imported_scene = load("res://dzej/scenes/engine/initialloading.tscn").instance()
		add_child(imported_scene)
		return self
	else:
		print("failed to load the game")
		var theb:Label = Label.new()
		theb.text = "error loading external file " + pathToPak
		add_child(theb)

