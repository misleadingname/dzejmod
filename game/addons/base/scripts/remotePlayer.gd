extends KinematicBody

var id = int(get_parent().name.trim_prefix("Player_"))

func netUpdate(data : Array):
	if data[0] == id:
		translation = data[1]
		rotation = data[2]
