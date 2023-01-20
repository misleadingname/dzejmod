extends KinematicBody

class_name dzejPlayer

export var walkSpeed : float = 5
export var crouchSpeed : float = 2.5
export var sprintSpeed : float = 7
export var jumpForce : float = 7
export var pushStrength : float = 3

export var gravityDefault : float = 16
export var accelDefault : float = 8
export var accelAir : float = 0.6

onready var accel : float = accelDefault
onready var gravity : float = gravityDefault
onready var movementSpeed = walkSpeed

var direction : Vector3 = Vector3.ZERO
var velocity : Vector3 = Vector3.ZERO
var gravity_vec : Vector3 = Vector3.ZERO
var movement : Vector3 = Vector3.ZERO

var weapon = "weapon_physgun"
var weapons = ["weapon_physgun"]
var weaponData = [{
	"name": "Physics Gun",
	"className": "weapon_physgun",
	"model": "",
	"damage":0,
	"canDamage":false
}]


var crouch = 1

var mouseDelta : Vector2 = Vector2.ZERO
var snap : Vector3 = Vector3.ZERO

const PI4 = PI/4

onready var rothelper = $RotationHelper
onready var viewmodel = $RotationHelper/view

onready var cam = $RotationHelper/Camera
onready var viewmodelcam = $RotationHelper/ViewportContainer/Viewport/viewmodelCam
onready var viewmodelViewport = $RotationHelper/ViewportContainer/Viewport

onready var ogViewmodelPos = viewmodel.translation
onready var viewmodelPos = ogViewmodelPos

var tickTimer : Timer = null

func _ready():
	#weapon = null
	#weapons = null
	#weaponData = null
	dzej.lpMouseLock(true)
	dzej.root.connect("size_changed", self, "screenResized")
	screenResized()

	tickTimer = Timer.new()
	tickTimer.connect("timeout", self, "tick")
	tickTimer.wait_time = 0.1
	tickTimer.one_shot = false
	add_child(tickTimer)
	tickTimer.start()
	var viewmodel = $KinematicBody/RotationHelper/ViewportContainer/Viewport/viewmodelCam/Weapon

func screenResized():
	viewmodelViewport.size = dzej.root.size

func _process(_delta):
	scale.y = lerp(scale.y, crouch, 0.1)
	var mouseSens = dzej_settings.all_settings.get("mouse_sens") / 5
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rothelper.rotation_degrees.x -= mouseDelta.y * mouseSens
		rothelper.rotation_degrees.x = clamp(rothelper.rotation_degrees.x, -90, 90)

		rotation_degrees.y -= mouseDelta.x * mouseSens

	mouseDelta = Vector2()

	viewmodelcam.global_transform = cam.global_transform

func _physics_process(delta):
	direction = Vector3.ZERO
	var f_input : float = 0.0
	var h_input : float = 0.0
	var h_rot = global_transform.basis.get_euler().y

	if(dzej.lpMouseIsLocked()):
		f_input = Input.get_action_strength("movement_backward") - Input.get_action_strength("movement_forward")
		h_input = Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left")
		direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	if(is_on_ceiling()):
		gravity_vec = -gravity_vec / 4
		# dzej.lpShowNotification("You are on the ceiling!", 1)

	if(is_on_floor()):
		gravity = 0

		snap = -get_floor_normal()
		accel = accelDefault
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		gravity = gravityDefault
		accel = accelAir
		gravity_vec += Vector3.DOWN * gravity * delta
		
	if(dzej.lpMouseIsLocked()):
		if(Input.is_action_pressed("movement_sprint") and is_on_floor()):
			movementSpeed = sprintSpeed

		elif(Input.is_action_pressed("movement_crouch")):
			if !self==null:
				crouch = .5
				movementSpeed = crouchSpeed
		else:
			crouch = 1
			movementSpeed = walkSpeed



		if(Input.is_action_just_pressed("movement_jump") and is_on_floor()):
			snap = Vector3.ZERO
			gravity_vec = Vector3.UP * jumpForce
	
	velocity = velocity.linear_interpolate(direction * movementSpeed, accel * delta)
	movement = velocity + gravity_vec
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider is RigidBody:
			collision.collider.apply_central_impulse(-collision.normal * 0.1)
			
	viewmodelPos = ogViewmodelPos

	if(dzej.lpMouseIsLocked()):
		viewmodelPos.x += -mouseDelta.x * 0.002
		viewmodelPos.y += mouseDelta.y * 0.002
		
	viewmodel.translation.y = cos(OS.get_ticks_msec() * 0.01) * clamp(movement.length(), 0, 50) * 0.000625 + viewmodel.translation.linear_interpolate(viewmodelPos, 10 * delta).y
	viewmodel.translation.x = sin(OS.get_ticks_msec() * 0.005) * clamp(movement.length(), 0, 50) * 0.000625 + viewmodel.translation.linear_interpolate(viewmodelPos, 10 * delta).x

	move_and_slide_with_snap(movement, snap, Vector3.UP, false, 4, PI4, false)

func tick():
	dzej.mpRPC(get_tree().get_network_unique_id(), [global_transform.origin, rotation_degrees, viewmodel.translation, viewmodel.rotation_degrees])


func addWeapon(meta:Dictionary, script):
	var display = meta.name
	var classname = meta.className
	var damage = meta.damage

func _input(event):
	if(event is InputEventMouseMotion):
		mouseDelta = event.relative
