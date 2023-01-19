extends KinematicBody

var id = int(get_parent().name.trim_prefix("Player_"))

var target_pos = Vector3.ZERO
var target_rot = Vector3.ZERO

func _init():
	set_physics_process(true)

func netUpdate(data : Array):
	if data[0] == id:
		target_pos = data[1]
		target_rot = data[2]

func _physics_process(delta):
	translation = translation.linear_interpolate(target_pos, 0.5)
	rotation_degrees = rotation_degrees.linear_interpolate(target_rot, 0.5)