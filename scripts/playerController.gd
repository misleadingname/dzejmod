extends KinematicBody

class_name dzejPlayer

const MOUSESENS = 7

export var moveSpeed : float = 5
export var jumpForce : float = 16
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

onready var ogViewmodelPos = viewmodel.translation

func _ready():
	dzej.lockMouse(true)

func _process(delta):
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

	input = input.normalized()

	var forward = global_transform.basis.z
	var right = global_transform.basis.x

	var relativeDir = (forward * input.y + right * input.x)

	if is_on_floor():
		grav = 0
		if Input.is_action_pressed("movement_jump"):
			grav = jumpForce
	else:
		grav -= gravity * delta

	vel = vel.linear_interpolate(relativeDir * moveSpeed, decel * delta)
	
	if(grav > 0.2):
		vel.y = 0
	else:
		vel.y = grav
					
	move_and_slide(vel, Vector3.UP)

	viewmodel.translation.x = ogViewmodelPos.x + sin(OS.get_ticks_usec() * 0.000005) * vel.length() * 0.0125


func _input(event):
	if(event is InputEventMouseMotion):
		mouseDelta = event.relative
