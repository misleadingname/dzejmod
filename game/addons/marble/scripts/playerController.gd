extends Spatial

onready var rigidbody = $RigidBody
onready var camBoom = $camBoom

onready var mesh = $RigidBody/MeshInstance

onready var camera = $camBoom/SpringArm/Camera

var mouseDelta = Vector2.ZERO

var mouseSens = 1
var speed = 50

func _ready():
	dzej.lpMouseLock(true)

	var material = dzej.resLoadToMem("res://mat/default.tres")
	mesh.set_material_override(material)

	
func _process(delta):
	mouseSens = dzej_settings.all_settings.get("mouse_sens")

	camBoom.rotation_degrees.x = camBoom.rotation_degrees.x + -mouseDelta.y * mouseSens
	camBoom.rotation_degrees.y = camBoom.rotation_degrees.y + -mouseDelta.x * mouseSens
	camBoom.rotation_degrees.x = clamp(camBoom.rotation_degrees.x, -80, 80)
	
	mouseDelta = Vector2.ZERO
	
	camBoom.translation = rigidbody.translation

func _physics_process(delta):
	camera.fov = clamp(rigidbody.linear_velocity.length() * 2.5, 60, 120)

	var f_input : float = 0.0
	var h_input : float = 0.0

	if(dzej.lpMouseIsLocked()):
		f_input = Input.get_action_strength("movement_backward") - Input.get_action_strength("movement_forward")
		h_input = Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left")
		
	rigidbody.angular_velocity = rigidbody.angular_velocity * 0.99
	
	rigidbody.angular_velocity += camBoom.get_global_transform().basis.xform(Vector3(f_input * speed * delta, 0, -h_input * speed * delta))
	rigidbody.angular_velocity = rigidbody.angular_velocity.limit_length(100)

	# rigidbody.linear_velocity += camBoom.get_global_transform().basis.xform(Vector3(h_input * speed * delta, 0, f_input * speed * delta) / 8)

func marbleSound():
	dzej.lpShowNotification("Marble sound")

func _input(event):
	if(event is InputEventMouseMotion):
		mouseDelta = event.relative