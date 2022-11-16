extends KinematicBody

class_name dzejPlayer

var MOUSESENS = 0

export var moveSpeed : float = 4
export var jumpForce : float = 4
export var gravity : float = 10

export var accel : float = 6
export var decel : float = 8

var vel : Vector3 = Vector3()
var grav : float = 0
var mouseDelta : Vector2 = Vector2()

onready var rothelper = $RotationHelper

onready var viewmodel = $RotationHelper/view

onready var cam = $RotationHelper/Camera
onready var viewmodelcam = $RotationHelper/ViewportContainer/Viewport/viewmodelCam
onready var OnFloorHelper = $OnFloor

onready var ogViewmodelPos = viewmodel.translation

func _ready():
	dzej.lockMouse(true)

func _process(delta):
	MOUSESENS = settings.all_settings.get("mouse_sens")
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rothelper.rotation_degrees.x -= mouseDelta.y * MOUSESENS * delta
		rothelper.rotation_degrees.x = clamp(rothelper.rotation_degrees.x, -90, 90)

		rotation_degrees.y -= mouseDelta.x * MOUSESENS * delta

	mouseDelta = Vector2()
	
	viewmodelcam.global_transform = cam.global_transform

func _physics_process(delta):
	var input = Vector2()

	if Input.is_action_pressed("movement_forward"):
		input.y -= 1
	if Input.is_action_pressed("movement_backward"):
		input.y += 1
	if Input.is_action_pressed("movement_left"):
		input.x -= 1
	if Input.is_action_pressed("movement_right"):
		input.x += 1
	
	#eeky fix :/
	if OnFloorHelper.is_colliding():
		grav = 0
		input = input.normalized()
		if(Input.is_action_pressed("movement_jump")):
			grav = jumpForce
	else:
		grav -= gravity * delta
	
	vel.y = grav
	
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	var relativeDir = (forward * input.y + right * input.x)
	
	vel = vel.linear_interpolate(relativeDir * moveSpeed, decel * delta)

	if(!OnFloorHelper.is_colliding() && vel.length() > 0.1):
			vel.x *= 1 + (2 * delta)
			vel.z *= 1 + (2 * delta)
	
	vel = move_and_slide(vel, Vector3.UP, true)

	viewmodel.translation.y = ogViewmodelPos.y + cos(OS.get_ticks_msec() * 0.01) * clamp(vel.length(), 0, 100) * 0.005
	viewmodel.translation.x = ogViewmodelPos.x + sin(OS.get_ticks_msec() * 0.005) * clamp(vel.length(), 0, 100) * 0.0125


func _input(event):
	if(event is InputEventMouseMotion):
		mouseDelta = event.relative
